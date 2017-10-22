module Main exposing (main, ModModel)

import Html exposing (Html)
import Html as H
import Html.Attributes as HA
import Navigation exposing (Location)
import UrlParser
import UrlParser exposing ((<?>))
import Bootstrap.Navbar as Navbar
import Bootstrap.Grid as Grid


-----------------------------------------------
-----------------------------------------------
-- modules

import NotFound
import Index
import Find


--  M O D E L


type ModModel
    = NotFoundModel NotFound.Model
    | IndexModel Index.Model
    | FindModel Find.Model



--  U P D A T E


type ModMsg
    = NotFoundMsg NotFound.Msg
    | IndexMsg Index.Msg
    | FindMsg Find.Msg


updateMod : ModMsg -> Model -> ( Model, Cmd Msg )
updateMod msg model =
    case msg of
        FindMsg msg ->
            let
                fmodel =
                    case model.content of
                        FindModel fmodel ->
                            fmodel

                        _ ->
                            Find.initModel
            in
                ( { model | content = FindModel <| Find.update msg fmodel }
                , Cmd.none
                )

        IndexMsg msg ->
            ( model, Cmd.none )

        NotFoundMsg _ ->
            ( model, Cmd.none )



--  V I E W


viewMod : Model -> Html Msg
viewMod model =
    let
        gridContent =
            case model.content of
                NotFoundModel m ->
                    [ H.map NotFoundMsg <| NotFound.view m ]

                IndexModel m ->
                    [ H.map IndexMsg <| Index.view m ]

                FindModel m ->
                    [ H.map FindMsg <| Find.view m ]
    in
        H.map MMsg <|
            Grid.container [] <|
                gridContent



-----------------------------------------------
-----------------------------------------------
-- main


routeParser : UrlParser.Parser (ModModel -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map (IndexModel Index.init) UrlParser.top
        , UrlParser.map (FindModel Find.initModel) (UrlParser.s "findconfig")

        --, UrlParser.map (FModel Find.execFind) (UrlParser.s "find")
        --, UrlParser.map (FModel Find.exec "sdfasdf") (UrlParser.s "find" <?> UrlParser.stringParam "txt")
        , UrlParser.map (FindModel Find.exec) (UrlParser.s "find")
        ]


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
            urlUpdate location { navState = navState, content = IndexModel Index.init }
    in
        ( model, Cmd.batch [ urlCmd, navCmd ] )


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navState NavMsg



-----------------------------------------------
--  M O D E L


type alias Model =
    { content : ModModel
    , navState : Navbar.State
    }



-----------------------------------------------
--  U P D A T E


type Msg
    = UrlChange Location
    | NavMsg Navbar.State
    | MMsg ModMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            urlUpdate location model

        NavMsg state ->
            ( { model | navState = state }
            , Cmd.none
            )

        MMsg mmsg ->
            updateMod mmsg model


urlUpdate : Navigation.Location -> Model -> ( Model, Cmd Msg )
urlUpdate location model =
    case decode location of
        Nothing ->
            ( { model | content = NotFoundModel NotFound.initModel }, Cmd.none )

        Just route ->
            ( { model | content = route }, Cmd.none )


decode : Location -> Maybe ModModel
decode location =
    UrlParser.parseHash routeParser location



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view model =
    H.div []
        [ menu model
        , viewMod model
        ]


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
