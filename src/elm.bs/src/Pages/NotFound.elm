module NotFound exposing (..)

import Html as H
import Html exposing (Html)
import Bootstrap.Grid as Grid


--
--
-----------------------------------------------
--  M O D E L


type Model
    = NoModel


initModel : Model
initModel =
    NoModel



-----------------------------------------------
--  U P D A T E


type Msg
    = NoMsg



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view items =
    Grid.container [] <|
        [ H.h1 [] [ H.text "Not found" ]
        , H.text "Sorry!!! This local page doesn't exists"
        ]
