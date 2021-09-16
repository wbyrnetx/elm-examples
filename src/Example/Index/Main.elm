module Example.Index.Main exposing (..)

import Browser exposing (..)
import Browser.Navigation
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    { rand : Int }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1, Cmd.none )



-- UPDATE


type Msg
    = GoToBulma
    | GoToMaterialize


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoToBulma ->
            ( model, Browser.Navigation.load "/bulma.html" )

        GoToMaterialize ->
            ( model, Browser.Navigation.load "/materialize.html" )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Elm Examples | Index"
    , body = [ container ]
    }


container : Html Msg
container =
    div
        [ style "text-align" "center"
        , style "font-size" "3rem"
        ]
        [ bulmaButton
        , materializeButton
        ]


bulmaButton : Html Msg
bulmaButton =
    frameworkButton GoToBulma "Bulma Framework"


materializeButton : Html Msg
materializeButton =
    frameworkButton GoToMaterialize "Materialize CSS Framework"


frameworkButton : Msg -> String -> Html Msg
frameworkButton msg title =
    button
        [ onClick msg
        , style "width" "300px"
        , style "height" "100px"
        , style "margin" "100px 50px"
        ]
        [ text title ]



-- MAIN


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
