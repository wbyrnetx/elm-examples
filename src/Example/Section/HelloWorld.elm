module Example.Section.HelloWorld exposing (Model, Msg, init, update, view)

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
    [ p
        []
        [ text (greeting model.input) ]
    , div
        []
        [ input
            [ onInput (toMsg << Input)
            , value model.input
            ]
            []
        ]
    ]


greeting : String -> String
greeting input =
    if input == "" then
        "Hello World!"

    else
        "Hello World, " ++ input ++ "!"
