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

local Game = {}
local ww, wh = love.graphics.getDimensions()

love.physics.setMeter(64)
local world = love.physics.newWorld(0, 9.81*64, true)

local objects = {}
objects.blocks = {}

objects.ground = {}
objects.ground.body = love.physics.newBody(world, ww/2, wh-50/2)
objects.ground.shape = love.physics.newRectangleShape(ww, 50)
objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

love.graphics.setBackgroundColor(0.41, 0.53, 0.97)

function Game:keypressed(key)
    if key == "space" then
        table.insert(objects.blocks, o.new(world))
        -- print(tprint(objects))
    end
end

function Game:update(dt)
    world:update(dt)
end

function Game:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setColor(0.28, 0.63, 0.05)
    love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))
    
    for i = #objects.blocks, 1, -1 do
        objects.blocks[i]:draw()
    end
end

return Game