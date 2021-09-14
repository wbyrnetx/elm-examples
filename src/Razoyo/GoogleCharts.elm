module Razoyo.GoogleCharts exposing (..)

import Dict exposing (Dict)
import Html exposing (Attribute, Html, node)
import Html.Attributes exposing (property)
import Json.Encode as E



--
-- Google Charts
-- https://developers.google.com/chart/interactive/docs/quick_start
--


encodeDataTable : List Column -> List Row -> E.Value
encodeDataTable cols rows =
    E.object
        [ ( "cols", E.list encodeColumn cols )
        , ( "rows", E.list encodeRow2 rows )
        ]


encodeRow2 : Row -> E.Value
encodeRow2 row =
    let
        c =
            \v ->
                E.object [ ( "v", encodeValue v ) ]
    in
    E.object
        [ ( "c", E.list c row ) ]


type alias Data =
    { columns : List Column
    , rows : List Row
    }


type Column
    = StringColumn String
    | NumberColumn String
    | StyleColumn
    | AnnotationColumn
    | TooltipColumn
    | CustomTooltipColumn


encodeColumn : Column -> E.Value
encodeColumn col =
    case col of
        StringColumn label ->
            dataColumn "string" label

        NumberColumn label ->
            dataColumn "number" label

        StyleColumn ->
            roleColumn "style"

        AnnotationColumn ->
            roleColumn "annotation"

        TooltipColumn ->
            roleColumn "tooltip"

        CustomTooltipColumn ->
            customTooltipColumn


dataColumn : String -> String -> E.Value
dataColumn type_ label =
    E.object
        [ ( "type", E.string type_ )
        , ( "label", E.string label )
        ]


roleColumn : String -> E.Value
roleColumn role =
    E.object [ ( "role", E.string role ) ]


customTooltipColumn : E.Value
customTooltipColumn =
    E.object
        [ ( "type", E.string "string" )
        , ( "role", E.string "tooltip" )
        , ( "p", E.object [ ( "html", E.bool True ) ] )
        ]


type alias Row =
    List DataValue


encodeRow : Row -> E.Value
encodeRow row =
    E.list encodeValue row


type DataValue
    = StringValue String
    | NumberValue Float
    | NullValue


encodeValue : DataValue -> E.Value
encodeValue value =
    case value of
        StringValue v ->
            E.string v

        NumberValue v ->
            E.float v

        NullValue ->
            E.null



--
-- Bar Charts
-- https://developers.google.com/chart/interactive/docs/gallery/barchart
--


type alias BarOptions =
    { width : Maybe Int
    , height : Maybe Int
    , title : Maybe String
    , legend : Legend
    , bar : Bar
    , isStacked : Bool
    , chartArea : Maybe ChartArea
    , hAxis : Maybe HAxis
    }


barChartDefaults : BarOptions
barChartDefaults =
    { width = Nothing
    , height = Nothing
    , title = Nothing
    , legend = legendDefaults
    , bar = { groupWidth = "61.8%" }
    , isStacked = False
    , chartArea = Nothing
    , hAxis = Nothing
    }


barChart : BarOptions -> Data -> Html msg
barChart opts data =
    node "gbar-chart"
        [ property "model" <| encodeBarChart opts data ]
        []


encodeBarChart : BarOptions -> Data -> E.Value
encodeBarChart opts data =
    E.object
        [ ( "columns", E.list encodeColumn data.columns )
        , ( "rows", E.list encodeRow data.rows )
        , ( "options", encodeBarOpts opts )
        ]


encodeBarOpts : BarOptions -> E.Value
encodeBarOpts opts =
    E.object
        [ ( "width", Maybe.map E.int opts.width |> Maybe.withDefault E.null )
        , ( "height", Maybe.map E.int opts.height |> Maybe.withDefault E.null )
        , ( "title", Maybe.map E.string opts.title |> Maybe.withDefault E.null )
        , ( "legend", encodeLegend opts.legend )
        , ( "bar", encodeBar opts.bar )
        , ( "isStacked", E.bool opts.isStacked )
        , ( "chartArea", Maybe.map encodeChartArea opts.chartArea |> Maybe.withDefault E.null )
        , ( "hAxis", Maybe.map encodeHAxis opts.hAxis |> Maybe.withDefault E.null )
        ]


type alias Bar =
    { groupWidth : String }


encodeBar : Bar -> E.Value
encodeBar bar =
    E.object [ ( "groupWidth", E.string bar.groupWidth ) ]


type alias ChartArea =
    { backgroundColor : String
    , left : Maybe NumberOrString
    , top : Maybe NumberOrString
    , width : Maybe NumberOrString
    , height : Maybe NumberOrString
    }


chartAreaDefaults : ChartArea
chartAreaDefaults =
    { backgroundColor = "white"
    , left = Nothing
    , top = Nothing
    , width = Nothing
    , height = Nothing
    }


