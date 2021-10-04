local Sounds = {}

Sounds.music = love.audio.newSource("/assets/sounds/bensound-smallguitar.mp3", "stream")
Sounds.rotate = love.filesystem.newFileData("/assets/sounds/rotate.wav")
Sounds.scratch = love.filesystem.newFileData("/assets/sounds/scratch.wav")

return Sounds