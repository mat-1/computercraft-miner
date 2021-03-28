turtle.refuel()

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
	return `${position.north},${position.up},${position.east}`
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


// { coordinate: block } pair for the world
let world = loadWorld()

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

function loadDirection() {
	const [ file ] = fs.open('direction.txt', 'r')
	if (file === null) {
		return 'north'
	} else {
		const data = file.readAll()
		file.close()
		return data
	}
}

let currentDirection = loadDirection()

function saveDirection() {
	const [ file ] = fs.open('direction.txt', 'w')
	file.write(currentDirection)
	file.close()
}

function reverseDirection(dir: string) {
	return directionsBack[dir]
}

/** get the coordinates for if the turtle were to move in a certain direction */
function getCoordinatesForDirection(dir): Position {
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
