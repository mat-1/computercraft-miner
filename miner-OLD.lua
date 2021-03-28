-- makes vsc stop giving warnings
turtle = turtle

turtle.refuel()

-- makes a coordinate pair for the specific coords
local function makeCoordinate(north, up, east)
	return { north = north, east = east, up = up}
end

local TOTAL_SLOTS = 4 * 4 -- the bot's inventory is a 4x4 grid

local function refuelAll()
	local couldRefuel = false
	for i = 1, TOTAL_SLOTS do
		turtle.select(i)
		local r = turtle.refuel()
		if r then
			couldRefuel = true
		end
	end
	if couldRefuel then
		print('Refueled turtle!')
	else
		print('Couldn\'t find any fuel :(')
	end
	turtle.select(1)
end

local function stringifyPosition(position)
	if position then
		return tostring(position.north)..','..tostring(position.up)..','..tostring(position.east)
	else
		return '???'
	end
end

local function unstringifyPosition(position)
	local i = 0
	local north = nil
	local up = nil
	local east = nil

	for n in string.gmatch(position, '([^,]+)') do
		i = i + 1
		if i == 1 then north = tonumber(n)
		elseif i == 2 then up = tonumber(n)
		elseif i == 3 then east = tonumber(n)
		end
	end

	return makeCoordinate(north, up, east)
end



function loadPosition()
	local file = fs.open('position.txt', 'r')
	local data
	if file == nil then
		return makeCoordinate(0, 0, 0)
	else
		data = file.readAll()
		file.close()
		return unstringifyPosition(data)
	end
end

local currentPosition = loadPosition()

function savePosition()
	local file = fs.open('position.txt', 'w')
	file.write(stringifyPosition(currentPosition))
	file.close()
end


function loadWorld()
	local file = fs.open('world.txt', 'r')
	local data
	if file == nil then
		return {}
	else
		data = file.readAll()
		file.close()
		return textutils.unserialize(data)
	end
end


-- { coordinate: block } pair for the world
local world = loadWorld()

function saveWorld()
	local file = fs.open('world.txt', 'w')
	file.write(textutils.serialize(world))
	file.close()
end




local DIRECTIONS_OFFSETS = {
	north = makeCoordinate(1, 0, 0),
	south = makeCoordinate(-1, 0, 0),

	east = makeCoordinate(0, 0, 1),
	west = makeCoordinate(0, 0, -1),

	up = makeCoordinate(0, 1, 0),
	down = makeCoordinate(0, -1, 0),
}


local ORES = {
	'minecraft:coal_ore',
	'minecraft:iron_ore',
	'minecraft:gold_ore',
	'minecraft:lapis_ore',
	'minecraft:diamond_ore',
	'minecraft:redstone_ore',
	'minecraft:emerald_ore',
}

local UNDERGROUND_MINEABLE = {
	'minecraft:stone',
	'minecraft:cobblestone',
	'minecraft:andesite',
	'minecraft:granite',
	'minecraft:diorite',
	'minecraft:obsidian',
	'minecraft:dirt',

	'crumbs:cobbled_andesite',
	'crumbs:cobbled_granite',
	'crumbs:cobbled_diorite',

	'wild_explorer:blunite',
	'wild_explorer:carbonite',

	'blockus:bluestone',
}



function loadDirection()
	local file = fs.open('direction.txt', 'r')
	local data
	if file == nil then
		return 'north'
	else
		data = file.readAll()
		file.close()
		return data
	end
end

local currentDirection = loadDirection()

function saveDirection()
	local file = fs.open('direction.txt', 'w')
	file.write(currentDirection)
	file.close()
end


local function reverseDirection(dir)
	-- TODO: make this a table
	if dir == 'north' then return 'south'
	elseif dir == 'south' then return 'north'
	elseif dir == 'east' then return 'west'
	elseif dir == 'west' then return 'east'
	end
end


-- get the coordinates for if the turtle were to move in a certain direction
local function getCoordinatesForDirection(dir)
	local directionOffsets = DIRECTIONS_OFFSETS[dir]
	return {
		north = currentPosition.north + directionOffsets.north,
		east = currentPosition.east + directionOffsets.east,
		up = currentPosition.up + directionOffsets.up,
	}
end



local function setBlock(position, block)
	world[stringifyPosition(position)] = block
end

local function getBlock(position)
	return world[stringifyPosition(position)]
end

