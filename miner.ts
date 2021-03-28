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

function stringifyPosition(position) {
	if (position)
		return `${position.north},${position.up},${position.east}`
	else
		return '?,?,?'
}

function unstringifyPosition(position: string) {
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
