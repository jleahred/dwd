module IndexTests exposing (..)

import GIndex
import Html exposing (Html)
import UrlParser
import UrlParser exposing ((<?>))


routeParserTest : List (UrlParser.Parser (Model -> c) c)
routeParserTest =
    [ UrlParser.map (initModel) (UrlParser.s "tests") ]



-----------------------------------------------
--  M O D E L


initModel : Model
initModel =
    let
        itemTuples =
            [ ( "GIndex", "This let us create Cards with link", "#test_gindex" )
            , ( "GMasterDetail", "Master detail tables", "#test_masterdetail" )
            ]

        itemFromTuple ( t, d, l ) =
            { title = t, desc = d, link = l }
    in
        { title = "Tests", items = List.map itemFromTuple itemTuples }


type alias Model =
    GIndex.Model



-----------------------------------------------
--  U P D A T E


type alias Msg =
    GIndex.Msg


update : Msg -> Model -> Model
update msg model =
    GIndex.update msg model



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view model =
    GIndex.view model
