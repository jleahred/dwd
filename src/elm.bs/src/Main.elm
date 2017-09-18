module Main exposing (main)

import Html exposing (..)
import Html as H
import Html.Attributes exposing (..)
import Navigation exposing (Location)
import UrlParser
import Bootstrap.Navbar as Navbar
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Card as Card
import Bootstrap.Button as Button


-- modules

import Found


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { view = view
        , update = update
        , subscriptions = subscriptions
        , init = init
        }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        ( navState, navCmd ) =
            Navbar.initialState NavMsg

        ( model, urlCmd ) =
            urlUpdate location { navState = navState, page = Home }
    in
        ( model, Cmd.batch [ urlCmd, navCmd ] )


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navState NavMsg



-----------------------------------------------
--  M O D E L


type alias Model =
    { page : Page
    , navState : Navbar.State
    }


type Page
    = Home
    | FModel Found.Model
    | NotFound



-----------------------------------------------
--  U P D A T E


type Msg
    = UrlChange Location
    | NavMsg Navbar.State
    | FoundMsg Found.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            urlUpdate location model

        NavMsg state ->
            ( { model | navState = state }
            , Cmd.none
            )

        FoundMsg msg ->
            ( model
            , Cmd.none
            )


urlUpdate : Navigation.Location -> Model -> ( Model, Cmd Msg )
urlUpdate location model =
    case decode location of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just route ->
            ( { model | page = route }, Cmd.none )


decode : Location -> Maybe Page
decode location =
    UrlParser.parseHash routeParser location


routeParser : UrlParser.Parser (Page -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map (FModel Found.initModel) (UrlParser.s "find")
        ]



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view model =
    div []
        [ menu model
        , mainContent model
        ]


menu : Model -> Html Msg
menu model =
    Navbar.config NavMsg
        |> Navbar.withAnimation
        |> Navbar.container
        |> Navbar.brand [ href "#" ] [ text "DwD" ]
        |> Navbar.items
            [ Navbar.itemLink [ href "#find" ] [ text "Find" ]
            ]
        |> Navbar.view model.navState


mainContent : Model -> Html Msg
mainContent model =
    Grid.container [] <|
        case model.page of
            Home ->
                pageHome model

            NotFound ->
                pageNotFound

            FModel fmodel ->
                [ H.div [] [ H.map FoundMsg <| Found.view fmodel ] ]


pageHome : Model -> List (Html Msg)
pageHome model =
    let
        rowStyle : Attribute Msg
        rowStyle =
            style
                [ ( "padding-top", ".75rem" )
                , ( "padding-bottom", ".75rem" )
                ]
    in
        [ h1 [] [ text "Applications" ]
        , Grid.row [ Row.attrs [ rowStyle ] ]
            [ Grid.col [ Col.md4 ]
                [ Card.config [ Card.outlinePrimary ]
                    |> Card.headerH4 [] [ text "Find" ]
                    |> Card.block []
                        [ Card.text [] [ text "Look for documents by name (tags in a future)" ]
                        , Card.custom <|
                            Button.linkButton
                                [ Button.primary, Button.attrs [ href "#find" ] ]
                                [ text "Run" ]
                        ]
                    |> Card.view
                ]
            , Grid.col [ Col.md4 ]
                [ Card.config [ Card.outlinePrimary ]
                    |> Card.headerH4 [] [ text "Example option" ]
                    |> Card.block []
                        [ Card.text [] [ text "Just an example to test composition" ]
                        , Card.custom <|
                            Button.linkButton
                                [ Button.primary, Button.attrs [ href "#" ] ]
                                [ text "Run" ]
                        ]
                    |> Card.view
                ]
            , Grid.col [ Col.md4 ]
                [ Card.config [ Card.outlinePrimary ]
                    |> Card.headerH4 [] [ text "Example option" ]
                    |> Card.block []
                        [ Card.text [] [ text "Just an example to test composition" ]
                        , Card.custom <|
                            Button.linkButton
                                [ Button.primary, Button.attrs [ href "#getting-started" ] ]
                                [ text "Start" ]
                        ]
                    |> Card.view
                ]
            ]
        , Grid.row []
            [ Grid.col [ Col.md4 ]
                [ Card.config [ Card.outlineDanger ]
                    |> Card.headerH4 [] [ text "Modules" ]
                    |> Card.block []
                        [ Card.text [] [ text "Check out the modules overview" ]
                        , Card.custom <|
                            Button.linkButton
                                [ Button.primary, Button.attrs [ href "#modules" ] ]
                                [ text "Module" ]
                        ]
                    |> Card.view
                ]
            , Grid.col [ Col.md4 ]
                [ Card.config [ Card.outlineDanger ]
                    |> Card.headerH4 [] [ text "Modules" ]
                    |> Card.block []
                        [ Card.text [] [ text "Check out the modules overview" ]
                        , Card.custom <|
                            Button.linkButton
                                [ Button.primary, Button.attrs [ href "#modules" ] ]
                                [ text "Module" ]
                        ]
                    |> Card.view
                ]
            ]
        ]


pageNotFound : List (Html Msg)
pageNotFound =
    [ h1 [] [ text "Not found" ]
    , text "Sorry couldn't find that LOCAL page"
    ]
