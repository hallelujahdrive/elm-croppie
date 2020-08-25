module Croppie.ResultOptionsTest exposing (..)

import Croppie.Internal exposing (ResultOption(..))
import Croppie.ResultOptions as ResultOptions
import Expect exposing (FloatingPointTolerance(..))
import Fuzz exposing (Fuzzer, bool, int , string)
import Json.Decode as Decode
import Test exposing (..)
import Utils exposing (..)


resultOptions : Test
resultOptions =
    describe "Tests of Croppie.ResultOptions"
        [ fuzz type_ "type_ has Encode.Value" <|
            \randomGeneratedType ->
                ResultOptions.type_ randomGeneratedType
                    |> \(ResultOption resultOption) ->
                        Expect.all
                            [ \opt -> Expect.equal "type" (Tuple.first opt)
                            , \opt ->
                                equalJson
                                    ( case randomGeneratedType of
                                        ResultOptions.Base64 ->
                                            "base64"
                                        
                                        ResultOptions.Canvas ->
                                            "canvas"
                                        
                                        ResultOptions.Html ->
                                            "html"
                                    )
                                    Decode.string
                                    (Tuple.second opt)
                            ]
                            resultOption
        , fuzz size "size has Encode.Value" <|
            \randomGeneratedSize ->
                ResultOptions.size randomGeneratedSize
                    |> \(ResultOption resultOption) ->
                        Expect.all
                            [ \opt -> Expect.equal "size" (Tuple.first opt)
                            , \opt ->
                                case randomGeneratedSize of
                                    ResultOptions.Viewport ->
                                        equalJson "viewport" Decode.string (Tuple.second opt)

                                    ResultOptions.Original ->
                                        equalJson "original" Decode.string (Tuple.second opt)
    
                                    ResultOptions.Custom { width, height } ->
                                        Expect.all
                                            [ \opt_ -> equalJson width (Decode.at [ "width" ] <| Decode.nullable Decode.int) opt_
                                            , \opt_ -> equalJson height (Decode.at [ "height" ] <| Decode.nullable Decode.int) opt_
                                            ]
                                            (Tuple.second opt)
                            ]
                            resultOption
        , fuzz format "format has Encode.Value" <|
            \randomGeneratedFormat ->
                ResultOptions.format randomGeneratedFormat
                    |> \(ResultOption resultOption) ->
                        Expect.all
                            [ \opt -> Expect.equal "format" (Tuple.first opt)
                            , \opt ->
                                equalJson
                                    ( case randomGeneratedFormat of
                                        ResultOptions.Jpeg ->
                                            "jpeg"
                                        
                                        ResultOptions.Png ->
                                            "png"

                                        ResultOptions.Webp ->
                                            "webp"
                                    )
                                    Decode.string
                                    (Tuple.second opt)
                            ]
                            resultOption
        , fuzz bool "circle has Encode.Value" <|
            \randomGeneratedBool ->
                ResultOptions.circle randomGeneratedBool
                    |> \(ResultOption resultOption) ->
                        Expect.all
                            [ \opt -> Expect.equal "circle" (Tuple.first opt)
                            , \opt -> equalJson randomGeneratedBool Decode.bool (Tuple.second opt)
                            ]
                            resultOption
        ]


type_ : Fuzzer ResultOptions.Type
type_ =
    Fuzz.oneOf
        [ Fuzz.constant ResultOptions.Base64
        , Fuzz.constant ResultOptions.Canvas
        , Fuzz.constant ResultOptions.Html
        ]


size : Fuzzer ResultOptions.Size
size =
    Fuzz.oneOf
        [ Fuzz.constant ResultOptions.Viewport
        , Fuzz.constant ResultOptions.Original
        , Fuzz.map2
            ( \h w ->
                ResultOptions.Custom { width = w, height = h }
            )
            ( Fuzz.maybe Fuzz.int )
            ( Fuzz.maybe Fuzz.int )
        ]


format : Fuzzer ResultOptions.Format
format =
    Fuzz.oneOf
        [ Fuzz.constant ResultOptions.Jpeg
        , Fuzz.constant ResultOptions.Png
        , Fuzz.constant ResultOptions.Webp
        ]