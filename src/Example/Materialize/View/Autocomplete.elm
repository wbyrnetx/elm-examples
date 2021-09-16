module Example.Materialize.View.Autocomplete exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, h1, input, label, p, text)
import Html.Attributes exposing (class, classList, id)
import Html.Events exposing (onInput)
import Razoyo.Debounce as Debounce
import Razoyo.Materialize.Forms.Autocomplete as Autocomplete
import Razoyo.RandomUser as RandomUser
import Razoyo.Time exposing (zoneNames)
import Task



-- MODEL


type alias Model =
    { distributions : List Distribution
    , distributionField : Autocomplete.State
    , selectedDistribution : Maybe Distribution
    , timezoneField : Autocomplete.State
    , selectedTimezone : Maybe String
    , users : List RandomUser.User
    , userField : Autocomplete.State
    , selectedUser : Maybe RandomUser.User
    , userDebounce : Debounce.State
    }


type alias Distribution =
    { name : String
    , family : Family
    }


type Family
    = Redhat
    | Debian
    | Other


init : ( Model, Cmd Msg )
init =
    ( initialModel, RandomUser.request LoadedUsers )


initialModel : Model
initialModel =
    { distributions = allDistributions
    , distributionField = Autocomplete.init
    , selectedDistribution = Nothing
    , timezoneField = Autocomplete.init
    , selectedTimezone = Nothing
    , users = []
    , userField = Autocomplete.init
    , selectedUser = Nothing
    , userDebounce = Debounce.init
    }


allDistributions : List Distribution
allDistributions =
    [ Distribution "Fedora" Redhat
    , Distribution "Ubuntu" Debian
    , Distribution "CentOS" Redhat
    , Distribution "Debian" Debian
    , Distribution "Arch" Other
    , Distribution "Mint" Other
    , Distribution "Kali" Debian
    ]



-- UPDATE


