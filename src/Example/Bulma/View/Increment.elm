module Example.Bulma.View.Increment exposing (Model, Msg, init, update, view)

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
    [ div
        [ class "section" ]
        [ div
            [ class "container" ]
            [ h1
                [ class "title" ]
                [ text "Increment" ]
            , p
                []
                [ text <| "You are at " ++ String.fromInt model.times ++ "!" ]
            , div
                []
                [ incrementButton toMsg ]
            ]
        ]
    ]


incrementButton : (Msg -> msg) -> Html msg
incrementButton toMsg =
    button
        [ class "button is-large is-primary"
        , onClick (toMsg Add)
        ]
        [ text "+" ]
