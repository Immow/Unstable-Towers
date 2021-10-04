---@diagnostic disable: redundant-parameter

local Square = require("scenes.square")
local Bar = require("scenes.bar")
local T = require("scenes.t")

local o = require("scenes.object")

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

function Game:RandomShape()
    local r = love.math.random(1,1)
    if r == 1 then return Square.new() end
    if r == 2 then return Bar.new() end
    if r == 3 then return T.new() end
end

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

local winTimerAmount = 3
local winTimer = winTimerAmount
function Game:score()
    love.graphics.setFont(Font)
    Font:setLineHeight(1.5)
    love.graphics.print(#objects.blocks.."\n"..winTimer)
    if #objects.blocks >= 2 then -- Wincondition
        win = true
        -- objects.blocks = {}
        for i = 1, #objects.blocks do
            objects.blocks[i].remove = true
        end
        -- print(tprint(objects.blocks))
    end
    love.graphics.setFont(DefaultFont)
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

function Game:update(dt)
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
        love.graphics.setFont(Font)
        Font:setLineHeight(1.5)
        love.graphics.printf("PRESS SPACE TO START\nUSE ARROW KEYS TO MOVE\nCTRL AND ALT TO ROTATE", 0, wh/2, ww,"center")
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