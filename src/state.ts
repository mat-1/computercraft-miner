import * as vec3 from './vec3'

function loadPosition() {
	let [ file ] = fs.open('position.txt', 'r')
	let data
	console.log(file)
	if (file == null) {
		return new vec3.Vec3(0, 0, 0)
	} else {
		data = file.readAll()
		file.close()
		return vec3.parse(data)
	}
}

function loadDirection(): vec3.Direction {
	const [ file ] = fs.open('direction.txt', 'r')
	if (file === null) {
		return 'north'
	} else {
		const data = file.readAll()
		file.close()
		return data as vec3.Direction
	}
}

export let currentPosition = loadPosition()

export function savePosition(position: vec3.Vec3) {
	currentPosition = position
	let [ file ] = fs.open('position.txt', 'w')
	if (file != null) {
		file.write(currentPosition.toString())
		file.close()
	}
}



export let currentDirection: vec3.Direction = loadDirection()

export function saveDirection(direction: vec3.Direction) {
	currentDirection = direction
	const [ file, reason ] = fs.open('direction.txt', 'w')
	file.write(currentDirection)
	file.close()
}

/** get the coordinates for if the turtle were to move in a certain direction */
export function getPositionForDirection(dir: vec3.DirectionUp): vec3.Vec3 {
	const directionOffsets = vec3.DIRECTIONS_OFFSETS[dir]
	return currentPosition.plus(directionOffsets.north, directionOffsets.up, directionOffsets.east)
}

export let inventoryFull = false

export function updateInventoryFull() {
	inventoryFull = turtle.getItemCount(4 * 4) > 0
	return inventoryFull
}

export let headingToSpawn = false


export function setHeadingToSpawn(value: boolean) {
	headingToSpawn = value
}
