module Main exposing (..)

import Html as H
import Html exposing (Html)
import Html.Attributes exposing (href, class, style)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Options as Options exposing (css)
import Material.Layout as Layout
import Material.Textfield as Textfield
import Html.Events exposing (on, keyCode, onInput)
import Json.Decode as Json
import Found


debug : Bool
debug =
    True



----------------------------------------------------------
-- MODEL

type alias MdModel =
    Material.Model


type alias Model =
    { contentSearchTxt : String
    , found : Found.Model
    , log : List String
    -- Boilerplate: model store for any and all MdModel components you use.
    , mdl :
        MdModel
    }


initModel : Model
initModel =
    { contentSearchTxt = ""
    , found = Found.initModel
    , log = []
    -- Boilerplate: Always use this initial MdModel model store.
    , mdl =
        Material.model
    }


testFill : Model -> Model
testFill model =
    { model | found = Found.testFill model.found }



----------------------------------------------------------
-- ACTION, UPDATE


type Msg
    = SearchTxtModif String
    | ExecuteSearch
    | Test
    | FoundMsg Found.Msg
      -- Boilerplate: Msg clause for internal MdModel messages.
    | MdlMsg (Material.Msg Msg)



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SearchTxtModif txt ->
            ( { model | contentSearchTxt = txt }
            , Cmd.none
            )
            

        ExecuteSearch ->
            ( { model | log = ("Execute search " ++ model.contentSearchTxt) :: model.log }
            , Cmd.none
            )

        Test ->
            ( testFill model
            , Cmd.none
            )

        FoundMsg _ ->
            ( model
            , Cmd.none
            )

        MdlMsg msg_ -> 
            Material.update MdlMsg msg_ model

----------------------------------------------------------
-- VIEW


viewDrawer : Html Msg
viewDrawer =
    H.div []
        [ Layout.title [] [ H.text "DwD" ]
        , Layout.navigation
            []
            [ Layout.link
                [ Layout.href "https://github.com/debois/elm-mdl" ]
                [ H.text "github" ]
            , Layout.link
                [ Layout.href "http://package.elm-lang.org/packages/debois/elm-mdl/latest/" ]
                [ H.text "elm-package" ]
            , Layout.link
                [ Layout.href "#cards"
                , Options.onClick (Layout.toggleDrawer MdlMsg)
                ]
                [ H.text "Card component" ]
            ]
        ]


viewHeader : Model -> MdModel -> Html Msg
viewHeader model mdModel =
    let
        onEnter : Msg -> H.Attribute Msg
        onEnter msg =
            let
                isEnter code =
                    if code == 13 then
                        Json.succeed msg
                    else
                        Json.fail "not ENTER"
            in
                on "keydown" (Json.andThen isEnter keyCode)
    in
        H.div []
            [ Layout.row
                [ Options.nop
                , css "transition" "height 333ms ease-in-out 0s"
                ]
                [ Layout.title
                    [ Layout.href "https://github.com/debois/elm-mdl" ]
                    [ H.span [] [ H.text "DwD" ] ]
                , Layout.spacer
                , Layout.navigation []
                    [ Layout.link
                        []
                        []
                    , Layout.link
                        [ Layout.href "https://github.com/debois/elm-mdl" ]
                        [ H.span [] [ H.text "github" ] ]
                    , Layout.navigation []
                        [ H.div [ style [], onInput SearchTxtModif, onEnter ExecuteSearch ]
                            [ Textfield.render MdlMsg
                                [ 100 ]
                                mdModel
                                [ Textfield.label "Search"
                                ]
                                []
                            ]
                        , Button.render MdlMsg
                            [ 1 ]
                            mdModel
                            [ Options.onClick Test ]
                            [ H.text "test" ]
                        ]
                    ]
                ]
            ]


viewBody : Model -> MdModel -> Html Msg
viewBody model mdModel =
    H.div [ style [ ( "padding", "2rem" ) ] ]
        --[ H.map (Msg << FoundMsg) (Found.view model.found mdModel)
        [ H.map (FoundMsg) (Found.view model.found mdModel)
        --[ FoundMsg (Found.view model.found mdModel) 
        , H.text ("Model: " ++ (toString model))
        , H.text (toString model.log)
        ]



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
----------------------------------------------------------
-- Material Design



----------------------------------------------------------
-- MODEL


type alias FModel =
    { model : Model
    }


initFModel : FModel
initFModel =
    { model = initModel
    }



----------------------------------------------------------
-- ACTION, UPDATE


type FMsg
    = Msg Msg


mdUpdate : FMsg -> FModel -> ( FModel, Cmd FMsg )
mdUpdate msg mdModel =
    case msg of
        Msg msg ->
        let f (mod, cmd_msg) = ({ mdModel | model= mod }, Cmd.map  Msg cmd_msg)
        in
         f(update msg mdModel.model)



----------------------------------------------------------
-- VIEW


mdView : FModel -> Html FMsg
mdView fModel =
    Layout.render (Msg << MdlMsg)
        fModel.model.mdl
        [ Layout.fixedHeader ]
        { header = [ H.div [] [ H.map Msg (viewHeader fModel.model fModel.model.mdl) ]]
        , drawer = [ H.map Msg viewDrawer ]
        , tabs = ( [], [] )
        , main = [ mdViewBody fModel ]
        }


mdViewBody : FModel -> Html FMsg
mdViewBody fModel =
    H.div [] [ H.map Msg (viewBody fModel.model fModel.model.mdl) |> Material.Scheme.top]



-- |> Material.Scheme.top
-- Load Google MdModel CSS. You'll likely want to do that not in code as we
-- do here, but rather in your master .html file. See the documentation
-- for the `Material` module for details.
