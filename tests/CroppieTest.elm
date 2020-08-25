module CroppieTest exposing (..)

import Croppie
import Expect exposing (FloatingPointTolerance(..))
import Fuzz exposing (Fuzzer, int, string)
import Json.Decode as Decode
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (style, tag)
import Utils exposing (..)


croppie : Test
croppie =
    describe "Tests of Croppie node"
        [ test "Croppie has the expectd class" <|
            \_ ->
                Croppie.croppie [] []
                    |> Query.fromHtml
                    |> Query.has
                        [ style "display" "block"
                        , tag "elm-croppie"
                        ]
        ]
 

datas : Test
datas =
    describe "Tests of Croppie datas"
        [ fuzz string "get outputs Decode.Value" <|
            \randomlyGeneratedString ->
                Croppie.get randomlyGeneratedString
                    |> Expect.all
                        [ \data -> Expect.equal "get" data.method
                        , \data -> Expect.equal randomlyGeneratedString data.id
                        ]
        , fuzz string "bind outputs Decode.Value" <|
            \randomlyGeneratedString ->
                Croppie.bind randomlyGeneratedString []
                    |> Expect.all
                        [ \data -> Expect.equal "bind" data.method
                        , \data -> Expect.equal randomlyGeneratedString data.id
                        ]
        , fuzz string "result outputs Decode.Value" <|
            \randomlyGeneratedString ->
                Croppie.result randomlyGeneratedString []
                    |> Expect.all
                        [ \data -> Expect.equal "result" data.method
                        , \data -> Expect.equal randomlyGeneratedString data.id
                        ]
        , fuzz rotateData "rotate outputs Decode.Value" <|
            \(randomlyGeneratedString, randomlyGeneratedInt) ->
                Croppie.rotate randomlyGeneratedString randomlyGeneratedInt
                    |> Expect.all
                        [ \data -> Expect.equal "rotate" data.method
                        , \data -> Expect.equal randomlyGeneratedString data.id
                        , \data -> equalJson randomlyGeneratedInt Decode.int data.value
                        ]
        , fuzz setZoomData "setZoom outputs Decode.Value" <|
            \(randomlyGeneratedString, randomlyGeneratedFloat) ->
                Croppie.setZoom randomlyGeneratedString randomlyGeneratedFloat
                    |> Expect.all
                        [ \data -> Expect.equal "setZoom" data.method
                        , \data -> Expect.equal randomlyGeneratedString data.id
                        , \data -> equalFloatJson randomlyGeneratedFloat data.value
                        ]
        ]


boundary : Fuzzer (Int, Int)
boundary =
    Fuzz.map2 (\a b -> (a, b)) Fuzz.int Fuzz.int


rotateData : Fuzzer (String, Int)
rotateData =
    Fuzz.map2 (\a b -> (a, b)) Fuzz.string Fuzz.int


setZoomData : Fuzzer (String, Float)
setZoomData =
    Fuzz.map2 (\a b -> (a, b)) Fuzz.string Fuzz.float