module Main exposing (..)

import Browser exposing (Document)
import Html exposing (Html, button, div, p, text)
import Html.Events exposing (onClick)



-- Model


type alias Model =
    { clickCount : Int }


init : Int -> ( Model, Cmd Msg )
init startingCount =
    ( { clickCount = startingCount }, Cmd.none )



-- Update


type Msg
    = SayHello


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SayHello ->
            ( { clickCount = model.clickCount + 1 }, Cmd.none )



-- View


view : Model -> Document Msg
view model =
    { title = "Razoyo Internship | Elm Frontend"
    , body = [ mainDiv model ]
    }


mainDiv : Model -> Html Msg
mainDiv model =
    div
        []
        [ p
            []
            [ text ("You said hello " ++ String.fromInt model.clickCount ++ " times!") ]
        , button
            [ onClick SayHello ]
            [ text "Say Hi" ]
        ]



-- Main


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
