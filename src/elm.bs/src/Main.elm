module Main exposing (main)

import Html exposing (..)
import Html as H
import Html.Attributes exposing (..)
import Navigation exposing (Location)
import UrlParser
import Bootstrap.Navbar as Navbar
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col


-- import Bootstrap.Grid.Row as Row

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
            urlUpdate location { navState = navState, page = Home initHItems }
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
    = Home (List HItem)
    | FModel Found.Model
    | NotFound


type alias HItem =
    { title : String
    , desc : String
    , link : String
    }


initHItems : List HItem
initHItems =
    let
        itemTuples =
            [ ( "Find", "Look for documents by name (tags in a future)", "#find" )
            , ( "Example option", "Just an example to test composition", "#none" )
            , ( "Example option", "Just an example to test composition", "#none" )
            , ( "Example option", "Just an example to test composition", "#none" )
            , ( "Modules", "Nothing", "#" )
            ]

        itemFromTuple ( t, d, l ) =
            { title = t, desc = d, link = l }
    in
        List.map itemFromTuple itemTuples



-----------------------------------------------
--  U P D A T E


type Msg
    = UrlChange Location
    | NavMsg Navbar.State
    | FoundMsg  Found.Msg


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
            ( { model | page = FModel <| Found.update msg Found.initModel }
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
        [ UrlParser.map (Home initHItems) UrlParser.top
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
            Home items ->
                pageHome items

            NotFound ->
                pageNotFound

            FModel fmodel ->
                [H.map  FoundMsg <| Found.view fmodel]


pageHome : List HItem -> List (Html Msg)
pageHome items =
    let
        colStyle : Attribute Msg
        colStyle =
            style
                [ ( "padding-top", ".75rem" )
                , ( "padding-bottom", ".75rem" )
                ]

        cardFromItem item =
            Grid.col [ Col.md4, Col.attrs [ colStyle ] ]
                [ Card.config [ Card.outlinePrimary ]
                    |> Card.headerH4 [] [ text item.title ]
                    |> Card.block []
                        [ Card.text [] [ text item.desc ]
                        , Card.custom <|
                            Button.linkButton
                                [ Button.primary, Button.attrs [ href item.link ] ]
                                [ text "Run" ]
                        ]
                    |> Card.view
                ]
    in
        [ h1 [] [ text "Applications" ]
        , Grid.row [] <|
            List.map cardFromItem items
        ]


pageNotFound : List (Html Msg)
pageNotFound =
    [ h1 [] [ text "Not found" ]
    , text "Sorry couldn't find that LOCAL page"
    ]
