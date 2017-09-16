module Found exposing (..)

import Dict as Dict
import Dict exposing (Dict)
import Html exposing (Html)
import Html as H
import Html.Attributes exposing (href, class, style)
import Material
import Material.List as MList
import Material.Typography as Typography
import Material.Options as Options exposing (when, css)
import Material.Elevation as Elevation
import Material.Button as Button
import Material.Typography as Typo


type alias MdModel =
    Material.Model



----------------------------------------------------------
-- MODEL


type alias Model =
    { found : Dict String (Dict String (List String))
    , mdl :
        Material.Model
    }


initModel : Model
initModel =
    { found = Dict.empty
    , mdl = Material.model
    }


testFill : Model -> Model
testFill model =
    { model
        | found =
            Dict.fromList
                [ ( "00000"
                  , Dict.fromList
                        [ ( "000222222", [ "00333333333", "00044444444444", "564654" ] )
                        , ( "000bbbb", [ "000cccc", "000dddd" ] )
                        ]
                  )
                , ( "aaaaa"
                  , Dict.fromList
                        [ ( "222222", [ "333333333", "44444444444" ] )
                        , ( "bbbb", [ "cccc", "dddd" ] )
                        ]
                  )
                ]
    }



----------------------------------------------------------
-- ACTION, UPDATE


type Msg
    = Test
    | MdlMsg (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Test ->
            ( testFill model, Cmd.none )

        _ ->
            ( model, Cmd.none )



----------------------------------------------------------
-- VIEW


view : Model -> Html Msg
view model =
    H.div [ style [ ( "padding", "2rem" ) ] ]
        [ Button.render MdlMsg
            [ 1, 1 ]
            model.mdl
            [ Options.onClick Test ]
            [ H.text "test" ]
        , H.text (toString { model | mdl = [] })
        , viewCard "Doc" [ ( "html", [ "pr1.html", "pr2.html" ] ) ]
        ]


viewCard : String -> List ( String, List String ) -> Html Msg
viewCard secTitle scont =
    let
        secItems items =
            MList.ul [] <|
                List.map (\item -> MList.li [] [ MList.content [] [ H.text item ] ]) items

        secContent content =
            MList.ul [] <|
                List.map
                    (\( subTitle, items ) ->
                        MList.li []
                            [ MList.content []
                                [ Options.styled H.p
                                    [ Typo.title ]
                                    [ H.text subTitle, secItems items ]
                                ]
                            ]
                    )
                    content
    in
        Options.div
            [ Elevation.e6
            , css "padding" ".6rem 1.0rem"
            ]
            [ Options.styled H.p
                [ Typo.headline ]
                [ H.text secTitle ]
            , secContent scont
            ]
