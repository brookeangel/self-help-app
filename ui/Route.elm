module Route exposing (Route(..), fromUrl, toString)

import Browser.Navigation as Navigation
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, int, s)



-- ROUTING


type Route
    = Programs
    | Section Int


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Programs Parser.top
        , Parser.map Section (s "sections" </> int)
        ]


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


toString : Route -> String
toString route =
    case route of
        Programs ->
            "/"

        Section int ->
            "/sections/" ++ String.fromInt int
