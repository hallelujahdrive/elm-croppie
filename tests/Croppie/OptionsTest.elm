module Croppie.OptionsTest exposing (..)

import Croppie.Internal exposing (Option(..))
import Croppie.Options as Options
import Expect exposing (FloatingPointTolerance(..))
import Fuzz exposing (Fuzzer, bool, int, string)
import Json.Decode as Decode
import Test exposing (..)
import Utils exposing (..)

type alias Viewport =
    { width : Int
    , height : Int
    , type_ : Options.CropType
    }


options : Test
options =
    describe "Tests of Croppie.Options module"
        [ fuzz boundary "boundary has Encode.Value" <|
            \(randomGeneratedWidth, randomGeneratedHeight) ->
                Options.boundary
                    { width = randomGeneratedWidth
                    , height = randomGeneratedHeight
                    }
                    |> \(Option option) ->
                        Expect.all
                            [ \opt -> Expect.equal "boundary" (Tuple.first opt)
                            , \opt -> equalJson randomGeneratedWidth (Decode.at [ "width" ] Decode.int) (Tuple.second opt)
                            , \opt -> equalJson randomGeneratedHeight (Decode.at ["height"] Decode.int) (Tuple.second opt)
                            ]
                            option
        , fuzz string "customClass has Encode.Value" <|
            \randomGeneratedString ->
                Options.customClass randomGeneratedString
                    |> \(Option option) ->
                        Expect.all
                            [ \opt -> Expect.equal "customClass" (Tuple.first opt)
                            , \opt -> equalJson randomGeneratedString Decode.string (Tuple.second opt)
                            ]
                            option
        , fuzz bool "enableExif has Encode.Value" <|
            \randomGeneratedBool ->
                Options.enableExif randomGeneratedBool
                    |> \(Option option) ->
                        Expect.all
                            [ \opt -> Expect.equal "enableExif" (Tuple.first opt)
                            , \opt -> equalJson randomGeneratedBool Decode.bool (Tuple.second opt)
                            ]
                            option
        , fuzz bool "enableOrientation has Encode.Value" <|
            \randomGeneratedBool ->
                Options.enableOrientation randomGeneratedBool
                    |> \(Option option) ->
                        Expect.all
                            [ \opt -> Expect.equal "enableOrientation" (Tuple.first opt)
                            , \opt -> equalJson randomGeneratedBool Decode.bool (Tuple.second opt)
                            ]
                            option
        , fuzz bool "enableResize has Encode.Value" <|
            \randomGeneratedBool ->
                Options.enableResize randomGeneratedBool
                    |> \(Option option) ->
                        Expect.all
                            [ \opt -> Expect.equal "enableResize" (Tuple.first opt)
                            , \opt -> equalJson randomGeneratedBool Decode.bool (Tuple.second opt)
                            ]
                            option
        , fuzz bool "enforceBoundary has Encode.Value" <|
            \randomGeneratedBool ->
                Options.enforceBoundary randomGeneratedBool
                    |> \(Option option) ->
                        Expect.all
                            [ \opt -> Expect.equal "enforceBoundary" (Tuple.first opt)
                            , \opt -> equalJson randomGeneratedBool Decode.bool (Tuple.second opt)
                            ]
                            option
        , fuzz mouseWheelZoom "mouseWheelZoom has Encode.Value" <|
            \randomGeneratedMouseWheelZoom ->
                Options.mouseWheelZoom randomGeneratedMouseWheelZoom
                    |> \(Option option) ->
                        Expect.all
                            [ \opt -> Expect.equal "mouseWheelZoom" (Tuple.first opt)
                            , \opt ->
                                if randomGeneratedMouseWheelZoom == Options.Ctrl then
                                    equalJson "ctrl" Decode.string (Tuple.second opt)
                                else
                                    equalJson (randomGeneratedMouseWheelZoom == Options.Enabled) Decode.bool (Tuple.second opt)
                            ]
                            option
        , fuzz bool "showZoomer has Encode.Value" <|
            \randomGeneratedBool ->
                Options.showZoomer randomGeneratedBool
                    |> \(Option option) ->
                        Expect.all
                            [ \opt -> Expect.equal "showZoomer" (Tuple.first opt)
                            , \opt -> equalJson randomGeneratedBool Decode.bool (Tuple.second opt)
                            ]
                            option
        , fuzz viewport "viewport has Encode.Value" <|
            \randomGeneratedViewport ->
                Options.viewport randomGeneratedViewport
                    |> \(Option option) ->
                        Expect.all
                            [ \opt -> Expect.equal "viewport" (Tuple.first opt)
                            , \opt -> equalJson randomGeneratedViewport.width (Decode.at [ "width" ] Decode.int) (Tuple.second opt)
                            , \opt -> equalJson randomGeneratedViewport.height (Decode.at [ "height" ] Decode.int) (Tuple.second opt)
                            , \opt ->
                                equalJson
                                    ( case randomGeneratedViewport.type_ of
                                        Options.Square ->
                                            "square"

                                        Options.Circle ->
                                            "circle"
                                    )
                                    (Decode.at [ "type" ] Decode.string)
                                    (Tuple.second opt)
                            ]
                            option
        ]


boundary : Fuzzer (Int, Int)
boundary =
    Fuzz.map2 (\a b -> (a, b)) Fuzz.int Fuzz.int


mouseWheelZoom : Fuzzer Options.MouseWheelZoom
mouseWheelZoom =
    Fuzz.oneOf
        [ Fuzz.constant Options.Enabled
        , Fuzz.constant Options.Disabled
        , Fuzz.constant Options.Ctrl
        ]


viewport : Fuzzer Viewport
viewport =
    Fuzz.map3 Viewport
        Fuzz.int
        Fuzz.int
        ( Fuzz.oneOf
            [ Fuzz.constant Options.Square
            , Fuzz.constant Options.Circle
            ]
        )