module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import App exposing (init)


all : Test
all =
    describe "The shopping cart"
        [ test "Adding apple to cart" <|
            \() ->
                case List.head init.availableFruit of
                    Just apple ->
                        init
                            |> App.update (App.AddToCart apple)
                            |> .cart
                            |> Expect.equal
                                [ { name = "Apple"
                                  , picture = "http://i.imgur.com/MxLIWN9.png"
                                  , price = 25
                                  , discount = Nothing
                                  , count = 1
                                  }
                                ]

                    Nothing ->
                        Expect.fail "The list of initially available fruits is empty"
        ]
