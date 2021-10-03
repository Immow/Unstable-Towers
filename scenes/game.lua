---@diagnostic disable: redundant-parameter

-- FUNCTION TO PRINT TABLES
function tprint (tbl, indent)
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2 
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint  .. k ..  "= "   
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\r\n"
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\r\n"
        elseif (type(v) == "table") then
            toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", indent-2) .. "}"
    return toprint
end

local o = require("scenes.object")
local gravity = 5*64 -- 9.81*64 = default

local Game = {}
local ww, wh = love.graphics.getDimensions()

love.physics.setMeter(64)
local world = love.physics.newWorld(0, gravity, true)

local objects = {}
objects.blocks = {}

objects.ground = {}
objects.ground.body = love.physics.newBody(world, ww/2, wh-50/2)
objects.ground.shape = love.physics.newRectangleShape(100, 50)
objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

local wallWidth = 50
objects.leftWall = {}
objects.leftWall.body = love.physics.newBody(world, wallWidth/2,wh/2)
objects.leftWall.shape = love.physics.newRectangleShape(wallWidth, wh)
objects.leftWall.fixture = love.physics.newFixture(objects.leftWall.body, objects.leftWall.shape)
objects.rightWall = {}
objects.rightWall.body = love.physics.newBody(world, ww-wallWidth/2,wh/2)
objects.rightWall.shape = love.physics.newRectangleShape(wallWidth, wh)
objects.rightWall.fixture = love.physics.newFixture(objects.rightWall.body, objects.rightWall.shape)

love.graphics.setBackgroundColor(0.41, 0.53, 0.97)

local continue = false
function Game:keypressed(key)
    if key == "space" and not continue then
        table.insert(objects.blocks, o.new(world))
        -- print(tprint(objects))
        continue = true
    end
end

function Game:removeObject(i)
    if objects.blocks[i].remove then
        if i == 1 then -- have to add an object despite this is a remove function else the loop ends :(
            table.insert(objects.blocks,i+1,o.new(world))
        end
        table.remove(objects.blocks, i)
    end
end

function Game:addObject()
    if not objects.blocks[#objects.blocks].active and continue then
        table.insert(objects.blocks, o.new(world))
    end
end

function Game:updateObject(dt)
    for i = #objects.blocks, 1, -1 do
        objects.blocks[i]:update(dt)
        self:addObject()
        self:removeObject(i)
    end
end

function Game:update(dt)
    world:update(dt)
    self:updateObject(dt)
end

function Game:continue()
    if not continue then
        love.graphics.setFont(Font)
        love.graphics.printf("PRESS SPACE TO START\nUSE ARROW KEYS TO MOVE", 0, wh/2, ww,"center")
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
    
    for i = #objects.blocks, 1, -1 do
        objects.blocks[i]:draw()
    end
    love.graphics.print(#objects.blocks)
end

return Game