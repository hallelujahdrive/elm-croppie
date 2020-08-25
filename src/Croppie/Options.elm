module Croppie.Options exposing
    ( CropType(..)
    , MouseWheelZoom(..)
    , boundary
    , customClass
    , enableExif
    , enableOrientation
    , enableResize
    , enableZoom
    , enforceBoundary
    , mouseWheelZoom
    , showZoomer
    , viewport
    )

{-| Options to inirialize Croppie

See [Croppie.croppie](/packages/hallelujahdrive/elm-croppie/1.0.0/Croppie#croppie) for usage.

# Boundary
@docs boundary

# Custom Class
@docs customClass

# Exif
@docs enableExif

# Orientation
@docs enableOrientation

# Resize
@docs enableResize

# Zoom
@docs enableZoom

# Enforce Boundary
@docs enforceBoundary

# Mouse wheel zoom
@docs mouseWheelZoom, MouseWheelZoom

# Show Zoomer
@docs showZoomer

# Viewport
@docs viewport, CropType
-}

import Croppie.Internal exposing (Option(..))
import Json.Encode as Encode


type alias Boundary =
    { width : Int
    , height : Int
    }


type alias Viewport =
    { width : Int
    , height : Int
    , type_ : CropType
    }


{-| Viewport shape
-}
type CropType
    = Circle
    | Square


{-| Mouse wheel zoom type
-}
type MouseWheelZoom
    = Enabled
    | Disabled
    | Ctrl


{-| The outer container of the cropper

Default: `will default to the size of the container`
-}
boundary :
    { width : Int
    , height : Int
    }
    -> Option
boundary boundary_ =
    Option ( "boundary", encodeBoundary boundary_ )


{-| A class of your choosing to add to the container to add custom styles to your croppie
-}
customClass : String -> Option
customClass customClass_ =
    Option ( "customClass", Encode.string customClass_ )


{-| Enable exif orientation reading. Tells Croppie to read exif orientation from the image data and orient the image correctly before rendering to the page.
Requires [exif.js](https://github.com/exif-js/exif-js)
-}
enableExif : Bool -> Option
enableExif enableExif_ =
    Option ( "enableExif", Encode.bool enableExif_ )


{-| Enable or disable support for specifying a custom orientation when binding images (See `Croppie.bind`)
-}
enableOrientation : Bool -> Option
enableOrientation enableOrientation_ =
    Option ( "enableOrientation", Encode.bool enableOrientation_ )


{-| Enable or disable support for resizing the viewport area.
-}
enableResize : Bool -> Option
enableResize enableResize_ =
    Option ( "enableResize", Encode.bool enableResize_ )


{-| Enable zooming functionality. If set to false - scrolling and pinching would not zoom.
-}
enableZoom : Bool -> Option
enableZoom enableZoom_ =
    Option ( "enableZoom", Encode.bool enableZoom_ )


{-| Restricts zoom so image cannot be smaller than viewport
-}
enforceBoundary : Bool -> Option
enforceBoundary enforceBoundary_ =
    Option ( "enforceBoundary", Encode.bool enforceBoundary_ )


{-| Enable or disable the ability to use the mouse wheel to zoom in and out on a croppie instance. 
If `Ctrl` is passed mouse wheel will only work while control keyboard is pressed
-}
mouseWheelZoom : MouseWheelZoom -> Option
mouseWheelZoom mouseWheelZoom_ =
    Option
        ( "mouseWheelZoom"
        , case mouseWheelZoom_ of
            Ctrl ->
                Encode.string "ctrl"
            
            Disabled ->
                Encode.bool False
            
            Enabled ->
                Encode.bool True
        )


{-| Hide or Show the zoom slider
-}
showZoomer : Bool -> Option
showZoomer showZoomer_ =
    Option ( "showZoomer", Encode.bool showZoomer_ )


{-| The inner container of the croppie, The visible part of the image

Default: `{ width = 100, height = 100, type_ : Square }`
-}
viewport :
    { width : Int
    , height : Int
    , type_ : CropType
    }
    -> Option
viewport viewport_ =
    Option ( "viewport", encodeViewport viewport_ )


encodeBoundary : Boundary -> Encode.Value
encodeBoundary { width, height } =
    Encode.object
        [ ( "width", Encode.int width )
        , ( "height", Encode.int height )
        ]


encodeViewport : Viewport -> Encode.Value
encodeViewport { width, height, type_ } =
    Encode.object
        [ ( "width", Encode.int width )
        , ( "height", Encode.int height )
        , ( "type"
          , Encode.string <|
                if type_ == Circle then
                    "circle"

                else
                    "square"
          )
        ]
