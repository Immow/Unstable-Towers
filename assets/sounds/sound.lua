local Sounds = {}

Sounds.music = love.audio.newSource("/assets/sounds/bensound-smallguitar.mp3", "stream")
Sounds.rotate = love.filesystem.newFileData("/assets/sounds/rotate.wav")
Sounds.scratch = love.filesystem.newFileData("/assets/sounds/scratch.wav")
Sounds.bump = love.filesystem.newFileData("/assets/sounds/bump.wav")
Sounds.spawn = love.filesystem.newFileData("/assets/sounds/spawn.wav")

return Sounds