-- the spawn coordinates are guaranteed to be air because the turtle is there
setBlock(makeCoordinate(0, 0, 0), 'minecraft:air')



-- face a specific direction (north south east west)
local function turnInDirection(dir)
	local previousDirection = currentDirection
	currentDirection = dir
	saveDirection()

	if dir == previousDirection then return
	-- we're headed in the opposite direction, turn twice
	elseif dir == reverseDirection(previousDirection) then turtle.turnRight() turtle.turnRight()

	elseif previousDirection == 'east' and dir == 'north' then turtle.turnLeft()
	elseif previousDirection == 'west' and dir == 'north' then turtle.turnRight()

	elseif previousDirection == 'east' and dir == 'south' then turtle.turnRight()
	elseif previousDirection == 'west'  and dir == 'south' then turtle.turnLeft()

	elseif previousDirection == 'north' and dir == 'east' then turtle.turnRight()
	elseif previousDirection == 'south' and dir == 'east' then turtle.turnLeft()

	elseif previousDirection == 'north' and dir == 'west' then turtle.turnLeft()
	elseif previousDirection == 'south' and dir == 'west' then turtle.turnRight()

	else
		error('ERROR: unknown turn direction "'..tostring(dir)..'"')
		currentDirection = previousDirection
		saveDirection()
		return
	end
end


-- inspect the block in a certain direction, these are cached
local function inspectInDirection(dir)
	print('inspectInDirection '..tostring(dir)..' '..stringifyPosition(currentPosition))
	local directionCoordinates = getCoordinatesForDirection(dir)

	-- we've already inspected here, no need to inspect again
	if getBlock(directionCoordinates) then
		return getBlock(directionCoordinates)
	end

	local success, block, blockName

	if dir == 'up' then
		success, block = turtle.inspectUp()
	elseif dir == 'down' then
		success, block = turtle.inspectDown()
	else
		-- turn in the direction of the block we're inspecting and inspect it
		turnInDirection(dir)
		success, block = turtle.inspect()
	end

	-- success is false if the block is air
	if (success == false) then
		blockName = 'minecraft:air'
	else
		blockName = block.name
	end

	-- save the block to the world so we know not to check again later
	setBlock(directionCoordinates, blockName)

	return block
end

-- returns true if we are certain the block in this direction is air
local function isDirectionVisitedAir(dir)
	print('isDirectionVisitedAir '..tostring(dir))
	local directionCoordinates = getCoordinatesForDirection(dir)
	if getBlock(directionCoordinates) then
		return getBlock(directionCoordinates) == 'minecraft:air'
	end
	return nil
end


local digInDirection

-- move in a specific direction (north south east west)
local function moveInDirection(dir)
	local success, reason

	local previousPosition = currentPosition
	print('moveInDirection '..tostring(dir))
	currentPosition = getCoordinatesForDirection(dir)
	savePosition()


	if dir == 'up' then
		success, reason = turtle.up()
	elseif dir == 'down' then
		success, reason = turtle.down()
	else
		turnInDirection(dir)
		success, reason = turtle.forward()
	end

	
	if (success) then
		-- since we moved to the block, we know it's air
		setBlock(currentPosition, 'minecraft:air')
	else
		currentPosition = previousPosition
		savePosition()

		if reason == 'Out of fuel' then
			refuelAll()
		elseif reason == 'Movement obstructed' then
			inspectInDirection(dir)
			digInDirection(dir)
		end
		print('Error moving: '..reason)
	end
end

