module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import App


all : Test
all =
    describe "The shopping cart"
        [ test "" <|
            \() ->
                
        , test "Adding fruits to the basket" <|
            \() ->
                Expect.equal 10 (3 + 7)
        , test "String.left" <|
            \() ->
                Expect.equal "a" (String.left 1 "abcdefg")
        , test "This test should fail" <|
            \() ->
                Expect.fail "failed as expected!"
        ]
