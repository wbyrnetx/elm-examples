module Razoyo.Materialize.Forms exposing
    ( Autocomplete
    , AutocompleteEvents
    , Chip
    , Select
    , SelectOption
    , autocomplete
    , autocompleteField
    , chip
    , select
    )

import Html exposing (Attribute, Html, node, text)
import Html.Attributes exposing (classList, id, property)
import Json.Encode as E
import Materialize.Components exposing (Icon, encodeIcon)
import Materialize.Components.Icons as MIcons
import Materialize.Events as MEvents



--
-- Autocomplete
-- https://materializecss.com/autocomplete.html
--


type alias Autocomplete msg =
    { id : String
    , label : String
    , input : String -> msg
    , select : String -> msg
    , icon : Maybe Icon
    }


type alias AutocompleteEvents msg =
    { input : String -> msg
    , select : String -> msg
    }


autocompleteField : AutocompleteEvents msg -> Autocomplete msg
autocompleteField events =
    { id = "ac-field"
    , label = "Autocomplete"
    , input = events.input
    , select = events.select
    , icon = Nothing
    }


autocomplete : Autocomplete msg -> List String -> List String -> String -> Html msg
autocomplete field options classList_ buffer =
    node "m2-autocomplete"
        [ id field.id
        , MEvents.onInput field.input
        , MEvents.onAutocomplete field.select
        , property "model" <| encodeAutocomplete field options buffer
        , classList <| List.map (\c -> ( c, True )) classList_
        ]
        []


encodeAutocomplete : Autocomplete msg -> List String -> String -> E.Value
encodeAutocomplete field options buffer =
    E.object
        [ ( "options", E.object <| List.map (\o -> ( o, E.null )) options )
        , ( "value", E.string buffer )
        , ( "open", E.bool False )
        , ( "label", E.string field.label )
        , ( "icon", Maybe.withDefault E.null <| Maybe.map encodeIcon <| field.icon )
        ]


autocompleteIcon : Icon
autocompleteIcon =
    MIcons.textSms
        |> (\i -> { i | prefix = True })



--
-- Chips
-- https://materializecss.com/chips.html
--


type alias Chip =
    { text : String
    , image : Maybe String
    }


encodeChip : Chip -> E.Value
encodeChip model =
    E.object
        [ ( "text", E.string model.text )
        , ( "image"
          , model.image
                |> Maybe.map E.string
                |> Maybe.withDefault E.null
          )
        ]


chip : List (Attribute msg) -> Chip -> Html msg
chip atts model =
    node "m-chip"
        (atts ++ [ property "model" <| encodeChip model ])
        [ text model.text ]



--
-- Select
-- https://materializecss.com/select.html
--


type alias Select =
    { options : List SelectOption
    , label : String
    , placeholder : Maybe String
    , disabled : Bool
    , value : String
    , icon : Maybe Icon
    }


type alias SelectOption =
    { value : String
    , text : String
    , disabled : Bool
    }


select : List (Attribute msg) -> Select -> Html msg
select atts model =
    node "m-select"
        (atts ++ [ property "model" <| encodeSelect model ])
        []


encodeSelect : Select -> E.Value
encodeSelect model =
    let
        optDecoder =
            \o ->
                E.object
                    [ ( "value", E.string o.value )
                    , ( "text", E.string o.text )
                    , ( "disabled", E.bool o.disabled )
                    ]
    in
    E.object
        [ ( "options", E.list optDecoder model.options )
        , ( "label", E.string model.label )
        , ( "placeholder", Maybe.withDefault E.null <| Maybe.map E.string model.placeholder )
        , ( "disabled", E.bool model.disabled )
        , ( "value", E.string model.value )
        , ( "icon", Maybe.withDefault E.null <| Maybe.map encodeIcon model.icon )
        ]
