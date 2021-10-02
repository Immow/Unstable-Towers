---@diagnostic disable: redundant-parameter
local Object = {}
Object.__index = Object

function Object.new(world)
    local w = love.math.random(10,100)
    local h = love.math.random(10,100)

    local o = {}
        o.body = love.physics.newBody(world, 200, 0, "dynamic")
        o.shape = love.physics.newRectangleShape(0, 0, w, h)
        o.fixture = love.physics.newFixture(o.body, o.shape, 1)
        o.active = true
        o.w = w
        o.h = h
        o.force = 400
    setmetatable(o, Object)
    return o
end

function Object:update(dt)
    if self.active then
        local mass = self.body:getMass()
        if mass < 1 then self.force = 100 end
        if love.keyboard.isDown("right") then
            self.body:applyForce(self.force, 0)
        elseif love.keyboard.isDown("left") then
            self.body:applyForce(-self.force, 0)
        elseif love.keyboard.isDown("up") then
            self.body:applyForce(0, -self.force)
        elseif love.keyboard.isDown("down") then
            self.body:applyForce(0, self.force)
        end
    end
    
local xVel, yVel = self.body:getLinearVelocity()
    if xVel < 0.001 and yVel < 0.001 then
        self.active = false
    end
end

function Object:draw()
    local x,y = self.body:getPosition()
    love.graphics.setColor(0.2,0.2,0.2,1)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(tostring(self.active).."\n"..self.body:getMass(),x-self.w/2,y-self.h/2)
end

return Object