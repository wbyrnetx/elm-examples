module Razoyo.Directory.US.Field exposing (..)

import Html exposing (Html)
import Razoyo.Directory.US.States exposing (State, code, list, name)
import Razoyo.Materialize.Forms.Autocomplete as Autocomplete exposing (Autocomplete)



--
-- Subscriptions
--


subscription : (Msg -> msg) -> Sub msg
subscription toMsg =
    Autocomplete.subscription (autocompleteSettings toMsg)


type alias Field =
    { autocomplete : Autocomplete }


init : Field
init =
    { autocomplete = Autocomplete.init }


initWith : State -> Field
initWith state =
    { autocomplete = Autocomplete.initWith (name state) }



--
-- Update
--


type Action
    = Internal Field
    | Selected State Field


type Msg
    = AutocompleteMsg Autocomplete.Msg


update : (Msg -> msg) -> Msg -> Field -> Action
update toMsg msg field =
    case msg of
        AutocompleteMsg subMsg ->
            case Autocomplete.update subMsg field.autocomplete of
                Autocomplete.Internal autocomplete ->
                    Internal { field | autocomplete = autocomplete }

                Autocomplete.Searched autocomplete ->
                    let
                        matchingStates =
                            List.filter (\s -> name s == autocomplete.search.current) list
                    in
                    case List.head matchingStates of
                        Just selectedState ->
                            Selected selectedState { field | autocomplete = autocomplete }

                        Nothing ->
                            Internal { field | autocomplete = autocomplete }

                Autocomplete.Selected autocomplete ->
                    let
                        matchingStates =
                            List.filter (\s -> name s == autocomplete.search.current) list
                    in
                    case List.head matchingStates of
                        Just selectedState ->
                            Selected selectedState { field | autocomplete = autocomplete }

                        Nothing ->
                            Internal field



--
-- View
--


input : (Msg -> msg) -> Field -> Maybe State -> Html msg
input toMsg field selectedState =
    Autocomplete.input
        (autocompleteSettings toMsg)
        field.autocomplete
        (options field.autocomplete.search.current)
        (Maybe.map name selectedState)


options : String -> List String
options search_ =
    if search_ == "" then
        List.map name list

    else
        search search_
            |> List.map name


search : String -> List State
search search_ =
    case searchByExactCode search_ of
        Just exactCodeMatch ->
            [ exactCodeMatch ]

        Nothing ->
            List.filter (matchesSearch search_) list


searchByExactCode : String -> Maybe State
searchByExactCode search_ =
    List.filter (\s -> String.toLower (code s) == String.toLower search_) list
        |> List.head


matchesSearch : String -> State -> Bool
matchesSearch search_ state =
    String.contains (String.toLower search_) (String.toLower (name state))
        || String.contains (String.toLower search_) (String.toLower (code state))


autocompleteSettings : (Msg -> msg) -> Autocomplete.Settings msg
autocompleteSettings toMsg =
    { id = "change-this"
    , label = "State"
    , toMsg = toMsg << AutocompleteMsg
    }