encodeChartArea : ChartArea -> E.Value
encodeChartArea area =
    E.object
        [ ( "backgroundColor", E.string area.backgroundColor )
        , ( "left", Maybe.map encodeNumberOrString area.left |> Maybe.withDefault E.null )
        , ( "top", Maybe.map encodeNumberOrString area.top |> Maybe.withDefault E.null )
        , ( "width", Maybe.map encodeNumberOrString area.width |> Maybe.withDefault E.null )
        , ( "height", Maybe.map encodeNumberOrString area.height |> Maybe.withDefault E.null )
        ]



--
-- Bubble Charts
-- https://developers.google.com/chart/interactive/docs/gallery/bubblechart
--


type alias BubbleOptions =
    { width : Maybe Int
    , height : Maybe Int
    , title : String
    , hAxis : HAxis
    , vAxis : VAxis
    , bubble : Bubble
    }


type alias Bubble =
    { textStyle : TextStyle }


type alias TextStyle =
    { fontSize : Int }


bubbleChart : BubbleOptions -> Data -> Html msg
bubbleChart opts data =
    node "gbubble-chart"
        [ property "model" <| encodeBubbleChart opts data ]
        []


encodeBubbleChart : BubbleOptions -> Data -> E.Value
encodeBubbleChart opts data =
    E.object
        [ ( "columns", E.list encodeColumn data.columns )
        , ( "rows", E.list encodeRow data.rows )
        , ( "options", encodeBubbleOpts opts )
        ]


encodeBubbleOpts : BubbleOptions -> E.Value
encodeBubbleOpts opts =
    E.object
        [ ( "width", Maybe.map E.int opts.width |> Maybe.withDefault E.null )
        , ( "height", Maybe.map E.int opts.height |> Maybe.withDefault E.null )
        , ( "title", E.string opts.title )
        , ( "hAxis", encodeHAxis opts.hAxis )
        , ( "vAxis", encodeVAxis opts.vAxis )
        , ( "bubble", encodeBubble opts.bubble )
        ]


encodeBubble : Bubble -> E.Value
encodeBubble bubble =
    E.object [ ( "textStyle", encodeTextStyle bubble.textStyle ) ]


encodeTextStyle : TextStyle -> E.Value
encodeTextStyle opts =
    E.object [ ( "fontSize", E.int opts.fontSize ) ]



--
-- Column Charts
-- https://developers.google.com/chart/interactive/docs/gallery/columnchart
--


columnChart : List (Attribute msg) -> Data -> Html msg
columnChart atts data =
    node "gcol-chart"
        (atts ++ [ property "model" <| encodeColumnChart data ])
        []


encodeColumnChart : Data -> E.Value
encodeColumnChart data =
    E.object
        [ ( "columns", E.list encodeColumn data.columns )
        , ( "rows", E.list encodeRow data.rows )
        ]



--
-- Combo Charts
-- https://developers.google.com/chart/interactive/docs/gallery/combochart
--


type alias ComboOptions =
    { width : Maybe Int
    , height : Maybe Int
    , legend : Legend
    , seriesType : String
    , series : Dict String SeriesOpt
    , pointShape : String
    , pointSize : Int
    , isStacked : Bool
    , orientation : String
    }


type SeriesOpt
    = LineType Float
    | BarType


comboChart : ComboOptions -> Data -> Html msg
comboChart opts data =
    node "gcombo-chart"
        [ property "model" <| encodeComboChart opts data ]
        []


encodeComboChart : ComboOptions -> Data -> E.Value
encodeComboChart opts data =
    E.object
        [ ( "columns", E.list encodeColumn data.columns )
        , ( "rows", E.list encodeRow data.rows )
        , ( "options", encodeComboOpts opts )
        ]


encodeComboOpts : ComboOptions -> E.Value
encodeComboOpts opts =
    E.object
        [ ( "width", Maybe.map E.int opts.width |> Maybe.withDefault E.null )
        , ( "height", Maybe.map E.int opts.height |> Maybe.withDefault E.null )
        , ( "legend", encodeLegend opts.legend )
        , ( "seriesType", E.string opts.seriesType )
        , ( "series", encodeSeries opts.series )
        , ( "pointShape", E.string opts.pointShape )
        , ( "pointSize", E.int opts.pointSize )
        , ( "isStacked", E.bool opts.isStacked )
        , ( "orientation", E.string opts.orientation )
        ]


encodeSeries : Dict String SeriesOpt -> E.Value
encodeSeries series =
    E.dict identity encodeSeriesOpt series


encodeSeriesOpt : SeriesOpt -> E.Value
encodeSeriesOpt opt =
    case opt of
        LineType lineWidth ->
            E.object
                [ ( "type", E.string "line" )
                , ( "lineWidth", E.float lineWidth )
                ]

        BarType ->
            E.object [ ( "type", E.string "bars" ) ]



