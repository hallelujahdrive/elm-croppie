module Croppie.Internal exposing
    ( CropData
    , Data
    , BindOption(..)
    , Option(..)
    , ResultOption(..)
    , bindOptionToValue
    , cropDataDecoder
    , optionToValue
    , resultOptionToValue
    )

import Json.Decode as Decode
import Json.Encode as Encode


type alias CropData =
    { orientation : Int
    , points : List Int
    , zoom : Float
    }

type alias Data =
    { id : String
    , method : String
    , value : Encode.Value
    }


type BindOption
    = BindOption ( String, Encode.Value )


type Option
    = Option ( String, Encode.Value )


type ResultOption
    = ResultOption ( String, Encode.Value )


optionToValue : Option -> ( String, Encode.Value )
optionToValue (Option option_) =
    option_


bindOptionToValue : BindOption -> ( String, Encode.Value )
bindOptionToValue (BindOption bindOption_) =
    bindOption_


resultOptionToValue : ResultOption -> ( String, Encode.Value )
resultOptionToValue (ResultOption resultOption_) =
    resultOption_


cropDataDecoder : Decode.Decoder CropData
cropDataDecoder =
    Decode.map3 CropData
        (Decode.field "orientation" Decode.int)
        (Decode.field "points" pointsDecoder)
        (Decode.field "zoom" Decode.float)


pointsDecoder : Decode.Decoder (List Int)
pointsDecoder =
    Decode.map (String.toInt >> Maybe.withDefault 0) Decode.string
        |> Decode.list
