module Example.Bulma.Main exposing (..)

import Browser exposing (..)
import Example.Bulma.View.HelloWorld as HelloWorld
import Example.Bulma.View.Increment as Increment
import Html exposing (Html, a, div, nav, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    { view : View }


type View
    = HelloWorld HelloWorld.Model
    | Increment Increment.Model


type ViewChange
    = HelloWorldChange
    | IncrementChange


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (HelloWorld HelloWorld.init)
    , Cmd.none
    )



-- UPDATE


type Msg
    = ChangeView ViewChange
    | HelloWorldUpdate HelloWorld.Msg
    | IncrementUpdate Increment.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeView viewChange ->
            ( { model | view = changeView viewChange }, Cmd.none )

        HelloWorldUpdate viewMsg ->
            case model.view of
                HelloWorld data ->
                    ( { model | view = (HelloWorld << HelloWorld.update viewMsg) data }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        IncrementUpdate viewMsg ->
            case model.view of
                Increment data ->
                    ( { model | view = (Increment << Increment.update viewMsg) data }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )


changeView : ViewChange -> View
changeView viewChange =
    case viewChange of
        HelloWorldChange ->
            HelloWorld HelloWorld.init

        IncrementChange ->
            Increment Increment.init



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Elm Examples | Bulma"
    , body = navBar :: viewSections model.view ++ [ footer ]
    }



-- Navbar


navBarItems : List ( String, ViewChange )
navBarItems =
    [ ( "Hello World", HelloWorldChange )
    , ( "Increment", IncrementChange )
    ]


navBar : Html Msg
navBar =
    nav
        [ class "navbar" ]
        [ div
            [ class "container" ]
            [ div
                [ class "navbar-menu" ]
                [ div
                    [ class "navbar-start" ]
                    (List.map navBarItem navBarItems)
                ]
            ]
        ]


navBarItem : ( String, ViewChange ) -> Html Msg
navBarItem ( name, viewChange ) =
    a
        [ class "navbar-item"
        , onClick (ChangeView viewChange)
        ]
        [ text name ]



-- Body


viewSections : View -> List (Html Msg)
viewSections view_ =
    case view_ of
        HelloWorld viewModel ->
            HelloWorld.view HelloWorldUpdate viewModel

        Increment viewModel ->
            Increment.view IncrementUpdate viewModel



-- Footer


footer : Html Msg
footer =
    Html.footer
        [ class "footer" ]
        [ div
            [ class "container" ]
            [ p
                []
                [ text "Copyright Razoyo" ]
            ]
        ]



-- MAIN


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
