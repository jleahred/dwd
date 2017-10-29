module Pages exposing (..)

import Html exposing (Html)
import Html as H
import Bootstrap.Grid as Grid
import UrlParser
import UrlParser exposing ((<?>))


--

import NotFound
import Index
import Find


routeParser : UrlParser.Parser (Model -> a) a
routeParser =
    UrlParser.oneOf <|
        [ UrlParser.map (IndexModel Index.init) UrlParser.top

        --, UrlParser.map (FindModel Find.initModel) (UrlParser.s "findconfig")
        --, UrlParser.map (FindModel Find.exec) (UrlParser.s "find" <?> UrlParser.stringParam "txt")
        --, UrlParser.map (FindModel Find.exec) (UrlParser.s "find")
        ]
            ++ List.map (UrlParser.map (FindModel)) Find.routeParser



-----------------------------------------------
--  M O D E L


type Model
    = NotFoundModel NotFound.Model
    | IndexModel Index.Model
    | FindModel Find.Model


notFoundInit : NotFound.Model
notFoundInit =
    NotFound.initModel


indexInit : Index.Model
indexInit =
    Index.init



-----------------------------------------------
--  U P D A T E


type Msg
    = NotFoundMsg NotFound.Msg
    | IndexMsg Index.Msg
    | FindMsg Find.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        FindMsg msg ->
            let
                fmodel =
                    case model of
                        FindModel fmodel ->
                            fmodel

                        _ ->
                            Find.initModel
            in
                FindModel <| Find.update msg fmodel

        IndexMsg msg ->
            model

        NotFoundMsg _ ->
            model



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view model =
    let
        gridPage =
            case model of
                NotFoundModel m ->
                    [ H.map NotFoundMsg <| NotFound.view m ]

                IndexModel m ->
                    [ H.map IndexMsg <| Index.view m ]

                FindModel m ->
                    [ H.map FindMsg <| Find.view m ]
    in
        Grid.container [] <|
            gridPage
