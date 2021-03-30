import * as vec3 from './vec3'
import * as state from './state'



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


export function setBlock(position: vec3.Vec3, block: string) {
	world[position.toString()] = block
}

export function getBlock(position: vec3.Vec3): string {
	return world[position.toString()]
}

// the spawn coordinates are guaranteed to be air because the turtle is there
setBlock(new vec3.Vec3(0, 0, 0), 'minecraft:air')




/** returns true if we are certain the block in this direction is air */
export function isDirectionVisitedAir(dir: vec3.DirectionUp) {
	const directionCoordinates = state.getPositionForDirection(dir)

	if (getBlock(directionCoordinates))
		return getBlock(directionCoordinates) == 'minecraft:air'
	else
		return false
}


export function findNearestBlockPosition(blocks: string[], height?: number, center?: vec3.Vec3): vec3.Vec3 | null {
	if (center === null)
		center = state.currentPosition

	let nearestOreDistance = 99999
	let nearestOrePosition: vec3.Vec3 = null

	for (const [ blockPositionString, block ] of Object.entries(world)) {
		if (blocks.includes(block)) {
			const blockPosition = vec3.parse(blockPositionString)
			if (
				(height == null || height === blockPosition.up)
				&& (blockPositionString !== state.currentPosition.toString())
			) {
				const blockDistance = vec3.getDistanceTo(blockPosition, center)

				if (blockDistance < nearestOreDistance) {
					nearestOreDistance = blockDistance
					nearestOrePosition = blockPosition
				}

			}
		}
	}
	return nearestOrePosition
}


export function countUnknownBlocksAround(position: vec3.Vec3, debug?: boolean): number {
	let count = 0
	for (const direction of Object.values(vec3.DIRECTIONS_OFFSETS)) {
		const checkPosition = position.plus(direction.north, direction.up, direction.east)
		if (getBlock(checkPosition) === null) {
			if (debug) console.log(checkPosition, direction)
			count ++
		}
	}
	return count
}


export function findNearestUnexplored(): vec3.Vec3 | null {
	// const nearestUnexplored = vec3.spiral(512, vec3.positionBetween(new vec3.Vec3(0, 0, 0), state.currentPosition), (position: vec3.Vec3) => {
	const nearestUnexplored = vec3.spiral(512, new vec3.Vec3(0, 0, 0), (position: vec3.Vec3) => {
		const block = getBlock(position)
		return block === null
			&& (
				position.north !== state.currentPosition.north
				|| position.up !== state.currentPosition.up
				|| position.east !== state.currentPosition.east
			)
	})
	if (nearestUnexplored.length >= 1)
		return nearestUnexplored[0]
	else
		return null
}