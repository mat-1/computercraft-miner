/** @noResolution */

export interface Position {
	north: number
	east: number
	up: number
}

export function makeCoordinate(north: number, up: number, east: number): Position {
	return { north: north, east: east, up: up}
}

export function stringifyPosition(position: Position): string {
	if (position)
		return `${position.north},${position.up},${position.east}`
	else
		return '?,?,?'
}

export function unstringifyPosition(position: string): Position {
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

export let currentPosition = loadPosition()

export function savePosition(position: Position) {
	currentPosition = position
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


export let world: { [ key: string ]: string } = loadWorld()

export function saveWorld() {
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

export type Direction = 'north' | 'east' | 'south' | 'west'
export type DirectionUp = Direction | 'up' | 'down'

export const ORES = [
	'minecraft:coal_ore',
	'minecraft:iron_ore',
	'minecraft:gold_ore',
	'minecraft:lapis_ore',
	'minecraft:diamond_ore',
	'minecraft:redstone_ore',
	'minecraft:emerald_ore',
]

// add to this if you have your own mods that add underground stuff
export const UNDERGROUND_MINEABLE = [
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



export let currentDirection: Direction = loadDirection()

function saveDirection() {
	const [ file, reason ] = fs.open('direction.txt', 'w')
	file.write(currentDirection)
	file.close()
}


/** get the coordinates for if the turtle were to move in a certain direction */
export function getCoordinatesForDirection(dir: DirectionUp): Position {
	const directionOffsets = DIRECTIONS_OFFSETS[dir]
	return {
		north: currentPosition.north + directionOffsets.north,
		east: currentPosition.east + directionOffsets.east,
		up: currentPosition.up + directionOffsets.up,
	}
}

export function setBlock(position: Position, block: string) {
	world[stringifyPosition(position)] = block
}

export function getBlock(position: Position): string {
	return world[stringifyPosition(position)]
}

// the spawn coordinates are guaranteed to be air because the turtle is there
setBlock(makeCoordinate(0, 0, 0), 'minecraft:air')

/** face a specific direction */
export function turnInDirection(dir: Direction) {
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
export function inspectInDirection(dir: DirectionUp) {
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
export function isDirectionVisitedAir(dir: DirectionUp) {
	const directionCoordinates = getCoordinatesForDirection(dir)

	if (getBlock(directionCoordinates))
		return getBlock(directionCoordinates) == 'minecraft:air'
	else
		return false
}

function getDistanceTo(position: Position, position2: Position): number {
	return Math.abs(position.north - position2.north)
		 + Math.abs(position.east - position2.east)
		 + Math.abs(position.up - position2.up)
}

export function findNearestBlockPosition(blocks: string[], height?: number, center?: Position): Position | null {
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


export function scanAround(blocks?: string[]): Position | null {
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
	if (blocks)
		return findNearestBlockPosition(blocks)
	else
		return null
}

