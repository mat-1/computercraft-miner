interface Position {
	north: number
	east: number
	up: number
}

function makeCoordinate(north: number, up: number, east: number): Position {
	return { north: north, east: east, up: up}
}

const TOTAL_SLOTS = 4 * 4

function refuelAll() {
	let couldRefuel = false
	for (let i = 1; i < TOTAL_SLOTS; i++) {
		turtle.select(i)
		let r = turtle.refuel()
		if (r)
			couldRefuel = true
	}
	if (couldRefuel)
		console.log('Refueled turtle!')
	else
		console.log('Couldn\'t find any fuel :(')
	turtle.select(1)
}

function stringifyPosition(position: Position): string {
	if (position)
		return `${position.north},${position.up},${position.east}`
	else
		return '?,?,?'
}

function unstringifyPosition(position: string): Position {
	let [ north, up, east ] = position.split(',')

	return makeCoordinate(parseInt(north), parseInt(up), parseInt(east))
}

function loadPosition() {
	let [ file ] = fs.open('position.txt', 'r')
	let data
	if (file == null) {
		return makeCoordinate(0, 0, 0)
	} else {
		data = file.readAll()
		file.close()
		return unstringifyPosition(data)
	}
}

let currentPosition = loadPosition()

function savePosition() {
	let [ file ] = fs.open('position.txt', 'w')
	if (file != null) {
		file.write(stringifyPosition(currentPosition))
		file.close()
	}
}

function loadWorld() {
	let [ file ] = fs.open('world.txt', 'r')
	let data
	if (file == null) {
		return {}
	} else {
		data = file.readAll()
		file.close()
		return textutils.unserialize(data)
	}
}


let world: { [ key: string ]: string } = loadWorld()

function saveWorld() {
	let [ file ] = fs.open('world.txt', 'w')
	file.write(textutils.serialize(world))
	file.close()
}

const DIRECTIONS_OFFSETS = {
	north: makeCoordinate(1, 0, 0),
	south: makeCoordinate(-1, 0, 0),

	east: makeCoordinate(0, 0, 1),
	west: makeCoordinate(0, 0, -1),

	up: makeCoordinate(0, 1, 0),
	down: makeCoordinate(0, -1, 0),
}

const directionsBack = {
	north: 'south',
	south: 'north',
	east: 'west',
	west: 'east',
	up: 'down',
	down: 'up',
}

const directionsRight = {
	north: 'east',
	south: 'west',
	east: 'south',
	west: 'north',
}

const directionsLeft = {
	north: 'west',
	south: 'east',
	east: 'north',
	west: 'south',
}

type Direction = 'north' | 'east' | 'south' | 'west'
type DirectionUp = Direction | 'up' | 'down'

const ORES = [
	'minecraft:coal_ore',
	'minecraft:iron_ore',
	'minecraft:gold_ore',
	'minecraft:lapis_ore',
	'minecraft:diamond_ore',
	'minecraft:redstone_ore',
	'minecraft:emerald_ore',
]

// add to this if you have your own mods that add underground stuff
const UNDERGROUND_MINEABLE = [
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
]

function loadDirection(): Direction {
	const [ file ] = fs.open('direction.txt', 'r')
	if (file === null) {
		return 'north'
	} else {
		const data = file.readAll()
		file.close()
		return data as Direction
	}
}



let currentDirection: Direction = loadDirection()

function saveDirection() {
	const [ file, reason ] = fs.open('direction.txt', 'w')
	file.write(currentDirection)
	file.close()
}


/** get the coordinates for if the turtle were to move in a certain direction */
function getCoordinatesForDirection(dir: DirectionUp): Position {
	const directionOffsets = DIRECTIONS_OFFSETS[dir]
	return {
		north: currentPosition.north + directionOffsets.north,
		east: currentPosition.east + directionOffsets.east,
		up: currentPosition.up + directionOffsets.up,
	}
}

function setBlock(position: Position, block: string) {
	world[stringifyPosition(position)] = block
}

function getBlock(position: Position): string {
	return world[stringifyPosition(position)]
}

// the spawn coordinates are guaranteed to be air because the turtle is there
setBlock(makeCoordinate(0, 0, 0), 'minecraft:air')

/** face a specific direction */
function turnInDirection(dir: Direction) {
	let previousDirection = currentDirection
	currentDirection = dir
	saveDirection()

	if (dir == previousDirection) return
	else if (dir == directionsBack[previousDirection]) { turtle.turnRight(); turtle.turnRight() }
	else if (dir == directionsLeft[previousDirection]) { turtle.turnRight() }
	else if (dir == directionsRight[previousDirection]) { turtle.turnLeft() }

	else {
		currentDirection = previousDirection
		saveDirection()
		throw `ERROR: unknown turn direction "${dir}"`
	}
}


