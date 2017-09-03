module Main exposing (..)

import Html as H
import Html exposing (Html)
import Html.Attributes exposing (href, class, style)
import Material.Scheme
import Material.Layout as MLayout
import Layout 
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
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }



----------------------------------------------------------
-- MODEL


type alias Model =
    { layout : Layout.Model
    , found : Found.Model
    , log : List String
    }


initModel : Model
initModel =
    { layout = Layout.initModel
    , found = Found.initModel
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
            let (m, cm) = Layout.update msg model.layout in
            ({ model | layout = m }, Cmd.map LayoutMsg cm)

        FoundMsg _ ->
            ( model
            , Cmd.none
            )



----------------------------------------------------------
-- VIEW


view : Model -> Html Msg
view model =
    MLayout.render (LayoutMsg << Layout.MdlMsg)
        model.layout.mdl
        [ MLayout.fixedHeader ]
        { header = [ H.div [] [ H.map LayoutMsg (Layout.viewHeader model.layout model.layout.mdl) ] ]
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
    H.div [ style [ ( "padding", "2rem" ) ] ]
        [ H.text ("Model: " ++ (toString model))
        ]



