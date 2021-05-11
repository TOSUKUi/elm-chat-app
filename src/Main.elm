module Main exposing (..)

import Browser
import Html exposing (Html, button, div, form, h1, img, input, text, textarea)
import Html.Attributes exposing (class, placeholder, src, type_)
import Html.Events exposing (onClick, onInput, onSubmit)
import List exposing (head, length, map, tail)



---- MODEL ----


type alias Message =
    { body : String, author : User }


type alias User =
    { uid : Int, name : String }


type alias Model =
    { messages : List Message, content : String, me : User }


init : ( Model, Cmd Msg )
init =
    ( { messages =
            [ Message "unko" (User 1 "takesi")
            , Message "unko" (User 1 "takesi")
            , Message "unko" (User 2 "shit")
            ]
      , content = ""
      , me = User 2 "shit"
      }
    , Cmd.none
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateContent c ->
            ( { model | content = c }, Cmd.none )

        SendChat ->
            if String.isEmpty (String.trim model.content) then
                ( model, Cmd.none )

            else
                ( { model | content = "", messages = model.messages ++ [ Message model.content model.me ] }, Cmd.none )


type Msg
    = UpdateContent String
    | SendChat



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "card p-1" ]
            [ div [ class "card-header" ]
                [ text "Super Chat tool 2077" ]
            , div
                [ class "card-body" ]
              <|
                chats model.me model.messages
            , inputChat
            ]
        ]


chat : User -> Message -> Html Msg
chat me message =
    div [ class "card mb-1 p-2" ]
        [ div [ class "row g-0 media" ] <|
            if message.author == me then
                [ div [ class "d-flex col-md-8 chat media-body" ]
                    [ text message.body ]
                , div
                    [ class "d-flex col-md-4 chat media-author" ]
                    [ text message.author.name ]
                ]

            else
                [ div
                    [ class "d-flex col-md-4 chat media-author" ]
                    [ text message.author.name ]
                , div [ class "d-flex col-md-8 chat media-body" ]
                    [ text message.body ]
                ]
        ]


chats : User -> List Message -> List (Html Msg)
chats me messages =
    map (chat me) messages


inputChat : Html Msg
inputChat =
    form [ class "form-group" ]
        [ input [ class "form-control", type_ "textarea", placeholder "Comment", onInput UpdateContent ] []
        , button [ class "btn btn-primary", onClick SendChat ] [ text "SEND" ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
