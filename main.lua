local Sound = require("assets.sounds.sound")
local scene
local bump = love.audio.newSource(Sound.bump, "static")

function RandomFloat(a, b)
	return a + math.random() * (b - a)
end

local persisting = 0
function BeginContact(a, b, coll)
	bump:setPitch(RandomFloat(0.2, 2))
	bump:play()
end

function EndContact(a, b, coll)
	persisting = 0
end

function PreSolve(a, b, coll)
	persisting = persisting + 1
end

function PostSolve(a, b, coll, normalimpulse, tangentimpulse)
	
end

function love.load()
	Debug = false
	love.physics.setMeter(64)
	local gravity = 5*64 -- 9.81*64 = default
	World = love.physics.newWorld(0, gravity, true)
	
	ChangeScene("game")
	DefaultFont = love.graphics.getFont()
	Font = love.graphics.newFont("assets/font/PressStart2P-Regular.ttf", 18)

	World:setCallbacks(BeginContact, EndContact, PreSolve, PostSolve)
end

function love.update(dt)
	if scene.update then scene:update(dt) end
end

function love.draw()
	if scene.draw then scene:draw() end
end

function love.keypressed(key,scancode,isrepeat)
	if scene.keypressed then scene:keypressed(key,scancode,isrepeat) end
	-- if key == "escape" then
	--	 love.event.quit()
	-- end
	-- if key == "r" then
	--	 love.event.quit("restart")
	-- end
	-- if key == "d" then
	--	 Debug = not Debug
	-- end
end

function love.keyreleased(key,scancode)
	if scene.keyreleased then scene:keyreleased(key,scancode) end
end

function love.mousepressed(x,y,button,istouch,presses)
	if scene.mousepressed then scene:mousepressed(x,y,button,istouch,presses) end
end

function love.mousereleased(x,y,button,istouch,presses)
	if scene.mousereleased then scene:mousereleased(x,y,button,istouch,presses) end
end

function love.touchpressed(id,x,y,dx,dy,pressure)
	if scene.touchpressed then scene:touchpressed(id,x,y,dx,dy,pressure) end
end

function love.touchreleased(id,x,y,dx,dy,pressure)
	if scene.touchreleased then scene:touchreleased(id,x,y,dx,dy,pressure) end
end

function love.touchmoved(id,x,y,dx,dy,pressure)
	if scene.touchmoved then scene:touchmoved(id,x,y,dx,dy,pressure) end
end

function ChangeScene(nextScene)
	scene = require("scenes/"..nextScene)
	if scene.load then scene:load() end
end