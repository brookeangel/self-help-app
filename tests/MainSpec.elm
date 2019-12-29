module MainSpec exposing (tests)

import Expect exposing (Expectation)
import Main
import ProgramTest exposing (ProgramTest)
import Test exposing (..)
import Test.Html.Selector as Selector


init : ProgramTest Main.Model () (Cmd ())
init =
    ProgramTest.createElement
        { init = Main.init
        , view = Main.view
        , update = Main.update
        }
        |> ProgramTest.start ()


tests : Test
tests =
    test "Renders the programs" <|
        \() ->
            init
                |> ProgramTest.ensureViewHas
                    [ Selector.text "All Programs"
                    ]
                |> ProgramTest.expectViewHas
                    [ Selector.text "Core Pillars"
                    ]
