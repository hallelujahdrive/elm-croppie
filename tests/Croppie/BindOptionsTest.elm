module Croppie.BindOptionsTest exposing (..)

import Croppie.Internal exposing (BindOption(..))
import Croppie.BindOptions as BindOptions
import Expect exposing (FloatingPointTolerance(..))
import Fuzz exposing (float, int, list, string)
import Json.Decode as Decode
import Test exposing (..)
import Utils exposing (..)


bindOptions : Test
bindOptions =
    describe "Tests of Croppie.BindOptions"
        [ fuzz string "url has Encode.Value" <|
            \randomGeneratedString ->
                BindOptions.url randomGeneratedString
                    |> \(BindOption bindOption) ->
                        Expect.all
                            [ \opt -> Expect.equal "url" (Tuple.first opt)
                            , \opt -> equalJson randomGeneratedString Decode.string (Tuple.second opt)
                            ]
                            bindOption
        , fuzz (list int) "points has Encode.Value" <|
            \randomGeneratedList ->
                BindOptions.points randomGeneratedList
                    |> \(BindOption bindOption) ->
                        Expect.all
                            [ \opt -> Expect.equal "points" (Tuple.first opt)
                            , \opt -> equalJson randomGeneratedList (Decode.list Decode.int) (Tuple.second opt)
                            ]
                            bindOption
        , fuzz float "zoom has Encode.Value" <|
            \randomGeneratedFloat ->
                BindOptions.zoom randomGeneratedFloat
                    |> \(BindOption bindOption) ->
                        Expect.all
                            [ \opt -> Expect.equal "zoom" (Tuple.first opt)
                            , \opt -> equalFloatJson randomGeneratedFloat (Tuple.second opt)
                            ]
                            bindOption
        , fuzz int "orientation has Encode.Value" <|
            \randomGeneratedInt ->
                BindOptions.orientation randomGeneratedInt
                    |> \(BindOption bindOption) ->
                        Expect.all
                            [ \opt -> Expect.equal "orientation" (Tuple.first opt)
                            , \opt -> equalJson randomGeneratedInt Decode.int (Tuple.second opt)
                            ]
                            bindOption
        ]