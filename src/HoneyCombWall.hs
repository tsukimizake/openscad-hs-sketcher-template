module HoneyCombWall (honeyCombCell, honeyCombWall, honeyCombWallHex) where

import Data.Function ((&))
import OpenSCAD

cos30 :: Double
cos30 = sqrt 3 / 2

sin30 :: Double
sin30 = 1 / 2

honeyCombCell :: Double -> Double -> OpenSCADM Model3d
honeyCombCell height size =
  do
    let scaler (x, y, z) = (x * size, y * size, z * size)
        crossSection = rectangle height 2
    declModule $
      union
        [ stick (0, 0, 0) (scaler (cos30, sin30, 0)) crossSection,
          stick (size * cos30, size * sin30, 0) (size * cos30, size * (1 + sin30), 0) crossSection,
          stick (scaler (cos30, 1 + sin30, 0)) (scaler (0, 2, 0)) crossSection,
          stick (scaler (0, 2, 0)) (scaler (-cos30, 1 + sin30, 0)) crossSection,
          stick (scaler (-cos30, 1 + sin30, 0)) (scaler (-cos30, sin30, 0)) crossSection,
          stick (scaler (-cos30, sin30, 0)) (0, 0, 0) crossSection
        ]
        & translate (0, 0, height)

stick :: Vector3d -> Vector3d -> Model2d -> Model3d
stick from to crossSection =
  let (x, y, z) = (to #- from)

      len = sqrt $ x * x + y * y + z * z
      toDegree x = x * 180 / pi
      degree =
        if x < 0
          then (180 +) . toDegree . atan
          else toDegree . atan
   in linearExtrudeDefault len crossSection
        & rotate3d (0, 90, 0)
        & rotate3d (0, 0, degree (y / x))
        & translate from

honeyCombWall :: Double -> Vector3d -> OpenSCADM Model3d
honeyCombWall honeyCombScale (x, y, z) = do
  cell <- honeyCombCell z honeyCombScale

  let rectsize = max x y
      cells =
        [ (y / (2 * honeyCombScale), x, y, 0)
          | x <- [0, 2 * honeyCombScale .. rectsize + honeyCombScale],
            y <- [0, 2 * honeyCombScale .. rectsize + honeyCombScale]
        ]
          & map
            ( \(i, x, y, z) ->
                translate
                  ( if even (floor i)
                      then x * cos30
                      else (x - honeyCombScale) * cos30,
                    (1 + sin30) / 2 * y,
                    z
                  )
                  cell
            )
      outer = box x y z
      inner = box (x - 8) (y - 8) (z + 2) & translate (4, 4, -1)
      rim = difference outer inner

  pure $
    union cells
      & with intersection outer
      & with union rim

honeyCombWallHex :: Double -> Double -> Double -> OpenSCADM Model3d
honeyCombWallHex honeyCombScale edgeLength thickness = do
  cell <- honeyCombCell thickness honeyCombScale
  let cells = do
        x <- [0, 2 * honeyCombScale .. edgeLength * 2 + honeyCombScale]
        y <- [0, 2 * honeyCombScale .. edgeLength * 2 + honeyCombScale * 5]
        pure $
          translate (-edgeLength, 0, 0) $
            translate
              ( if even (floor (y / (2 * honeyCombScale)))
                  then x * cos30
                  else (x - honeyCombScale) * cos30,
                (1 + sin30) / 2 * y,
                0
              )
              cell

      outer =
        polygon
          3
          [ [(0, 0), (cos30, sin30), (cos30, 1 + sin30), (0, 2), (-cos30, 1 + sin30), (-cos30, sin30)]
              & map (\(x, y) -> (x * edgeLength, y * edgeLength))
          ]
          & linearExtrudeDefault thickness
      inner =
        polygon
          3
          [ [(0, 0), (cos30, sin30), (cos30, 1 + sin30), (0, 2), (-cos30, 1 + sin30), (-cos30, sin30)]
              & map (\(x, y) -> (x * (edgeLength - 4), y * (edgeLength - 4)))
          ]
          & linearExtrudeDefault (thickness + 2)
          & translate (0, 4, -1)
      rim = difference outer inner
  pure $
    union cells
      & with intersection outer
      & with union rim
