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

local scene

love.physics.setMeter(64)
local gravity = 5*64 -- 9.81*64 = default
World = love.physics.newWorld(0, gravity, true)
function love.load()
    ChangeScene("game")
    DefaultFont = love.graphics.getFont()
    Font = love.graphics.newFont("assets/font/PressStart2P-Regular.ttf", 18)

    -- local function example(...)
    --     -- print("a "..a)
    --     print(select(...,3))
    --     -- return print(...)
    -- end
    -- example(1, 2, 3, 4, 5, 6)

    -- for i = 2, 10, 2 do
    --     print(i)
    -- end
end

function love.update(dt)
    if scene.update then scene:update(dt) end
end

function love.draw()
    if scene.draw then scene:draw() end
end

function love.keypressed(key,scancode,isrepeat)
    if scene.keypressed then scene:keypressed(key,scancode,isrepeat) end
    if key == "escape" then
        love.event.quit()
    end
    if key == "r" then
        love.event.quit("restart")
    end
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