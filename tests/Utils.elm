module Utils exposing (..)

import Expect exposing (FloatingPointTolerance(..), Expectation)
import Json.Decode as Decode exposing (Decoder, decodeValue, errorToString)
import Json.Encode as Encode


equalJson : a -> (Decoder a) -> Encode.Value -> Expectation
equalJson a decoder value =
    case decodeValue decoder value of
        Ok value_ ->
            Expect.equal value_ a
        Err err ->
            Expect.fail (errorToString err)


equalFloatJson : Float -> Encode.Value -> Expectation
equalFloatJson f value =
    case decodeValue Decode.float value of
        Ok value_ ->
            Expect.within (Absolute 0.000000001) value_ f
            
        Err err ->
            Expect.fail (errorToString err)