/** inspect the block in a certain direction, these are cached */
function inspectInDirection(dir: DirectionUp) {
	let directionCoordinates = getCoordinatesForDirection(dir)

	// we've already inspected here, no need to inspect again
	if (getBlock(directionCoordinates))
		return getBlock(directionCoordinates)

	let inspectResponse: [ boolean, string | Block ] = null


	if (dir == 'up') {
		inspectResponse = turtle.inspectUp()
	} else if (dir == 'down') {
		inspectResponse = turtle.inspectDown()
	} else {
		// turn in the direction of the block we're inspecting and inspect it
		turnInDirection(dir)
		inspectResponse = turtle.inspect()
	}

	if (typeof inspectResponse[1] === 'string')
		return

	const success: boolean = inspectResponse[0]
	const block: Block = inspectResponse[1]

	// success is false if the block is air
	const blockName: string = success ? block.name : 'minecraft:air'

	// save the block to the world so we know not to check again later
	setBlock(directionCoordinates, blockName)

	return block
}


/** returns true if we are certain the block in this direction is air */
 function isDirectionVisitedAir(dir: DirectionUp) {
	const directionCoordinates = getCoordinatesForDirection(dir)

	if (getBlock(directionCoordinates))
		return getBlock(directionCoordinates) == 'minecraft:air'
	else
		return false
}


/** move in a specific direction (north south east west) */
function moveInDirection(dir: DirectionUp) {
	let success, reason

	let previousPosition = currentPosition

	currentPosition = getCoordinatesForDirection(dir)
	savePosition()


	if (dir == 'up')
		[ success, reason ] = turtle.up()
	else if (dir == 'down')
		[ success, reason ] = turtle.down()
	else {
		turnInDirection(dir)
		;[ success, reason ] = turtle.forward()
	}

	
	if (success) {
		// since we moved to the block, we know it's air
		setBlock(currentPosition, 'minecraft:air')
	} else {
		currentPosition = previousPosition
		savePosition()

		if (reason == 'Out of fuel')
			refuelAll()
		else if (reason == 'Movement obstructed') {
			inspectInDirection(dir)
			digInDirection(dir)
		}
		console.log(`Error moving: ${reason}`)
	}
}

/** get the most optimal direction for getting to a position */
function getDirectionTo(position: Position, preferVisited?: boolean) {
	let allowedDirections: DirectionUp[] = []

	if (position.north > currentPosition.north) allowedDirections.push('north')
	if (position.north < currentPosition.north) allowedDirections.push('south')
	
	if (position.east > currentPosition.east) allowedDirections.push('east')
	if (position.east < currentPosition.east) allowedDirections.push('west')
	
	if (position.up > currentPosition.up) allowedDirections.push('up')
	if (position.up < currentPosition.up) allowedDirections.push('down')


	if (allowedDirections.length == 0)
		throw 'Already here, no direction'

	else if (preferVisited) {
		for (const direction of allowedDirections) {
			if (currentDirection == direction && isDirectionVisitedAir(direction))
				return direction
		}
		for (const direction of allowedDirections) {
			if (isDirectionVisitedAir(direction))
				return direction
		}
	} else {
		for (const direction of allowedDirections) {
			if (currentDirection == direction && !isDirectionVisitedAir(direction))
				return direction
		}
		for (const direction of allowedDirections) {
			if (!isDirectionVisitedAir(direction))
				return direction
		}
	}

	for (const direction of allowedDirections) {
		if (currentDirection == direction && currentDirection == direction)
			return direction
	}

	return allowedDirections[0]
}

function isInventoryFull() {
	return turtle.getItemCount(TOTAL_SLOTS) > 0
}

function suckInDirection(dir) {
	let success, reason

	if (dir == 'up')
		[ success, reason ] = turtle.suckUp()
	else if (dir == 'down')
		[ success, reason ] = turtle.suckDown()
	else {
		turnInDirection(dir)
		;[ success, reason ] = turtle.suck()
	}

	if (isInventoryFull())
		depositAllAtSpawn()
}

// move in a specific direction (north south east west)
function digInDirection(dir) {
	let success, reason

	if (dir == 'up')
		[ success, reason ] = turtle.digUp()
	else if (dir == 'down')
		[ success, reason ] = turtle.digDown()
	else {
		turnInDirection(dir)
		;[ success, reason ] = turtle.dig()
	}

	if (!success)
		if (reason != 'Nothing to dig here')
			throw `Error digging: ${reason}`
	else
		suckInDirection(dir)

	let blockPosition = getCoordinatesForDirection(dir)

	// it broke the block, so it's air now
	setBlock(blockPosition, 'minecraft:air')
}

