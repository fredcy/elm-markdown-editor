module Main (..) where

import Html
import Html.Attributes
import Html.Events
import Markdown
import Task
import Effects
import StartApp


type alias Model = {
    text : String
  }



init : ( Model, Effects.Effects Action )
init =
  ( Model "initial text", Effects.none )


type Action
  = NoOp
  | ModifyText String
    

update : Action -> Model -> ( Model, Effects.Effects Action )
update action model =
  case action of
    NoOp ->
      ( model, Effects.none )

    ModifyText str ->
      ( { model | text = str }, Effects.none )


view : Signal.Address Action -> Model -> Html.Html
view address model =
  Html.div
    []
    [ Html.h1 [] [ Html.text "Markdown editor" ]
    , Html.textarea [ Html.Attributes.value model.text
                    , Html.Events.on "input" Html.Events.targetValue (Signal.message address << ModifyText) ] []
    , Html.h2 [] [ Html.text "Result" ]
    , Html.div [ ] [ Markdown.toHtml model.text ]
    ]


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }


port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks


main : Signal Html.Html
main =
  app.html
