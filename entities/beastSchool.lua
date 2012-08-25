--[[ list operations on a school/herd/whatever of beasts 
]]

local Beast = require "entities.beast"
local Class = require "hump.class"
local consts = require "consts"

local beastSchool = Class( --  constructor
		function(self)
			self.school = {}
		end
)

function beastSchool:checkBoundary(beast) --keeps a beast inside game bounds
	local loc = beast:gLocation()
	if(loc.x < 0) then
		beast:sLocation(Vector(consts.SCREEN.x, loc.y))
	elseif(loc.x > consts.SCREEN.x) then
		beast:sLocation(Vector(0, loc.y))	
	end

	loc = beast:gLocation()
	if(loc.y < 0) then
		beast:sLocation(Vector(loc.x, consts.SCREEN.y))
	elseif(loc.y > consts.SCREEN.y) then
		beast:sLocation(Vector(loc.x,0))
	end
end

function beastSchool:mack(parent1, parent2)
	table.insert(self.school, Beast(
					Vector(
						(parent1:gLocation().x+parent2:gLocation().x)/2, 
						(parent1:gLocation().y+parent2:gLocation().y)/2),
					{(parent1:gRed()+parent2:gRed())/2, (parent1:gGreen()+parent2:gGreen())/2,
						(parent1:gBlue()+parent2:gBlue())/2, (parent1:gAlpha()+parent2:gAlpha())/2},
					parent1:passGene(),
					parent2:passGene()
			)
	) 
end

function beastSchool:mackTest()
	local i = 1
	local j = 1
	for i = 1, #self.school do
		for j = i+1, #self.school do
			if(self.school[i]:ready() and self.school[j]:ready() and 
			   self.school[i]:collisionTest(self.school[j])) then
				self:mack(self.school[i], self.school[j])
				break
			end
		end
	end
end

function beastSchool:initGenerationZero(numPopulation, numCarrying)
	local color = {0, 200, 0, 255}
	local all1 = true
	local all2 = true
	local i =1 

	for i = 1, numPopulation do
		if(i > numPopulation - numCarrying) then
			all2 = false
		end
		table.insert(self.school, Beast(
				Vector(math.random()*consts.SCREEN.x, math.random()*consts.SCREEN.y),
				{color[1], color[2], color[3], color[4]},
				all1, all2
		))
		if (math.random() > .5) then 
			color[1] = 0
		else
			color[1] = 200
		end
		if (math.random() > .5) then 
			color[2] = 0
		else
			color[2] = 200
		end
		if (math.random() > .5) then 
			color[3] = 0
		else
			color[3] = 200
		end

		--TODO preditable color exploit fix here. Do colors better
	end
end

function beastSchool:update(dt)
	--update all beasts in list
	local i =1 
	for i = 1, #self.school do
		self.school[i]:update(dt)  --update
		--check for boundary exits
		self:checkBoundary(self.school[i])
	end
	
	--collision check
	self:mackTest()
end



function beastSchool:draw()
	local i =1 
	for i = 1, #self.school do
		self.school[i]:draw()
	end
end



return beastSchool  --aaaaaaaaugh