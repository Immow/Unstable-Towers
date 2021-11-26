function love.conf(t)
	t.title = "Unstable Towers"
	t.identity = "unstable_towers"
	t.version = "11.3"
	t.console = false
	t.window.fullscreen = false
	t.window.msaa = 8
	t.modules.joystick = false
	t.modules.physics = true
	t.externalstorage = true
	t.window.vsync = 0
	t.window.resizable = false
end