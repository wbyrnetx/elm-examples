module Example.Materialize.Main exposing (..)

import Browser exposing (..)
import Example.Materialize.View.Autocomplete as Autocomplete
import Example.Materialize.View.HelloWorld as HelloWorld
import Html exposing (Html, a, div, li, nav, p, text, ul)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    { view : View }


type View
    = HelloWorld HelloWorld.Model
    | Autocomplete Autocomplete.Model


type ViewType
    = HelloWorldType
    | AutocompleteType


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (HelloWorld HelloWorld.init)
    , Cmd.none
    )


viewToType : View -> ViewType
viewToType view_ =
    case view_ of
        HelloWorld _ ->
            HelloWorldType

        Autocomplete _ ->
            AutocompleteType



-- UPDATE


type Msg
    = ChangeView ViewType
    | HelloWorldUpdate HelloWorld.Msg
    | AutocompleteUpdate Autocomplete.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.view ) of
        ( ChangeView viewType, _ ) ->
            ( { model | view = changeView viewType }, Cmd.none )

        ( HelloWorldUpdate viewMsg, HelloWorld data ) ->
            let
                ( viewModel, viewCmd ) =
                    HelloWorld.update viewMsg data
            in
            ( { model | view = HelloWorld viewModel }
            , Cmd.map HelloWorldUpdate viewCmd
            )

        ( AutocompleteUpdate viewMsg, Autocomplete data ) ->
            let
                ( viewModel, viewCmd ) =
                    Autocomplete.update viewMsg data
            in
            ( { model | view = Autocomplete viewModel }
            , Cmd.map AutocompleteUpdate viewCmd
            )

        _ ->
            ( model, Cmd.none )


changeView : ViewType -> View
changeView viewType =
    case viewType of
        HelloWorldType ->
            HelloWorld HelloWorld.init

        AutocompleteType ->
            Autocomplete Autocomplete.init



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Elm Examples | Materialize"
    , body =
        [ (navBar << viewToType) model.view
        , mainView model.view
        , footer
        ]
    }



-- Navbar


navBarItems : List ( String, ViewType )
navBarItems =
    [ ( "Hello World", HelloWorldType )
    , ( "Autocomplete", AutocompleteType )
    ]


navBar : ViewType -> Html Msg
navBar activeView =
    nav
        [ class "navbar" ]
        [ div
            [ class "nav-wrapper" ]
            [ ul
                [ class "left" ]
                (List.map (navBarItem activeView) navBarItems)
            ]
        ]


navBarItem : ViewType -> ( String, ViewType ) -> Html Msg
navBarItem activeView ( name, viewType ) =
    li
        [ classList [ ( "active", viewType == activeView ) ] ]
        [ a
            [ onClick (ChangeView viewType) ]
            [ text name ]
        ]



-- Body


mainView : View -> Html Msg
mainView view_ =
    case view_ of
        HelloWorld viewModel ->
            Html.map HelloWorldUpdate (HelloWorld.view viewModel)

        Autocomplete viewModel ->
            Html.map AutocompleteUpdate (Autocomplete.view viewModel)



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
