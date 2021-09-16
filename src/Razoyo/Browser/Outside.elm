module Razoyo.Browser.Outside exposing (..)

{-| Detect clicks outside of an element.

Solution was found in this article:
<https://dev.to/margaretkrutikova/elm-dom-node-decoder-to-detect-click-outside-3ioh>

-}

import Browser.Events exposing (onMouseDown)
import Json.Decode as D


subscription : msg -> String -> Sub msg
subscription msg containerId =
    onMouseDown (outsideDecoder msg containerId)


outsideDecoder : msg -> String -> D.Decoder msg
outsideDecoder msg containerId =
    D.field "target" (isOutsideTarget containerId)
        |> D.andThen
            (\isOutside ->
                if isOutside then
                    D.succeed msg

                else
                    D.fail "inside dropdown"
            )


isOutsideTarget : String -> D.Decoder Bool
isOutsideTarget containerId =
    D.oneOf
        [ D.field "id" D.string
            |> D.andThen
                (\id ->
                    if containerId == id then
                        -- found match by id
                        D.succeed False

                    else
                        -- try next decoder
                        D.fail "continue"
                )
        , D.lazy (\_ -> isOutsideTarget containerId |> D.field "parentNode")

        -- fallback if all previous decoders failed
        , D.succeed True
        ]
