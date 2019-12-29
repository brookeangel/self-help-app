module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Navigation exposing (Key)
import Dialog
import Dict exposing (Dict)
import HealthProgram
import Html exposing (Html)
import Route exposing (Route)
import Section
import Url exposing (Url)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = HandleUrlRequest
        , onUrlChange = HandleUrlChange
        }



-- MODEL


type alias Model =
    { key : Key
    , page : Page
    }


type Page
    = NotFound
    | HealthProgram HealthProgram.Model
    | Section Section.Model


init : () -> Url -> Key -> ( Model, Cmd Msg )
init () url key =
    changeRouteTo (Route.fromUrl url) key


changeRouteTo : Maybe Route -> Key -> ( Model, Cmd Msg )
changeRouteTo maybeRoute key =
    let
        ( page, theCmd ) =
            case maybeRoute of
                Nothing ->
                    ( NotFound, Cmd.none )

                Just Route.Programs ->
                    let
                        ( model, cmd ) =
                            HealthProgram.init
                    in
                    ( HealthProgram model, Cmd.map HealthProgramMsg cmd )

                Just (Route.Section id) ->
                    let
                        ( model, cmd ) =
                            Section.init id
                    in
                    ( Section model, Cmd.map SectionMsg cmd )
    in
    ( { key = key, page = page }, theCmd )



-- UPDATE


type Msg
    = HandleUrlRequest Browser.UrlRequest
    | HandleUrlChange Url
    | HealthProgramMsg HealthProgram.Msg
    | SectionMsg Section.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HealthProgramMsg healthProgramMsg ->
            case model.page of
                HealthProgram healthProgramModel ->
                    let
                        ( newModel, cmd ) =
                            HealthProgram.update
                                healthProgramMsg
                                healthProgramModel
                    in
                    ( { model | page = HealthProgram newModel }
                    , Cmd.map HealthProgramMsg cmd
                    )

                _ ->
                    -- Not possible
                    ( model, Cmd.none )

        SectionMsg sectionMsg ->
            case model.page of
                Section sectionModel ->
                    let
                        ( newModel, cmd ) =
                            Section.update
                                sectionMsg
                                sectionModel
                    in
                    ( { model | page = Section newModel }
                    , Cmd.map SectionMsg cmd
                    )

                _ ->
                    -- Not possible
                    ( model, Cmd.none )

        HandleUrlRequest request ->
            case request of
                Browser.Internal url ->
                    ( model
                    , Navigation.pushUrl model.key
                        (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Navigation.load href
                    )

        HandleUrlChange url ->
            changeRouteTo (Route.fromUrl url) model.key



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.page of
        NotFound ->
            { title = "Not found"
            , body = [ Html.text "Not found" ]
            }

        HealthProgram healthProgramModel ->
            { title = "Self Help Programs"
            , body =
                [ HealthProgram.view healthProgramModel
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
