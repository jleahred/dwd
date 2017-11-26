module Pages exposing (..)

import Html exposing (Html)
import Html as H
import UrlParser


--

import NotFound
import Index
import Find
import About
import PagesTests


--


routeParser : UrlParser.Parser (Model -> a) a
routeParser =
    UrlParser.oneOf <|
        List.map (UrlParser.map IndexModel) Index.routeParser
            ++ List.map (UrlParser.map FindModel) Find.routeParser
            ++ List.map (UrlParser.map AboutModel) About.routeParser
            ++ List.map (UrlParser.map PagesTestsModel) PagesTests.routeParser



-----------------------------------------------
--  S U B S C R I P T I O N S


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        PagesTestsModel model_ ->
            Sub.batch
                [ Sub.map PagesTestsMsg <| PagesTests.subscriptions model_
                ]

        _ ->
            Sub.batch []



-----------------------------------------------
--  M O D E L


type Model
    = NotFoundModel NotFound.Model
    | IndexModel Index.Model
    | FindModel Find.Model
    | AboutModel About.Model
    | PagesTestsModel PagesTests.Model


notFoundInit : NotFound.Model
notFoundInit =
    NotFound.initModel


indexInit : Index.Model
indexInit =
    Index.initModel



-----------------------------------------------
--  U P D A T E


type Msg
    = NotFoundMsg NotFound.Msg
    | IndexMsg Index.Msg
    | FindMsg Find.Msg
    | AboutMsg About.Msg
    | PagesTestsMsg PagesTests.Msg


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
            let
                ( msg_, model_ ) =
                    case model of
                        IndexModel model_ ->
                            ( msg, model_ )

                        _ ->
                            ( msg, Index.initModel )
            in
                IndexModel <| Index.update msg_ model_

        AboutMsg msg ->
            model

        NotFoundMsg _ ->
            model

        PagesTestsMsg msg ->
            let
                ( msg_, model_ ) =
                    case model of
                        PagesTestsModel model ->
                            ( msg, model )

                        _ ->
                            ( msg, PagesTests.initModel )
            in
                PagesTestsModel <| PagesTests.update msg_ model_



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view model =
    --Grid.container [] <|
    H.div [] <|
        case model of
            NotFoundModel m ->
                [ H.map NotFoundMsg <| NotFound.view m ]

            IndexModel m ->
                [ H.map IndexMsg <| Index.view m ]

            FindModel m ->
                [ H.map FindMsg <| Find.view m ]

            AboutModel m ->
                [ H.map AboutMsg <| About.view m ]

            PagesTestsModel m ->
                [ H.map PagesTestsMsg <| PagesTests.view m ]



-- let
--     gridPage =
--         case model of
--             NotFoundModel m ->
--                 [ H.map NotFoundMsg <| NotFound.view m ]
--             IndexModel m ->
--                 [ H.map IndexMsg <| Index.view m ]
--             FindModel m ->
--                 [ H.map FindMsg <| Find.view m ]
--             AboutModel m ->
--                 [ H.map AboutMsg <| About.view m ]
--             MasterDetailModel m ->
--                 [ H.map MasterDetailMsg <| MasterDetail.view m ]
-- in
--     Grid.container [] <|
--         gridPage
--
