module GMasterDetail exposing (..)

import Array exposing (Array)
import Time exposing (Time, second)
import Html as H
import Html.Attributes as HA
import Html exposing (Html)
import Html.Events exposing (on)
import Json.Decode as Json
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Table as Table
import Bootstrap.Button as Button
import Bootstrap.ButtonGroup as ButtonGroup
import UrlParser
import UrlParser exposing ((<?>))
import UrlParser exposing ((</>))


-----------------------------------------------
-----------------------------------------------
--  T E S T


baseRouteTest : String
baseRouteTest =
    "test_masterdetail"


routeParserTest : List (UrlParser.Parser (Model -> c) c)
routeParserTest =
    [ UrlParser.map (emptyModel)
        (UrlParser.s baseRouteTest)
    , UrlParser.map (\route -> emptyModel)
        (UrlParser.s baseRouteTest
            </> urlParser
        )
    ]


emptyModel : Model
emptyModel =
    { master = emptyTableInfo
    , details = Array.fromList [ emptyTableInfo ]
    , selectedRow = 0
    , pageInfo = page1
    }


emptyTableInfo : TableInfo
emptyTableInfo =
    { headers = [], values = [ [] ] }


initModelTest : Model
initModelTest =
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
    , pageInfo = page1
    }


page1 : PageInfo
page1 =
    { page = 1, lastPage = False }



--  SUBSCRIPTIONS


subscriptionsTest : Model -> Sub Msg
subscriptionsTest model =
    Sub.batch
        [ Time.every (second * 2)
            (\_ ->
                Update model
            )
        ]



--  T E S T
-----------------------------------------------
-----------------------------------------------
--
-----------------------------------------------
--  ROUTE


baseRoute : String
baseRoute =
    "mastdetall"


type alias UrlInfo =
    { page : Int }


urlParser : UrlParser.Parser (Int -> a) a
urlParser =
    UrlParser.s baseRoute
        </> UrlParser.s "page"
        </> UrlParser.int



-- routeParser : List (UrlParser.Parser (Model -> c) c)
-- routeParser =
--     let
--         pageInformation pageNumber =
--             { page = pageNumber, lastPage = False }
--     in
--         [ UrlParser.map (initModelTest) UrlParser.top
--         , UrlParser.map (initModelTest) (UrlParser.s baseRoute)
--         , UrlParser.map (\urlInfo -> { initModelTest | pageInfo = pageInformation urlInfo.page })
--             (UrlParser.map
--                 UrlInfo
--                 (UrlParser.s baseRoute
--                     </> UrlParser.s "page"
--                     </> UrlParser.int
--                 )
--             )
--         ]
-----------------------------------------------
--  M O D E L


type alias Model =
    { master : TableInfo
    , details : Array TableInfo
    , selectedRow : Int
    , pageInfo : PageInfo
    }


type alias TableInfo =
    { headers : List String
    , values : List (List String)
    }


type alias PageInfo =
    { page : Int
    , lastPage : Bool
    }



-----------------------------------------------
--  U P D A T E


type Msg
    = RowClick Int
    | Update Model


update : Msg -> Model -> Model
update msg model =
    case msg of
        RowClick row ->
            { model | selectedRow = row }

        Update model ->
            model



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

        buttons pageInfo =
            [ ButtonGroup.linkButtonGroup []
                [ ButtonGroup.linkButton
                    [ Button.secondary
                    , Button.disabled <| pageInfo.page == 1
                    ]
                    [ H.text "<" ]
                , ButtonGroup.linkButton
                    [ Button.secondary
                    ]
                    [ H.text <| "Page: " ++ toString pageInfo.page ]
                , ButtonGroup.linkButton
                    [ Button.secondary
                    , Button.disabled pageInfo.lastPage
                    , Button.attrs [ HA.href <| "#" ++ baseRoute ++ "/?page=" ++ (toString pageInfo.page) ]
                    ]
                    [ H.text ">" ]
                ]
            ]
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
            , Grid.row [] <|
                [ Grid.col [ Col.md6, Col.attrs [ colStyle ] ]
                    [ H.div [ HA.align "center" ] (buttons model.pageInfo) ]
                ]
            , H.text <| toString model
            ]
