module Section exposing (view)

import Css
import Dict exposing (Dict)
import Html.Parser
import Html.Parser.Util
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Json.Encode
import RemoteData exposing (RemoteData(..), WebData)
import RemoteData.Http
import Route
import Types exposing (Section)
import Url exposing (Url)
import ViewHelpers


view : WebData Section -> Html msg
view webdata =
    case webdata of
        Success section ->
            Html.section
                [ Attributes.css
                    [ Css.displayFlex
                    , Css.alignItems Css.center
                    , Css.flexDirection Css.column
                    ]
                ]
                [ Html.div
                    [ Attributes.css
                        [ Css.marginBottom (Css.px 20)
                        ]
                    ]
                    [ ViewHelpers.h2
                        [ Html.text
                            ("Part "
                                ++ ViewHelpers.intToWord section.orderIndex
                                ++ ": "
                                ++ section.name
                            )
                        ]
                    ]
                , Html.div
                    [ Attributes.css
                        [ Css.height (Css.px 5)
                        , Css.width (Css.pct 100)
                        , Css.backgroundColor ViewHelpers.lightGrey
                        , Css.marginBottom (Css.px 40)
                        ]
                    ]
                    []
                , sectionContent section
                ]

        Loading ->
            Html.text "Loading..."

        _ ->
            Html.text "Error"


sectionContent : Section -> Html msg
sectionContent section =
    let
        htmlContent =
            case Html.Parser.run section.htmlContent of
                Ok parsedNodes ->
                    Html.Parser.Util.toVirtualDom parsedNodes
                        |> List.map Html.fromUnstyled

                _ ->
                    []
    in
    Html.div
        [ Attributes.css
            [ Css.width (Css.pct 100)
            , Css.minHeight (Css.px 400)
            , Css.displayFlex
            , Css.margin (Css.px 20)
            ]
        ]
        [ Html.div
            [ Attributes.css
                [ Css.width (Css.pct 50)
                ]
            ]
            [ ViewHelpers.p section.description
            , Html.div
                [ Attributes.css
                    [ Css.color ViewHelpers.darkGrey
                    , Css.margin (Css.px 20)
                    ]
                ]
                htmlContent
            , Html.a
                [ Attributes.href "/"
                , ViewHelpers.buttonStyles
                ]
                [ Html.text "Back" ]
            ]
        , Html.div
            [ Attributes.css
                [ Css.width (Css.pct 50)
                , Css.displayFlex
                , Css.justifyContent Css.center
                , Css.alignItems Css.center
                ]
            ]
            [ Html.img [ Attributes.src section.overviewImage ] []
            ]
        ]
