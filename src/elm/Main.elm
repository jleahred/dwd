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


type alias Model =
    { contentSearchTxt : String
    , found : Found.Model
    , log : List String
    }


initModel : Model
initModel =
    { contentSearchTxt = ""
    , found = Found.initModel
    , log = []
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


update : Msg -> Model -> Model
update msg model =
    case msg of
        SearchTxtModif txt ->
            { model | contentSearchTxt = txt }

        ExecuteSearch ->
            { model | log = ("Execute search " ++ model.contentSearchTxt) :: model.log }

        Test ->
            testFill model

        FoundMsg _ ->
            model



----------------------------------------------------------
-- VIEW


viewDrawer : Html FMsg
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
                , Options.onClick (Layout.toggleDrawer MdMsg)
                ]
                [ H.text "Card component" ]
            ]
        ]


viewHeader : Model -> MdModel -> Html FMsg
viewHeader model mdModel =
    let
        onEnter : FMsg -> H.Attribute FMsg
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
                        [ H.div [ style [], onInput (\txt -> Msg (SearchTxtModif txt)), onEnter (Msg ExecuteSearch) ]
                            [ Textfield.render MdMsg
                                [ 100 ]
                                mdModel
                                [ Textfield.label "Search"
                                ]
                                []
                            ]
                        , Button.render MdMsg
                            [ 1 ]
                            mdModel
                            [ Options.onClick (Msg Test) ]
                            [ H.text "test" ]
                        ]
                    ]
                ]
            ]


viewBody : Model -> MdModel -> Html FMsg
viewBody model mdModel =
    H.div [ style [ ( "padding", "2rem" ) ] ]
        [ H.map (Msg << FoundMsg) (Found.view model.found mdModel)
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


type alias MdModel =
    Material.Model



----------------------------------------------------------
-- MODEL


type alias FModel =
    { model : Model

    -- Boilerplate: model store for any and all MdModel components you use.
    , mdl :
        MdModel

    -- Material.Model
    }


initFModel : FModel
initFModel =
    { model = initModel

    -- Boilerplate: Always use this initial MdModel model store.
    , mdl =
        Material.model
    }



----------------------------------------------------------
-- ACTION, UPDATE


type FMsg
    = Msg Msg
      -- Boilerplate: Msg clause for internal MdModel messages.
    | MdMsg (Material.Msg FMsg)


mdUpdate : FMsg -> FModel -> ( FModel, Cmd FMsg )
mdUpdate msg mdModel =
    case msg of
        Msg msg ->
            ( { mdModel | model = update msg mdModel.model }
            , Cmd.none
            )

        -- Boilerplate: MdModel action handler.
        MdMsg msg_ ->
            Material.update MdMsg msg_ mdModel



----------------------------------------------------------
-- VIEW


mdView : FModel -> Html FMsg
mdView fModel =
    Layout.render MdMsg
        fModel.mdl
        [ Layout.fixedHeader ]
        { header = [ viewHeader fModel.model fModel.mdl ]
        , drawer = [ viewDrawer ]
        , tabs = ( [], [] )
        , main = [ mdViewBody fModel ]
        }


mdViewBody : FModel -> Html FMsg
mdViewBody fModel =
    viewBody fModel.model fModel.mdl |> Material.Scheme.top



-- |> Material.Scheme.top
-- Load Google MdModel CSS. You'll likely want to do that not in code as we
-- do here, but rather in your master .html file. See the documentation
-- for the `Material` module for details.
