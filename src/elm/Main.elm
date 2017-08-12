module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Options as Options exposing (css)

import Material.Layout as Layout
import Material.Textfield as Textfield
import Html.Events exposing (on, keyCode, onInput)
import Json.Decode as Json


-- MODEL


type alias Model =
    { searchTxt : String
    , execSearchTxt : String -- "" Means clear find

    -- Boilerplate: model store for any and all Mdl components you use.
    , mdl :
        Material.Model
    }


initModel : Model
initModel =
    { searchTxt = ""
    , execSearchTxt = ""

    -- Boilerplate: Always use this initial Mdl model store.
    , mdl =
        Material.model
    }



-- ACTION, UPDATE


type Msg
    = SearchTxtModif String
    | ExecuteSearch
      -- Boilerplate: Msg clause for internal Mdl messages.
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchTxtModif txt ->
            ( { model | searchTxt = txt }
            , Cmd.none
            )

        ExecuteSearch ->
            ( { model | execSearchTxt = model.searchTxt }
            , Cmd.none
            )

        -- { model | currentText = text }
        -- Boilerplate: Mdl action handler.
        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader ]
        { header = header2 model
            --header = [ viewHeader model ]
        , drawer = drawer
        , tabs = ( [], [] )
        , main = [ viewBody model ]
        }


-- drawer : List (Html Msg)
-- drawer =
--   [ Layout.title [] [ text "Example drawer" ]
--   , Layout.navigation
--     []
--     [  Layout.link
--         [ Layout.href "https://github.com/debois/elm-mdl" ]
--         [ text "github" ]
--     , Layout.link
--         [ Layout.href "http://package.elm-lang.org/packages/debois/elm-mdl/latest/" ]
--         [ text "elm-package" ]
--     , Layout.link
--         [ Layout.href "#cards"
--         , Options.onClick (Layout.toggleDrawer Mdl)
--         ]
--         [ text "Card component" ]
--     ]
--   ]

drawer : List (Html Msg)
drawer =
  [ Layout.title [] [ text "DwD" ]
  , Layout.navigation
    []
    [  Layout.link
        [ Layout.href "https://github.com/debois/elm-mdl" ]
        [ text "github" ]
    , Layout.link
        [ Layout.href "http://package.elm-lang.org/packages/debois/elm-mdl/latest/" ]
        [ text "elm-package" ]
    , Layout.link
        [ Layout.href "#cards"
        , Options.onClick (Layout.toggleDrawer Mdl)
        ]
        [ text "Card component" ]
    ]
  ]


header2 : Model -> List (Html Msg)
header2 model =
    [ Layout.row
        [ Options.nop
        , css "transition" "height 333ms ease-in-out 0s"
        ]
        --[ Layout.title [] [ text "DwD" ]
        [ Layout.title
                [ Layout.href "https://github.com/debois/elm-mdl"]
                [ span [] [text "DwD"] ]
        , Layout.spacer
        , Layout.navigation []
            [ Layout.link
                []
                --[ Options.onClick ToggleHeader]
                []
                --[ Icon.i "photo" ]
            , Layout.link
                [ Layout.href "https://github.com/debois/elm-mdl"]
                [ span [] [text "github"] ]
            , Layout.navigation []
                [
                    Textfield.render Mdl
                        [ 100 ]
                        model.mdl
                        [ Textfield.label "Search"
                        -- , Textfield.floatingLabel
                        -- , Textfield.expandable "id-of-expandable-100"
                        -- , Textfield.expandableIcon "search"
                        -- , Options.onInput Search
                        -- , Options.onClick SearchClicked
                        ]
                        []
                ]
            ]
        ]
    ]


-- md 1xx
viewHeader : Model -> Html Msg
viewHeader model =
    let
        onEnter : Msg -> Attribute Msg
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
        div []
            [ 
                h3 [ style [ ( "padding-left", "1rem" ) ] ]
                [ text "DwD"
                ,Button.render Mdl [9, 0, 0, 1] model.mdl
                    [ Button.ripple
                    , Button.colored
                    , Button.raised
                    , Button.link "#"
                    ]
                    [ text "DwD"] 
                , div
                    [ style [ ( "padding-right", "2rem" ), ( "float", "right" ) ], onInput SearchTxtModif, onEnter ExecuteSearch ]
                    [ Textfield.render Mdl
                        [ 100 ]
                        model.mdl
                        [ Textfield.label "Search"

                        -- , Textfield.floatingLabel
                        -- , Textfield.expandable "id-of-expandable-100"
                        -- , Textfield.expandableIcon "search"
                        -- , Options.onInput Search
                        -- , Options.onClick SearchClicked
                        ]
                        []
                    ]
                ]
            ]


viewBody : Model -> Html Msg
viewBody model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        [ text ("Sent search: " ++ toString model.execSearchTxt)
        ]
        |> Material.Scheme.top



-- Load Google Mdl CSS. You'll likely want to do that not in code as we
-- do here, but rather in your master .html file. See the documentation
-- for the `Material` module for details.


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, Cmd.none )
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }
