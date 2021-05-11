module Tests exposing (..)

import Expect
import Main exposing (..)
import Platform.Cmd exposing (none)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector



-- Check out https://package.elm-lang.org/packages/elm-explorations/test/latest to learn more about testing in Elm!


all : Test
all =
    describe "The main module" <|
        let
            me =
                User 1 "fuckoffman"
        in
        [ describe "chatForm"
            [ test "フォームに'abc'と入力すると、UpdateContent 'abc' のMsgが発行される" <|
                \_ ->
                    inputChat
                        |> Query.fromHtml
                        |> Query.find [ Selector.tag "input" ]
                        |> Event.simulate (Event.input "abc")
                        |> Event.expect (UpdateContent "abc")
            , test "SENDボタンを押したら、SendChat Msgが発行される" <|
                \_ ->
                    inputChat
                        |> Query.fromHtml
                        |> Query.find [ Selector.tag "button" ]
                        |> Event.simulate Event.click
                        |> Event.expect SendChat
            ]
        , describe "mediaView" <|
            let
                james =
                    User 2 "James Brown"

                jamesChat =
                    chat me <| Message "unko" james

                myChat =
                    chat me <| Message "fuck" me
            in
            [ test "コメントしたのは、「James Brown」" <|
                \_ ->
                    jamesChat
                        |> Query.fromHtml
                        |> Query.find [ Selector.class "media-author" ]
                        |> Query.has [ Selector.text "James Brown" ]
            , test "コメント内容、「unko」" <|
                \_ ->
                    jamesChat
                        |> Query.fromHtml
                        |> Query.find [ Selector.class "media-body" ]
                        |> Query.has [ Selector.text "unko" ]
            , test "自分のコメントの場合、右に名前が表示される" <|
                \_ ->
                    myChat
                        |> Query.fromHtml
                        |> Query.children [ Selector.class "chat" ]
                        |> Query.index 1
                        |> Query.has [ Selector.text "fuckoffman" ]
            , test "他社のコメントの場合、左に名前が表示される" <|
                \_ ->
                    jamesChat
                        |> Query.fromHtml
                        |> Query.children [ Selector.class "chat" ]
                        |> Query.index 0
                        |> Query.has [ Selector.text "James Brown" ]
            ]
        ]
