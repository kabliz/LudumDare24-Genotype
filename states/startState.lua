--[[
	Gamestate for starting menu
]]

local startState = Gamestate.new()

function startState:init() -- once
end

function startState:load()
end

function startState:enter()
end

function startState:update(dt)
end

function startState:draw()
	love.graphics.print("state switched good", 400, 300)
end

function startState:mousepressed(x,y, mouse_btn)
	Gamestate.switch(states.run)  --references globals in main
end

return startState   --allows loading as a module