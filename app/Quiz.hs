#!/usr/bin/env runhaskell
{-# LANGUAGE ScopedTypeVariables #-}

import Text.Pandoc.JSON
import Text.Pandoc.Walk
import Control.Exception
import Data.Monoid ((<>))
import Data.List (partition)
import Data.Maybe (isNothing, mapMaybe, listToMaybe)

main :: IO ()
main = toJSONFilter quizLift

-- Move bottom-Up through the structure, find quiz-answers and remove the
-- incorrect formattet ones from the Block they came from.
quizLift :: Block -> [Block]
quizLift pb@(Plain b) = fmap makeQuiz (query findQuiz pb) ++ [Plain (filter ((==) [] . findQuiz) b)]
quizLift pb@(Para  b) = fmap makeQuiz (query findQuiz pb) ++ [Plain (filter ((==) [] . findQuiz) b)]
quizLift x = [x]

-- If we have []{.answer} then we have a quiz-answer
-- maybe with a tooltip
findQuiz :: Inline -> [(Attr, [Inline], Maybe ([Inline],Attr))]
findQuiz (Span attributes@(id, att, att') answerText)
  | "answer" `elem` att     = [(attributes, answerText', tooltip)]
                where
                        answerText' = filter (isNothing . findTooltip) answerText   --filter everything that is a tooltip
                        tooltip     = listToMaybe $ mapMaybe findTooltip answerText --get the first span that is labled tooltip
findQuiz x = []

-- If we have []{.tooltip} we have a tooltip ;)
-- we save the text and the attributes in a tuple
findTooltip :: Inline -> Maybe ([Inline],Attr)
findTooltip (Span attr@(_,att,_) tooltipText)
  | "tooltip" `elem` att    = Just (tooltipText, attr)
findTooltip _ = Nothing

-- Generate Divs for the quiz
makeQuiz :: (Attr, [Inline], Maybe ([Inline],Attr)) -> Block
makeQuiz (att, answer, Nothing) = Div att [Plain answer]
makeQuiz (att, answer, Just (tooltip,a)) = Div att [Plain answer, Div a [Plain tooltip]]
