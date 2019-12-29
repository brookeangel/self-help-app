module Section exposing (view)

import Dialog
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Attributes.Extra as Attributes
import Html.Events as Events
import RemoteData exposing (RemoteData(..), WebData)
import RemoteData.Http
import Route
import Types exposing (Section)
import Url exposing (Url)


view : WebData Section -> Html msg
view webdata =
    case webdata of
        Success section ->
            Html.section []
                [ Html.h1 []
                    [ Html.text
                        ("Part "
                            ++ String.fromInt section.orderIndex
                            -- TODO: should be word, e.g. "one"
                            ++ ": "
                            ++ section.name
                        )
                    ]
                , Html.div
                    []
                    [ Html.div
                        [ Attributes.stringProperty "innerHTML" section.htmlContent ]
                        []
                    , Html.img [ Attributes.src section.overviewImage ] []
                    , Html.a [ Attributes.href "/" ] [ Html.text "Go Back" ]
                    ]
                ]

        Loading ->
            Html.text "Loading..."

        _ ->
            Html.text "Error"
