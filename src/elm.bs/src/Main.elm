module Main exposing (main)

import Html exposing (Html)
import Html as H
import Html.Attributes as HA
import Navigation exposing (Location)
import UrlParser
import UrlParser exposing ((<?>))


-- app modules

import Pages
import Menu


-----------------------------------------------
--  M O D E L


type alias Model =
    { page : Pages.Model
    , menu : Menu.Model
    }



-----------------------------------------------
--  U P D A T E


type Msg
    = UrlChange Location
    | MenuMsg Menu.Msg
    | PageMsg Pages.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            urlUpdate location model

        MenuMsg state ->
            ( { model | menu = Menu.Model <| (Menu.modelFromMsg state).state }
            , Cmd.none
            )

        PageMsg pmsg ->
            ( { model | page = Pages.update pmsg model.page }
            , Cmd.none
            )



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view model =
    H.div []
        [ H.map MenuMsg <| Menu.view model.menu
        , H.div
            [ HA.style
                [ ( "padding-top", "4.0rem" )
                , ( "padding-bottom", ".75rem" )
                ]
            ]
            [ H.map PageMsg <| Pages.view model.page ]
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
        ( menu, navCmd ) =
            Menu.init

        ( model, urlCmd ) =
            urlUpdate location { menu = menu, page = Pages.IndexModel Pages.indexInit }
    in
        ( model, Cmd.batch [ urlCmd, Cmd.map MenuMsg <| navCmd ] )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map MenuMsg <| Menu.subscriptions model.menu



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
