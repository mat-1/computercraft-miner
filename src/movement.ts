import * as world from './world'
import * as vec3 from './vec3'
import * as state from './state'



/** face a specific direction */
export function turnInDirection(dir: vec3.Direction) {
	let previousDirection = state.currentDirection
	state.saveDirection(dir)

	let [ success, reason ] = [ false, null ]

	if (dir == previousDirection) return
	else if (dir == vec3.directionsBack[previousDirection]) {
		[ success, reason ] = turtle.turnRight()
		turtle.turnRight()
	}
	else if (dir == vec3.directionsLeft[previousDirection]) {
		[ success, reason ] = turtle.turnLeft()
	}
	else if (dir == vec3.directionsRight[previousDirection]) {
		[ success, reason ] = turtle.turnRight()
	}

	else {
		state.saveDirection(previousDirection)
		throw `ERROR: unknown turn direction "${tostring(dir)}"`
	}
	if (!success) {
		state.saveDirection(previousDirection)
		throw `Error turning: ${reason}`
	}
}


export function refuelAll() {
	let couldRefuel = false
	for (let i = 1; i <= 16; i++) {
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


/** move in a specific direction (north south east west) */
export function moveInDirection(dir: vec3.DirectionUp) {
	let success, reason

	let previousPosition = state.currentPosition
	const newPosition = state.getPositionForDirection(dir)

	state.savePosition(newPosition)


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
		world.setBlock(newPosition, 'minecraft:air')
		inspectInDirection(dir)
	} else {
		state.savePosition(previousPosition)

		if (reason == 'Out of fuel')
			refuelAll()
		else if (reason == 'Movement obstructed') {
			scanAround()
			// index.digInDirection(dir)
		}
		console.log(`Error moving: ${reason}`)
	}
}

/** inspect the block in a certain direction, these are cached */
export function inspectInDirection(dir: vec3.DirectionUp) {
	const directionCoordinates = state.getPositionForDirection(dir)

	// we've already inspected here, no need to inspect again
	if (world.getBlock(directionCoordinates))
		return world.getBlock(directionCoordinates)

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

	let block: Block
	const success: boolean = inspectResponse[0]

	if (typeof inspectResponse[1] === 'string') {
		if (inspectResponse[1] === 'No block to inspect') {
			block = { 'name': 'minecraft:air' }
		} else {
			console.log('error inspecting', inspectResponse[1])
			return
		}
	} else {
		block = inspectResponse[1]
	}

	// success is false if the block is air
	const blockName: string = success ? block.name : 'minecraft:air'

	// save the block to the world so we know not to check again later
	world.setBlock(directionCoordinates, blockName)

	return block
}


export function scanAround(blocks?: string[]): vec3.Vec3 | null {
	// If we've already scanned east, scan west. This saves a bit of time while turning

	const [
		forward,
		left,
		right,
		back
	] = [
		state.currentDirection as vec3.Direction,
		vec3.directionsLeft[state.currentDirection] as vec3.Direction,
		vec3.directionsRight[state.currentDirection] as vec3.Direction,
		vec3.directionsBack[state.currentDirection] as vec3.Direction
	]


	inspectInDirection('up')
	inspectInDirection('down')

	// always inspect forward first since we don't have to rotate or anything
	inspectInDirection(forward)

	if (world.getBlock(state.getPositionForDirection(right))) {
		inspectInDirection(left)
		inspectInDirection(back)
	} else {
		inspectInDirection(right)
		inspectInDirection(back)
		inspectInDirection(left)
	}


	// we inspected in all directions, now return the nearest ore (if there is one)
	if (blocks)
		return world.findNearestBlockPosition(blocks)
	else
		return null
}


// move in a specific direction (north south east west)
export function digInDirection(dir) {
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

	let blockPosition = state.getPositionForDirection(dir)

	// it broke the block, so it's air now
	world.setBlock(blockPosition, 'minecraft:air')
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

	state.updateInventoryFull()
}
