module App exposing (..)

import Html
    exposing
        ( Html
        , text
        , div
        , img
        , section
        , h1
        , h2
        , a
        , p
        , article
        , figure
        , table
        , thead
        , tr
        , td
        , th
        )
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import String exposing (dropRight, right, padLeft)


---- MODEL ----


type alias Count =
    Int


type alias Price =
    Int


formatPrice : Price -> String
formatPrice price =
    let
        s =
            toString price
    in
        (s
            |> dropRight 2
            |> padLeft 1 '0'
        )
            ++ "."
            ++ (s
                    |> right 2
                    |> padLeft 2 '0'
               )
            ++ " $"


type alias Multiple a =
    { a | count : Count }


type alias Fruit =
    { name : String
    , picture : String
    , price : Price
    , discount : Maybe ( String, Count -> Price -> Maybe Price )
    }


type alias Fruits =
    Multiple Fruit


type alias Model =
    { availableFruit : List Fruit
    , cart : List Fruits
    }


init : Model
init =
    Model
        [ Fruit
            "Apple"
            "http://i.imgur.com/MxLIWN9.png"
            25
            Nothing
        , Fruit
            "Orange"
            "http://i.imgur.com/ichM2Mo.png"
            30
            Nothing
        , Fruit
            "Banana"
            "http://i.imgur.com/t4hxTmi.png"
            15
            Nothing
        , Fruit
            "Papaya"
            "http://i.imgur.com/L99sMfH.png"
            50
            (Just
                ( "Three for the price of two"
                , \count price ->
                    let
                        d =
                            (count // 3) * price
                    in
                        if d > 0 then
                            Just d
                        else
                            Nothing
                )
            )
        ]
        []



---- UPDATE ----


type Msg
    = AddToCart Fruit
    | RemoveFromCart Fruits


addFruitToCart : Fruit -> List Fruits -> List Fruits
addFruitToCart fruit cart =
    if List.any (\i -> i.name == fruit.name) cart then
        List.map
            (\i ->
                if i.name == fruit.name then
                    { i | count = i.count + 1 }
                else
                    i
            )
            cart
    else
        let
            fruits : Fruits
            fruits =
                { name = fruit.name
                , price = fruit.price
                , picture = fruit.picture
                , discount = fruit.discount
                , count = 1
                }
        in
            fruits :: cart


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddToCart fruit ->
            { model | cart = addFruitToCart fruit model.cart }

        RemoveFromCart fruit ->
            { model
                | cart =
                    (if fruit.count > 1 then
                        model.cart
                            |> List.map
                                (\f ->
                                    if f == fruit then
                                        { f | count = f.count - 1 }
                                    else
                                        f
                                )
                     else
                        model.cart
                            |> List.filter
                                (\f ->
                                    f /= fruit
                                )
                    )
            }



---- VIEW ----


getDiscounts : List Fruits -> List ( Fruits, String, Price )
getDiscounts cart =
    cart
        |> List.filterMap
            (\fruit ->
                case fruit.discount of
                    Nothing ->
                        Nothing

                    Just ( description, fn ) ->
                        case fn fruit.count fruit.price of
                            Nothing ->
                                Nothing

                            Just amount ->
                                Just ( fruit, description, amount )
            )


view : Model -> Html Msg
view model =
    let
        discounts =
            getDiscounts model.cart

        total =
            (model.cart
                |> List.foldl
                    (\i sum ->
                        sum + i.count * i.price
                    )
                    0
            )
                - (discounts |> List.foldl (\( _, _, amount ) sum -> sum + amount) 0)
    in
        div []
            [ section [ class "hero is-dark" ]
                [ div [ class "hero-body" ]
                    [ div [ class "container" ]
                        [ h1 [ class "title" ] [ text "The Fruit Basket" ]
                        , h2 [ class "subtitle" ] [ text "Satisfying Your Fruit Cravings 24/7" ]
                        ]
                    ]
                ]
            , section [ class "section" ]
                [ div [ class "container" ]
                    [ div [ class "columns" ]
                        [ div [ class "column" ]
                            (model.availableFruit
                                |> List.map
                                    (\f ->
                                        div [ class "box" ]
                                            [ article [ class "media" ]
                                                [ div [ class "media-left" ]
                                                    [ figure [ class "image is-96x96" ]
                                                        [ img [ src f.picture ] [] ]
                                                    ]
                                                , div [ class "media-content" ]
                                                    [ div [ class "content" ]
                                                        ([ h2 [] [ text f.name ]
                                                         , p [ class "subtitle" ] [ text <| formatPrice f.price ]
                                                         ]
                                                            ++ (case f.discount of
                                                                    Just ( discount, _ ) ->
                                                                        [ div [ class "notification is-warning" ]
                                                                            [ text discount ]
                                                                        ]

                                                                    Nothing ->
                                                                        []
                                                               )
                                                        )
                                                    ]
                                                , div [ class "media-right" ]
                                                    [ a [ class "button is-primary", onClick <| AddToCart f ] [ text "Add to cart" ] ]
                                                ]
                                            ]
                                    )
                            )
                        , div [ class "column" ]
                            [ div [ class "content" ]
                                ([ h1 [] [ text "Cart" ]
                                 , table []
                                    ([ thead []
                                        [ th [] [ text "Item" ]
                                        , th [] [ text "Price" ]
                                        , th [] [ text "Qty" ]
                                        , th [] [ text "Total" ]
                                        , th [] []
                                        ]
                                     ]
                                        ++ (model.cart
                                                |> List.reverse
                                                |> List.map
                                                    (\item ->
                                                        tr []
                                                            [ td [] [ text item.name ]
                                                            , td [] [ text (formatPrice item.price) ]
                                                            , td [] [ text (toString item.count) ]
                                                            , td [] [ text (formatPrice <| item.price * item.count) ]
                                                            , td [] [ a [ class "button is-danger", onClick (RemoveFromCart item) ] [ text "remove" ] ]
                                                            ]
                                                    )
                                           )
                                    )
                                 ]
                                    ++ (if List.isEmpty discounts then
                                            []
                                        else
                                            [ h2 [] [ text "Discounts" ]
                                            , table []
                                                (discounts
                                                    |> List.map
                                                        (\( fruit, discount, amount ) ->
                                                            tr []
                                                                [ td [] [ text fruit.name ]
                                                                , td [] [ text discount ]
                                                                , td [] [ text (formatPrice amount) ]
                                                                ]
                                                        )
                                                )
                                            ]
                                       )
                                    ++ [ h2 [] [ text ("Total: " ++ formatPrice total) ] ]
                                )
                            ]
                        ]
                    ]
                ]
            ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { view = view
        , model = init
        , update = update
        }
