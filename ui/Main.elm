module Main exposing (Model, init, main, update, view)

import Browser
import Html exposing (Html)


main : Program () Model ()
main =
    Browser.element
        { init = init
        , view = \_ -> Html.text "Hello World!"
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { programs : List HealthProgram
    }


type alias HealthProgram =
    { id : Int
    , name : String
    , description : String
    }


init : () -> ( Model, Cmd () )
init () =
    ( { programs =
            [ { id = 1
              , name = "Core Pillars"
              , description = "Core pillars description"
              }
            , { id = 1
              , name = "The Next Level"
              , description = "The next level description"
              }
            ]
      }
    , Cmd.none
    )



-- UPDATE


update : () -> Model -> ( Model, Cmd () )
update () model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html ()
view model =
    Html.main_ []
        [ Html.h1 [] [ Html.text "All Programs" ]
        , viewPrograms model.programs
        ]


viewPrograms : List HealthProgram -> Html ()
viewPrograms programs =
    programs
        |> List.map
            (\program ->
                Html.section []
                    [ Html.h2 [] [ Html.text program.name ]
                    ]
            )
        |> Html.div []
