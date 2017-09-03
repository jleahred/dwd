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


main : Program Never FModel FMsg
main =
    Html.program
        { init = ( initFModel, Cmd.none )
        , view = mdView
        , subscriptions = always Sub.none
        , update = mdUpdate
        }



----------------------------------------------------------
-- MODEL


type alias FModel =
    { layout : L.Model
    , found : Found.Model
    , log : List String
    }


initFModel : FModel
initFModel =
    { layout = L.initModel
    , found = Found.initModel
    , log = []
    }



----------------------------------------------------------
-- ACTION, UPDATE


type FMsg
    = LayoutMsg L.Msg
    | FoundMsg Found.Msg


mdUpdate : FMsg -> FModel -> ( FModel, Cmd FMsg )
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


mdView : FModel -> Html FMsg
mdView fModel =
    Layout.render (LayoutMsg << L.MdlMsg)
        fModel.layout.mdl
        [ Layout.fixedHeader ]
        { header = [ H.div [] [ H.map LayoutMsg (L.viewHeader fModel.layout fModel.layout.mdl) ] ]
        , drawer = [ H.map LayoutMsg L.viewDrawer ]
        , tabs = ( [], [] )
        , main = [ mdViewBody fModel ]
        }


mdViewBody : FModel -> Html FMsg
mdViewBody fModel =
    --H.div [] [ H.map LayoutMsg (viewBody fModel) |> Material.Scheme.top ]
    H.div [] [ viewBody fModel |> Material.Scheme.top ]

viewBody : FModel -> Html FMsg
viewBody model =
    H.div [ style [ ( "padding", "2rem" ) ] ]
        --[ H.map (Msg << FoundMsg) (Found.view model.found mdModel)
        --[ H.map (FoundMsg) (Found.view model.found mdModel)

        --[ FoundMsg (Found.view model.found mdModel)
        --, 
        [
        H.text ("Model: " ++ (toString model))
        --, H.text (toString model.log)
        ]


-- |> Material.Scheme.top
-- Load Google MdModel CSS. You'll likely want to do that not in code as we
-- do here, but rather in your master .html file. See the documentation
-- for the `Material` module for details.
