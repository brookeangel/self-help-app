module Main exposing (Model, Msg, init, main, update, view)

import Browser
import Dialog
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { programs : List HealthProgram
    , programsById : Dict ProgramId HealthProgram
    , openModal : Modal
    }


type alias ProgramId =
    Int


type alias HealthProgram =
    { id : ProgramId
    , name : String
    , description : String
    , sections : List Section
    }


type alias SectionId =
    Int


type alias Section =
    { id : SectionId
    , name : String
    , overviewImage : String
    }


type Modal
    = NoModal
    | ProgramModal ProgramId


init : () -> ( Model, Cmd Msg )
init () =
    let
        programs =
            [ { id = 1
              , name = "Core Pillars"
              , description = "Core pillars description"
              , sections =
                    [ { id = 101
                      , name = "Core Section 1"
                      , overviewImage = "http://placecorgi.com/250"
                      }
                    , { id = 102
                      , name = "Core Section 2"
                      , overviewImage = "http://placekitten.com/200/200"
                      }
                    ]
              }
            , { id = 2
              , name = "The Next Level"
              , description = "The next level description"
              , sections = []
              }
            ]
    in
    ( { programs = programs
      , programsById =
            programs
                |> List.map (\program -> ( program.id, program ))
                |> Dict.fromList
      , openModal = NoModal
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SetModal Modal


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetModal modal ->
            ( { model | openModal = modal }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Html.main_ []
        [ Html.h1 [] [ Html.text "All Programs" ]
        , viewPrograms model.programs
        , viewModal model.openModal model.programsById
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
                Html.button []
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
