module Index exposing (..)

import GIndex
import Html exposing (Html)
import UrlParser
import UrlParser exposing ((<?>))


routeParser : List (UrlParser.Parser (Model -> c) c)
routeParser =
    [ UrlParser.map (initModel) UrlParser.top ]



-----------------------------------------------
--  M O D E L


type alias Model =
    GIndex.Model


initModel : Model
initModel =
    let
        itemTuples =
            [ ( "Find", "Look for documents by name (tags in a future)", "#findconfig" )
            , ( "About", "Some info about this application", "#about" )
            ]

        itemFromTuple ( t, d, l ) =
            { title = t, desc = d, link = l }
    in
        { title = "Applications", items = List.map itemFromTuple itemTuples }



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
