module Find exposing (..)

import Html exposing (Html)
import Html as H
import Html.Attributes as HA
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import UrlParser
import UrlParser exposing ((<?>))


routeParser : List (UrlParser.Parser (Model -> c) c)
routeParser =
    [ UrlParser.map (Find { txt = "" }) (UrlParser.s "findconfig")

    --, UrlParser.map (FindModel Find.exec) (UrlParser.s "find" <?> UrlParser.stringParam "txt")
    --, UrlParser.map (FindModel Find.exec) (UrlParser.s "find")
    ]



--, UrlParser.map (FindModel Find.exec) (UrlParser.s "find" <?> UrlParser.stringParam "txt")
--, UrlParser.map (FindModel Find.exec) (UrlParser.s "find")
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
        Grid.container [] <|
            [ H.h1 []
                [ H.text "Find Config"
                ]
            , Form.form []
                [ Form.group []
                    [ Form.label [ HA.for "findtext" ] [ H.text "Text to search" ]
                    , Input.text [ Input.id "findtext", Input.onInput MsgTxtModif ]
                    ]
                , Button.linkButton
                    [ Button.primary
                    , Button.attrs <| buttonSearchAttr model
                    ]
                    [ H.text "Submit" ]
                ]
            , H.text <| toString model
            ]
