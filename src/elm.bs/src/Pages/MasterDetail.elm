module MasterDetail exposing (..)

import Html as H
import Html.Attributes as HA
import Html exposing (Html)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Table as Table
import UrlParser
import UrlParser exposing ((<?>))
import Html.Events exposing (on)
import Json.Decode as Json


routeParser : List (UrlParser.Parser (Model -> c) c)
routeParser =
    [ UrlParser.map (initModel) (UrlParser.s "masterdetail") ]



-----------------------------------------------
--  M O D E L


type alias Model =
    { master : TableInfo
    , detail : TableInfo
    , rowClicked : Int
    }


type alias TableInfo =
    { headers : List String
    , values : List (List String)
    }


initModel : Model
initModel =
    { master =
        { headers = [ "a", "b", "cc", "d", "e", "f", "g" ]
        , values =
            [ [ "vaasdfasdfasd", "vb", "vasfasfasfasdfc", "vasfasdfasdffsadfc", "vasdfasfasdfc", "vc", "vasfasfasdfsfdc" ]
            , [ "va", "vb", "vc" ]
            , [ "va", "vb", "vc" ]
            , [ "va", "vb", "vc" ]
            , [ "va", "vb", "vc" ]
            , [ "va", "vb", "vc" ]
            , [ "va", "vb", "vc" ]
            ]
        }
    , detail =
        { headers = [ "a", "b", "c" ]
        , values = [ [ "va", "vb", "vc" ], [ "va", "vb", "vc" ], [ "va", "vb", "vc" ] ]
        }
    , rowClicked = -1
    }



-----------------------------------------------
--  U P D A T E


type Msg
    = RowClick Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        RowClick row ->
            { model | rowClicked = row }



-----------------------------------------------
--  V I E W


type TableRole
    = Master
    | Slave


view : Model -> Html Msg
view model =
    let
        --onClick : msg -> H.Attribute msg
        onClick msg =
            on "click" (Json.succeed msg)

        colStyle : H.Attribute Msg
        colStyle =
            HA.style
                [ ( "padding-top", ".75rem" )
                , ( "padding-bottom", ".75rem" )
                ]

        gridRow r idx role =
            (r |> List.map (\cell -> Table.td [] [ H.text cell ]))

        table data role =
            let
                rowAttr rowIdx =
                    let
                        rowColor =
                            if rem rowIdx 2 == 0 then
                                [ Table.rowWarning ]
                            else
                                []
                    in
                        rowColor
                            ++ case role of
                                Master ->
                                    [ Table.rowAttr << onClick <| RowClick rowIdx ]

                                Slave ->
                                    []
            in
                Table.table
                    { options = [ Table.striped, Table.hover ]
                    , thead =
                        Table.simpleThead <|
                            (data.headers |> List.map (\cell -> Table.th [] ([ H.text cell ])))
                    , tbody =
                        Table.tbody [] <|
                            (data.values
                                |> (List.indexedMap
                                        (\rowIdx rowContent ->
                                            Table.tr
                                                (rowAttr rowIdx)
                                            <|
                                                gridRow rowContent rowIdx role
                                        )
                                   )
                            )
                    }
    in
        H.div []
            [ H.h1 []
                [ H.text "MasterDetail Example" ]
            , Grid.row [] <|
                [ Grid.col [ Col.md6, Col.attrs [ colStyle ] ]
                    [ table model.master Master ]
                , Grid.col [ Col.md6, Col.attrs [ colStyle ] ]
                    [ table model.detail Slave ]
                ]
            , H.text <| toString model
            ]
