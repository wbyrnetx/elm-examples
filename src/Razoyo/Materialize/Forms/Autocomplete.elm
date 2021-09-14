module Razoyo.Materialize.Forms.Autocomplete exposing (..)

import Html exposing (Attribute, Html, div, i, label, li, span, text, ul)
import Html.Attributes exposing (class, classList, for, id, placeholder, selected, style, type_, value)
import Html.Events exposing (onClick, onFocus, onInput)
import Razoyo.Browser.Outside as Outside
import Razoyo.Debounce as Debounce


subscription : Settings msg -> Sub msg
subscription settings =
    Outside.subscription (settings.toMsg Close) settings.id


type alias Settings msg =
    { id : String
    , label : String
    , toMsg : Msg -> msg
    }


type alias Autocomplete =
    { isOpen : Bool
    , search : Debounce.Search
    }


init : Autocomplete
init =
    { isOpen = False
    , search = Debounce.initSearch
    }


initWith : String -> Autocomplete
initWith search =
    let
        newSearch =
            Debounce.initSearch
                |> Debounce.setCurrentSearch search
                |> Debounce.setPreviousSearch
    in
    { isOpen = False
    , search = newSearch
    }


type Msg
    = Focus
    | Input String
    | Select String
    | Toggle
    | Close


type Action
    = Internal Autocomplete
    | Searched Autocomplete
    | Selected Autocomplete


update : Msg -> Autocomplete -> Action
update msg autocomplete =
    case msg of
        Close ->
            Internal { autocomplete | isOpen = False }

        Input search_ ->
            Searched { autocomplete | search = Debounce.setCurrentSearch search_ autocomplete.search }

        Focus ->
            Internal { autocomplete | isOpen = True }

        Select selected ->
            Selected
                { autocomplete
                    | isOpen = False
                    , search = Debounce.setCurrentSearch selected autocomplete.search
                }

        Toggle ->
            Internal { autocomplete | isOpen = not autocomplete.isOpen }


setSearchCurrent : String -> Autocomplete -> Autocomplete
setSearchCurrent search ac =
    { ac | search = Debounce.setCurrentSearch search ac.search }


setSearchPrevious : Autocomplete -> Autocomplete
setSearchPrevious ac =
    { ac | search = Debounce.setPreviousSearch ac.search }


input : Settings msg -> Autocomplete -> List String -> Maybe String -> Html msg
input settings autocomplete options selectedOption =
    let
        search =
            autocomplete.search.current

        dropdown =
            if List.isEmpty options then
                []

            else
                [ ul
                    (class "dropdown-content autocomplete-content"
                        :: openAttributes autocomplete.isOpen
                    )
                    (List.map (option_ settings.toMsg selectedOption) options)
                ]
    in
    div
        [ id settings.id
        , class "input-field select-wrapper"
        ]
        (smsIcon
            :: mainInput settings.toMsg settings.id settings.label autocomplete.isOpen search
            ++ dropdown
        )


openAttributes : Bool -> List (Attribute msg)
openAttributes isOpen =
    if isOpen then
        [ classList [ ( "active", True ) ]
        , style "display" "block"
        , style "height" "50px"
        , style "left" "0px"
        , style "opacity" "1"
        , style "position" "absolute"
        , style "top" "46px"
        , style "transform" "scaleX(1) scaleY(1)"
        , style "width" "450px"
        ]

    else
        []


option_ : (Msg -> msg) -> Maybe String -> String -> Html msg
option_ toMsg selectedValue value_ =
    let
        isSelected =
            Maybe.map (\v -> v == value_) selectedValue
                |> Maybe.withDefault False
    in
    li
        [ classList [ ( "active", isSelected ) ]
        , onClick (toMsg (Select value_))
        ]
        [ span
            []
            [ text value_ ]
        ]


smsIcon : Html msg
smsIcon =
    i
        [ class "material-icons prefix" ]
        [ text "textsms" ]


mainInput : (Msg -> msg) -> String -> String -> Bool -> String -> List (Html msg)
mainInput toMsg id_ label_ isOpen value_ =
    [ Html.input
        [ class "autocomplete validate"
        , id id_
        , classList [ ( "active", isOpen ) ]
        , type_ "text"
        , value value_
        , onFocus (toMsg Focus)
        , onInput (toMsg << Input)
        , placeholder <| "Select a " ++ label_
        ]
        []
    , label
        [ for id_
        , class "active"
        ]
        [ text label_ ]
    ]
