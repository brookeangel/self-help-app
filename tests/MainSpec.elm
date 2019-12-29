module MainSpec exposing (tests)

import Expect exposing (Expectation)
import Main
import ProgramTest exposing (ProgramTest)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


init : ProgramTest Main.Model Main.Msg (Cmd Main.Msg)
init =
    ProgramTest.createElement
        { init = Main.init
        , view = Main.view
        , update = Main.update
        }
        |> ProgramTest.start ()


tests : Test
tests =
    describe "The index page"
        [ test "Renders the programs" <|
            \() ->
                init
                    |> ProgramTest.ensureViewHas
                        [ Selector.text "All Programs"
                        ]
                    |> ProgramTest.expectViewHas
                        [ Selector.text "Core Pillars"
                        ]
        , test "Can can show and hide the program's description" <|
            \() ->
                init
                    |> ProgramTest.within
                        (Query.find
                            [ Selector.tag "section"
                            , Selector.containing
                                [ Selector.text "Core Pillars"
                                ]
                            ]
                        )
                        (\context ->
                            context
                                |> ProgramTest.clickButton "Learn More"
                        )
                    |> ProgramTest.ensureViewHas [ Selector.text "Core pillars description" ]
                    |> ProgramTest.clickButton "x"
                    |> ProgramTest.expectViewHasNot [ Selector.text "Core pillars description" ]
        , test "Renders a list sections" <|
            \() ->
                init
                    |> ProgramTest.within
                        (Query.find
                            [ Selector.tag "section"
                            , Selector.containing
                                [ Selector.text "Core Pillars"
                                ]
                            ]
                        )
                        (\context ->
                            context
                                |> ProgramTest.ensureViewHas
                                    [ Selector.text "Core Section 1"
                                    ]
                                |> ProgramTest.ensureViewHas
                                    [ Selector.text "Core Section 2"
                                    ]
                        )
                    |> ProgramTest.done
        ]
