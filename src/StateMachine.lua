StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
	self.state_name = nil
end

function StateMachine:change(state_name, enterParams)
	assert(self.states[state_name]) -- state must exist!
	self.current:exit()
	self.state_name = state_name
	self.current = self.states[state_name]()
	self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end