// return to 0, 0, 0
function returnToSpawn() {
	// remove the current position

	const spawnPosition = makeCoordinate(0, 0, 0)

	while (!(currentPosition.north === 0 && currentPosition.east === 0 && currentPosition.up === 0)) {
		const recommendedDirection = getDirectionTo(spawnPosition, true)
		digInDirection(recommendedDirection)
		moveInDirection(recommendedDirection)
	}
	
	turnInDirection('north')
}

function getDistanceTo(position: Position, position2: Position): number {
	return
		Math.abs(position.north - position2.north)
		+ Math.abs(position.east - position2.east)
		+ Math.abs(position.up - position2.up)
}

function findNearestBlockPosition(blocks: string[], height?: number, center?: Position): Position | null {
	if (center === null)
		center = currentPosition

	let nearestOreDistance = 99999
	let nearestOrePosition: Position = null

	for (const [ blockPositionString, block ] of Object.entries(world)) {
		if (blocks.includes(block)) {
			const blockPosition = unstringifyPosition(blockPositionString)
			if (
				(height == null || height === blockPosition.up)
				&& (blockPositionString !== stringifyPosition(currentPosition))
			) {
				const blockDistance = getDistanceTo(blockPosition, center)

				if (blockDistance < nearestOreDistance) {
					nearestOreDistance = blockDistance
					nearestOrePosition = blockPosition
				}

			}
		}
	}
	return nearestOrePosition
}


function scanForOres() {
	// If we've already scanned east, scan west. This saves a bit of time while turning

	const [
		forward,
		left,
		right,
		back
	] = [
		currentDirection as Direction,
		directionsLeft[currentDirection] as Direction,
		directionsRight[currentDirection] as Direction,
		directionsBack[currentDirection] as Direction
	]


	inspectInDirection('up')
	inspectInDirection('down')

	if (getBlock(getCoordinatesForDirection(right))) {
		inspectInDirection(forward)
		inspectInDirection(left)
		inspectInDirection(back)
	} else {
		inspectInDirection(forward)
		inspectInDirection(right)
		inspectInDirection(back)
		inspectInDirection(left)
	}


	// we inspected in all directions, now return the nearest ore (if there is one)
	return findNearestBlockPosition(ORES)
}


function returnToStartingHeight() {
	// already at the correct height, just return
	if (currentPosition.up == 0) return

	if (currentPosition.up > 0) {
		for (let i = 1; i < currentPosition.up; i ++) {
			digInDirection('down')
			moveInDirection('down')
		}
	} else if (currentPosition.up < 0) {
		for (let i = 1; i < -currentPosition.up; i ++) {
			digInDirection('up')
			moveInDirection('up')
		}
	}
}

function positionBetween(position1: Position, position2: Position): Position {
	return makeCoordinate(
		(position1.north + position2.north) / 2,
		(position1.up + position2.up) / 2,
		(position1.east + position2.east) / 2
	)
}

function depositAllAtSpawn() {
	returnToSpawn()

	for (let i = 1; i < TOTAL_SLOTS; i ++) {
		turtle.select(i)
		turtle.refuel()
		turtle.dropDown()
	}

	turtle.select(1)
}


if (isInventoryFull())
	depositAllAtSpawn()


while (true) {
	const nearestOrePosition = scanForOres()
	console.log('aight nearestOrePosition')

	if (nearestOrePosition) {
		console.log(`To ${stringifyPosition(nearestOrePosition)}`)
		const recommendedDirection = getDirectionTo(nearestOrePosition)
		digInDirection(recommendedDirection)
		moveInDirection(recommendedDirection)
	} else {
		returnToStartingHeight()
		console.log('aight returnToStartingHeight')
		// let nearestMineablePosition = findNearestBlockPosition(UNDERGROUND_MINEABLE, 0, positionBetween(currentPosition, makeCoordinate(0, 0, 0)))
		let nearestMineablePosition = findNearestBlockPosition(UNDERGROUND_MINEABLE, 0, makeCoordinate(0, 0, 0))
		console.log('aight nearestMineablePosition')
		let recommendedDirection
		if (nearestMineablePosition)
			recommendedDirection = getDirectionTo(nearestMineablePosition)
		else
			recommendedDirection = 'north'

		console.log(`.To ${stringifyPosition(nearestMineablePosition)} ${recommendedDirection}`)
		digInDirection(recommendedDirection)
		moveInDirection(recommendedDirection)
	}

	// digging up/down is cheap and it makes it easier to follow the turtle so we might as well
	if (currentPosition.up == 0) {
		inspectInDirection('up')
		console.log('main up')
		let upBlock = getBlock(getCoordinatesForDirection('up'))
		if (UNDERGROUND_MINEABLE.includes(upBlock))
			digInDirection('up')
	}

	saveWorld()
}




















