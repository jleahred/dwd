module MasterDetail exposing (..)

import Html as H
import Html.Attributes as HA
import Html exposing (Html)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Card as Card
import Bootstrap.Text as Text
import Bootstrap.Table as Table
import UrlParser
import UrlParser exposing ((<?>))


routeParser : List (UrlParser.Parser (Model -> c) c)
routeParser =
    [ UrlParser.map (init) (UrlParser.s "masterdetail") ]



-----------------------------------------------
--  M O D E L


type alias Model =
    { master : TableInfo
    , detail : TableInfo
    }


type alias TableInfo =
    { headers : List String
    , values : List (List String)
    }


init : Model
init =
    { master =
        { headers = [ "a", "b", "cc", "d", "e", "f", "g" ]
        , values =
            [ [ "va", "vb", "vc", "vc", "vc", "vc", "vc" ]
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
    }



-----------------------------------------------
--  U P D A T E


type Msg
    = None



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view model =
    let
        colStyle : H.Attribute Msg
        colStyle =
            HA.style
                [ ( "padding-top", ".75rem" )
                , ( "padding-bottom", ".75rem" )
                ]

        gridRow r =
            r |> List.map (\cell -> Table.td [] [ H.text cell ])

        table data =
            Table.table
                { options = [ Table.striped, Table.hover ]
                , thead =
                    Table.simpleThead <|
                        (data.headers |> List.map (\cell -> Table.th [] ([ H.text cell ])))
                , tbody =
                    Table.tbody [] <|
                        (data.values |> (List.map (\row -> Table.tr [] (gridRow row))))
                }
    in
        H.div []
            [ H.h1 []
                [ H.text "MasterDetail Example" ]
            , Grid.row [] <|
                [ Grid.col [ Col.md6, Col.attrs [ colStyle ] ]
                    [ Card.config []
                        |> Card.block []
                            [ Card.custom <| table model.master ]
                        |> Card.block [ Card.blockAlign Text.alignXsRight ]
                            [ Card.link [ HA.href "item.link" ] [ H.text "run" ] ]
                        |> Card.view
                    ]
                , Grid.col [ Col.md6, Col.attrs [ colStyle ] ]
                    [ Card.config []
                        |> Card.block []
                            [ Card.text [] [ H.text "item.desc" ] ]
                        |> Card.block [ Card.blockAlign Text.alignXsRight ]
                            [ Card.link [ HA.href "item.link" ] [ H.text "run" ] ]
                        |> Card.view
                    ]
                ]
            ]
