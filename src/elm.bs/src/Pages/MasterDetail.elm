module MasterDetail exposing (..)

import Array exposing (Array)
import Html as H
import Html.Attributes as HA
import Html exposing (Html)
import Html.Events exposing (on)
import Json.Decode as Json
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Table as Table
import UrlParser
import UrlParser exposing ((<?>))


routeParser : List (UrlParser.Parser (Model -> c) c)
routeParser =
    [ UrlParser.map (initModel) (UrlParser.s "masterdetail") ]



-----------------------------------------------
--  M O D E L


type alias Model =
    { master : TableInfo
    , details : Array TableInfo
    , selectedRow : Int
    }


type alias TableInfo =
    { headers : List String
    , values : List (List String)
    }


initModel : Model
initModel =
    { master =
        { headers = [ "a", "b", "c", "d", "e", "f", "g" ]
        , values =
            [ [ "aaaaa", "aaaaa", "aaaaa", "aaaaa", "aaaaa", "aaaaa", "" ]
            , [ "bbbbb", "bbbbb", "bbbbb", "bbbbb", "bbbbb", "bbbbb", "" ]
            , [ "ccc", "ccc", "ccc", "ccc", "ccc", "ccc", "" ]
            , [ "dddd", "dddd", "dddd", "dddd", "dddd", "dddd", "dddd" ]
            , [ "eeee", "eeee", "", "", "eeee", "", "" ]
            , [ "ffff", "ffff", "ffff", "ffff", "ffff", "", "" ]
            , [ "ggggg", "", "", "", "", "ggggg", "" ]
            ]
        }
    , details =
        Array.fromList
            [ { headers = [ "a1", "b1", "c1" ]
              , values = [ [ "11", "22", "33" ], [ "va", "vb", "vc" ], [ "va", "vb", "vc" ] ]
              }
            , { headers = [ "aa", "bb", "cc" ]
              , values = [ [ "ava", "avb", "vc" ], [ "ava", "avb", "avc" ], [ "ava", "avb", "avc" ] ]
              }
            , { headers = [ "cca", "ccb", "ccc" ]
              , values = [ [ "va", "vb", "vc" ], [ "va", "vb", "vc" ], [ "va", "vb", "vc" ] ]
              }
            , { headers = [ "a", "b", "c" ]
              , values = [ [ "va", "vb", "vc" ], [ "va", "vb", "vc" ], [ "va", "vb", "vc" ] ]
              }
            ]
    , selectedRow = 0
    }



-----------------------------------------------
--  U P D A T E


type Msg
    = RowClick Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        RowClick row ->
            { model | selectedRow = row }



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
                            if (rowIdx == model.selectedRow) && (role == Master) then
                                [ Table.rowSuccess ]
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
                    { options = [ Table.hover, Table.bordered ]
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

        empty =
            { headers = [ "no detail" ]
            , values = [ [] ]
            }
    in
        H.div []
            [ H.h1 []
                [ H.text "MasterDetail Example" ]
            , Grid.row [] <|
                [ Grid.col [ Col.md6, Col.attrs [ colStyle ] ]
                    [ table model.master Master ]
                , Grid.col [ Col.md6, Col.attrs [ colStyle ] ]
                    [ table
                        (Maybe.withDefault empty (Array.get model.selectedRow model.details))
                        Slave
                    ]
                ]
            , H.text <| toString model
            ]
