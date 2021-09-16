module Example.Materialize.View.Autocomplete exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, h1, input, label, p, text)
import Html.Attributes exposing (class, classList, id)
import Html.Events exposing (onInput)
import Razoyo.Materialize.Forms.Autocomplete as Autocomplete


type alias Model =
    { autocomplete : Autocomplete.State
    , selected : Maybe String
    }


type Msg
    = FieldMsg Autocomplete.Msg


init : Model
init =
    { autocomplete = Autocomplete.init
    , selected = Nothing
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldMsg acMsg ->
            case Autocomplete.update acMsg model.autocomplete of
                Autocomplete.Internal state ->
                    ( { model | autocomplete = state }, Cmd.none )

                Autocomplete.Searched state ->
                    ( { model | autocomplete = state }, Cmd.none )

                Autocomplete.Selected state ->
                    ( { model | autocomplete = state }, Cmd.none )


view : Model -> Html Msg
view model =
    div
        [ id "view" ]
        [ div
            [ class "container" ]
            [ h1
                []
                [ text "Autocomplete" ]
            , field model
            ]
        ]


field : Model -> Html Msg
field model =
    div
        [ class "field" ]
        [ div
            [ class "control" ]
            [ Autocomplete.input
                fieldSettings
                model.autocomplete
                fieldOptions
                model.selected
            ]
        ]


fieldSettings : Autocomplete.Settings Msg
fieldSettings =
    { id = "ac-field"
    , label = "Favorite Linux Distribution"
    , toMsg = FieldMsg
    }


fieldOptions : List String
fieldOptions =
    [ "Fedora"
    , "Ubuntu"
    , "CentOS"
    , "Debian"
    , "Arch"
    , "Mint"
    , "Kali"
    ]
