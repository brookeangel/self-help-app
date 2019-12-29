module Main exposing (Effect, Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Navigation exposing (Key)
import Dialog
import Dict exposing (Dict)
import HealthProgram
import Html exposing (Html)
import RemoteData exposing (RemoteData(..), WebData)
import RemoteData.Http
import Route exposing (Route)
import Section
import Types exposing (HealthProgram, ProgramData)
import Url exposing (Url)


main : Program () (Model Key) Msg
main =
    Browser.application
        { init =
            \flags url key ->
                init flags url key
                    |> Tuple.mapSecond (runEffect key)
        , view = view
        , update =
            \msg model ->
                update msg model
                    |> Tuple.mapSecond (runEffect model.key)
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = HandleUrlRequest
        , onUrlChange = HandleUrlChange
        }



-- MODEL


type alias Model key =
    { key : key
    , page : Page
    , programData : WebData ProgramData
    }


type Page
    = NotFound
    | HealthProgram HealthProgram.Model
    | Section Section.Model


init : () -> Url -> key -> ( Model key, Effect )
init () url key =
    changeRouteTo (Route.fromUrl url) (initModel key)


initModel : key -> Model key
initModel key =
    { key = key
    , page = NotFound

    -- Requires a page; NotFound is our empty page but we could make this more descriptive, e.g. Loading
    , programData = Loading
    }


changeRouteTo : Maybe Route -> Model key -> ( Model key, Effect )
changeRouteTo maybeRoute model =
    let
        ( page, theCmd ) =
            case maybeRoute of
                Nothing ->
                    ( NotFound, NoEffect )

                Just Route.Programs ->
                    ( HealthProgram HealthProgram.init
                    , GetProgramData
                      -- TODO: only fetch if the cache isn't populated
                    )

                Just (Route.Section id) ->
                    let
                        sectionModel =
                            Section.init id
                    in
                    ( Section sectionModel, NoEffect )
    in
    ( { model | page = page }
    , theCmd
    )



-- UPDATE


type Msg
    = HandleUrlRequest Browser.UrlRequest
    | HandleUrlChange Url
    | HealthProgramMsg HealthProgram.Msg
    | SectionMsg Section.Msg
    | ReceiveProgramData (WebData (List HealthProgram))


update : Msg -> Model key -> ( Model key, Effect )
update msg model =
    case msg of
        HealthProgramMsg healthProgramMsg ->
            case model.page of
                HealthProgram healthProgramModel ->
                    let
                        newModel =
                            HealthProgram.update
                                healthProgramMsg
                                healthProgramModel
                    in
                    ( { model | page = HealthProgram newModel }
                    , NoEffect
                    )

                _ ->
                    -- Not possible
                    ( model, NoEffect )

        SectionMsg sectionMsg ->
            case model.page of
                Section sectionModel ->
                    let
                        newModel =
                            Section.update
                                sectionMsg
                                sectionModel
                    in
                    ( { model | page = Section newModel }
                    , NoEffect
                    )

                _ ->
                    -- Not possible
                    ( model, NoEffect )

        HandleUrlRequest request ->
            case request of
                Browser.Internal url ->
                    ( model
                    , PushUrl url
                    )

                Browser.External href ->
                    ( model
                    , LoadUrl href
                    )

        HandleUrlChange url ->
            changeRouteTo (Route.fromUrl url) model

        ReceiveProgramData remoteData ->
            case remoteData of
                Success healthPrograms ->
                    ( { model
                        | programData =
                            Success
                                (Types.initProgramData healthPrograms)
                      }
                    , NoEffect
                    )

                _ ->
                    -- TODO: Error handling
                    ( model, NoEffect )


type Effect
    = NoEffect
    | LoadUrl String
    | PushUrl Url
    | GetProgramData


runEffect : Key -> Effect -> Cmd Msg
runEffect key effect =
    case effect of
        NoEffect ->
            Cmd.none

        LoadUrl href ->
            Navigation.load href

        PushUrl url ->
            Navigation.pushUrl key (Url.toString url)

        GetProgramData ->
            RemoteData.Http.get "/api/programs" ReceiveProgramData Types.programsDecoder



-- VIEW


view : Model key -> Browser.Document Msg
view model =
    case model.page of
        NotFound ->
            { title = "Not found"
            , body = [ Html.text "Not found" ]
            }

        HealthProgram healthProgramModel ->
            { title = "Self Help Programs"
            , body =
                [ HealthProgram.view healthProgramModel model.programData
                    |> Html.map HealthProgramMsg
                ]
            }

        Section sectionModel ->
            { title = "Self Help Section"
            , body =
                [ Section.view sectionModel
                    |> Html.map SectionMsg
                ]
            }