-- get the most optimal direction for getting to a position
local function getDirectionTo(position, preferVisited)
	local canGoNorth = position.north > currentPosition.north
	local canGoSouth = position.north < currentPosition.north
	local canGoEast = position.east > currentPosition.east
	local canGoWest = position.east < currentPosition.east
	local canGoUp = position.up > currentPosition.up
	local canGoDown = position.up < currentPosition.up

	if preferVisited == true then
		if (canGoUp and currentDirection == 'up' and isDirectionVisitedAir('up')) then return 'up'
		elseif (canGoDown and currentDirection == 'down' and isDirectionVisitedAir('down')) then return 'down'
		elseif (canGoNorth and currentDirection == 'north' and isDirectionVisitedAir('north')) then return 'north'
		elseif (canGoSouth and currentDirection == 'south' and isDirectionVisitedAir('south')) then return 'south'
		elseif (canGoEast and currentDirection == 'east' and isDirectionVisitedAir('east')) then return 'east'
		elseif (canGoWest and currentDirection == 'west' and isDirectionVisitedAir('west')) then return 'west'


		elseif (canGoUp and isDirectionVisitedAir('up')) then return 'up'
		elseif (canGoDown and isDirectionVisitedAir('down')) then return 'down'
		elseif (canGoNorth and isDirectionVisitedAir('north')) then return 'north'
		elseif (canGoSouth and isDirectionVisitedAir('south')) then return 'south'
		elseif (canGoEast and isDirectionVisitedAir('east')) then return 'east'
		elseif (canGoWest and isDirectionVisitedAir('west')) then return 'west'
		end
	else
		if (canGoUp and currentDirection == 'up' and not isDirectionVisitedAir('up')) then return 'up'
		elseif (canGoDown and currentDirection == 'down' and not isDirectionVisitedAir('down')) then return 'down'
		elseif (canGoNorth and currentDirection == 'north' and not isDirectionVisitedAir('north')) then return 'north'
		elseif (canGoSouth and currentDirection == 'south' and not isDirectionVisitedAir('south')) then return 'south'
		elseif (canGoEast and currentDirection == 'east' and not isDirectionVisitedAir('east')) then return 'east'
		elseif (canGoWest and currentDirection == 'west' and not isDirectionVisitedAir('west')) then return 'west'


		elseif (canGoUp and not isDirectionVisitedAir('up')) then return 'up'
		elseif (canGoDown and not isDirectionVisitedAir('down')) then return 'down'
		elseif (canGoNorth and not isDirectionVisitedAir('north')) then return 'north'
		elseif (canGoSouth and not isDirectionVisitedAir('south')) then return 'south'
		elseif (canGoEast and not isDirectionVisitedAir('east')) then return 'east'
		elseif (canGoWest and not isDirectionVisitedAir('west')) then return 'west'
		end
	end


	if (canGoUp and currentDirection == 'up') then return 'up'
	elseif (canGoDown and currentDirection == 'down') then return 'down'
	elseif (canGoNorth and currentDirection == 'north') then return 'north'
	elseif (canGoSouth and currentDirection == 'south') then return 'south'
	elseif (canGoEast and currentDirection == 'east') then return 'east'
	elseif (canGoWest and currentDirection == 'west') then return 'west'


	elseif (canGoUp) then return 'up'
	elseif (canGoDown) then return 'down'
	elseif (canGoNorth) then return 'north'
	elseif (canGoSouth) then return 'south'
	elseif (canGoEast) then return 'east'
	elseif (canGoWest) then return 'west'

	end
end

local function isInventoryFull()
	return turtle.getItemCount(TOTAL_SLOTS) > 0
end

local depositAllAtSpawn

local function suckInDirection(dir)
	local success, reason

	if dir == 'up' then
		success, reason = turtle.suckUp()
	elseif dir == 'down' then
		success, reason = turtle.suckDown()
	else
		turnInDirection(dir)
		success, reason = turtle.suck()
	end

	if isInventoryFull() then
		depositAllAtSpawn()
	end
end


-- move in a specific direction (north south east west)
digInDirection = function(dir)
	local success, reason

	if dir == 'up' then
		success, reason = turtle.digUp()
	elseif dir == 'down' then
		success, reason = turtle.digDown()
	else
		print('digInDirection '..tostring(dir))
		turnInDirection(dir)
		success, reason = turtle.dig()
	end

	if (success == false) then
		if (reason ~= 'Nothing to dig here') then
			error('Error digging: '..reason)
		end
	else
		suckInDirection(dir)
	end

	print('digInDirection '..tostring(dir))
	local blockPosition = getCoordinatesForDirection(dir)

	-- it broke the block, so it's air now
	setBlock(blockPosition, 'minecraft:air')
end


-- return to 0, 0, 0
local function returnToSpawn()
	-- remove the current position

	local spawnPosition = makeCoordinate(0, 0, 0)

	while (currentPosition.north ~= 0 or currentPosition.east ~= 0 or currentPosition.up ~= 0) do
		local recommendedDirection = getDirectionTo(spawnPosition, true)
		digInDirection(recommendedDirection)
		moveInDirection(recommendedDirection)
	end
	
	turnInDirection('north')
end


local function arrayContains(item, items)
	for _, arrayItem in pairs(items) do
		if (item == arrayItem) then
			return true
		end
	end
	return false
