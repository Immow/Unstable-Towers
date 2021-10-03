---@diagnostic disable: redundant-parameter

local Object = {}
Object.__index = Object

function Object.new(b)
    local w = love.math.random(30,100)
    local h = love.math.random(30,100)

    local o = {}
        o.body = b.body
        o.shape = b.shape
        o.fixture = love.physics.newFixture(o.body, o.shape, 1)
        -- o.body = love.physics.newBody(World, 200, 0, "dynamic")
        -- o.shape = love.physics.newRectangleShape(0, 0, w, h)
        -- o.fixture = love.physics.newFixture(o.body, o.shape, 1)
        o.active = true
        o.w = w
        o.h = h
        o.force = 400
        o.remove = false
        o.time = 0
        o.vel = 0
    setmetatable(o, Object)
    return o
end

function Object:update(dt)
    local y = self.body:getY()
    if y - 100 > love.graphics.getHeight() then
        self.remove = true
    end

    local left  = love.keyboard.isDown("left")
    local right = love.keyboard.isDown("right")
    local up    = love.keyboard.isDown("up")
    local down  = love.keyboard.isDown("down")
    local alt   = love.keyboard.isDown("lalt" or "ralt")
    local ctrl  = love.keyboard.isDown("lctrl" or "rctrl")

    self.body:setMass(1)
    if self.active then
        if right then
            self.body:applyForce(self.force, 0)
        elseif left then
            self.body:applyForce(-self.force, 0)
        elseif up then
            self.body:applyForce(0, -self.force * 2)
        elseif down then
            self.body:applyForce(0, self.force)
        elseif alt then
            self.body:applyTorque(1500)
        elseif ctrl then
            self.body:applyTorque(-1500)
        end
    end

    if not self.active then return end

    local xVel, yVel = self.body:getLinearVelocity()
    self.vel = math.abs(xVel) + math.abs(yVel)
    if self.vel < 5 and not left and not right and not up and not down then
        self.time = self.time + 0.1 * dt
        if self.time > 0.01 then
            self.active = false
        end
    else
        self.time = 0
    end
end

function Object:draw()
    local x,y = self.body:getPosition()
    love.graphics.setColor(0.2,0.2,0.2,1)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(tostring(self.active).."\n"
        ..self.body:getMass().."\n"
        ..self.time.."\n"
        ..self.vel.."\n"
        ,x-self.w/2,y-self.h/2)
end

return Object