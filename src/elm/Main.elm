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


type alias FoundKey =
    { key0 : String
    , key1 : String
    } deriving (Ord,Show)


type alias Model =
    { searchTxt : String -- "" Means clear find
    , found : Dict.Dict FoundKey String
    , log : List String

    -- Boilerplate: model store for any and all Mdl components you use.
    , mdl :
        Material.Model
    }


initModel : Model
initModel =
    { searchTxt = ""
    , found = Dict.empty
    , log = []

    -- Boilerplate: Always use this initial Mdl model store.
    , mdl =
        Material.model
    }


testFillFound : Model -> Model
testFillFound model =
    { model | found = Dict.insert { key0 = "asdfasdf", key1 = "aaaa" } "asdfasdf" model.found }



----------------------------------------------------------
-- ACTION, UPDATE


type Msg
    = SearchTxtModif String
    | ExecuteSearch
      -- Boilerplate: Msg clause for internal Mdl messages.
    | Test
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchTxtModif txt ->
            ( { model | searchTxt = txt }
            , Cmd.none
            )

        ExecuteSearch ->
            ( { model | log = ("Execute search " ++ model.searchTxt) :: model.log }
            , Cmd.none
            )

        Test ->
            ( testFillFound model
            , Cmd.none
            )

        -- Boilerplate: Mdl action handler.
        Mdl msg_ ->
            Material.update Mdl msg_ model



----------------------------------------------------------
-- VIEW


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader ]
        { header = header2 model
        , drawer = drawer
        , tabs = ( [], [] )
        , main = [ viewBody model, H.text <| toString model.log ]
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


header2 : Model -> List (Html Msg)
header2 model =
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
                            model.mdl
                            [ Textfield.label "Search"
                            ]
                            []
                        ]
                    , Button.render Mdl
                        [ 1 ]
                        model.mdl
                        [ Options.onClick Test ]
                        [ H.text "test" ]
                    ]
                ]
            ]
        ]


viewBody : Model -> Html Msg
viewBody model =
    H.div [ style [ ( "padding", "2rem" ) ] ]
        [ H.text ("Sent search:  " ++ (toString model))
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
