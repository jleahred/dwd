module Find exposing (..)

import Html exposing (Html)
import Html as H
import Html.Attributes as HA
import Bootstrap.Button as Button
import Bootstrap.Form as Form


--import Bootstrap.Form.InputGroup as InputGroup

import Bootstrap.Form.Input as Input


-- import Char
-- import Html.Events as HE
-- import Json.Decode as Json
-- import Bootstrap.Grid as Grid
-- import Bootstrap.Grid.Col as Col
-- import Bootstrap.Grid.Row as Row
-- import Bootstrap.Card as Card
--
-----------------------------------------------
--  M O D E L


type Model
    = Find { txt : String }
    | Found { items : List String }


initModel : Model
initModel =
    Find { txt = "" }


exec : Model
exec =
    Found { items = [ "asdfasdf", "asdfasdf" ] }



-----------------------------------------------
--  U P D A T E


type Msg
    = MsgExecFind
    | MsgTxtModif String


update : Msg -> Model -> Model
update msg model =
    case msg of
        MsgTxtModif txt ->
            Find { txt = txt }

        MsgExecFind ->
            model



-----------------------------------------------
--  V I E W


view : Model -> Html Msg
view model =
    let
        buttonSearchAttr model =
            case model of
                Find cfg ->
                    if String.length cfg.txt > 0 then
                        [ HA.href <| "#find?" ++ cfg.txt ]
                    else
                        []

                _ ->
                    []
    in
        H.div []
            [ H.h1 []
                [ H.text "Find Config"
                ]
            , Form.form []
                [ Form.group []
                    [ Form.label [ HA.for "findtext" ] [ H.text "Text to search" ]
                    , Input.text [ Input.id "findtext", Input.onInput MsgTxtModif ]

                    -- , Form.help [] [ H.text "Write the text to search" ]
                    ]
                , Button.linkButton
                    [ Button.primary
                    , Button.attrs <| buttonSearchAttr model
                    ]
                    [ H.text "Submit" ]

                -- , Button.button
                -- [ Button.primary, Button.attrs [ HE.onClick <| MsgExecFind ] ]
                -- [ H.text "Submit" ]
                --     [ Button.primary, Button.attrs [ HE.onClick <| MsgExecFind ] ]
                --     [ H.text "Submit" ]
                ]
            , H.text <| toString model
            ]



-- view : Model -> Html Msg
-- view model =
--     H.div []
--         [ H.h1 []
--             [ H.text "Find"
--             ]
--         , Button.linkButton
--             [ Button.primary, Button.attrs [ HA.href "#find?lalala" ] ]
--             [ H.text "Test" ]
--         , InputGroup.config
--             (InputGroup.text
--                 [ Input.placeholder "Search for"
--                 , Input.onInput MsgTxtModif
--                 ]
--             )
--             |> InputGroup.successors
--                 [ InputGroup.button
--                     [ Button.secondary, Button.attrs [ HA.href "#find?aaa" ] ]
--                     [ H.text "Search" ]
--                 ]
--             |> InputGroup.view
--         , H.text <| toString model
--         ]
