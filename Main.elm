module Main (..) where

import Html
import Html.Attributes as Html
import Html.Events as Html
import Markdown
import Task
import Effects
import StartApp


type alias Model =
  { text : String
  }


defaultText = """
# Markdown example

Put *text* here.

```elm
main =
  Html.text "awesome"
```
"""


init : ( Model, Effects.Effects Action )
init =
  ( Model defaultText, Effects.none )


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
    [ Html.class "view" ]
    [ Html.h1 [] [ Html.text "Elm Markdown Editor" ]
    , Html.div
        [ Html.class "pure-g panes" ]
        [ Html.div
            [ Html.class "pure-u-1-2 edit" ]
            [ Html.textarea
                [ Html.value model.text
                , Html.on "input" Html.targetValue (Signal.message address << ModifyText)
                , Html.class "inputarea"
                ]
                []
            ]
        , Html.div
            [ Html.class "pure-u-1-2 display" ]
            [ Markdown.toHtml model.text ]
        ]
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
