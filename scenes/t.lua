---@diagnostic disable: redundant-parameter, undefined-global

local T = {}
T.__index = T

-- local body1 = love.physics.newBody(World, 200, 0, "dynamic")
-- local body2 = love.physics.newBody(World, 230, 0, "dynamic")
-- local joint = love.physics.newWeldJoint( body1, body2, 0,0, collideConnected )

function T.new()
    local o = {}
    o.w = 30
    o.h = 30
    o.body = love.physics.newBody(World, 200, 0, "dynamic")
    o.body1 = love.physics.newBody(World, 230, 0, "dynamic")
    o.shape = love.physics.newRectangleShape(0, 0, o.w, o.h)
    setmetatable(o, T)
    return o
end

return T