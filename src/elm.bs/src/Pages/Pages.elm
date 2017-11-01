module Pages exposing (..)

import Html exposing (Html)
import Html as H
import Bootstrap.Grid as Grid
import UrlParser


--

import NotFound
import Index
import Find
import About


routeParser : UrlParser.Parser (Model -> a) a
routeParser =
    UrlParser.oneOf <|
        List.map (UrlParser.map IndexModel) Index.routeParser
            ++ List.map (UrlParser.map FindModel) Find.routeParser
            ++ List.map (UrlParser.map AboutModel) About.routeParser



-----------------------------------------------
--  M O D E L


type Model
    = NotFoundModel NotFound.Model
    | IndexModel Index.Model
    | FindModel Find.Model
    | AboutModel About.Model


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
    | AboutMsg About.Msg


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

        AboutMsg msg ->
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

                AboutModel m ->
                    [ H.map AboutMsg <| About.view m ]
    in
        Grid.container [] <|
            gridPage
