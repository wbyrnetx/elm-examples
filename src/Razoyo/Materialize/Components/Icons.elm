module Razoyo.Materialize.Components.Icons exposing (..)

import Html exposing (Attribute, Html, i, text)
import Html.Attributes exposing (class)


type Icon
    = Add
    | ArrowDropDown
    | Delete
    | Edit
    | KeyboardArrowRight
    | Search


icon : Icon -> Html msg
icon icon_ =
    iconWith icon_ []


iconWith : Icon -> List (Attribute msg) -> Html msg
iconWith icon_ attributes =
    i
        ([ class "material-icons" ] ++ attributes)
        [ text (iconText icon_) ]



--
-- Helpers
--


add : Html msg
add =
    icon Add


arrowDropDown : Html msg
arrowDropDown =
    icon ArrowDropDown


delete : Html msg
delete =
    icon Delete


edit : Html msg
edit =
    icon Edit


keyboardArrowRight : Html msg
keyboardArrowRight =
    icon KeyboardArrowRight


search : Html msg
search =
    icon Search



--
-- Text
--


iconText : Icon -> String
iconText icon_ =
    case icon_ of
        Add ->
            "add"

        ArrowDropDown ->
            "arrow_drop_down"

        Delete ->
            "delete"

        Edit ->
            "edit"

        KeyboardArrowRight ->
            "keyboard_arrow_right"

        Search ->
            "search"
