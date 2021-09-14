module Razoyo.Directory.US.States exposing (State, code, decoder, encode, list, name)

import Json.Decode exposing (Decoder)
import Json.Encode


type State
    = Alabama
    | Alaska
    | Arizona
    | Arkansas
    | California
    | Colorado
    | Connecticut
    | Delaware
    | DistrictOfColumbia
    | Florida
    | Georgia
    | Hawaii
    | Idaho
    | Illinois
    | Indiana
    | Iowa
    | Kansas
    | Kentucky
    | Louisiana
    | Maine
    | Maryland
    | Massachusetts
    | Michigan
    | Minnesota
    | Mississippi
    | Missouri
    | Montana
    | Nebraska
    | Nevada
    | NewHampshire
    | NewJersey
    | NewMexico
    | NewYork
    | NorthCarolina
    | NorthDakota
    | Ohio
    | Oklahoma
    | Oregon
    | Pennsylvania
    | RhodeIsland
    | SouthCarolina
    | SouthDakota
    | Tennessee
    | Texas
    | Utah
    | Vermont
    | Virginia
    | Washington
    | WestVirginia
    | Wisconsin
    | Wyoming


list : List State
list =
    [ Alabama
    , Alaska
    , Arizona
    , Arkansas
    , California
    , Colorado
    , Connecticut
    , Delaware
    , DistrictOfColumbia
    , Florida
    , Georgia
    , Hawaii
    , Idaho
    , Illinois
    , Indiana
    , Iowa
    , Kansas
    , Kentucky
    , Louisiana
    , Maine
    , Maryland
    , Massachusetts
    , Michigan
    , Minnesota
    , Mississippi
    , Missouri
    , Montana
    , Nebraska
    , Nevada
    , NewHampshire
    , NewJersey
    , NewMexico
    , NewYork
    , NorthCarolina
    , NorthDakota
    , Ohio
    , Oklahoma
    , Oregon
    , Pennsylvania
    , RhodeIsland
    , SouthCarolina
    , SouthDakota
    , Tennessee
    , Texas
    , Utah
    , Vermont
    , Virginia
    , Washington
    , WestVirginia
    , Wisconsin
    , Wyoming
    ]



--
-- Decode
--


decoder : Decoder State
decoder =
    Json.Decode.string
        |> Json.Decode.andThen stringDecoder


stringDecoder : String -> Decoder State
stringDecoder code_ =
    fromCode code_
        |> Maybe.map Json.Decode.succeed
        |> Maybe.withDefault (Json.Decode.fail "Invalid state.")



--
-- Encode
--


encode : State -> Json.Encode.Value
encode state =
    Json.Encode.string (code state)



--
-- States
--


code : State -> String
code state =
    case state of
        Alabama ->
            "AL"

        Alaska ->
            "AK"

        Arizona ->
            "AZ"

        Arkansas ->
            "AR"

        California ->
            "CA"

        Colorado ->
            "CO"

        Connecticut ->
            "CT"

        Delaware ->
            "DE"

        DistrictOfColumbia ->
            "DC"

        Florida ->
            "FL"

        Georgia ->
            "GA"

        Hawaii ->
            "HI"

        Idaho ->
            "ID"

        Illinois ->
            "IL"

        Indiana ->
            "IN"

        Iowa ->
            "IA"

        Kansas ->
            "KS"

        Kentucky ->
            "KY"

        Louisiana ->
            "LA"

        Maine ->
            "ME"

        Maryland ->
            "MD"

        Massachusetts ->
            "MA"

        Michigan ->
            "MI"

        Minnesota ->
            "MN"

        Mississippi ->
            "MS"

        Missouri ->
            "MO"

        Montana ->
            "MT"

        Nebraska ->
            "NE"

        Nevada ->
            "NV"

        NewHampshire ->
            "NH"

        NewJersey ->
            "NJ"

        NewMexico ->
            "NM"

        NewYork ->
            "NY"

        NorthCarolina ->
            "NC"

        NorthDakota ->
            "ND"

        Ohio ->
            "OH"

        Oklahoma ->
            "OK"

        Oregon ->
            "OR"

        Pennsylvania ->
            "PA"

        RhodeIsland ->
            "RI"

        SouthCarolina ->
            "SC"

        SouthDakota ->
            "SD"

        Tennessee ->
            "TN"

        Texas ->
            "TX"

        Utah ->
            "UT"

        Vermont ->
            "VT"

        Virginia ->
            "VA"

        Washington ->
            "WA"

        WestVirginia ->
            "WV"

        Wisconsin ->
            "WI"

        Wyoming ->
            "WY"


