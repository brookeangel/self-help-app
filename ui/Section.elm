module Section exposing (Model, Msg(..), init, update, view)

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
    ()


init : Int -> ( Model, Cmd Msg )
init id =
    ( ()
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Html.text "sections"
