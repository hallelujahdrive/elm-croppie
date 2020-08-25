module Croppie exposing
    ( BindOption
    , CropData
    , Data
    , Option
    , ResultOption
    , Result(..)
    , bind
    , croppie
    , get
    , result
    , rotate
    , setZoom
    )

{-|

# Datas

To execute the instance method of Croppie, send Data via port as shown below.

    port croppie : Croppie.Data -> Cmd msg

    view =
        Croppie.croppie [] [ id "example" ]

    get =
        croppie <|
            Croppie.get "example"

    bind =
        croppie <|
            Croppie.bind "example" bindOptions

    result =
        croppie <|
            Croppie.result "example" resultOptions

    rotate =
        croppie <|
            Croppie.rotate "example" degrees

    setZoom =
        croppie <|
            Croppie.setZoom "example" value

@docs get, bind, result, rotate, setZoom
@docs Data

# Croppie
@docs croppie

# Options
@docs Option, BindOption, ResultOption

# CropData
@docs CropData

# Result of Cropped image
@docs Result

-}

import Croppie.Internal as Internal exposing (BindOption(..), Option(..))
import Html exposing (Html)
import Html.Attributes exposing (property, style)
import Html.Lazy exposing (lazy3)
import Json.Encode as Encode


{-| The crop points and the zoom of the image.
-}
type alias CropData =
    { orientation : Int
    , points : List Int
    , zoom : Float
    }


{-| Data to communicate via port
-}
type alias Data =
    Internal.Data


{-| Option of Croppie

Learn more in the [Croppie.Options](/packages/hallelujahdrive/elm-croppie/1.0.0/Croppie-Options) module.
-}
type alias Option =
    Internal.Option


{-| Option of bind an image

Learn more in the [Croppie.BindOptions](/packages/hallelujahdrive/elm-croppie/1.0.0/Croppie-BindOptions) module.
-}
type alias BindOption =
    Internal.BindOption


{-| Option of to get the resulting crop of image

 Learn more in the [Croppie.ResultOptions](/packages/hallelujahdrive/elm-croppie/1.0.0/Croppie-ResultOptions) module.
-}
type alias ResultOption =
    Internal.ResultOption


{-| The result of cropping the image.
-}
type Result msg
    = Base64 String
    | Canvas String
    | Html (Html msg)


{-| Get the crop points, and the zoom of the image.

The return value can be received with [Croppie.Events.onGet](/packages/hallelujahdrive/elm-croppie/1.0.0/Croppie-Events#onGet)

- `id ` id of the target Croppie element

-}
get : String-> Data
get id =
    { id = id
    , method  = "get"
    , value = Encode.null
    }

{-| Bind an image to the croppie.

- `id ` id of the target Croppie element
- `bindOptions` List of bind options 
(see [Croppie.BindOptions](/packages/hallelujahdrive/elm-croppie/1.0.0/Croppie-BindOptions)).


-}
bind : String -> List BindOption -> Data
bind id options =
    { id = id
    , method = "bind"
    , value = encodeBindOptions options
    }


{-| Get the resulting crop of the image.

The return value can be received with [Croppie.Events.onResult](/packages/hallelujahdrive/elm-croppie/1.0.0/Croppie-Events#onResult).

- `id ` id of the target Croppie element
- `resultOptions` List of result options. 
See [Croppie.ResultOptions](/packages/hallelujahdrive/elm-croppie/1.0.0/Croppie-ResultOptions) for list of options

-}
result : String -> List ResultOption -> Data
result id options =
    { id = id
    , method = "result"
    , value = encodeResultOptions options
    }


{-| Rotate the image by a specified degree amount. 
Only works with `enableOrientation` option enabled 
(see [Croppie.Options.enableOrientation](/packages/hallelujahdrive/elm-croppie/1.0.0/Croppie-Options#enableOrientation)).

- `id ` id of the target Croppie element
- `degrees` rotation angle

    Valid Values: `90, 180, 270, -90, -180, -270`

-}
rotate : String -> Int -> Data
rotate id degrees =
    { id = id
    , method = "rotate"
    , value = Encode.int degrees
    }


{-| Set the zoom of a Croppie instance. 
The value passed in is still restricted to the min/max set by Croppie.

- `id ` id of the target Croppie element
- `value` a floating point to scale the image within the croppie. 
Must be between a min and max value set by croppie.

-}
setZoom : String -> Float -> Data
setZoom id value =
    { id = id
    , method = "setZoom"
    , value = Encode.float value
    }


{-| Croppie view function. 

-}
croppie : List Option -> List (Html.Attribute msg) -> Html msg
croppie options attributes =
    lazy3 Html.node
        "elm-croppie"
        ( [ displayAttr
          , optionsProp options
          ]
        ++ attributes
        )
        []


displayAttr : Html.Attribute msg
displayAttr =
    style "display" "block"


optionsProp : List Internal.Option -> Html.Attribute msg
optionsProp options =
    property "options" (encodeOptions options)


encodeOptions : List Internal.Option -> Encode.Value
encodeOptions options =
    let
        options_ =
            List.map Internal.optionToValue options
    in
    Encode.object options_


encodeBindOptions : List Internal.BindOption -> Encode.Value
encodeBindOptions bindOptions =
    let
        bindOptions_ =
            List.map Internal.bindOptionToValue bindOptions
    in
    Encode.object bindOptions_


encodeResultOptions : List Internal.ResultOption -> Encode.Value
encodeResultOptions resultOptions =
    let
        resultOptions_ =
            List.map Internal.resultOptionToValue resultOptions
    in
    Encode.object resultOptions_