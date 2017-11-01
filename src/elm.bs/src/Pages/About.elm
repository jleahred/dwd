module About exposing (..)

import Html as H
import Html.Attributes as HA
import Html exposing (Html)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Card as Card
import UrlParser
import UrlParser exposing ((<?>))
import Markdown


routeParser : List (UrlParser.Parser (Model -> c) c)
routeParser =
    [ UrlParser.map (init) (UrlParser.s "about") ]



-----------------------------------------------
--  M O D E L


type alias Model =
    { description : String
    }


init : Model
init =
    { description =
        """This is a small container applications developed in elm lang.

Writted by jlea

**version**: 0.1

**date**: 2017-11-01
        """
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
    in
        H.div []
            [ H.h1 [] [ H.text "About" ]
            , Grid.row [] <|
                [ Grid.col [ Col.md12, Col.attrs [ colStyle ] ]
                    [ Card.config [ Card.outlinePrimary ]
                        |> Card.block []
                            [ Card.text [ HA.class "text-center" ] <|
                                [ Markdown.toHtml
                                    []
                                    model.description
                                ]
                            ]
                        |> Card.view
                    ]
                ]
            ]
