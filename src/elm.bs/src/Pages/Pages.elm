module Pages exposing (..)

import Html exposing (Html)
import Html as H
import Bootstrap.Grid as Grid
import UrlParser


--

import NotFound
import Index
import Find
import MasterDetail
import About


routeParser : UrlParser.Parser (Model -> a) a
routeParser =
    UrlParser.oneOf <|
        List.map (UrlParser.map IndexModel) Index.routeParser
            ++ List.map (UrlParser.map FindModel) Find.routeParser
            ++ List.map (UrlParser.map AboutModel) About.routeParser
            ++ List.map (UrlParser.map MasterDetailModel) MasterDetail.routeParser



-----------------------------------------------
--  M O D E L


type Model
    = NotFoundModel NotFound.Model
    | IndexModel Index.Model
    | FindModel Find.Model
    | AboutModel About.Model
    | MasterDetailModel MasterDetail.Model


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
    | MasterDetailMsg MasterDetail.Msg


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

        MasterDetailMsg mdmsg_ ->
            let
                ( mdmsg, mdmodel ) =
                    case model of
                        MasterDetailModel model ->
                            ( mdmsg_, model )

                        _ ->
                            ( mdmsg_, MasterDetail.initModel )
            in
                MasterDetailModel <| MasterDetail.update mdmsg mdmodel



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

            MasterDetailModel m ->
                [ H.map MasterDetailMsg <| MasterDetail.view m ]



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
