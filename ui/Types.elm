module Types exposing (HealthProgram, ProgramData, ProgramId, SectionId, SectionOverview, initProgramData, programsDecoder, sectionsDecoder)

import Dict exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode


type alias ProgramData =
    { programs : List HealthProgram
    , programsById : Dict ProgramId HealthProgram
    }


initProgramData : List HealthProgram -> ProgramData
initProgramData programs =
    { programs = programs
    , programsById =
        programs
            |> List.map (\program -> ( program.id, program ))
            |> Dict.fromList
    }


type alias ProgramId =
    Int


type alias SectionId =
    Int


type alias HealthProgram =
    { id : ProgramId
    , name : String
    , description : String
    , sections : List SectionOverview
    }


type alias SectionOverview =
    { id : SectionId
    , name : String
    , overviewImage : String
    }


programsDecoder : Decoder (List HealthProgram)
programsDecoder =
    Decode.list
        (Decode.succeed HealthProgram
            |> Decode.required "id" Decode.int
            |> Decode.required "name" Decode.string
            |> Decode.required "description" Decode.string
            |> Decode.required "sections" sectionsDecoder
        )


sectionsDecoder : Decoder (List SectionOverview)
sectionsDecoder =
    Decode.list
        (Decode.succeed SectionOverview
            |> Decode.required "id" Decode.int
            |> Decode.required "name" Decode.string
            |> Decode.required "overview_image" Decode.string
        )
