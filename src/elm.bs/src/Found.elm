module Found exposing (..)

import Html exposing (Html)
import Html as H
import Html.Attributes as HA
import Bootstrap.Button as Button
import Bootstrap.Form.InputGroup as InputGroup
import Bootstrap.Form.Input as Input
-- import Char
-- import Html.Events as HE
-- import Json.Decode as Json


-- import Bootstrap.Grid as Grid
-- import Bootstrap.Grid.Col as Col
-- import Bootstrap.Grid.Row as Row
-- import Bootstrap.Card as Card
-----------------------------------------------
--  M O D E L


type Model
    = ConfigFind
    | Found {items: List String }
    -- { params : { searchTxt : String }
    -- , items : List String
    -- }


initModel : Model
initModel =
    { params = { searchTxt = "" }
    , items = []
    }



-----------------------------------------------
--  U P D A T E


type Msg
    = Find String
    | AddCharSearch Char


update : Msg -> Model -> Model
update msg model =
    case msg of
        Find txt ->
            model

        AddCharSearch ch ->
            { model | params = { searchTxt = String.cons ch model.params.searchTxt } }



-----------------------------------------------
--  V I E W


-- onKeyPress : (Int -> msg) -> Input.Option msg
-- onKeyPress tagger =
--     Input.attrs [ HE.on "keypress" (Json.map tagger HE.keyCode) ]


view : Model -> Html Msg
view model =
    H.div []
        [ H.h1 []
            [ H.text "Find"
            ]
        , Button.linkButton
            [ Button.primary, Button.attrs [ HA.href "#find?lalala" ] ]
            [ H.text "Test" ]
        , InputGroup.config
            (InputGroup.text
                [ --Input.value "",
                  -- onKeyPress AddCharSearch
                  Input.placeholder "Search for"
                , Input.onInput Find
                ]
            )
            |> InputGroup.successors
                [ InputGroup.button
                    [ Button.secondary ]
                    [ H.text "Search" ]
                ]
            |> InputGroup.view
        , H.text <| toString model
        ]
