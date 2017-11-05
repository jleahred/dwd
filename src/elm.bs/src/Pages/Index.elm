module Index exposing (..)

import Html as H
import Html.Attributes as HA
import Html exposing (Html)
import Html.Events exposing (on)
import Json.Decode as Json
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Card as Card
import Bootstrap.Text as Text


--import Bootstrap.Button as Button

import UrlParser
import UrlParser exposing ((<?>))


routeParser : List (UrlParser.Parser (Model -> c) c)
routeParser =
    [ UrlParser.map (initModel) UrlParser.top ]



-----------------------------------------------
--  M O D E L


type alias Model =
    List
        { title : String
        , desc : String
        , link : String
        }


initModel : Model
initModel =
    let
        itemTuples =
            [ ( "Find", "Look for documents by name (tags in a future)", "#findconfig" )
            , ( "Master Detail", "A small example of master detail page", "#masterdetail" )
            , ( "About", "Some info about this application", "#about" )
            ]

        itemFromTuple ( t, d, l ) =
            { title = t, desc = d, link = l }
    in
        List.map itemFromTuple itemTuples



-----------------------------------------------
--  U P D A T E


type Msg
    = Clicked


update : Msg -> Model -> Model
update msg model =
    case msg of
        Clicked ->
            model ++ model



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view items =
    let
        onClick msg =
            on "click" (Json.succeed msg)

        colStyle : H.Attribute Msg
        colStyle =
            HA.style
                [ ( "padding-top", ".75rem" )
                , ( "padding-bottom", ".75rem" )
                ]

        cardFromItem item =
            Grid.col [ Col.md4, Col.attrs [ colStyle ] ]
                [ Card.config [ Card.attrs <| [ onClick Clicked ] ]
                    |> Card.headerH4 []
                        [ H.text item.title

                        -- , H.div [ HA.align "right" ]
                        --     [ Button.linkButton
                        --         [ Button.primary, Button.attrs [ HA.href item.link ] ]
                        --         [ H.text "Run" ]
                        --     ]
                        ]
                    |> Card.block []
                        [ Card.text [] [ H.text item.desc ]
                        ]
                    |> Card.block [ Card.blockAlign Text.alignXsRight ]
                        [ Card.link [ HA.href item.link ] [ H.text "run" ]
                        ]
                    -- |> Card.block [ Card.blockAlign Text.alignXsRight ]
                    --     [ Card.custom <|
                    --         Button.linkButton
                    --             [ Button.primary, Button.attrs [ HA.href item.link ] ]
                    --             [ H.text "Run" ]
                    --     ]
                    -- |> Card.footer [ HA.align "right" ]
                    --     [ Button.linkButton
                    --         [ Button.primary, Button.attrs [ HA.href item.link ] ]
                    --         [ H.text "Run" ]
                    --     ]
                    |> Card.view
                ]
    in
        Grid.container [] <|
            [ H.h1 []
                [ H.text "Applications" ]
            , Grid.row [] <|
                List.map
                    cardFromItem
                    items
            ]
