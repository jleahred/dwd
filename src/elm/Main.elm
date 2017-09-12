module Main exposing (..)

import Html as H
import Html exposing (Html)
import Material.Scheme
import Material.Layout as MLayout
import Layout
import Found


----------------------------------------------------------
----------------------------------------------------------
-- main


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, Cmd.none )
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }



----------------------------------------------------------
-- MODEL


type ModelBody
    = ModelFound Found.Model


type alias ModelCommon =
    { debug : Bool
    , log : List String
    }


type alias Model =
    { layout : Layout.Model
    , body : ModelBody
    , common : ModelCommon
    }


initModel : Model
initModel =
    { layout = Layout.initModel
    , body = ModelFound Found.initModel
    , common = initCommon
    }


initCommon : ModelCommon
initCommon =
    { debug = True
    , log = []
    }



----------------------------------------------------------
-- ACTION, UPDATE


type Msg
    = LayoutMsg Layout.Msg
    | FoundMsg Found.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LayoutMsg msg ->
            (\( m, cm ) ->
                ( { model | layout = m }, Cmd.map LayoutMsg cm )
            )
                (Layout.update msg model.layout)

        FoundMsg msg ->
            let modFound modelBody =
                case modelBody of
                    ModelFound model -> model
                    -- _ -> Found.initModel
            in
                (\( m, cm ) ->
                    ( { model | body = ModelFound m }, Cmd.map FoundMsg cm )
                )
                    (Found.update msg <| modFound model.body)



----------------------------------------------------------
-- VIEW


view : Model -> Html Msg
view model =
    MLayout.render (LayoutMsg << Layout.MdlMsg)
        model.layout.mdl
        [ MLayout.fixedHeader ]
        { header = [ H.map LayoutMsg (Layout.viewHeader model.layout) ]
        , drawer = [ H.map LayoutMsg Layout.viewDrawer ]
        , tabs = ( [], [] )
        , main = [ viewBody model |> Material.Scheme.top ]
        }



-- |> Material.Scheme.top
-- Load Google MdModel CSS. You'll likely want to do that not in code as we
-- do here, but rather in your master .html file. See the documentation
-- for the `Material` module for details.


viewBody : Model -> Html Msg
viewBody model =
    let
        concreteBody model =
            case model.body of
                ModelFound mf ->
                    H.map FoundMsg <| Found.view mf
    in
        H.div []
            [ concreteBody model
            , H.div [] [ H.text (toString model.common) ]
            ]



-- H.div [ style [ ( "padding", "2rem" ) ] ]
--     [ H.text ("Model: " ++ (toString model))
--     ]
