export class Vec3 {
	north: number
	up: number
	east: number

	constructor(x: number, y: number, z: number) {
		this.north = Math.floor(x)
		this.up = Math.floor(y)
		this.east = Math.floor(z)
	}

	toString() {
		return `${this.north},${this.up},${this.east}`
	}

	plus(x: number, y: number, z: number) {
		return new Vec3(this.north + x, this.up + y, this.east + z)
	}
}


export function parse(position: string): Vec3 {
	let [ north, up, east ] = position.split(',')
	return new Vec3(parseInt(north), parseInt(up), parseInt(east))
}

export const DIRECTIONS_OFFSETS = {
	north: new Vec3(1, 0, 0),
	south: new Vec3(-1, 0, 0),

	east: new Vec3(0, 0, 1),
	west: new Vec3(0, 0, -1),

	up: new Vec3(0, 1, 0),
	down: new Vec3(0, -1, 0),
}

export const directionsBack = {
	north: 'south',
	south: 'north',
	east: 'west',
	west: 'east',
	up: 'down',
	down: 'up',
}

export const directionsRight = {
	north: 'east',
	south: 'west',
	east: 'south',
	west: 'north',
}

export const directionsLeft = {
	north: 'west',
	south: 'east',
	east: 'north',
	west: 'south',
}

export type Direction = 'north' | 'east' | 'south' | 'west'
export type DirectionUp = Direction | 'up' | 'down'


export function spiral(size: number, around: Vec3, until: (Vec3) => boolean): Vec3[] {
	let x = 0
	let z = 0
	let dx = 0
	let dz = -1

	const results: Vec3[] = []

	for (let i = 0; i < size ** 2; i ++) {
		const position = new Vec3(around.north + x, 0, around.east + z)
		if (until && until(position))
			return [ position ]

		results.push(position)

		if (x == z || (x < 0 && x == -z) || (x > 0 && x == 1-z)) {
			[ dx, dz ] = [ -dz, dx ]
		}
		[ x, z ] = [ x + dx, z + dz ]
	}
	return results
}


export function positionBetween(position1: Vec3, position2: Vec3): Vec3 {
	return new Vec3(
		(position1.north + position2.north) / 2,
		(position1.up + position2.up) / 2,
		(position1.east + position2.east) / 2
	)
}

export function getDistanceTo(position: Vec3, position2: Vec3): number {
	return Math.abs(position.north - position2.north)
		 + Math.abs(position.east - position2.east)
		 + Math.abs(position.up - position2.up)
}