end


local function getDistanceTo(position, position2)
	return
		math.abs(position.north - position2.north)
		+ math.abs(position.east - position2.east)
		+ math.abs(position.up - position2.up)
end


-- find the nearest blocks it currently knows of
local function findNearestBlockPosition(blocks, height, center)
	if center == nil then
		center = currentPosition
	end
	local nearestOreDistance = 99999
	local nearestOrePosition = nil

	for blockPositionString, block in pairs(world) do
		if arrayContains(block, blocks) then
			local blockPosition = unstringifyPosition(blockPositionString)
			if (height == nil or height == blockPosition.up) and (blockPositionString ~= stringifyPosition(currentPosition)) then
				local blockDistance = getDistanceTo(blockPosition, center)

				if (blockDistance < nearestOreDistance) then
					nearestOreDistance = blockDistance
					nearestOrePosition = blockPosition
				end

			end
		end
	end
	return nearestOrePosition
end


local function scanForOres()
	-- If we've already scanned east, scan west. This saves a bit of time while turning

	local forward = currentDirection
	local left, right, back
	if forward == 'north' then
		left = 'west'
		right = 'east'
		back = 'south'
	elseif forward == 'east' then
		left = 'north'
		right = 'south'
		back = 'west'
	elseif forward == 'south' then
		left = 'east'
		right = 'west'
		back = 'north'
	elseif forward == 'west' then
		left = 'south'
		right = 'north'
		back = 'east'
	end

	inspectInDirection('up')
	inspectInDirection('down')

	print('scanForOres '..tostring(right)..' '..tostring(currentDirection))
	if getBlock(getCoordinatesForDirection(right)) then
		inspectInDirection(forward)
		inspectInDirection(left)
		inspectInDirection(back)
	else
		inspectInDirection(forward)
		inspectInDirection(right)
		inspectInDirection(back)
		inspectInDirection(left)
	end


	-- we inspected in all directions, now return the nearest ore (if there is one)
	return findNearestBlockPosition(ORES)
end


local function returnToStartingHeight()
	-- already at the correct height, just return
	if (currentPosition.up == 0) then return end

	if currentPosition.up > 0 then
		for _ = 1, currentPosition.up do
			digInDirection('down')
			moveInDirection('down')
		end
	elseif currentPosition.up < 0 then
		for _ = 1, -currentPosition.up do
			digInDirection('up')
			moveInDirection('up')
		end
	end
end

local function positionBetween(position1, position2)
	return makeCoordinate(
		(position1.north + position2.north) / 2,
		(position1.up + position2.up) / 2,
		(position1.east + position2.east) / 2
	)
end

depositAllAtSpawn = function()
	returnToSpawn()

	for i = 1, TOTAL_SLOTS do
		turtle.select(i)
		turtle.refuel()
		turtle.dropDown()
	end
	turtle.select(1)
end

print('ok starting')

if isInventoryFull() then
	depositAllAtSpawn()
end

while true do
	local nearestOrePosition = scanForOres()

	if (nearestOrePosition) then
		print('To '..stringifyPosition(nearestOrePosition))
		local recommendedDirection = getDirectionTo(nearestOrePosition)
		digInDirection(recommendedDirection)
		moveInDirection(recommendedDirection)
	else
		returnToStartingHeight()
		-- local nearestMineablePosition = findNearestBlockPosition(UNDERGROUND_MINEABLE, 0, positionBetween(currentPosition, makeCoordinate(0, 0, 0)))
		local nearestMineablePosition = findNearestBlockPosition(UNDERGROUND_MINEABLE, 0, makeCoordinate(0, 0, 0))
		local recommendedDirection
		if (nearestMineablePosition ~= nil) then
			recommendedDirection = getDirectionTo(nearestMineablePosition)
		else
			recommendedDirection = 'north'
		end
		print('.To '..stringifyPosition(nearestMineablePosition)..' '..tostring(recommendedDirection))
		digInDirection(recommendedDirection)
		moveInDirection(recommendedDirection)
	end

	-- digging up/down is cheap and it makes it easier to follow the turtle so we might as well
	if (currentPosition.up == 0) then
		inspectInDirection('up')
		print('main up')
		local upBlock = getBlock(getCoordinatesForDirection('up'))
		if arrayContains(upBlock, UNDERGROUND_MINEABLE) then
			digInDirection('up')
		end
	end


	saveWorld()
end


