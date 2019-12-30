module HealthProgram exposing (Model, Msg(..), init, update, view)

import Css
import Dialog
import Dict exposing (Dict)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode
import RemoteData exposing (RemoteData(..), WebData)
import RemoteData.Http
import Route
import Types exposing (..)
import Url exposing (Url)
import ViewHelpers



-- MODEL


type alias Model =
    { openModal : Modal
    }


type Modal
    = NoModal
    | ProgramModal ProgramId


init : Model
init =
    { openModal = NoModal }



-- UPDATE


type Msg
    = SetModal Modal


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetModal modal ->
            { model | openModal = modal }



-- VIEW


view : Model -> WebData ProgramData -> Html Msg
view model programData =
    let
        programContent =
            case programData of
                Success data ->
                    Html.div []
                        [ viewPrograms data.programs
                        , viewModal model.openModal data.programsById
                        ]

                _ ->
                    -- TODO: Add error handling
                    ViewHelpers.p "Loading..."
    in
    Html.div []
        [ ViewHelpers.h1 [ Html.text "All Programs" ]
        , programContent
        ]


viewPrograms : List HealthProgram -> Html Msg
viewPrograms programs =
    programs
        |> List.map
            (\program ->
                Html.section
                    []
                    [ Html.div
                        [ Attributes.css
                            [ Css.displayFlex
                            , Css.alignItems Css.center
                            , Css.justifyContent Css.spaceBetween
                            ]
                        ]
                        [ ViewHelpers.h2 [ Html.text program.name ]
                        , Html.button
                            [ Events.onClick (SetModal <| ProgramModal program.id)
                            , Attributes.css
                                [ Css.cursor Css.pointer
                                , Css.textDecoration Css.underline
                                , Css.fontSize (Css.px 14)
                                , Css.backgroundColor Css.transparent
                                , Css.border Css.zero
                                , Css.margin (Css.px 5)
                                ]
                            ]
                            [ Html.text "Learn More"
                            ]
                        ]
                    , viewSections program.sections
                    ]
            )
        |> Html.div []


viewSections : List SectionOverview -> Html Msg
viewSections sections =
    sections
        |> List.sortBy .orderIndex
        |> List.map
            (\section ->
                Html.a
                    [ Attributes.href (Route.toString (Route.Section section.id))
                    , Attributes.css
                        [ Css.textDecoration Css.none
                        , Css.cursor Css.pointer
                        , Css.width (Css.px 250)
                        , Css.height (Css.px 325)
                        , Css.margin (Css.px 15)
                        , Css.padding (Css.px 15)
                        , Css.boxShadow4 (Css.px 2) (Css.px 2) (Css.px 7) (Css.rgba 0 0 0 0.2)
                        , Css.color ViewHelpers.steelblue
                        , Css.displayFlex
                        , Css.flexDirection Css.column
                        , Css.justifyContent Css.spaceBetween
                        ]
                    ]
                    [ Html.img
                        [ Attributes.src section.overviewImage
                        , Attributes.alt ""
                        , Attributes.css
                            [ Css.width (Css.px 200)
                            , Css.height (Css.px 200)
                            , Css.margin2 (Css.px 10) Css.auto
                            , Css.display Css.block
                            ]
                        ]
                        []
                    , Html.div []
                        [ ViewHelpers.p ("Part " ++ String.fromInt section.orderIndex) -- TODO: this should be the "word" version of the string, e.g. "one"
                        , ViewHelpers.h3 [ Html.text section.name ]
                        ]
                    ]
            )
        |> Html.div
            [ Attributes.css [ Css.displayFlex ]
            ]


viewModal : Modal -> Dict ProgramId HealthProgram -> Html Msg
viewModal modal programsById =
    (case modal of
        NoModal ->
            Nothing

        ProgramModal programId ->
            let
                maybeProgram =
                    Dict.get programId programsById
            in
            Maybe.map
                (\program ->
                    { closeMessage = Just (SetModal NoModal)
                    , containerClass = Nothing
                    , header = Just (ViewHelpers.h2 [ Html.text program.name ] |> Html.toUnstyled)
                    , body = Just (Html.text program.description |> Html.toUnstyled)
                    , footer = Nothing
                    }
                )
                maybeProgram
    )
        |> Dialog.view
        |> Html.fromUnstyled
