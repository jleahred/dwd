module Index exposing (..)

import Html as H
import Html.Attributes as HA
import Html exposing (Html)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Card as Card
import Bootstrap.Button as Button
import UrlParser
import UrlParser exposing ((<?>))


routeParser : List (UrlParser.Parser (Model -> c) c)
routeParser =
    [ UrlParser.map (init) UrlParser.top ]



-----------------------------------------------
--  M O D E L


type alias Model =
    List
        { title : String
        , desc : String
        , link : String
        }


init : Model
init =
    let
        itemTuples =
            [ ( "Find", "Look for documents by name (tags in a future)", "#findconfig" )
            , ( "About", "Some info about this application", "#about" )
            ]

        itemFromTuple ( t, d, l ) =
            { title = t, desc = d, link = l }
    in
        List.map itemFromTuple itemTuples



-----------------------------------------------
--  U P D A T E


type Msg
    = None



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view items =
    let
        colStyle : H.Attribute Msg
        colStyle =
            HA.style
                [ ( "padding-top", ".75rem" )
                , ( "padding-bottom", ".75rem" )
                ]

        cardFromItem item =
            Grid.col [ Col.md4, Col.attrs [ colStyle ] ]
                [ Card.config [ Card.outlinePrimary ]
                    |> Card.headerH4 [] [ H.text item.title ]
                    |> Card.block []
                        [ Card.text [] [ H.text item.desc ]
                        , Card.custom <|
                            H.div [ HA.align "right" ]
                                [ Button.linkButton
                                    [ Button.primary, Button.attrs [ HA.href item.link ] ]
                                    [ H.text "Run" ]
                                ]
                        ]
                    |> Card.view
                ]
    in
        H.div []
            [ H.h1 [] [ H.text "Applications" ]
            , Grid.row [] <|
                List.map cardFromItem items
            ]