type Msg
    = LoadedUsers RandomUser.RequestResult
    | TimezoneFieldMsg Autocomplete.Msg
    | DistributionFieldMsg Autocomplete.Msg
    | UserFieldMsg Autocomplete.Msg
    | UserDebounced Debounce.PushMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadedUsers result ->
            case result of
                Ok users ->
                    ( { model | users = users }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        {-
           I just need to update a string value from a static list of options
        -}
        TimezoneFieldMsg acMsg ->
            let
                ( newState, maybeZone ) =
                    Autocomplete.update acMsg model.timezoneField

                newModel =
                    { model | timezoneField = newState }
            in
            case maybeZone of
                -- The user selected a record
                Just zone ->
                    ( { newModel | selectedTimezone = maybeZone }
                    , Cmd.none
                    )

                -- The user did something I don't care about
                Nothing ->
                    ( newModel, Cmd.none )

        {-
           I'm using a custom data type and need to find it from a list of options on my Model
        -}
        DistributionFieldMsg acMsg ->
            let
                ( newState, maybeId ) =
                    Autocomplete.update acMsg model.distributionField

                newModel =
                    { model | distributionField = newState }
            in
            case maybeId of
                -- The user selected a record
                Just id ->
                    case List.head (List.filter ((==) id << .name) model.distributions) of
                        -- The ID of the reocrd the user selected exists, I have it
                        Just distribution ->
                            ( { newModel | selectedDistribution = Just distribution }, Cmd.none )

                        -- The ID of the reocrd the user selected does NOT exist
                        Nothing ->
                            ( newModel, Cmd.none )

                -- The user did something I don't care about
                Nothing ->
                    ( newModel, Cmd.none )

        {-
           I'm using a custom data type and need to find it from a list of options on my Model
        -}
        UserFieldMsg acMsg ->
            let
                ( newState, maybeOp ) =
                    Autocomplete.customUpdate
                        (Just UserFieldInput)
                        (Just UserFieldChose)
                        acMsg
                        model.userField

                newModel =
                    { model | userField = newState }
            in
            case maybeOp of
                -- The user did something I DO care about, they added input
                Just UserFieldInput ->
                    let
                        ( newDebounce, debounceTask ) =
                            Debounce.push newModel.userDebounce newState.search
                    in
                    ( { newModel | userDebounce = newDebounce }
                    , Task.perform UserDebounced debounceTask
                    )

                -- The user did something I DO care about, they selected a record
                Just (UserFieldChose id) ->
                    case List.head (List.filter ((==) id << .email) model.users) of
                        Just user ->
                            ( { newModel | selectedUser = Just user }, Cmd.none )

                        Nothing ->
                            ( newModel, Cmd.none )

                -- The user did something I don't care about
                Nothing ->
                    ( newModel, Cmd.none )

        UserDebounced pushMsg ->
            let
                ( newState, isReady ) =
                    Debounce.debounce pushMsg model.userDebounce model.userField.search

                newModel =
                    { model | userDebounce = newState }
            in
            if isReady then
                ( newModel, RandomUser.request LoadedUsers )

            else
                ( newModel, Cmd.none )


type UserFieldOp
    = UserFieldInput
    | UserFieldChose String



-- VIEjW


view : Model -> Html Msg
view model =
    div
        [ id "view" ]
        [ div
            [ class "container" ]
            [ h1
                []
                [ text "Autocomplete" ]
            , div
                [ class "row" ]
                [ timezoneField model ]
            , div
                [ class "row" ]
                [ distributionField model ]
            , div
                [ class "row" ]
                [ userField model ]
            ]
        ]



-- Timezone


timezoneField : Model -> Html Msg
timezoneField model =
    let
        info =
            model.selectedTimezone
                |> Maybe.map (\x -> "You selected " ++ x)
                |> Maybe.withDefault ""
    in
    div
        [ class "field" ]
        [ div
            [ class "control" ]
            [ Autocomplete.input
                TimezoneFieldMsg
                timezoneFieldConfig
                model.timezoneField
                zoneNames
                model.selectedTimezone
            ]
        , p
            []
            [ text info ]
        ]


timezoneFieldConfig : Autocomplete.ViewConfig String
timezoneFieldConfig =
    { id = "timezone-ac"
    , label = "What is your timezone?"
    , placeholder = Just "UTC"
    , toId = identity
    }



-- Linux Distribution autocomplete


distributionField : Model -> Html Msg
distributionField model =
    div
        [ class "field" ]
        [ div
            [ class "control" ]
            [ Autocomplete.input
                DistributionFieldMsg
                distributionFieldConfig
                model.distributionField
                model.distributions
                model.selectedDistribution
            , p
                []
                [ text (familyMessage model.selectedDistribution) ]
            ]
        ]


distributionFieldConfig : Autocomplete.ViewConfig Distribution
distributionFieldConfig =
    { id = "distribution-ac"
    , label = "Favorite Linux Distribution"
    , placeholder = Nothing
    , toId = .name
    }


familyMessage : Maybe Distribution -> String
familyMessage maybeDistribution =
    case maybeDistribution of
        Just distribution ->
            case distribution.family of
                Redhat ->
                    "Oh, you like Redhat?"

                Debian ->
                    "So basic."

                Other ->
                    "You are so indie."

        Nothing ->
            ""



-- User autocomplete


userField : Model -> Html Msg
userField model =
    div
        [ class "field" ]
        [ div
            [ class "control" ]
            [ Autocomplete.input
                UserFieldMsg
                userFieldConfig
                model.userField
                model.users
                model.selectedUser
            , p
                []
                [ text (userGreeting model.selectedUser) ]
            ]
        ]


userFieldConfig : Autocomplete.ViewConfig RandomUser.User
userFieldConfig =
    { id = "user-ac"
    , label = "User"
    , placeholder = Nothing
    , toId = .email
    }


userGreeting : Maybe RandomUser.User -> String
userGreeting maybeUser =
    case maybeUser of
        Just user ->
            "Hello, " ++ user.firstName ++ " " ++ user.lastName

        Nothing ->
            ""
