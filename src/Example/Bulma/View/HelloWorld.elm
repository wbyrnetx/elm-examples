module Example.Bulma.View.HelloWorld exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


type alias Model =
    { input : String }


type Msg
    = Input String


init : Model
init =
    { input = "" }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input input ->
            { model | input = input }


view : (Msg -> msg) -> Model -> List (Html msg)
view toMsg model =
    [ div
        [ class "section" ]
        [ div
            [ class "container" ]
            [ h1
                [ class "title" ]
                [ text "Hello World" ]
            , nameField toMsg model
            , greeting model.input
            ]
        ]
    ]


nameField : (Msg -> msg) -> Model -> Html msg
nameField toMsg model =
    div
        [ class "field" ]
        [ label
            [ class "label" ]
            [ text "Enter your name" ]
        , div
            [ class "control" ]
            [ input
                [ class "input"
                , onInput (toMsg << Input)
                , value model.input
                ]
                []
            ]
        ]


greeting : String -> Html msg
greeting input =
    if input /= "" then
        p
            []
            [ text <| "Welcome to Elm examples, " ++ input ++ "!" ]

    else
        p [] []
