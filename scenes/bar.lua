local Bar = {}
Bar.__index = Bar

function Bar.new()
	local o = {}
	o.w = 30
	o.h = 120
	o.body = love.physics.newBody(World, 200, 0, "dynamic")
	o.shape = love.physics.newRectangleShape(0, 0, o.w, o.h)
	setmetatable(o, Bar)
	return o
end

return Bar