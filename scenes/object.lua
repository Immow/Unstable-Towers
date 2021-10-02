---@diagnostic disable: redundant-parameter
local Object = {}
Object.__index = Object

function Object.new(world)
    local o = {}
        o.body = love.physics.newBody(world, 200, 0, "dynamic")
        o.shape = love.physics.newRectangleShape(0, 0, 50, 100)
        o.fixture = love.physics.newFixture(o.body, o.shape, 5)
    setmetatable(o, Object)
    return o
end

function Object:update(dt)
    -- self:update(dt)
end

function Object:draw()
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

return Object