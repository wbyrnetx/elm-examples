module Example.Materialize.View.HelloWorld exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, h1, input, label, p, text)
import Html.Attributes exposing (class, id, value)
import Html.Events exposing (onInput)


type alias Model =
    { input : String }


type Msg
    = Input String


init : ( Model, Cmd Msg )
init =
    ( { input = "" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input input ->
            ( { model | input = input }, Cmd.none )


view : Model -> Html Msg
view model =
    div
        [ id "view" ]
        [ div
            [ class "container" ]
            [ h1
                []
                [ text "Hello World" ]
            , nameField model
            , greeting model.input
            ]
        ]


nameField : Model -> Html Msg
nameField model =
    div
        [ class "field" ]
        [ label
            [ class "label" ]
            [ text "Enter your name" ]
        , div
            [ class "control" ]
            [ input
                [ class "input"
                , onInput Input
                , value model.input
                ]
                []
            ]
        ]


greeting : String -> Html Msg
greeting input =
    if input /= "" then
        p
            []
            [ text <| "Welcome to Elm examples, " ++ input ++ "!" ]

    else
        p [] []
