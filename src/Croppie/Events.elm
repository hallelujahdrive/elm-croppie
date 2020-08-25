module Croppie.Events exposing
    ( onGet
    , onResult
    , onUpdate
    )

{-|
    type alias Model =
        { cropData : CropData
        , result : String
        }

    type Msg
        = GotCropData CropData
        | GotResult String

    view =
        Croppie.croppie
            []
            [ id "events-example"
            , onUpdate GotCropData
            , onGet GotCropData
            , onResult GotResult
            ]
    
    update msg model =
        case msg of
            GotCropData cropData ->
                ( { model | cropData = cropData }
                , Cmd.none
                )
            GorResult url ->
                ( { model | result = url }
                , Cmd.none
                )    

# Events
@docs onUpdate

# Receive function callbacks
@docs onGet
@docs onResult

-}

import Croppie exposing (CropData, Result(..))
import Croppie.Internal as Internal
import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Html.Events as Events
import Json.Decode as Decode exposing (Decoder, field)
import Parser exposing (Parser, Step(..), (|=), (|.), backtrackable, loop, oneOf, spaces, symbol)
import Set


{-| Detect update evnents. Update events trigged when a drag or zoom occurs
-}
onUpdate : (CropData -> msg) -> Html.Attribute msg
onUpdate handler =
    Events.on "update" <| Decode.map handler (field "detail" Internal.cropDataDecoder)


{-| Receive get callbacks
-}
onGet : (CropData -> msg) -> Html.Attribute msg
onGet handler =
    Events.on "get" <| Decode.map handler (field "detail" Internal.cropDataDecoder)


{-| Receive result callbacks
-}
onResult : (Result msg -> msg) -> Html.Attribute msg
onResult handler =
    Events.on "result" <| Decode.map handler resultDecoder


resultDecoder : Decoder (Result msg)
resultDecoder =
    let
        decodeHelper type_ value =
            case type_ of
                "base64" ->
                    Croppie.Base64 value
                
                "html" ->
                    case Parser.run nodeParser value of
                        Ok nodes ->
                            Croppie.Html nodes

                        Err _ ->
                            Croppie.Html <|
                                Html.div [] []
                
                _ ->
                    Croppie.Canvas value
            
    in
    Decode.map2 decodeHelper
        (field "type" Decode.string)
        (field "value" Decode.string)
        |> field "detail"


nodesParser : Parser (List (Html msg))
nodesParser =
    loop [] nodesHelp


nodesHelp : List (Html msg) -> Parser (Step (List (Html msg)) (List (Html msg)))
nodesHelp nodes =
    oneOf
        [ Parser.succeed (\node -> Loop (node :: nodes))
            |= backtrackable nodeParser
        , Parser.succeed ()
            |> Parser.map (\_ -> Done nodes)
        ]
        

nodeParser : Parser (Html msg)
nodeParser =
    Parser.succeed Html.node
        |. symbol "<"
        |= var
        |. spaces
        |= attributesParser
        |. spaces
        |. symbol ">"
        |= nodesParser
        |. oneOf
            [ Parser.succeed ()
                |. symbol "</"
                |. var
                |. symbol ">"
            , spaces
            ]
    

attributesParser : Parser (List (Html.Attribute msg))
attributesParser =
    loop [] attributesHelp


attributesHelp : List (Html.Attribute msg) -> Parser (Step (List (Html.Attribute msg)) (List (Html.Attribute msg)))
attributesHelp attrs =
    oneOf
        [ Parser.succeed (\attr -> Loop (attr :: attrs))
            |. spaces
            |= attributeParser
        , Parser.succeed ()
            |> Parser.map (\_ -> Done attrs)
        ]


attributeParser : Parser (Html.Attribute msg)
attributeParser =
    Parser.succeed attribute
        |= var
        |. symbol "="
        |. symbol "\""
        |= attrVal
        |. symbol "\""


var : Parser String
var =
    Parser.variable
        { start = Char.isAlphaNum
        , inner = \c -> Char.isAlphaNum c || c == '-'
        , reserved = Set.empty
        }


attrVal : Parser String
attrVal =
    Parser.variable
        { start = Char.isAlphaNum
        , inner = \c -> Char.isAlphaNum c || List.member c ['-', ':', ';', '/', '.', ' ']
        , reserved = Set.empty
        }