module Main (main) where

import Data.Function ((&))
import OpenSCAD
import Sketch
import SketchTH
import SketchTypes

data Hoge = Hoge
  { honi :: Polygon,
    fuwa :: Point,
    poyo :: Polygon
  }
  deriving (Show)

mkSketchRes ''Hoge

obj :: OpenSCADM Model3d
obj = do
  let r = sketch do
        a <- point & x 0 & y 0
        b <- point & x 4 & y 0
        v1 <- line & from a & degree 30
        v2 <- line & from b & degree 90
        c <- intersectionPoint v1 v2
        honi <- poly =<< traverse (chamfer 0.3 . pure) [a, b, c]
        let poyo = honi
        let fuwa = a
        pure Hoge {..}
  pure $ linearExtrudeDefault 1 r.poyo

main :: IO ()
main =
  render obj & writeFile "SketchTry.scad"
