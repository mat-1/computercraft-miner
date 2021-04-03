import * as state from './state'
import * as vec3 from './vec3'
import * as world from './world'
import * as movement from './movement'

/** get the most optimal direction for getting to a position */
export function _getDirectionTo(position: vec3.Vec3, preferVisited?: boolean): vec3.DirectionUp {
	let allowedDirections: vec3.DirectionUp[] = []

	// we can only go in directions that will help us get there more efficiently
	if (preferVisited) {
		if (position.north > state.currentPosition.north) allowedDirections.push('north')
		if (position.north < state.currentPosition.north) allowedDirections.push('south')
		if (position.east > state.currentPosition.east) allowedDirections.push('east')
		if (position.east < state.currentPosition.east) allowedDirections.push('west')
		if (position.up > state.currentPosition.up) allowedDirections.push('up')
		if (position.up < state.currentPosition.up) allowedDirections.push('down')
	} else {
		if (position.north + 2 >= state.currentPosition.north) allowedDirections.push('north')
		if (position.north - 2 <= state.currentPosition.north) allowedDirections.push('south')
		if (position.east + 2 >= state.currentPosition.east) allowedDirections.push('east')
		if (position.east - 2 <= state.currentPosition.east) allowedDirections.push('west')
		if (position.up + 2 >= state.currentPosition.up) allowedDirections.push('up')
		if (position.up - 2 <= state.currentPosition.up) allowedDirections.push('down')
	}

	let bestDirection: vec3.DirectionUp = null
	let bestDirectionScore = -999

	// find the direction with the best score
	// the score is calculated as unknown adjacent blocks, and +1 if it's already headed in this direction
	// note: unknown adjacent blocks is negative if preferVisited is true
	for (const direction of allowedDirections) {
		let theoreticalPosition = state.getPositionForDirection(direction)
		let directionScore = 0

		let unknownBlocksAround = world.countUnknownBlocksAround(state.getPositionForDirection(direction))

		if (preferVisited) {
			if (direction === 'up' || direction === 'down') {
				directionScore -= unknownBlocksAround / 4
			} else
				directionScore -= unknownBlocksAround
		}
		else {
			if (direction === 'up' || direction === 'down') {
				directionScore += unknownBlocksAround / 4
			} else
				directionScore += unknownBlocksAround / 1.2
		}

		// add 1 to the score if we're already headed in this direction

		if (direction == state.currentDirection) directionScore += 1
	
		if (direction === 'north' && position.north > state.currentPosition.north) directionScore += 1.1
		else if (direction === 'south' && position.north < state.currentPosition.north) directionScore += 1.1
		else if (direction === 'east' && position.east > state.currentPosition.east) directionScore += 1.1
		else if (direction === 'west' && position.east < state.currentPosition.east) directionScore += 1.1
		else if (direction === 'up' && position.up > state.currentPosition.up) directionScore += 1.1
		else if (direction === 'down' && position.up > state.currentPosition.up) directionScore += 1.1

		directionScore -= vec3.getDistanceTo(position, theoreticalPosition) / 2
	
	
		// this direction is better than the one we know of, replace it
		if (directionScore > bestDirectionScore) {
			bestDirectionScore = directionScore
			bestDirection = direction
		}
	}

	let bestUnknownBlocksAround = world.countUnknownBlocksAround(state.getPositionForDirection(bestDirection), true)
	console.log('best:', bestUnknownBlocksAround)

	return bestDirection
}

/** get the most optimal direction for getting to a position */
export function getDirectionTo(position: vec3.Vec3, preferVisited?: boolean, nextTo?: boolean): vec3.DirectionUp {
	let allowedDirections: vec3.DirectionUp[] = []

	// we can only go in directions that will help us get there more efficiently
	if (preferVisited) {
		if (position.north > state.currentPosition.north) allowedDirections.push('north')
		if (position.north < state.currentPosition.north) allowedDirections.push('south')
		if (position.east > state.currentPosition.east) allowedDirections.push('east')
		if (position.east < state.currentPosition.east) allowedDirections.push('west')
		if (position.up > state.currentPosition.up) allowedDirections.push('up')
		if (position.up < state.currentPosition.up) allowedDirections.push('down')
	} else {
		if (position.north + 2 >= state.currentPosition.north) allowedDirections.push('north')
		if (position.north - 2 <= state.currentPosition.north) allowedDirections.push('south')
		if (position.east + 2 >= state.currentPosition.east) allowedDirections.push('east')
		if (position.east - 2 <= state.currentPosition.east) allowedDirections.push('west')
		if (position.up + 2 >= state.currentPosition.up) allowedDirections.push('up')
		if (position.up - 2 <= state.currentPosition.up) allowedDirections.push('down')
	}

	let bestDirection: vec3.DirectionUp = null
	let bestDirectionScore = -999

	// find the direction with the best score
	// the score is calculated as unknown adjacent blocks, and +1 if it's already headed in this direction
	// note: unknown adjacent blocks is negative if preferVisited is true
	for (const direction of allowedDirections) {
		let theoreticalPosition = state.getPositionForDirection(direction)
		let directionScore = 0

		let unknownBlocksAround = world.countUnknownBlocksAround(state.getPositionForDirection(direction))

		if (preferVisited) {
			if (direction === 'up' || direction === 'down') {
				directionScore -= unknownBlocksAround / 4
			} else
				directionScore -= unknownBlocksAround
		}
		else {
			if (direction === 'up' || direction === 'down') {
				directionScore += unknownBlocksAround / 4
			} else
				directionScore += unknownBlocksAround / 1.2
		}

		// add 1 to the score if we're already headed in this direction

		if (direction == state.currentDirection) directionScore += 1
	
		if (direction === 'north' && position.north > state.currentPosition.north) directionScore += 1.1
		else if (direction === 'south' && position.north < state.currentPosition.north) directionScore += 1.1
		else if (direction === 'east' && position.east > state.currentPosition.east) directionScore += 1.1
		else if (direction === 'west' && position.east < state.currentPosition.east) directionScore += 1.1
		else if (direction === 'up' && position.up > state.currentPosition.up) directionScore += 1.1
		else if (direction === 'down' && position.up > state.currentPosition.up) directionScore += 1.1

		directionScore -= vec3.getDistanceTo(position, theoreticalPosition) / 2
	
	
		// this direction is better than the one we know of, replace it
		if (directionScore > bestDirectionScore) {
			bestDirectionScore = directionScore
			bestDirection = direction
		}
	}

	let bestUnknownBlocksAround = world.countUnknownBlocksAround(state.getPositionForDirection(bestDirection), true)
	console.log('best:', bestUnknownBlocksAround)

	return bestDirection
}

export function goto(position: vec3.Vec3) {
	while (!(
		state.currentPosition.north === position.north
		&& state.currentPosition.east === position.east
		&& state.currentPosition.up === position.up
	)) {
		const recommendedDirection = getDirectionTo(position, true)
		movement.digInDirection(recommendedDirection)
		movement.moveInDirection(recommendedDirection)
	}
}
