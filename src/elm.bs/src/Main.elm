module Main exposing (main)

import Html exposing (Html)
import Html as H
import Html.Attributes as HA
import Navigation exposing (Location)
import UrlParser
import UrlParser exposing ((<?>))
import Bootstrap.Navbar as Navbar


--

import Pages
import NavBar


-----------------------------------------------
--  M O D E L


type alias Model =
    { page : Pages.Model
    , navState : Navbar.State
    }



-----------------------------------------------
--  U P D A T E


type Msg
    = UrlChange Location
    | NavMsg Navbar.State
    | PMsg Pages.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            urlUpdate location model

        NavMsg state ->
            ( { model | navState = state }
            , Cmd.none
            )

        PMsg pmsg ->
            ( { model | page = Pages.update pmsg model.page }
            , Cmd.none
            )



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view model =
    H.div []
        [ menu model
        , H.map PMsg <| Pages.view model.page
        ]



-----------------------------------------------
-----------------------------------------------
-- main


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
            urlUpdate location { navState = navState, page = Pages.IndexModel Pages.indexInit }
    in
        ( model, Cmd.batch [ urlCmd, navCmd ] )


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navState NavMsg



-----------------------------------------------
--  U P D A T E


urlUpdate : Navigation.Location -> Model -> ( Model, Cmd Msg )
urlUpdate location model =
    case decode location of
        Nothing ->
            ( { model | page = Pages.NotFoundModel Pages.notFoundInit }, Cmd.none )

        Just route ->
            ( { model | page = route }, Cmd.none )


decode : Location -> Maybe Pages.Model
decode location =
    UrlParser.parseHash Pages.routeParser location



-----------------------------------------------
--  V I E W


menu : Model -> Html Msg
menu model =
    Navbar.config NavMsg
        |> Navbar.withAnimation
        |> Navbar.container
        |> Navbar.brand [ HA.href "#" ] [ H.text "DwD" ]
        |> Navbar.items
            [ Navbar.itemLink [ HA.href "#findconfig" ] [ H.text "Find" ]
            ]
        |> Navbar.view model.navState
