module Razoyo.Materialize.Forms.Autocomplete exposing (Msg, State, ViewConfig, customUpdate, init, initWith, input, update)

import Html exposing (Attribute, Html, div, i, label, li, span, text, ul)
import Html.Attributes exposing (class, classList, for, id, placeholder, selected, style, type_, value)
import Html.Events exposing (onClick, onFocus, onInput)
import Razoyo.Browser.Outside as Outside



-- MODEL


type alias State =
    { isOpen : Bool
    , search : String
    }


init : State
init =
    { isOpen = False
    , search = ""
    }


initWith : String -> State
initWith search =
    { isOpen = False
    , search = search
    }



-- UPDATE


type Msg
    = Focus
    | Input String
    | Select String
    | Toggle
    | Close


update : Msg -> State -> ( State, Maybe String )
update msg state =
    customUpdate Nothing (Just identity) msg state


customUpdate : Maybe msg -> Maybe (String -> msg) -> Msg -> State -> ( State, Maybe msg )
customUpdate onInput onChose msg state =
    case msg of
        Close ->
            ( { state | isOpen = False }, Nothing )

        Input search ->
            ( { state | search = search }, onInput )

        Focus ->
            ( { state | isOpen = True }, Nothing )

        Select id ->
            ( { state | isOpen = False, search = id }, Maybe.map (\x -> x id) onChose )

        Toggle ->
            ( { state | isOpen = not state.isOpen }, Nothing )



-- VIEW


type alias ViewConfig a =
    { id : String
    , label : String
    , placeholder : Maybe String
    , toId : a -> String
    }


input : (Msg -> msg) -> ViewConfig a -> State -> List a -> Maybe a -> Html msg
input toMsg config state options selected =
    div
        [ id config.id
        , class "input-field select-wrapper"
        ]
        (smsIcon
            :: mainInput toMsg config state
            ++ dropdown toMsg config state options selected
        )



-- Input


smsIcon : Html msg
smsIcon =
    i
        [ class "material-icons prefix" ]
        [ text "textsms" ]


mainInput : (Msg -> msg) -> ViewConfig a -> State -> List (Html msg)
mainInput toMsg config state =
    [ Html.input
        [ class "autocomplete validate"
        , id config.id
        , classList [ ( "active", state.isOpen ) ]
        , type_ "text"
        , value state.search
        , onFocus (toMsg Focus)
        , onInput (toMsg << Input)
        , placeholder (Maybe.withDefault "" config.placeholder)
        ]
        []
    , label
        [ for config.id
        , class "active"
        ]
        [ text config.label ]
    ]



-- Dropdown


dropdown : (Msg -> msg) -> ViewConfig a -> State -> List a -> Maybe a -> List (Html msg)
dropdown toMsg config state options selected =
    if List.isEmpty options then
        []

    else
        let
            toOption =
                option toMsg config selected

            filteredOptions =
                filterOptions config state.search options
        in
        [ ul
            (class "dropdown-content autocomplete-content"
                :: openAttributes state.isOpen (List.length filteredOptions)
            )
            (List.map toOption filteredOptions)
        ]


openAttributes : Bool -> Int -> List (Attribute msg)
openAttributes isOpen optionCount =
    let
        heightPx =
            if optionCount > 4 then
                "200px"

            else
                String.fromInt (optionCount * 50) ++ "px"
    in
    if isOpen then
        [ classList [ ( "active", True ) ]
        , style "display" "block"
        , style "height" heightPx
        , style "left" "0px"
        , style "opacity" "1"
        , style "position" "absolute"
        , style "top" "46px"
        , style "transform" "scaleX(1) scaleY(1)"
        , style "width" "450px"
        ]

    else
        []


filterOptions : ViewConfig a -> String -> List a -> List a
filterOptions config search allOptions =
    let
        matches =
            \x ->
                String.contains (String.toLower search) (String.toLower (config.toId x))
    in
    List.filter matches allOptions


option : (Msg -> msg) -> ViewConfig a -> Maybe a -> a -> Html msg
option toMsg config selected option_ =
    li
        [ classList [ ( "active", Just option_ == selected ) ]
        , (onClick << toMsg << Select) (config.toId option_)
        ]
        [ span
            []
            [ text (config.toId option_) ]
        ]
