module Croppie.ResultOptions exposing
    ( Format(..)
    , Size(..)
    , Type(..)
    , circle
    , format
    , quality
    , size
    , type_
    )

{-| Options of Result

See [Croppie.result](/packages/hallelujahdrive/elm-croppie/1.0.0/Croppie#result) for usage.

# Type
@docs type_, Type

# Size
@docs size, Size

# Format
@docs format, Format

# Quarity
@docs quality

# Circle
@docs circle

-}

import Croppie
import Croppie.Internal exposing (ResultOption(..))
import Json.Encode as Encode


{-| Type of result type
-}
type Type
    = Base64
    | Canvas
    | Html


{-| Size type
-}
type Size
    = Viewport
    | Original
    | Custom { width : Maybe Int, height : Maybe Int }


{-| Type of result format
-}
type Format
    = Jpeg
    | Png
    | Webp


{-| The type of result to return defaults to `Canvas`
-}
type_ : Type -> Croppie.ResultOption
type_ resultType =
    ResultOption
        ( "type"
        , Encode.string <|
            case resultType of
                Base64 -> "base64"

                Canvas -> "canvas"

                Html -> "html"
        )


{-| The size of the cropped image defaults to `Viewport`
-}
size : Size -> Croppie.ResultOption
size size_ =
    let
        value_ =
            case size_ of
                Viewport ->
                    Encode.string "viewport"

                Original ->
                    Encode.string "original"

                Custom { width, height } ->
                    Encode.object
                        [ ( "width", nullable Encode.int width )
                        , ( "height", nullable Encode.int height )
                        ]
    in
    ResultOption ( "size", value_ )


{-| Indicating the image format. 

If you do not specify a format, the default is `Png`
-}
format : Format -> Croppie.ResultOption
format format_ =
    let
        value_ =
            case format_ of
                Jpeg ->
                    Encode.string "jpeg"

                Png ->
                    Encode.string "png"

                Webp ->
                    Encode.string "webp"
    in
    ResultOption ( "format", value_ )


{-| Number between `0` and `1` indicating image quarity.
-}
quality : Float -> Croppie.ResultOption
quality quarity_ =
    ResultOption ( "quality", Encode.float quarity_ )


{-| Force the result to be cropped into a circle.
-}
circle : Bool -> Croppie.ResultOption
circle circle_ =
    ResultOption ( "circle", Encode.bool circle_ )


nullable : (a -> Encode.Value) -> Maybe a -> Encode.Value
nullable encoder value =
    case value of
        Just v ->
            encoder v
        
        _ ->
            Encode.null