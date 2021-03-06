---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

local Sprites = {}

Sprites.loading = {
  source = "img/deco/loading.png",
  frames = {width=167, height=178, numFrames=10},
  sequences = {
      { name = "stop", loopCount = 1, start = 1, count=1},
      { name = "play", time=1200, start = 1, count=10}
  }
}

Sprites.loadingMin = {
  source = "img/deco/loadingMin.png",
  frames = {width=64, height=64, numFrames=8},
  sequences = {
      { name = "stop", loopCount = 1, start = 1, count=1},
      { name = "play", time=1500, start = 1, count=8}
  }
}

return Sprites