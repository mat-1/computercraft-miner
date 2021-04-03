import * as world from './world'
import * as movement from './movement'
import * as vec3 from './vec3'
import * as state from './state'
import * as pathing from './pathing'

const TOTAL_SLOTS = 4 * 4




// return to 0, 0, 0
function returnToSpawn() {
	state.setHeadingToSpawn(true)
	console.log('Going to spawn...')

	const spawnPosition = new vec3.Vec3(0, 0, 0)

	while (!(state.currentPosition.north === 0 && state.currentPosition.east === 0 && state.currentPosition.up === 0)) {
		const recommendedDirection = pathing.getDirectionTo(spawnPosition, true)
		console.log(',,recommendedDirection', recommendedDirection)
		movement.digInDirection(recommendedDirection)
		movement.moveInDirection(recommendedDirection)
	}
	
	movement.turnInDirection('north')
	state.setHeadingToSpawn(false)
}


function returnToStartingHeight() {
	// already at the correct height, just return
	if (state.currentPosition.up == 0) return

	if (state.currentPosition.up > 0) {
		for (let i = 1; i < state.currentPosition.up; i ++) {
			movement.digInDirection('down')
			movement.moveInDirection('down')
		}
	} else if (state.currentPosition.up < 0) {
		for (let i = 1; i < -state.currentPosition.up; i ++) {
			movement.digInDirection('up')
			movement.moveInDirection('up')
		}
	}
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

depositAllAtSpawn()

state.updateInventoryFull()
if (state.inventoryFull)
	depositAllAtSpawn()

let miningOres = false

while (true) {
	const nearestOrePosition = movement.scanAround(world.ORES)

	if (nearestOrePosition) {
		console.log(`To ${nearestOrePosition.toString()}`)
		const recommendedDirection = pathing.getDirectionTo(nearestOrePosition, true)
		movement.digInDirection(recommendedDirection)
		movement.moveInDirection(recommendedDirection)
		miningOres = true
	} else {
		returnToStartingHeight()
		let nearestMineablePosition = world.findNearestUnexplored()
		// let nearestMineablePosition = world.findNearestBlockPosition(world.UNDERGROUND_MINEABLE, 0, positionBetween(state.currentPosition, new vec3.Vec3(0, 0, 0)))
		let recommendedDirection
		if (nearestMineablePosition)
			recommendedDirection = pathing.getDirectionTo(nearestMineablePosition)
		else
			recommendedDirection = state.currentDirection

		console.log(`.To ${nearestMineablePosition.toString()} ${recommendedDirection}`)
		movement.digInDirection(recommendedDirection)
		movement.moveInDirection(recommendedDirection)
	}

	movement.scanAround()

	// digging up/down is cheap and it makes it easier to follow the turtle so we might as well
	if (state.currentPosition.up == 0) {
		movement.inspectInDirection('up')
		let upBlock = world.getBlock(state.getPositionForDirection('up'))
		if (world.UNDERGROUND_MINEABLE.includes(upBlock))
			movement.digInDirection('up')
	}

	if (state.inventoryFull)
		depositAllAtSpawn()

	world.saveWorld()
}










