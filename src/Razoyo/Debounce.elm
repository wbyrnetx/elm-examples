module Razoyo.Debounce exposing (PushMsg, State, debounce, debounceWith, init, push, pushWith)

import Process
import Task exposing (Task)


defaultWaitTime : Float
defaultWaitTime =
    1000


defaultMinLength : Int
defaultMinLength =
    2


type alias State =
    { num : Int
    , last : String
    }


init : State
init =
    State 0 ""


type alias PushMsg =
    Int


push : State -> String -> ( State, Task x PushMsg )
push state value =
    pushWith defaultWaitTime state value


pushWith : Float -> State -> String -> ( State, Task x PushMsg )
pushWith waitTime { num, last } value =
    let
        newNum =
            num + 1

        pushTask =
            \_ ->
                Task.succeed newNum

        sleepTask =
            Process.sleep waitTime
                |> Task.andThen pushTask
    in
    ( State newNum last, sleepTask )


debounce : PushMsg -> State -> String -> ( State, Bool )
debounce pushMsg state value =
    debounceWith defaultMinLength pushMsg state value


debounceWith : Int -> PushMsg -> State -> String -> ( State, Bool )
debounceWith minLength pushMsg { num, last } value =
    let
        isLast =
            pushMsg == num

        isDifferent =
            value /= last

        hasLength =
            String.length value > minLength
    in
    if isLast && isDifferent && hasLength then
        ( State num value, True )

    else
        ( State num last, False )
