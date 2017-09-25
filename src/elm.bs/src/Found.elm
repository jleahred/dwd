module Found exposing (..)

import Html exposing (Html)
import Html as H
import Html.Attributes as HA
import Bootstrap.Button as Button
import Bootstrap.Form.InputGroup as InputGroup
import Bootstrap.Form.Input as Input


-- import Bootstrap.Grid as Grid
-- import Bootstrap.Grid.Col as Col
-- import Bootstrap.Grid.Row as Row
-- import Bootstrap.Card as Card
-----------------------------------------------
--  M O D E L


type alias Model =
    { items : List String }


initModel : Model
initModel =
    { items = [] }



-----------------------------------------------
--  U P D A T E


type Msg
    = Find String



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view model =
    H.div []
        [ H.h1 []
            [ H.text "Find"
            ]
        , Button.linkButton
            [ Button.primary, Button.attrs [ HA.href "#find?lalala" ] ]
            [ H.text "Find" ]
        , InputGroup.config
            (InputGroup.text [ Input.placeholder "Search for", Input.onInput Find ])
            |> InputGroup.successors
                [ InputGroup.button
                    [ Button.secondary]
                    [ H.text "Go!" ]
                ]
            |> InputGroup.view
        ]
