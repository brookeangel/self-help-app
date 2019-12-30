module ViewHelpers exposing (buttonStyles, darkGrey, h1, h2, h3, intToWord, lightGrey, p, steelblue)

import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)


p : String -> Html msg
p string =
    Html.p
        [ css
            [ Css.fontSize (Css.px 16)
            , Css.color steelblue
            , Css.marginBottom (Css.px 10)
            ]
        ]
        [ Html.text string
        ]


h1 : List (Html msg) -> Html msg
h1 =
    Html.h1
        [ css
            [ Css.fontSize (Css.px 36)
            , Css.color steelblue
            , Css.fontWeight (Css.int 700)
            , Css.textAlign Css.center
            , Css.marginBottom (Css.px 10)
            ]
        ]


h2 : List (Html msg) -> Html msg
h2 =
    Html.h2
        [ css
            [ Css.fontSize (Css.px 24)
            , Css.color steelblue
            , Css.fontWeight (Css.int 700)
            , Css.marginBottom (Css.px 10)
            ]
        ]


h3 : List (Html msg) -> Html msg
h3 =
    Html.h3
        [ css
            [ Css.fontSize (Css.px 20)
            , Css.color steelblue
            , Css.fontWeight (Css.int 700)
            , Css.marginBottom (Css.px 10)
            ]
        ]


steelblue : Css.Color
steelblue =
    Css.hex "4B75A7"


darkGrey : Css.Color
darkGrey =
    Css.hex "595B5C"


lightGrey : Css.Color
lightGrey =
    Css.hex "D6DDE1"


{-| Weirdly, I can't find an Elm package for this. Note: this only works up to 10
-}
intToWord : Int -> String
intToWord int =
    case int of
        1 ->
            "one"

        2 ->
            "two"

        3 ->
            "three"

        4 ->
            "four"

        5 ->
            "five"

        6 ->
            "six"

        7 ->
            "seven"

        8 ->
            "eight"

        9 ->
            "nine"

        10 ->
            "ten"

        _ ->
            -- Non-ideal, but alright
            String.fromInt int


buttonStyles : Attribute msg
buttonStyles =
    css
        [ Css.width (Css.px 150)
        , Css.height (Css.px 35)
        , Css.color steelblue
        , Css.borderRadius (Css.px 4)
        , Css.display Css.inlineBlock
        , Css.border3 (Css.px 2) Css.solid lightGrey
        , Css.displayFlex
        , Css.alignItems Css.center
        , Css.justifyContent Css.center
        , Css.textDecoration Css.none
        , Css.cursor Css.pointer
        , Css.fontSize (Css.px 14)
        ]
