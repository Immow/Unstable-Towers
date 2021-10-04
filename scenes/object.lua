---@diagnostic disable: redundant-parameter
local Sound = require("assets.sounds.sound")
local ww = love.graphics.getWidth()

local Object = {}
Object.__index = Object

local img1 = love.graphics.newImage("assets/images/1.png")
local img2 = love.graphics.newImage("assets/images/2.png")



function Object.new()
    local dropSpot
    local w = love.math.random(30,100)
    local h = love.math.random(30,100)
    local r = love.math.random(1,2)
    if r == 1 then dropSpot = 200 else dropSpot = ww-200 end
    local o = {}
        o.body = love.physics.newBody(World, dropSpot, 0, "dynamic")
        o.shape = love.physics.newRectangleShape(0, 0, w, h)
        o.fixture = love.physics.newFixture(o.body, o.shape, 1)
        o.active = true
        o.w = w
        o.h = h
        o.force = 400
        o.remove = false
        o.time = 0
        o.vel = 0
        o.image = function () if r == 1 then return img1 else return img2 end end
        o.imageWidth = o.image():getWidth()
        o.imageHeight = o.image():getHeight()
        o.imageScaleW = w / o.imageWidth
        o.imageScaleH = h / o.imageHeight
        o.rotate = love.audio.newSource(Sound.rotate, "static")
        o.spawn = love.audio.newSource(Sound.spawn, "static")
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
    local alt   = love.keyboard.isDown("lalt")
    local ctrl  = love.keyboard.isDown("lctrl")

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
            self.rotate:play()
        elseif ctrl then
            self.body:applyTorque(-1500)
            self.rotate:play()
        end
    end

    if not self.active then return end

    local xVel, yVel = self.body:getLinearVelocity()
    self.vel = math.abs(xVel) + math.abs(yVel)
    if self.vel < 5 and not left and not right and not up and not down then
        self.time = self.time + 0.1 * dt
        if self.time > 0.01 then
            self.spawn:play()
            self.active = false
        end
    else
        self.time = 0
    end
end

-- function Object:beginContact(a, b, coll)
    
-- end

function Object:draw()
    local x,y = self.body:getPosition()
    love.graphics.setColor(0.2,0.2,0.2,1)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.setColor(1,1,1,1)

    love.graphics.draw(self.image(), x, y, self.body:getAngle(), self.imageScaleW, self.imageScaleH,self.imageWidth/2,self.imageHeight/2)
    if Debug then
        love.graphics.print(tostring(self.active).."\n"
            ..self.body:getMass().."\n"
            ..self.time.."\n"
            ..self.vel.."\n"
            ,x-self.w/2,y-self.h/2)
    end
end

return Object