module Found exposing (..)

import Dict
import Html exposing (Html)
import Html as H
import Html.Attributes exposing (href, class, style)
import Material
import Material.List as MList
import Material.Typography as Typography
import Material.Options as Options exposing (when, css)
import Material.Card as Card
import Material.Color as Color
-- import Material.Button as Button
-- import Material.Icon as Icon
import Material.Elevation as Elevation

-- Material Design


type alias MdModel =
    Material.Model


white : Options.Property c m
white =
    Color.text Color.white



----------------------------------------------------------
-- MODEL


type alias Model =
    { found : Dict.Dict ( String, String ) String
    }


initModel : Model
initModel =
    { found = Dict.empty
    }


testFill : Model -> Model
testFill model =
    { model | found = Dict.insert ( "bbbbbbbbbb", "aaaa" ) "asdfasdf" model.found }



----------------------------------------------------------
-- ACTION, UPDATE


type Msg
    = None
    | Mdl (Material.Msg Msg)



----------------------------------------------------------
-- VIEW


view : Model -> MdModel -> Html Msg
view model mdModel =
    H.div [ style [ ( "padding", "2rem" ) ] ]
        [ Options.styled Html.h4 [ Typography.headline ] [ H.text "Departures" ]
        , MList.ul []
            [ MList.li [] [ MList.content [] [ H.text "Elm" ] ]
            , MList.li [] [ MList.content [] [ H.text "F#" ] ]
            , MList.li [] [ MList.content [] [ H.text "Lisp" ] ]
            ]
        , Card.view
            [ Color.background (Color.color Color.Indigo Color.S400)
            , css "width" "90%"
            --, css "height" "192px"
            ]
            [ Card.title [] [ Card.head [ white ] [ H.text "Roskilde Festival asd fasdf dasf asdf dasf asdf dsaf das fasdf" ] ]
            , Card.text [ white ] [ H.text "Buy tickets before May asdf asdf asdf sadf asdf asdf sadf sadf sad fasd f" ]
            , Card.actions
                []--[ Card.border, css "vertical-align" "center", css "text-align" "right", white ]
                []
                -- [ Button.render Mdl
                --     [ 8, 1 ]
                --     mdModel
                --     [ Button.icon, Button.ripple ]
                --     [ Icon.i "favorite_border" ]
                -- , Button.render Mdl
                --     [ 8, 2 ]
                --     mdModel
                --     [ Button.icon, Button.ripple ]
                --     [ Icon.i "event_available" ]
                -- ]
            ]
        ]



-- [ H.text ("Found:  " ++ (toString model))
-- ]
