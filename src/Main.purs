module Main where

import Prelude
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)
import Component.Rainbow as Rainbow

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    runUI Rainbow.component unit body

data Action
  = Increment
  | Decrement

type State
  = Int

component :: ∀ query input output m. H.Component query input output m
component = H.mkComponent { initialState, render, eval }
  where
  initialState :: input -> State
  initialState _input = 0

  render :: ∀ slots. State -> HH.HTML (H.ComponentSlot slots m Action) Action
  render state =
    HH.div_
      [ HH.button [ HE.onClick \_ -> Decrement ] [ HH.text "-" ]
      , HH.div_ [ HH.text $ show state ]
      , HH.button [ HE.onClick \_ -> Increment ] [ HH.text "+" ]
      ]

  eval ::
    ∀ a slots.
    H.HalogenQ query Action input a ->
    H.HalogenM State Action slots output m a
  eval = H.mkEval $ H.defaultEval { handleAction = handleAction }
    where
    handleAction :: Action -> H.HalogenM State Action slots output m Unit
    handleAction = case _ of
      Increment -> H.modify_ (_ + 1)
      Decrement -> H.modify_ (_ - 1)

