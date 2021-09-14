module Example.Section.Increment exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    { times : Int }


type Msg
    = Add


init : Model
init =
    { times = 0 }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Add ->
            { model | times = model.times + 1 }


view : (Msg -> msg) -> Model -> List (Html msg)
view toMsg model =
    [ p
        []
        [ text <| "You are at " ++ String.fromInt model.times ++ "!" ]
    , div
        []
        [ button
            [ onClick (toMsg Add) ]
            [ text "+" ]
        ]
    ]
