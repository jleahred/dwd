module Layout exposing (..)

import Html as H
import Html exposing (Html)
import Html.Attributes exposing (href, class, style)
import Material
import Material.Button as Button
import Material.Options as Options exposing (css)
import Material.Layout as Layout
import Material.Textfield as Textfield
import Html.Events exposing (on, keyCode, onInput)
import Json.Decode as Json


----------------------------------------------------------
-- MODEL


type alias MdModel =
    Material.Model


type alias Model =
    { contentSearchTxt : String
    -- Boilerplate: model store for any and all MdModel components you use.
    , mdl :
        MdModel
    }


initModel : Model
initModel =
    { contentSearchTxt = ""
    -- Boilerplate: Always use this initial MdModel model store.
    , mdl =
        Material.model
    }


testFill : Model -> Model
testFill model = model
    --{ model | found = Found.testFill model.found }




----------------------------------------------------------
-- ACTION, UPDATE


type Msg
    = SearchTxtModif String
    | ExecuteSearch
    | Test
      -- Boilerplate: Msg clause for internal MdModel messages.
    | MdlMsg (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchTxtModif txt ->
            ( { model | contentSearchTxt = txt }
            , Cmd.none
            )

        ExecuteSearch ->
            --( { model | log = ("Execute search " ++ model.contentSearchTxt) :: model.log }
            ( model
            , Cmd.none
            )

        Test ->
            ( testFill model
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


viewHeader : Model -> Html Msg
viewHeader model =
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
                                model.mdl
                                [ Textfield.label "Search"
                                ]
                                []
                            ]
                        , Button.render MdlMsg
                            [ 1 ]
                            model.mdl
                            [ Options.onClick Test ]
                            [ H.text "test" ]
                        ]
                    ]
                ]
            ]


