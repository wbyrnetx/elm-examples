module Razoyo.Materialize.Forms.Select exposing (..)

import Html exposing (Attribute, Html, div, input, label, li, span, text, ul)
import Html.Attributes exposing (class, classList, for, id, readonly, style, type_, value)
import Html.Events exposing (onClick)


type alias Select =
    { isOpen : Bool }


init : Select
init =
    { isOpen = False }


type Msg
    = SelectedOption String
    | Toggled


type Action
    = Internal Select
    | Selection String Select


update : Msg -> Select -> Action
update msg select_ =
    case msg of
        SelectedOption optStr ->
            Selection optStr { select_ | isOpen = False }

        Toggled ->
            Internal { select_ | isOpen = not select_.isOpen }


select : (Msg -> msg) -> Select -> List String -> Maybe String -> String -> Html msg
select toMsg select_ options selectedOption label_ =
    div
        [ class "select-wrapper" ]
        [ caretSpan
        , mainInput toMsg select_.isOpen selectedOption label_
        , ul
            (class "dropdown-content select-dropdown"
                :: openAttributes select_.isOpen
            )
            (chooseOption toMsg
                :: List.map (option_ toMsg selectedOption) options
            )
        ]


openAttributes : Bool -> List (Attribute msg)
openAttributes isOpen =
    if isOpen then
        [ classList [ ( "active", True ) ]
        , style "display" "block"
        , style "opacity" "1"
        , style "width" "450px"
        , style "top" "0px"
        , style "left" "0px"
        , style "position" "absolute"
        ]

    else
        []


chooseOption : (Msg -> msg) -> Html msg
chooseOption toMsg =
    li
        [ class "disabled"
        , onClick (toMsg Toggled)
        ]
        [ span
            []
            [ text "Choose your option" ]
        ]


option_ : (Msg -> msg) -> Maybe String -> String -> Html msg
option_ toMsg selectedValue value_ =
    let
        isSelected =
            Maybe.map (\v -> v == value_) selectedValue
                |> Maybe.withDefault False
    in
    li
        [ classList [ ( "active", isSelected ) ]
        , onClick (toMsg (SelectedOption value_))
        ]
        [ span
            []
            [ text value_ ]
        ]


caretSpan : Html msg
caretSpan =
    span
        [ class "caret" ]
        [ text "▼" ]


mainInput : (Msg -> msg) -> Bool -> Maybe String -> String -> Html msg
mainInput toMsg isOpen value_ label_ =
    let
        id_ =
            String.toLower label_ ++ "-input"
    in
    div [ class "input-field" ]
        [ input
            [ id id_
            , classList [ ( "active", isOpen ) ]
            , readonly True
            , type_ "text"
            , value (Maybe.withDefault "Choose your option" value_)
            , onClick (toMsg Toggled)
            ]
            []
        , label [ class "active", for id_ ] [ text label_ ]
        ]
