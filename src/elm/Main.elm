module Main exposing (..)

import Html as H
import Html exposing (Html)
import Html.Attributes exposing (href, class, style)
import Material.Scheme
import Material.Layout as Layout
import Layout as L
import Found


debug : Bool
debug =
    True



----------------------------------------------------------
----------------------------------------------------------
-- main


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, Cmd.none )
        , view = mdView
        , subscriptions = always Sub.none
        , update = mdUpdate
        }



----------------------------------------------------------
-- MODEL


type alias Model =
    { layout : L.Model
    , found : Found.Model
    , log : List String
    }


initModel : Model
initModel =
    { layout = L.initModel
    , found = Found.initModel
    , log = []
    }



----------------------------------------------------------
-- ACTION, UPDATE


type Msg
    = LayoutMsg L.Msg
    | FoundMsg Found.Msg


mdUpdate : Msg -> Model -> ( Model, Cmd Msg )
mdUpdate msg mdModel =
    case msg of
        LayoutMsg msg ->
            let
                f ( lmod, lcmd_msg ) =
                    ( { mdModel | layout = lmod }, Cmd.map LayoutMsg lcmd_msg )
            in
                f (L.update msg mdModel.layout)

        FoundMsg _ ->
            ( mdModel
            , Cmd.none
            )



----------------------------------------------------------
-- VIEW


mdView : Model -> Html Msg
mdView model =
    Layout.render (LayoutMsg << L.MdlMsg)
        model.layout.mdl
        [ Layout.fixedHeader ]
        { header = [ H.div [] [ H.map LayoutMsg (L.viewHeader model.layout model.layout.mdl) ] ]
        , drawer = [ H.map LayoutMsg L.viewDrawer ]
        , tabs = ( [], [] )
        , main = [ mdViewBody model ]
        }


mdViewBody : Model -> Html Msg
mdViewBody model =
    H.div [ style [ ( "padding", "2rem" ) ] ]
        [ H.text ("Model: " ++ (toString model))
            |> Material.Scheme.top
        ]



-- |> Material.Scheme.top
-- Load Google MdModel CSS. You'll likely want to do that not in code as we
-- do here, but rather in your master .html file. See the documentation
-- for the `Material` module for details.