--
-- Geo Charts
-- https://developers.google.com/chart/interactive/docs/gallery/geochart
--


type alias GeoOptions =
    { width : Maybe Int
    , height : Maybe Int
    , region : String
    , displayMode : GeoDisplayMode
    }


type GeoDisplayMode
    = AutoGeoDisplay
    | RegionsGeoDisplay
    | MarkersGeoDisplay
    | TextGeoDisplay


geoChart : GeoOptions -> Data -> Html msg
geoChart opts data =
    node "geo-chart"
        [ property "model" <| encodeGeoChart opts data ]
        []


encodeGeoChart : GeoOptions -> Data -> E.Value
encodeGeoChart opts data =
    E.object
        [ ( "columns", E.list encodeColumn data.columns )
        , ( "rows", E.list encodeRow data.rows )
        , ( "options", encodeGeoOpts opts )
        ]


encodeGeoOpts : GeoOptions -> E.Value
encodeGeoOpts opts =
    E.object
        [ ( "width", Maybe.map E.int opts.width |> Maybe.withDefault E.null )
        , ( "height", Maybe.map E.int opts.height |> Maybe.withDefault E.null )
        , ( "region", E.string opts.region )
        , ( "displayMode", encodeGeoDisplay opts.displayMode )
        ]


encodeGeoDisplay : GeoDisplayMode -> E.Value
encodeGeoDisplay mode =
    case mode of
        AutoGeoDisplay ->
            E.string "auto"

        RegionsGeoDisplay ->
            E.string "regions"

        MarkersGeoDisplay ->
            E.string "markers"

        TextGeoDisplay ->
            E.string "text"



--
-- Pie Charts
-- https://developers.google.com/chart/interactive/docs/gallery/piechart
--


type alias PieChartOptions =
    { is3d : Bool
    , pieHole : Maybe Float
    , title : String
    }


pieChart : PieChartOptions -> Data -> Html msg
pieChart opts data =
    node "gpie-chart"
        [ property "model" <| encodePieChart opts data ]
        []


encodePieChart : PieChartOptions -> Data -> E.Value
encodePieChart opts data =
    E.object
        [ ( "columns", E.list encodeColumn data.columns )
        , ( "rows", E.list encodeRow data.rows )
        , ( "options", encodePieChartOpts opts )
        ]


encodePieChartOpts : PieChartOptions -> E.Value
encodePieChartOpts opts =
    E.object
        [ ( "is3D", E.bool opts.is3d )
        , ( "pieHole", Maybe.withDefault E.null <| Maybe.map E.float opts.pieHole )
        , ( "title", E.string opts.title )
        ]



--
-- Options
--


type NumberOrString
    = NosNumber Float
    | NosString String


encodeNumberOrString : NumberOrString -> E.Value
encodeNumberOrString nos =
    case nos of
        NosNumber num ->
            E.float num

        NosString str ->
            E.string str


type alias Legend =
    { position : LegendPosition
    , maxLines : Int
    }


legendDefaults : Legend
legendDefaults =
    { position = LegendRight
    , maxLines = 1
    }


encodeLegend : Legend -> E.Value
encodeLegend legend =
    E.object
        [ ( "position", encodeLegendPosition legend.position )
        , ( "maxLines", E.int legend.maxLines )
        ]


type LegendPosition
    = LegendBottom
    | LegendLeft
    | LegendIn
    | LegendNone
    | LegendRight
    | LegendTop


encodeLegendPosition : LegendPosition -> E.Value
encodeLegendPosition pos =
    case pos of
        LegendBottom ->
            E.string "bottom"

        LegendLeft ->
            E.string "left"

        LegendIn ->
            E.string "in"

        LegendNone ->
            E.string "none"

        LegendRight ->
            E.string "right"

        LegendTop ->
            E.string "top"


type alias HAxis =
    { title : String
    , scaleType : ScaleType
    }


hAxisDefaults : HAxis
hAxisDefaults =
    { title = ""
    , scaleType = NoScaleType
    }


encodeHAxis : HAxis -> E.Value
encodeHAxis axis =
    E.object
        [ ( "title", E.string axis.title )
        , ( "scaleType", encodeScaleType axis.scaleType )
        ]


type alias VAxis =
    { title : String }


encodeVAxis : VAxis -> E.Value
encodeVAxis axis =
    E.object
        [ ( "title", E.string axis.title ) ]


type ScaleType
    = NoScaleType
    | LogScaleType
    | MirrorLogScaleType


encodeScaleType : ScaleType -> E.Value
encodeScaleType scale =
    case scale of
        NoScaleType ->
            E.null

        LogScaleType ->
            E.string "log"

        MirrorLogScaleType ->
            E.string "mirrorLog"
