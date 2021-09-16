module Razoyo.Debounce exposing (PushMsg, State, debounce, init, push)

import Process
import Task exposing (Task)


type alias State =
    { num : Int
    , last : String
    }


init : State
init =
    State 0 ""


defaultWait : Float
defaultWait =
    2000


type alias PushMsg =
    Int


push : State -> String -> ( State, Task x PushMsg )
push { num, last } value =
    let
        newNum =
            num + 1

        pushTask =
            \_ ->
                Task.succeed newNum

        sleepTask =
            Process.sleep defaultWait
                |> Task.andThen pushTask
    in
    ( State newNum last, sleepTask )


debounce : PushMsg -> State -> String -> ( State, Bool )
debounce pushMsg { num, last } value =
    let
        isLast =
            pushMsg == num

        isDifferent =
            value /= last

        hasLength =
            String.length value > 3
    in
    if isLast && isDifferent && hasLength then
        ( State num value, True )

    else
        ( State num last, False )
