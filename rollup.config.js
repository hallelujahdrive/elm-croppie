import commonjs from "@rollup/plugin-commonjs";
import { nodeResolve } from "@rollup/plugin-node-resolve";
import { terser } from "rollup-plugin-terser";
import typescript from "@rollup/plugin-typescript";

export default {
    input: "./src/elm-croppie.ts",
    output: [
        {
            file: "./dist/elm-croppie.commin.js",
            format: "cjs",
            exports: "default",
            name: "ElmCroppie"
        },
        {
            file: "./dist/elm-croppie.esm.js",
            format:"esm",
            name: "ElmCroppie"
        },
        {
            file: "./dist/elm-croppie.js",
            format: "iife",
            name: "ElmCroppie"
        }
    ],
    plugins: [
        commonjs(),
        nodeResolve(),
        typescript({
            lib: ["es5", "dom"]
        }),
        terser()
    ]
}