name : State -> String
name state =
    case state of
        Alabama ->
            "Alabama"

        Alaska ->
            "Alaska"

        Arizona ->
            "Arizona"

        Arkansas ->
            "Arkansas"

        California ->
            "California"

        Colorado ->
            "Colorado"

        Connecticut ->
            "Connecticut"

        Delaware ->
            "Delaware"

        DistrictOfColumbia ->
            "District of Columbia"

        Florida ->
            "Florida"

        Georgia ->
            "Georgia"

        Hawaii ->
            "Hawaii"

        Idaho ->
            "Idaho"

        Illinois ->
            "Illinois"

        Indiana ->
            "Indiana"

        Iowa ->
            "Iowa"

        Kansas ->
            "Kansas"

        Kentucky ->
            "Kentucky"

        Louisiana ->
            "Louisiana"

        Maine ->
            "Maine"

        Maryland ->
            "Maryland"

        Massachusetts ->
            "Massachusetts"

        Michigan ->
            "Michigan"

        Minnesota ->
            "Minnesota"

        Mississippi ->
            "Mississippi"

        Missouri ->
            "Missouri"

        Montana ->
            "Montana"

        Nebraska ->
            "Nebraska"

        Nevada ->
            "Nevada"

        NewHampshire ->
            "New Hampshire"

        NewJersey ->
            "New Jersey"

        NewMexico ->
            "New Mexico"

        NewYork ->
            "New York"

        NorthCarolina ->
            "North Carolina"

        NorthDakota ->
            "North Dakota"

        Ohio ->
            "Ohio"

        Oklahoma ->
            "Oklahoma"

        Oregon ->
            "Oregon"

        Pennsylvania ->
            "Pennsylvania"

        RhodeIsland ->
            "Rhode Island"

        SouthCarolina ->
            "South Carolina"

        SouthDakota ->
            "South Dakota"

        Tennessee ->
            "Tennessee"

        Texas ->
            "Texas"

        Utah ->
            "Utah"

        Vermont ->
            "Vermont"

        Virginia ->
            "Virginia"

        Washington ->
            "Washington"

        WestVirginia ->
            "West Virginia"

        Wisconsin ->
            "Wisconsin"

        Wyoming ->
            "Wyoming"


fromCode : String -> Maybe State
fromCode code_ =
    case code_ of
        "AL" ->
            Just Alabama

        "AK" ->
            Just Alaska

        "AZ" ->
            Just Arizona

        "AR" ->
            Just Arkansas

        "CA" ->
            Just California

        "CO" ->
            Just Colorado

        "CT" ->
            Just Connecticut

        "DE" ->
            Just Delaware

        "DC" ->
            Just DistrictOfColumbia

        "FL" ->
            Just Florida

        "GA" ->
            Just Georgia

        "HI" ->
            Just Hawaii

        "ID" ->
            Just Idaho

        "IL" ->
            Just Illinois

        "IN" ->
            Just Indiana

        "IA" ->
            Just Iowa

        "KS" ->
            Just Kansas

        "KY" ->
            Just Kentucky

        "LA" ->
            Just Louisiana

        "ME" ->
            Just Maine

        "MD" ->
            Just Maryland

        "MA" ->
            Just Massachusetts

        "MI" ->
            Just Michigan

        "MN" ->
            Just Minnesota

        "MS" ->
            Just Mississippi

        "MO" ->
            Just Missouri

        "MT" ->
            Just Montana

        "NE" ->
            Just Nebraska

        "NV" ->
            Just Nevada

        "NH" ->
            Just NewHampshire

        "NJ" ->
            Just NewJersey

        "NM" ->
            Just NewMexico

        "NY" ->
            Just NewYork

        "NC" ->
            Just NorthCarolina

        "ND" ->
            Just NorthDakota

        "OH" ->
            Just Ohio

        "OK" ->
            Just Oklahoma

        "OR" ->
            Just Oregon

        "PA" ->
            Just Pennsylvania

        "RI" ->
            Just RhodeIsland

        "SC" ->
            Just SouthCarolina

        "SD" ->
            Just SouthDakota

        "TN" ->
            Just Tennessee

        "TX" ->
            Just Texas

        "UT" ->
            Just Utah

        "VT" ->
            Just Vermont

        "VA" ->
            Just Virginia

        "WA" ->
            Just Washington

        "WV" ->
            Just WestVirginia

        "WI" ->
            Just Wisconsin

        "WY" ->
            Just Wyoming

        _ ->
            Nothing
