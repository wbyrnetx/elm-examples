module Razoyo.Debounce exposing (..)

import Process
import Task



--
-- Search
--


type alias Search =
    { current : String
    , previous : String
    }


initSearch : Search
initSearch =
    { current = ""
    , previous = ""
    }


setCurrentSearch : String -> Search -> Search
setCurrentSearch pushed search =
    { search | current = pushed }


setPreviousSearch : Search -> Search
setPreviousSearch search =
    { search | previous = search.current }



-- Used if page loads on tab where search value already exists


setAllSearch : String -> Search -> Search
setAllSearch pushed search =
    { search
        | current = pushed
        , previous = pushed
    }



--
-- Debounce
--


type alias Debounce =
    { allowBlank : Bool
    , current : String
    , previous : String
    , pushed : String
    }


defaultWait =
    500


push : (String -> msg) -> String -> Cmd msg
push toMsg value =
    Process.sleep defaultWait
        |> Task.andThen (\_ -> Task.succeed value)
        |> Task.perform toMsg


isDebounced : Debounce -> Bool
isDebounced params =
    let
        pushedEqualsCurrent =
            params.pushed == params.current

        currentNotEqualsPrevious =
            params.current /= params.previous

        currentNotEmpty =
            params.current /= ""
    in
    if params.allowBlank then
        pushedEqualsCurrent && currentNotEqualsPrevious

    else
        pushedEqualsCurrent && currentNotEqualsPrevious && currentNotEmpty
