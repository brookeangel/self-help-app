module HealthProgram exposing (Model, Msg(..), init, update, view)

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
                    Html.text "Loading..."
    in
    Html.main_ []
        [ Html.h1 [] [ Html.text "All Programs" ]
        , programContent
        ]


viewPrograms : List HealthProgram -> Html Msg
viewPrograms programs =
    programs
        |> List.map
            (\program ->
                Html.section []
                    [ Html.h2 [] [ Html.text program.name ]
                    , Html.button
                        [ Events.onClick (SetModal <| ProgramModal program.id)
                        ]
                        [ Html.text "Learn More"
                        ]
                    , viewSections program.sections
                    ]
            )
        |> Html.div []


{-| TODO: ensure ordering
-}
viewSections : List SectionOverview -> Html Msg
viewSections sections =
    sections
        |> List.sortBy .orderIndex
        |> List.map
            (\section ->
                Html.a
                    [ Attributes.href (Route.toString (Route.Section section.id))
                    ]
                    [ Html.img
                        [ Attributes.src section.overviewImage
                        , Attributes.alt ""
                        ]
                        []
                    , Html.p [] [ Html.text ("Part " ++ String.fromInt section.orderIndex) ] -- TODO: this should be the "word" version of the string, e.g. "one"
                    , Html.h3 [] [ Html.text section.name ]
                    ]
            )
        |> Html.div []


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
                    , header = Just (Html.h2 [] [ Html.text program.name ] |> Html.toUnstyled)
                    , body = Just (Html.text program.description |> Html.toUnstyled)
                    , footer = Nothing
                    }
                )
                maybeProgram
    )
        |> Dialog.view
        |> Html.fromUnstyled
