module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation exposing (Key)
import Dialog
import Dict exposing (Dict)
import HealthProgram
import Html exposing (Html)
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


type Model
    = HealthProgram HealthProgram.Model


init : () -> Url -> key -> ( Model, Cmd Msg )
init () url _ =
    let
        ( model, cmd ) =
            HealthProgram.init
    in
    ( HealthProgram model, Cmd.map HealthProgramMsg cmd )



-- UPDATE


type Msg
    = HandleUrlRequest Browser.UrlRequest
    | HandleUrlChange Url
    | HealthProgramMsg HealthProgram.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HealthProgramMsg healthProgramMsg ->
            case model of
                HealthProgram healthProgramModel ->
                    let
                        ( newModel, cmd ) =
                            HealthProgram.update
                                healthProgramMsg
                                healthProgramModel
                    in
                    ( HealthProgram newModel
                    , Cmd.map HealthProgramMsg cmd
                    )

        HandleUrlRequest request ->
            -- TODO
            ( model, Cmd.none )

        HandleUrlChange url ->
            -- TODO
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model of
        HealthProgram healthProgramModel ->
            { title = "Self Help Programs"
            , body =
                [ HealthProgram.view healthProgramModel
                    |> Html.map HealthProgramMsg
                ]
            }
