module MasterDetail exposing (..)

import Html as H
import Html.Attributes as HA
import Html exposing (Html)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Table as Table
import Bootstrap.Button as Button
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
    }



-----------------------------------------------
--  U P D A T E


type Msg
    = Click



-----------------------------------------------
--  V I E W


type TableRole
    = Master
    | Slave


view : Model -> Html Msg
view model =
    let
        colStyle : H.Attribute Msg
        colStyle =
            HA.style
                [ ( "padding-top", ".75rem" )
                , ( "padding-bottom", ".75rem" )
                ]

        gridRow r idx role =
            (r |> List.map (\cell -> Table.td [] [ H.text cell ]))
                ++ case role of
                    Master ->
                        [ Table.td [] [ Button.button [ Button.secondary ] [ H.text ">" ] ] ]

                    Slave ->
                        []

        table data role =
            Table.table
                { options = [ Table.striped ]
                , thead =
                    Table.simpleThead <|
                        (data.headers |> List.map (\cell -> Table.th [] ([ H.text cell ])))
                , tbody =
                    Table.tbody [] <|
                        (data.values |> (List.map (\row -> Table.tr [] (gridRow row 0 role))))
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
            ]
