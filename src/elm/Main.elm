module Main exposing (..)

import Dict
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


debug : Bool
debug =
    True



----------------------------------------------------------
-- MODEL


type alias Model =
    { searchTxt : String -- "" Means clear find
    , found : Dict.Dict ( String, String ) String
    , log : List String
    }


initModel : Model
initModel =
    { searchTxt = ""
    , found = Dict.empty
    , log = []
    }


testFillFound : Model -> Model
testFillFound model =
    { model | found = Dict.insert ( "asdfasdf", "aaaa" ) "asdfasdf" model.found }



----------------------------------------------------------
-- ACTION, UPDATE


type Msg
    = SearchTxtModif String
    | ExecuteSearch
      -- Boilerplate: Msg clause for internal Mdl messages.
    | Test
    | Mdl (Material.Msg Msg)


update : Msg -> MdModel -> ( MdModel, Cmd Msg )
update msg mdModel =
    case msg of
        SearchTxtModif txt ->
            let
                setSearchTxt model txt =
                    { model | searchTxt = txt }
            in
                ( { mdModel | model =  setSearchTxt mdModel.model txt}
                , Cmd.none
                )

        ExecuteSearch ->
            let addLog model txt = { model | log = txt :: model.log } in
            ( { mdModel | model = addLog mdModel.model <| "Execute search " ++ mdModel.model.searchTxt}
            , Cmd.none
            )

        Test ->
            ( { mdModel | model = testFillFound mdModel.model }
            , Cmd.none
            )

        -- Boilerplate: Mdl action handler.
        Mdl msg_ ->
            Material.update Mdl msg_ mdModel



----------------------------------------------------------
-- VIEW


type alias Mdl =
    Material.Model


view : MdModel -> Html Msg
view mdModel =
    Layout.render Mdl
        mdModel.mdl
        [ Layout.fixedHeader ]
        { header = header2 mdModel
        , drawer = drawer
        , tabs = ( [], [] )
        , main = [ viewBody mdModel, H.text <| toString mdModel.model.log ]
        }


drawer : List (Html Msg)
drawer =
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
            , Options.onClick (Layout.toggleDrawer Mdl)
            ]
            [ H.text "Card component" ]
        ]
    ]


header2 : MdModel -> List (Html Msg)
header2 mdModel =
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
                        [ Textfield.render Mdl
                            [ 100 ]
                            mdModel.mdl
                            [ Textfield.label "Search"
                            ]
                            []
                        ]
                    , Button.render Mdl
                        [ 1 ]
                        mdModel.mdl
                        [ Options.onClick Test ]
                        [ H.text "test" ]
                    ]
                ]
            ]
        ]


viewBody : MdModel -> Html Msg
viewBody mdModel =
    H.div [ style [ ( "padding", "2rem" ) ] ]
        [ H.text ("Sent search:  " ++ (toString mdModel.model))
        ]
        |> Material.Scheme.top



-- Load Google Mdl CSS. You'll likely want to do that not in code as we
-- do here, but rather in your master .html file. See the documentation
-- for the `Material` module for details.


main : Program Never MdModel Msg
main =
    Html.program
        { init = ( initMdModel, Cmd.none )
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }



----------------------------------------------------------
-- Material Design


type alias MdModel =
    { model : Model

    -- Boilerplate: model store for any and all Mdl components you use.
    , mdl :
        Material.Model
    }


initMdModel : MdModel
initMdModel =
    { model = initModel

    -- Boilerplate: Always use this initial Mdl model store.
    , mdl =
        Material.model
    }
