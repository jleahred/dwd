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
    { count : Int

    -- Boilerplate: model store for any and all Mdl components you use.
    , mdl :
        Material.Model
    }


model : Model
model =
    { count = 0

    -- Boilerplate: Always use this initial Mdl model store.
    , mdl =
        Material.model
    }



-- ACTION, UPDATE


type Msg
    = Increase
    | Reset
    | SelectTab Int
    | Search String
    | SearchClicked
    | KeyDown Int
    | Input String
      -- Boilerplate: Msg clause for internal Mdl messages.
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increase ->
            ( { model | count = model.count + 1 }
            , Cmd.none
            )

        Reset ->
            ( { model | count = 0 }
            , Cmd.none
            )

        SelectTab idx ->
            let
                _ =
                    Debug.log "Selected tab" idx
            in
                model ! []

        Search txt ->
            let
                _ =
                    Debug.log "Searching " txt
            in
                model ! []

        SearchClicked ->
            let
                _ =
                    Debug.log "Clicked" "clicke"
            in
                model ! []

        KeyDown key ->
            let
                _ =
                    Debug.log "key down" key
            in
                model ! []

        -- if key == 13 then
        --     { model | savedText = model.currentText }
        -- else
        --     model
        Input text ->
            let
                _ =
                    Debug.log "input text" text
            in
                model ! []

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
        [ Layout.fixedHeader
        , Layout.onSelectTab SelectTab
        ]
        { header = [ viewHeader model ]
        , drawer = []
        , tabs = ( [], [] )
        , main = [ viewBody model ]
        }



-- md 1xx
viewHeader : Model -> Html Msg
viewHeader model =
    div []
        [ h3
            [ style [ ( "padding-left", "1rem" ) ] ]
            [ text "DwD"
            , div
                [ style [ ( "padding-right", "2rem" ), ( "float", "right" ) ], onKeyDown KeyDown, onInput Input ]
                [ Textfield.render Mdl
                    [ 100 ]
                    model.mdl
                    [ Textfield.label "Search"
                    , Textfield.floatingLabel
                    -- , Textfield.expandable "id-of-expandable-100"
                    -- , Textfield.expandableIcon "search"
                    -- , Options.onInput Search
                    -- , Options.onClick SearchClicked
                    ]
                    []
                ]
            ]
        ]


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


viewBody : Model -> Html Msg
viewBody model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        [ text ("Current count: " ++ toString model.count)

        {- We construct the instances of the Button component that we need, one
           for the increase button, one for the reset button. First, the increase
           button. The first three arguments are:
             - A Msg constructor (`Mdl`), lifting Mdl messages to the Msg type.
             - An instance id (the `[0]`). Every component that uses the same model
               collection (model.mdl in this file) must have a distinct instance id.
             - A reference to the elm-mdl model collection (`model.mdl`).
           Notice that we do not have to add fields for the increase and reset buttons
           separately to our model; and we did not have to add to our update messages
           to handle their internal events.
           Mdl components are configured with `Options`, similar to `Html.Attributes`.
           The `Options.onClick Increase` option instructs the button to send the `Increase`
           message when clicked. The `css ...` option adds CSS styling to the button.
           See `Material.Options` for details on options.
        -}
        , Button.render Mdl
            [ 0 ]
            model.mdl
            [ Options.onClick Increase
            , css "margin" "0 24px"
            ]
            [ text "Increase" ]
        , Button.render Mdl
            [ 1 ]
            model.mdl
            [ Options.onClick Reset ]
            [ text "Reset" ]
        , div
                --[ style [ ( "padding-right", "2rem" ), ( "float", "right" ) ], onKeyDown KeyDown, onInput Input ]
                []
                [ Textfield.render Mdl
                    [ 1 ]
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
        |> Material.Scheme.top



-- Load Google Mdl CSS. You'll likely want to do that not in code as we
-- do here, but rather in your master .html file. See the documentation
-- for the `Material` module for details.


main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }
