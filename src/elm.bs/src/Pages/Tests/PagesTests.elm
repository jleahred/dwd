module PagesTests exposing (..)

import Html exposing (Html)
import Html as H
import UrlParser


--

import IndexTests
import GIndex
import GMasterDetail


--


routeParser : List (UrlParser.Parser (Model -> c) c)
routeParser =
    List.map (UrlParser.map IndexTestsModel) IndexTests.routeParserTest
        ++ List.map (UrlParser.map GIndexModel) GIndex.routeParserTest
        ++ List.map (UrlParser.map GMasterDetailModel) GMasterDetail.routeParserTest



-----------------------------------------------
--  S U B S C R I P T I O N S


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        GMasterDetailModel model_ ->
            Sub.batch
                [ Sub.map GMasterDetailMsg <| GMasterDetail.subscriptionsTest model_
                ]

        _ ->
            Sub.batch []



-----------------------------------------------
--  M O D E L


type Model
    = IndexTestsModel IndexTests.Model
    | GIndexModel GIndex.Model
    | GMasterDetailModel GMasterDetail.Model


initModel : Model
initModel =
    IndexTestsModel IndexTests.initModel



-----------------------------------------------
--  U P D A T E


type Msg
    = IndexTestsMsg IndexTests.Msg
    | GIndexMsg GIndex.Msg
    | GMasterDetailMsg GMasterDetail.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        IndexTestsMsg msg ->
            let
                ( msg_, model_ ) =
                    case model of
                        IndexTestsModel model_ ->
                            ( msg, model_ )

                        _ ->
                            ( msg, IndexTests.initModel )
            in
                IndexTestsModel <| IndexTests.update msg_ model_

        GIndexMsg msg ->
            let
                ( msg_, model_ ) =
                    case model of
                        GIndexModel model_ ->
                            ( msg, model_ )

                        _ ->
                            ( msg, GIndex.initModelTest )
            in
                GIndexModel <| GIndex.update msg_ model_

        GMasterDetailMsg mdmsg_ ->
            let
                ( mdmsg, mdmodel ) =
                    case model of
                        GMasterDetailModel model ->
                            ( mdmsg_, model )

                        _ ->
                            ( mdmsg_, GMasterDetail.initModelTest )
            in
                GMasterDetailModel <| GMasterDetail.update mdmsg mdmodel



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view model =
    H.div [] <|
        case model of
            IndexTestsModel m ->
                [ H.map IndexTestsMsg <| IndexTests.view m ]

            GIndexModel m ->
                [ H.map IndexTestsMsg <| IndexTests.view m ]

            GMasterDetailModel m ->
                [ H.map GMasterDetailMsg <| GMasterDetail.view m ]
