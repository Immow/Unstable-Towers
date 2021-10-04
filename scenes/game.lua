---@diagnostic disable: redundant-parameter, undefined-global, lowercase-global

local Sound = require("assets.sounds.sound")
local o = require("scenes.object")

-- local scratch = love.audio.newSource(Sound.scratch, "static")
local Game = {}
local ww, wh = love.graphics.getDimensions()

local objects = {}
objects.blocks = {}

objects.ground = {}
objects.ground.body = love.physics.newBody(World, ww/2, wh-50/2)
objects.ground.shape = love.physics.newRectangleShape(100, 50)
objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

local wallWidth = 50
objects.leftWall = {}
objects.leftWall.body = love.physics.newBody(World, wallWidth/2,wh/2)
objects.leftWall.shape = love.physics.newRectangleShape(wallWidth, wh)
objects.leftWall.fixture = love.physics.newFixture(objects.leftWall.body, objects.leftWall.shape)
objects.rightWall = {}
objects.rightWall.body = love.physics.newBody(World, ww-wallWidth/2,wh/2)
objects.rightWall.shape = love.physics.newRectangleShape(wallWidth, wh)
objects.rightWall.fixture = love.physics.newFixture(objects.rightWall.body, objects.rightWall.shape)

love.graphics.setBackgroundColor(0.41, 0.53, 0.97)

local win = false
local continue = false
function Game:keypressed(key)
    if key == "space" and not continue and not win then
        table.insert(objects.blocks, o.new())
        -- print(tprint(objects.blocks))
        continue = true
    end
end

function Game:removeObject(i)
    if objects.blocks[i].remove then
        objects.blocks[i].body:destroy()
        table.remove(objects.blocks, i)
    end
end

function Game:addObject()
    if not next(objects.blocks) and continue then
        table.insert(objects.blocks, o.new())
    end
end

function Game:addObject1()
    if not objects.blocks[#objects.blocks].active and continue then
        table.insert(objects.blocks, o.new())
    end
end

local WinconditionValue = 15
local winTimerAmount = 3
local winTimer = winTimerAmount
function Game:score()
    love.graphics.setFont(Font)
    Font:setLineHeight(1.5)
    love.graphics.print(#objects.blocks,5,5)
    if #objects.blocks >= WinconditionValue then -- Wincondition
        win = true
        for i = 1, #objects.blocks do
            objects.blocks[i].remove = true
        end
    end
    love.graphics.setFont(DefaultFont)
end

function Game:keyreleased(key)
    if key == "lalt" or "lctrl" then
        -- love.audio.stop()
    end 
end

function Game:winDraw()
    if win then
        love.graphics.setFont(Font)
        Font:setLineHeight(1.5)
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf("YOU WIN", 0, wh/2, ww,"center")
        love.graphics.setFont(DefaultFont)
    end
end

function Game:updateObject(dt)
    if not win and continue then
        for i = #objects.blocks, 1, -1 do
            objects.blocks[i]:update(dt)
            self:addObject1()
            self:removeObject(i)
        end
        self:addObject()
    end
end

function Game:music()
    if not Sound.music:isPlaying() then
		Sound.music:play()
        Sound.music:setVolume(0.05)
	end
end

function Game:update(dt)
    self:music()
    World:update(dt)
    self:updateObject(dt)
    if win then
        winTimer = winTimer - 1 * dt
        if winTimer < 0 then
            winTimer = winTimerAmount
            win = false
            continue = false
        end
    end
end

function Game:continue()
    if not continue and not win then
        local text = "PRESS SPACE TO START\nUSE ARROW KEYS TO MOVE\nLEFT CTRL AND ALT TO ROTATE\n YOU WIN WHEN YOU STACK:"..WinconditionValue.." CRATES"
        love.graphics.setFont(Font)
        local fontHeight = Font:getHeight()
        Font:setLineHeight(1.5)

        love.graphics.printf(text, 0, wh/2 - 4 * fontHeight, ww,"center")
        love.graphics.setFont(DefaultFont)
    end
end

function Game:draw()
    love.graphics.setColor(1, 1, 1)
    self:continue()
    love.graphics.setColor(0.28, 0.63, 0.05)
    love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))
    love.graphics.polygon("fill", objects.leftWall.body:getWorldPoints(objects.leftWall.shape:getPoints()))
    love.graphics.polygon("fill", objects.rightWall.body:getWorldPoints(objects.rightWall.shape:getPoints()))
    if not win and continue then
        for i = #objects.blocks, 1, -1 do
            objects.blocks[i]:draw()
        end
        self:score()
    end
    self:winDraw()
end

return Game