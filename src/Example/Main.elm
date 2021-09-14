module Example.Main exposing (..)

import Browser exposing (..)
import Example.Section.HelloWorld as HelloWorld
import Example.Section.Increment as Increment
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)



-- MODEL


type alias Model =
    { section : Section }


type Section
    = HelloWorld HelloWorld.Model
    | Increment Increment.Model


type ChangeTo
    = HelloWorldChange
    | IncrementChange


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (HelloWorld HelloWorld.init)
    , Cmd.none
    )



-- UPDATE


type Msg
    = ChangeSection ChangeTo
    | HelloWorldUpdate HelloWorld.Msg
    | IncrementUpdate Increment.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeSection changeTo ->
            let
                section_ =
                    case changeTo of
                        HelloWorldChange ->
                            HelloWorld HelloWorld.init

                        IncrementChange ->
                            Increment Increment.init
            in
            ( { model | section = section_ }, Cmd.none )

        HelloWorldUpdate sectionMsg ->
            case model.section of
                HelloWorld data ->
                    ( { model | section = (HelloWorld << HelloWorld.update sectionMsg) data }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        IncrementUpdate sectionMsg ->
            case model.section of
                Increment data ->
                    ( { model | section = (Increment << Increment.update sectionMsg) data }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Razoyo Internship | Todo"
    , body = body model
    }


body : Model -> List (Html Msg)
body model =
    [ navigation
    , div [] (section model.section)
    ]


navigation : Html Msg
navigation =
    ul
        []
        (List.map navigationItem navigationItems)


navigationItems : List ( String, ChangeTo )
navigationItems =
    [ ( "Hello World", HelloWorldChange )
    , ( "Increment", IncrementChange )
    ]


navigationItem : ( String, ChangeTo ) -> Html Msg
navigationItem ( name, changeTo ) =
    li
        []
        [ a
            [ href "#"
            , onClick (ChangeSection changeTo)
            ]
            [ text name ]
        ]


section : Section -> List (Html Msg)
section section_ =
    case section_ of
        HelloWorld sectionModel ->
            HelloWorld.view HelloWorldUpdate sectionModel

        Increment sectionModel ->
            Increment.view IncrementUpdate sectionModel



-- MAIN


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
