module Croppie.EventsTest exposing (..)

import Croppie
import Croppie.Events as Events
import Croppie.Internal
import Expect exposing (FloatingPointTolerance(..))
import Fuzz exposing (Fuzzer, bool, int , string)
import Html
import Html.Attributes exposing (class, src)
import Json.Encode as Encode
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test exposing (..)
import Utils exposing (..)
import Croppie


type Msg
    = GotCropData Croppie.CropData
    | GotResult (Croppie.Result Msg)

events : Test
events =
    let
        encodeCropData_ cropData_ =
            Encode.object
                [ ("detail"
                  , Encode.object
                    [ ( "orientation", Encode.int cropData_.orientation )
                    , ( "points", Encode.list Encode.string <| List.map String.fromInt cropData_.points )
                    , ( "zoom", Encode.float cropData_.zoom )
                    ]
                  )
                ]
        
        encodeResult_ result_ =
            Encode.object
                [ ( "detail"
                  , case result_ of
                    Croppie.Base64 value_ ->
                        Encode.object
                            [ ( "type", Encode.string "base64" )
                            , ( "value", Encode.string value_ )
                            ]
                        
                    Croppie.Canvas value_ ->
                        Encode.object
                            [ ( "type", Encode.string "canvas" )
                            , ( "value", Encode.string value_ )
                            ]

                    _ ->
                        Encode.null
                  )
                ]
    in
    describe "Tests of Croppie.Events"
        [ fuzz cropData "update event test" <|
            \randomGeneratedCropData ->
                Croppie.croppie [] [ Events.onUpdate GotCropData ]
                    |> Query.fromHtml
                    |> Event.simulate (Event.custom "update" (encodeCropData_ randomGeneratedCropData))
                    |> Event.expect (GotCropData randomGeneratedCropData)
        , fuzz cropData "get event test" <|
            \randomGeneratedCropData ->
                Croppie.croppie [] [ Events.onGet GotCropData ]
                    |> Query.fromHtml
                    |> Event.simulate (Event.custom "get" (encodeCropData_ randomGeneratedCropData))
                    |> Event.expect (GotCropData randomGeneratedCropData)
        , fuzz result "result event test" <|
            \randomGeneratedResult ->
                Croppie.croppie [] [ Events.onResult GotResult ]
                    |> Query.fromHtml
                    |> Event.simulate (Event.custom "result" (encodeResult_ randomGeneratedResult))
                    |> Event.expect (GotResult randomGeneratedResult)
        ]


cropData : Fuzzer Croppie.CropData
cropData =
    Fuzz.map3 Croppie.CropData
        Fuzz.int
        (Fuzz.list Fuzz.int)
        Fuzz.float


result : Fuzzer (Croppie.Result Msg)
result =
    Fuzz.oneOf
        [ Fuzz.map Croppie.Base64 Fuzz.string
        , Fuzz.map Croppie.Canvas Fuzz.string
        ]