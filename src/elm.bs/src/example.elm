module Main exposing (main)

import Html exposing (..)
import Html as H
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Navigation exposing (Location)


-- import UrlParser exposing ((</>))

import UrlParser
import Bootstrap.Navbar as Navbar
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Card as Card
import Bootstrap.Button as Button
import Bootstrap.ListGroup as Listgroup
import Bootstrap.Modal as Modal


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { view = view
        , update = update
        , subscriptions = subscriptions
        , init = init
        }



-----------------------------------------------
--  M O D E L


type alias Model =
    { page : Page
    , navState : Navbar.State
    , modalState : Modal.State
    }


type Page
    = Home
    | GettingStarted
    | Modules
    | NotFound


init : Location -> ( Model, Cmd Msg )
init location =
    let
        ( navState, navCmd ) =
            Navbar.initialState NavMsg

        ( model, urlCmd ) =
            urlUpdate location { navState = navState, page = Home, modalState = Modal.hiddenState }
    in
        ( model, Cmd.batch [ urlCmd, navCmd ] )



-----------------------------------------------
--  U P D A T E


type Msg
    = UrlChange Location
    | NavMsg Navbar.State
    | ModalMsg Modal.State


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navState NavMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            urlUpdate location model

        NavMsg state ->
            ( { model | navState = state }
            , Cmd.none
            )

        ModalMsg state ->
            ( { model | modalState = state }
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
        , UrlParser.map GettingStarted (UrlParser.s "getting-started")
        , UrlParser.map Modules (UrlParser.s "modules")
        ]



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view model =
    div []
        [ menu model
        , mainContent model
        , modal model
        ]


menu : Model -> Html Msg
menu model =
    Navbar.config NavMsg
        |> Navbar.withAnimation
        |> Navbar.container
        |> Navbar.brand [ href "#" ] [ text "DwD" ]
        |> Navbar.items
            [ Navbar.itemLink [ href "#find" ] [ text "Find" ]
            , Navbar.itemLink [ href "#getting-started" ] [ text "Getting started" ]
            , Navbar.itemLink [ href "#modules" ] [ text "Modules" ]
            ]
        |> Navbar.view model.navState


mainContent : Model -> Html Msg
mainContent model =
    Grid.container [] <|
        case model.page of
            Home ->
                pageHome model

            GettingStarted ->
                pageGettingStarted model

            Modules ->
                pageModules model

            NotFound ->
                pageNotFound


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


pageGettingStarted : Model -> List (Html Msg)
pageGettingStarted model =
    [ h2 [] [ text "Getting started" ]
    , Button.button
        [ Button.success
        , Button.large
        , Button.block
        , Button.attrs [ onClick <| ModalMsg Modal.visibleState ]
        ]
        [ text "Click me" ]
    ]


pageModules : Model -> List (Html Msg)
pageModules model =
    [ h1 [] [ text "Modules" ]
    , Listgroup.ul
        [ Listgroup.li [] [ text "Alert" ]
        , Listgroup.li [] [ text "Badge" ]
        , Listgroup.li [] [ text "Card" ]
        ]
    ]


pageNotFound : List (Html Msg)
pageNotFound =
    [ h1 [] [ text "Not found" ]
    , text "Sorry couldn't find that page"
    ]


modal : Model -> Html Msg
modal model =
    Modal.config ModalMsg
        |> Modal.small
        |> Modal.h4 [] [ text "Getting started ?" ]
        |> Modal.body []
            [ Grid.containerFluid []
                [ Grid.row []
                    [ Grid.col
                        [ Col.xs6 ]
                        [ text "Col 1" ]
                    , Grid.col
                        [ Col.xs6 ]
                        [ text "Col 2" ]
                    ]
                ]
            ]
        |> Modal.view model.modalState


rowStyle : Attribute Msg
rowStyle =
    style
        [ ( "padding-top", ".75rem" )
        , ( "padding-bottom", ".75rem" )
        ]
