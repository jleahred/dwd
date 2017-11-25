module Menu exposing (..)

import Bootstrap.Navbar as Navbar
import Html exposing (Html)
import Html as H
import Html.Attributes as HA


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.state MNavbar



--
--
-----------------------------------------------
--  M O D E L


type alias Model =
    { state : Navbar.State }


init : ( Model, Cmd Msg )
init =
    let
        ( navbarState, msg ) =
            Navbar.initialState MNavbar
    in
        ( { state = navbarState }, msg )


modelFromMsg : Msg -> Model
modelFromMsg msg =
    case msg of
        MNavbar st ->
            { state = st }



-----------------------------------------------
--  U P D A T E


type Msg
    = MNavbar Navbar.State



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view model =
    Navbar.config MNavbar
        |> Navbar.withAnimation
        |> Navbar.fixTop
        |> Navbar.container
        |> Navbar.brand [ HA.href "#" ] [ H.text "DwD" ]
        |> Navbar.items
            [ Navbar.itemLink [ HA.href "#about" ] [ H.text "About" ]
            , Navbar.itemLink [ HA.href "#tests" ] [ H.text "Tests" ]
            ]
        |> Navbar.view model.state
