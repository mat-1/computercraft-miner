/** @noResolution */

import * as world from './world'

const TOTAL_SLOTS = 4 * 4

function refuelAll() {
	let couldRefuel = false
	for (let i = 1; i <= TOTAL_SLOTS; i++) {
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
function moveInDirection(dir: world.DirectionUp) {
	let success, reason

	let previousPosition = world.currentPosition

	world.savePosition(world.getCoordinatesForDirection(dir))


	if (dir == 'up')
		[ success, reason ] = turtle.up()
	else if (dir == 'down')
		[ success, reason ] = turtle.down()
	else {
		world.turnInDirection(dir)
		;[ success, reason ] = turtle.forward()
	}

	
	if (success) {
		// since we moved to the block, we know it's air
		world.setBlock(world.currentPosition, 'minecraft:air')
	} else {
		world.savePosition(previousPosition)

		if (reason == 'Out of fuel')
			refuelAll()
		else if (reason == 'Movement obstructed') {
			world.inspectInDirection(dir)
			digInDirection(dir)
		}
		console.log(`Error moving: ${reason}`)
	}
}

/** get the most optimal direction for getting to a position */
function getDirectionTo(position: world.Position, preferVisited?: boolean) {
	let allowedDirections: world.DirectionUp[] = []

	if (position.north > world.currentPosition.north) allowedDirections.push('north')
	if (position.north < world.currentPosition.north) allowedDirections.push('south')
	
	if (position.east > world.currentPosition.east) allowedDirections.push('east')
	if (position.east < world.currentPosition.east) allowedDirections.push('west')
	
	if (position.up > world.currentPosition.up) allowedDirections.push('up')
	if (position.up < world.currentPosition.up) allowedDirections.push('down')


	if (allowedDirections.length == 0)
		throw 'Already here, no direction'

	else if (preferVisited) {
		for (const direction of allowedDirections) {
			if (world.currentDirection == direction && world.isDirectionVisitedAir(direction))
				return direction
		}
		for (const direction of allowedDirections) {
			if (world.isDirectionVisitedAir(direction))
				return direction
		}
	} else {
		for (const direction of allowedDirections) {
			if (world.currentDirection == direction && !world.isDirectionVisitedAir(direction))
				return direction
		}
		for (const direction of allowedDirections) {
			if (!world.isDirectionVisitedAir(direction))
				return direction
		}
	}

	for (const direction of allowedDirections) {
		if (world.currentDirection == direction && world.currentDirection == direction)
			return direction
	}

	return allowedDirections[0]
}

function isInventoryFull() {
	return turtle.getItemCount(TOTAL_SLOTS) > 0
}

let headingToSpawn = false

function suckInDirection(dir) {
	let success, reason

	if (dir == 'up')
		[ success, reason ] = turtle.suckUp()
	else if (dir == 'down')
		[ success, reason ] = turtle.suckDown()
	else {
		world.turnInDirection(dir)
		;[ success, reason ] = turtle.suck()
	}

	if (isInventoryFull() && !headingToSpawn)
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
		world.turnInDirection(dir)
		;[ success, reason ] = turtle.dig()
	}

	if (!success)
		if (reason != 'Nothing to dig here')
			throw `Error digging: ${reason}`
	else
		suckInDirection(dir)

	let blockPosition = world.getCoordinatesForDirection(dir)

	// it broke the block, so it's air now
	world.setBlock(blockPosition, 'minecraft:air')
}

// return to 0, 0, 0
function returnToSpawn() {
	headingToSpawn = true
	print('Going to spawn...')

	const spawnPosition = world.makeCoordinate(0, 0, 0)

	while (!(world.currentPosition.north === 0 && world.currentPosition.east === 0 && world.currentPosition.up === 0)) {
		const recommendedDirection = getDirectionTo(spawnPosition, true)
		digInDirection(recommendedDirection)
		moveInDirection(recommendedDirection)
	}
	
	world.turnInDirection('north')
	headingToSpawn = false
}


function scanForOres() {
	return world.scanAround(world.ORES)
}


function returnToStartingHeight() {
	// already at the correct height, just return
	if (world.currentPosition.up == 0) return

	if (world.currentPosition.up > 0) {
		for (let i = 1; i < world.currentPosition.up; i ++) {
			digInDirection('down')
			moveInDirection('down')
		}
	} else if (world.currentPosition.up < 0) {
		for (let i = 1; i < -world.currentPosition.up; i ++) {
			digInDirection('up')
			moveInDirection('up')
		}
	}
}

function positionBetween(position1: world.Position, position2: world.Position): world.Position {
	return world.makeCoordinate(
		(position1.north + position2.north) / 2,
		(position1.up + position2.up) / 2,
		(position1.east + position2.east) / 2
	)
}

function depositAllAtSpawn() {
	returnToSpawn()

	for (let i = 1; i <= TOTAL_SLOTS; i ++) {
		turtle.select(i)
		turtle.refuel()
		let [ success, reason ] = turtle.dropDown()
		if (reason) console.log(reason)
	}

	turtle.select(1)
}

print('Ok')

if (isInventoryFull())
	depositAllAtSpawn()


while (true) {
	const nearestOrePosition = scanForOres()

	if (nearestOrePosition) {
		console.log(`To ${world.stringifyPosition(nearestOrePosition)}`)
		const recommendedDirection = getDirectionTo(nearestOrePosition)
		digInDirection(recommendedDirection)
		moveInDirection(recommendedDirection)
	} else {
		returnToStartingHeight()
		// let nearestMineablePosition = findNearestBlockPosition(UNDERGROUND_MINEABLE, 0, positionBetween(currentPosition, makeCoordinate(0, 0, 0)))
		let nearestMineablePosition = world.findNearestBlockPosition(world.UNDERGROUND_MINEABLE, 0, world.makeCoordinate(0, 0, 0))
		let recommendedDirection
		if (nearestMineablePosition)
			recommendedDirection = getDirectionTo(nearestMineablePosition)
		else
			recommendedDirection = 'north'

		console.log(`.To ${world.stringifyPosition(nearestMineablePosition)} ${recommendedDirection}`)
		digInDirection(recommendedDirection)
		moveInDirection(recommendedDirection)
	}

	// digging up/down is cheap and it makes it easier to follow the turtle so we might as well
	if (world.currentPosition.up == 0) {
		world.inspectInDirection('up')
		let upBlock = world.getBlock(world.getCoordinatesForDirection('up'))
		if (world.UNDERGROUND_MINEABLE.includes(upBlock))
			digInDirection('up')
	}

	world.saveWorld()
}





















