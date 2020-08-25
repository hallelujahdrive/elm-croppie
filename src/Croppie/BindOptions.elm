module Croppie.BindOptions exposing
    ( orientation
    , points
    , url
    , zoom
    )

{-| Options of binding an image.

See [Croppie.bind](/packages/hallelujahdrive/elm-croppie/1.0.0/Croppie#bind) for usage.

# Bind Options
@docs url
@docs points
@docs zoom
@docs orientation

-}

import Croppie
import Croppie.Internal exposing (BindOption(..))
import Json.Encode as Encode


{-| Url to image
-}
url : String -> Croppie.BindOption
url url_ =
    BindOption ( "url", Encode.string url_ )


{-| Array of points that translate into `[topLeftX, topLeftY, bottomRightX, bottomRightY]`
-}
points : List Int -> Croppie.BindOption
points points_ =
    BindOption ( "points", Encode.list Encode.int points_ )


{-| Apply zoom after image has been bound
-}
zoom : Float -> Croppie.BindOption
zoom zoom_ =
    BindOption ( "zoom", Encode.float zoom_ )


{-|  Custom orientation, applied after exif orientation (if enabled). 
Only works with enableOrientation option enabled 
(see [Croppie.Options.enableOrientation](/packages/hallelujahdrive/elm-croppie/1.0.0/Croppie-Options#enableOrientation)).

Valid options are:

`1` unchanged

`2` flipped horizontally

`3` rotated 180 degrees

`4` flipped vertically

`5` flipped hozirontally. then rotated left by 90 degrees

`6` rotated clockwise by 90 degrees

`7` flipped horizontally, then rotated right by 90 degrees

`8` rotated counter-clockwise by 90 degrees

-}
orientation : Int -> Croppie.BindOption
orientation orientation_ =
    BindOption ( "orientation", Encode.int orientation_ )

