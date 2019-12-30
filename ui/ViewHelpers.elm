module ViewHelpers exposing (h1, h2, h3, p, steelblue)

import Css
import Html.Styled as Html exposing (Html)
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
            [ Css.fontSize (Css.px 30)
            , Css.color steelblue
            , Css.fontWeight (Css.int 700)
            , Css.marginBottom (Css.px 10)
            ]
        ]


h3 : List (Html msg) -> Html msg
h3 =
    Html.h3
        [ css
            [ Css.fontSize (Css.px 24)
            , Css.color steelblue
            , Css.fontWeight (Css.int 700)
            , Css.marginBottom (Css.px 10)
            ]
        ]


steelblue : Css.Color
steelblue =
    Css.hex "4682b4"
