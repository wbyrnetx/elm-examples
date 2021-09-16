module Razoyo.RandomUser exposing (RequestResult, User, request)

import Http
import Json.Decode as D
import Url.Builder as UB



-- MODEL


type alias User =
    { firstName : String
    , lastName : String
    , email : String
    }



-- HTTP


type alias RequestResult =
    Result Http.Error (List User)


request : (RequestResult -> msg) -> Cmd msg
request toMsg =
    Http.get
        { url = apiUrl
        , expect = Http.expectJson toMsg userListDecoder
        }


apiUrl : String
apiUrl =
    UB.crossOrigin "https://randomuser.me/"
        [ "api" ]
        [ UB.int "results" 50 ]



-- JSON


userListDecoder : D.Decoder (List User)
userListDecoder =
    D.field "results" (D.list userDecoder)


userDecoder : D.Decoder User
userDecoder =
    D.map3 User
        (D.at [ "name", "first" ] D.string)
        (D.at [ "name", "last" ] D.string)
        (D.field "email" D.string)
