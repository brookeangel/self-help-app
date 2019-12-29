module HealthProgram exposing (Model, Msg(..), init, update, view)

import Dialog
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode
import RemoteData exposing (RemoteData(..), WebData)
import RemoteData.Http
import Route
import Url exposing (Url)



-- MODEL


type alias Model =
    { data : WebData ProgramData
    , openModal : Modal
    }


type alias ProgramData =
    { programs : List HealthProgram
    , programsById : Dict ProgramId HealthProgram
    }


type alias ProgramId =
    Int


type alias SectionId =
    Int


type alias HealthProgram =
    { id : ProgramId
    , name : String
    , description : String
    , sections : List Section
    }


type alias Section =
    { id : SectionId
    , name : String
    , overviewImage : String
    }


type Modal
    = NoModal
    | ProgramModal ProgramId


init : ( Model, Cmd Msg )
init =
    ( { data = Loading
      , openModal = NoModal
      }
    , RemoteData.Http.get "/api/programs" ReceiveData programsDecoder
    )


programsDecoder : Decoder (List HealthProgram)
programsDecoder =
    Decode.list
        (Decode.succeed HealthProgram
            |> Decode.required "id" Decode.int
            |> Decode.required "name" Decode.string
            |> Decode.required "description" Decode.string
            |> Decode.required "sections" sectionsDecoder
        )


sectionsDecoder : Decoder (List Section)
sectionsDecoder =
    Decode.list
        (Decode.succeed Section
            |> Decode.required "id" Decode.int
            |> Decode.required "name" Decode.string
            |> Decode.required "overview_image" Decode.string
        )


initData : List HealthProgram -> ProgramData
initData programs =
    { programs = programs
    , programsById =
        programs
            |> List.map (\program -> ( program.id, program ))
            |> Dict.fromList
    }



-- UPDATE


type Msg
    = SetModal Modal
    | ReceiveData (WebData (List HealthProgram))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetModal modal ->
            ( { model | openModal = modal }, Cmd.none )

        ReceiveData remoteData ->
            case remoteData of
                Success healthPrograms ->
                    ( { model | data = Success (initData healthPrograms) }, Cmd.none )

                _ ->
                    -- TODO: Error handling
                    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        programContent =
            case model.data of
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
viewSections : List Section -> Html Msg
viewSections sections =
    sections
        |> List.indexedMap
            (\index section ->
                Html.a
                    [ Attributes.href (Route.toString (Route.Section section.id))
                    ]
                    [ Html.img
                        [ Attributes.src section.overviewImage
                        , Attributes.alt ""
                        ]
                        []
                    , Html.p [] [ Html.text ("Part " ++ String.fromInt index) ] -- TODO: this should be the "word" version of the string, e.g. "one"
                    , Html.h3 [] [ Html.text section.name ]
                    ]
            )
        |> Html.div []


viewModal : Modal -> Dict ProgramId HealthProgram -> Html Msg
viewModal modal programsById =
    Dialog.view <|
        case modal of
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
                        , header = Just (Html.h2 [] [ Html.text program.name ])
                        , body = Just (Html.text program.description)
                        , footer = Nothing
                        }
                    )
                    maybeProgram
