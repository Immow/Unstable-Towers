local Square = {}
Square.__index = Square

function Square.new()
	local o = {}
	o.w = 60
	o.h = 60
	o.body = love.physics.newBody(World, 200, 0, "dynamic")
	o.shape = love.physics.newRectangleShape(0, 0, o.w, o.h)
	setmetatable(o, Square)
	return o
end

return Square