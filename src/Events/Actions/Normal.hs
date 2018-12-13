{-# LANGUAGE NoImplicitPrelude #-}
module Events.Actions.Normal (event) where

import ClassyPrelude hiding (delete)

import Graphics.Vty.Input.Events
import Data.Char (isDigit)
import Events.State
import Events.State.Types (Stateful)
import Events.State.Modal.Detail (showDetail, editDue)

-- Normal
event :: Event -> Stateful

-- quit
event (EvKey (KChar 'q') _) = quit

-- add/edit
event (EvKey (KChar 'e') _) = (startEdit =<<) . store
event (EvKey (KChar 'A') _) = (startEdit =<<) . store
event (EvKey (KChar 'i') _) = (startEdit =<<) . store
event (EvKey (KChar 'C') _) = (startEdit =<<) . (clearItem =<<) . store
event (EvKey (KChar 'a') _) = (startCreate =<<) . (newItem =<<) . store
event (EvKey (KChar 'O') _) = (startCreate =<<) . (above  =<<) . store
event (EvKey (KChar 'o') _) = (startCreate =<<) . (below =<<) . store

-- add list
event (EvKey (KChar 'N') _) = (createListStart =<<) . store
event (EvKey (KChar 'E') _) = (editListStart =<<) . store
event (EvKey (KChar 'X') _) = (write =<<) . (deleteCurrentList =<<) . store

-- navigation
event (EvKey KUp _) = previous
event (EvKey KDown _) = next
event (EvKey KLeft _) = left
event (EvKey KRight _) = right

event (EvKey (KChar 'G') _) = bottom

-- moving items
event (EvKey (KChar 'K') _) = (write =<<) . (up =<<) . store
event (EvKey (KChar 'J') _) = (write =<<) . (down =<<) . store
event (EvKey (KChar 'H') _) = (write =<<) . (bottom =<<) . (left =<<) . (moveLeft =<<) . store
event (EvKey (KChar 'L') _) = (write =<<) . (bottom =<<) . (right =<<) . (moveRight =<<) . store
event (EvKey (KChar ' ') _) = (write =<<) . (moveRight =<<) . store
event (EvKey (KChar 'm') _) = showMoveTo

-- removing items
event (EvKey (KChar 'D') _) = (write =<<) . (delete =<<) . store

-- undo
event (EvKey (KChar 'u') _) = (write =<<) . undo

-- moving lists
event (EvKey (KChar '>') _) = (write =<<) . (listRight =<<) . store
event (EvKey (KChar '<') _) = (write =<<) . (listLeft =<<) . store

-- search
event (EvKey (KChar '/') _) = searchMode

-- help
event (EvKey (KChar '?') _) = showHelp

-- subtasks
event (EvKey KEnter _) = showDetail
event (EvKey (KChar '@') _) = (editDue =<<) . (store =<<) . showDetail

-- selecting lists
event (EvKey (KChar n) _)
    | isDigit n = selectList n
    | otherwise = return

-- fallback
event _ = return
