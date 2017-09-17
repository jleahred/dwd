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


-- import Tuple exposing (first, second)

import Material.Grid as MGrid
import Material.Color as MColor


type alias MdModel =
    Material.Model



----------------------------------------------------------
-- MODEL


type alias Model =
    { found : ModelFound
    , mdl :
        Material.Model
    }


type alias ModelFound =
    Dict String (Dict String (List String))


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
        , viewFound model.found
        ]


viewFound : ModelFound -> Html Msg
viewFound found =
    let
        viewL1 =
            List.map
                (\( title, dictL2 ) ->
                    MGrid.grid []
                        [ MGrid.cell
                            [ MGrid.size MGrid.All 12
                            , MColor.background (MColor.color MColor.Blue MColor.S200)
                            ]
                            [ Options.styled H.p
                                [ Typo.headline ]
                                [ H.text title ]
                            ]
                        , MGrid.cell
                            [ MGrid.size MGrid.All 12 ]
                            [ viewL2 dictL2 ]
                        ]
                 -- H.div [ style [ ( "padding", "0.6rem 0.0rem" ) ] ]
                 --     [ Options.div
                 --         [ Elevation.e6
                 --         , css "padding" ".6rem 1.0rem"
                 --         ]
                 --         [ Options.styled H.p
                 --             [ Typo.headline ]
                 --             [ H.text title ]
                 --         , viewL2 dictL2
                 --         ]
                 --     ]
                )
            <| Dict.toList found

        viewL2 l2 =
            MList.ul [] <|
                List.map
                    (\( subTitle, items ) ->
                        MList.li []
                            [ MList.content []
                                [ Options.styled H.p
                                    [ Typo.title ]
                                    [ H.text subTitle, viewL3 items ]
                                ]
                            ]
                    )
                <|
                    Dict.toList l2

        viewL3 items =
            MList.ul [] <|
                List.map (\item -> MList.li [] [ MList.content [] [ H.text item ] ]) items
    in
        H.div []
            [ H.div [] viewL1 ]


viewCard_ : String -> List ( String, List String ) -> Html Msg
viewCard_ secTitle scont =
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
