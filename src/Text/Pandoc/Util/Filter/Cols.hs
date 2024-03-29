{-# LANGUAGE ScopedTypeVariables #-}

-- | Conversion of lvl-x-headings to x-column-layouts in HTML
--   especially for use in revealjs-slides
module Text.Pandoc.Util.Filter.Cols
    (cols)
        where

import Text.Pandoc.JSON
import Data.Monoid ((<>))
import Text.Read (readMaybe)
import Data.Maybe (fromMaybe)
import Text.Pandoc.Util.Filter

-- | This filter makes multi-column-layouts out of lvl-x-headings
--
-- Syntax is
-- 
-- @
--     ## a b
-- @
--
-- yielding a 2-column-layout with aspects a:b i.e. 1:1 for 50/50-layout
-- or 8:2 for 80/20 layout
--
-- currently works for 2 and 3-columns, but extension is straight-forward.
--
-- If you need multiple Block-Elements inside one column, just wrap them
-- with a @\<div\>@:
--
-- @
--     ## 2 5
--
--     \<div\>
--     multiple things
--     ```
--     foo
--     ```
--     ![image](...)
--     \</div\>
--
--     second column here with only 1 element.
-- @
cols :: [Block] -> [Block]
cols (Header 2 attr [Str wa,Space,Str wb]:a:b:rest) =
  outerDiv:rest
    where
      wa' = fromMaybe 1 (readMaybe wa) :: Int
      wb' = fromMaybe 1 (readMaybe wb) :: Int
      total = wa' + wb'
      pa = (100*wa') `div` total
      pb = (100*wb') `div` total
      outerDiv = Div attr [ makeDiv pa a
                          , makeDiv pb b
                          , clearDiv
                          ]
cols (Header 3 attr [Str wa,Space,Str wb,Space,Str wc]:a:b:c:rest) =
  outerDiv:rest
    where
      wa' = fromMaybe 1 (readMaybe wa) :: Int
      wb' = fromMaybe 1 (readMaybe wb) :: Int
      wc' = fromMaybe 1 (readMaybe wc) :: Int
      total = wa' + wb' + wc'
      pa = (100*wa') `div` total
      pb = (100*wb') `div` total
      pc = (100*wc') `div` total
      outerDiv = Div attr [ makeDiv pa a
                          , makeDiv pb b
                          , makeDiv pc c
                          , clearDiv
                          ]
cols x = x

makeDiv :: Int -> Block -> Block
makeDiv width content = Div ("", [], [("style","width:" <> show width <> "%;float:left")]) [content]

clearDiv :: Block
clearDiv = Div ("", [], [("style", "clear: both")]) [Plain [toHtml ""]]
