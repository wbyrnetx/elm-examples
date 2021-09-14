module Razoyo.Materialize.Components.FloatingActionButton exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (style)
import Html.Events exposing (onMouseEnter, onMouseLeave)


type alias FloatingActions =
    { active : Bool }



--
-- Update
--


type Msg
    = HoverIn
    | HoverOut


update : Msg -> FloatingActions -> FloatingActions
update msg fabs =
    case msg of
        HoverIn ->
            { fabs | active = True }

        HoverOut ->
            { fabs | active = False }


init : FloatingActions
init =
    { active = False }



--
-- View
--


buttonsEvents : (Msg -> msg) -> List (Attribute msg)
buttonsEvents toMsg =
    [ onMouseEnter (toMsg HoverIn)
    , onMouseLeave (toMsg HoverOut)
    ]


extraAttributes : Bool -> List (Attribute msg)
extraAttributes processing =
    let
        mainStyles =
            [ style "transition" "opacity 0.7s, transform 0.3s" ]
    in
    if not processing then
        mainStyles
            ++ [ style "opacity" "1"
               , style "transform" "scale(1) translateY(0px) translateX(0px)"
               ]

    else
        mainStyles
            ++ [ style "opacity" "0"
               , style "transform" "scale(0.4) translateY(40px) translateX(0px)"
               ]
