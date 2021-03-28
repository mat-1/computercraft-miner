/** @noSelfInFile */

declare interface Block {
	name: string
	count?: number
}

declare namespace turtle {
	/** 
	 * Move the turtle forward one block.
	 * @tuplereturn
	*/
	function forward(): [ success: boolean, reason: string | null ]

	/** 
	 * Move the turtle backwards one block.
	 * @tuplereturn
	*/
	function back(): [ success: boolean, reason: string | null ]

	/** 
	 * Move the turtle up one block.
	 * @tuplereturn
	*/
	function up(): [ success: boolean, reason: string | null ]

	/** 
	 * Move the turtle down one block.
	 * @tuplereturn
	*/
	function down(): [ success: boolean, reason: string | null ]

	/** 
	 * Rotate the turtle 90 degress to the left.
	 * @tuplereturn
	*/
	function turnLeft(): [ success: boolean, reason: string | null ]

	/** 
	 * Rotate the turtle 90 degress to the right.
	 * @tuplereturn
	*/
	function turnRight(): [ success: boolean, reason: string | null ]

	/** 
	 * Rotate the turtle 90 degress to the right.
	 * @tuplereturn
	*/
	function dig(side?: string): [ success: boolean, reason: string | null ]

	/** 
	 * Attempt to break the block above the turtle. See `dig` for full details.
	 * @param side The specific tool to use.
	 * @tuplereturn
	*/
	function digUp(side?: string): [ success: boolean, reason: string | null ]

	/** 
	 * Attempt to break the block below the turtle. See dig for full details.
	 * @param side The specific tool to use.
	 * @tuplereturn
	*/
	function digDown(side?: string): [ success: boolean, reason: string | null ]

	/** 
	 * Place a block or item into the world in front of the turtle.
	 * 
	 * "Placing" an item allows it to interact with blocks and entities in front of the turtle. For instance, buckets can pick up and place down fluids, and wheat can be used to breed cows. However, you cannot use place to perform arbitrary block interactions, such as clicking buttons or flipping levers.
	 * @param text When placing a sign, set its contents to this text.
	 * @tuplereturn
	*/
	function place(text?: string): [ success: boolean, reason: string | null ]

	/** 
	 * Place a block or item into the world above the turtle.
	 * @param text When placing a sign, set its contents to this text.
	 * @tuplereturn
	*/
	function placeUp(text?: string): [ success: boolean, reason: string | null ]

	/** 
	 * Place a block or item into the world below the turtle.
	 * @param text When placing a sign, set its contents to this text.
	 * @tuplereturn
	*/
	function placeDown(text?: string): [ success: boolean, reason: string | null ]


	/** 
	 * Drop the currently selected stack into the inventory in front of the turtle, or as an item into the world if there is no inventory.
	 * @param count The number of items to drop. If not given, the entire stack will be dropped.
	 * @throws If dropping an invalid number of items.
	 * @tuplereturn
	*/
	function drop(count?: number): [ success: boolean, reason: string | null ]

	/** 
	 * Drop the currently selected stack into the inventory above the turtle, or as an item into the world if there is no inventory.
	 * @param count The number of items to drop. If not given, the entire stack will be dropped.
	 * @throws If dropping an invalid number of items.
	 * @tuplereturn
	*/
	function dropUp(count?: number): [ success: boolean, reason: string | null ]

	/** 
	 * Drop the currently selected stack into the inventory in front of the turtle, or as an item into the world if there is no inventory.
	 * @param count The number of items to drop. If not given, the entire stack will be dropped.
	 * @throws If dropping an invalid number of items.
	 * @tuplereturn
	*/
	function dropDown(count?: number): [ success: boolean, reason: string | null ]

	/** 
	 * Change the currently selected slot.
	 *
	 * The selected slot is determines what slot actions like drop or getItemCount act on.
	 * @param count The slot to select.
	 * @throws If the slot is out of range.
	*/
	function select(slot: number): true

	/** 
	 * Get the number of items in the given slot.
	 * @param slot The slot we wish to check. Defaults to the selected slot.
	 * @throws If the slot is out of range.
	 * @returns The number of items in this slot.
	*/
	function getItemCount(slot?: number): number

	/** 
	 * Get the remaining number of items which may be stored in this stack.
	 *
	 * For instance, if a slot contains 13 blocks of dirt, it has room for another 51.
	 * @param slot The slot we wish to check. Defaults to the selected slot.
	 * @throws If the slot is out of range.
	 * @returns The space left in in this slot.
	*/
	function getItemSpace(slot?: number): number

	/** 
	 * Check if there is a solid block in front of the turtle. In this case, solid refers to any non-air or liquid block.
	 * @returns If there is a solid block in front.
	*/
	function detect(): boolean

	/** 
	 * Check if there is a solid block above the turtle. In this case, solid refers to any non-air or liquid block.
	 * @returns If there is a solid block in front.
	*/
	function detectUp(): boolean

	/** 
	 * Check if there is a solid block below the turtle. In this case, solid refers to any non-air or liquid block.
	 * @returns If there is a solid block in front.
	*/
	function detectDown(): boolean

	/**
	 *
	*/
	function compare(): any

	/**
	 *
	*/
	function compareUp(): any

	/**
	 *
	*/
	function compareDown(): any

	/**
	 * Attack the entity in front of the turtle.
	 * @param side The specific tool to use.
	 * @returns Whether an entity was attacked.
	 * @returns The reason nothing was attacked.
	 * @tuplereturn
	*/
	function attack(side?: string): [ boolean, string | null ]

	/**
	 * Attack the entity above the turtle.
	 * @param side The specific tool to use.
	 * @returns Whether an entity was attacked.
	 * @returns The reason nothing was attacked.
	 * @tuplereturn
	*/
	function attackUp(side?: string): [ boolean, string | null ]

	/**
	 * Attack the entity below the turtle.
	 * @param side The specific tool to use.
	 * @returns Whether an entity was attacked.
	 * @returns The reason nothing was attacked.
	 * @tuplereturn
	*/
	function attackDown(side?: string): [ boolean, string | null ]

	/**
	 * Suck an item from the inventory in front of the turtle, or from an item floating in the world.
	 * 
	 * This will pull items into the first acceptable slot, starting at the currently selected one.
	 * @param count The number of items to suck. If not given, up to a stack of items will be picked up.
	 * @returns Whether items were picked up.
	 * @returns The reason the no items were picked up.
	 * @throws If given an invalid number of items.
	 * @tuplereturn
	*/
	function suck(count?: number): [ boolean, string | null ]

	/**
	 * Suck an item from the inventory above the turtle, or from an item floating in the world.
	 * @param count The number of items to suck. If not given, up to a stack of items will be picked up.
	 * @returns Whether items were picked up.
	 * @returns The reason the no items were picked up.
	 * @throws If given an invalid number of items.
	 * @tuplereturn
	*/
	function suckUp(count?: number): [ boolean, string | null ]

	/**
	 * Suck an item from the inventory below the turtle, or from an item floating in the world.
	 * @param count The number of items to suck. If not given, up to a stack of items will be picked up.
	 * @returns Whether items were picked up.
	 * @returns The reason the no items were picked up.
	 * @throws If given an invalid number of items.
	 * @tuplereturn
	*/
	function suckDown(count?: number): [ boolean, string | null ]

	/**
	*/
	function getFuelLevel(): any

	/**
	*/
	function refuel(count?: number): any

	/**
	*/
	function compareTo(slot: number): any

	/**
	*/
	function transferTo(slot: number, count?: number): any

	/**
	 * Get the currently selected slot.
	 * @returns The current slot.
	*/
	function getSelectedSlot(): number

	/**
	*/
	function getFuelLimit(): any

	/**
	*/
	function equipLeft(): any

	/**
	*/
	function equipRight(): any

	/**
	 * Get information about the block in front of the turtle.
	 * @returns Whether there is a block in front of the turtle.
	 * @returns Information about the block in front, or a message explaining that there is no block.
	 * @tuplereturn
	*/
	function inspect(): [ boolean, Block | string ]

	/**
	 * Get information about the block above the turtle.
	 * @returns Whether there is a block above the turtle.
	 * @returns Information about the above below, or a message explaining that there is no block.
	 * @tuplereturn
	*/
	function inspectUp(): [ boolean, Block | string ]

	/**
	 * Get information about the block below the turtle.
	 * @returns Whether there is a block below the turtle.
	 * @returns Information about the block below, or a message explaining that there is no block.
	 * @tuplereturn
	*/
	function inspectDown(): [ boolean, Block | string ]

	/**
	 * Get information about the block below the turtle.
	 * @param slot The slot to get information about. Defaults to the selected slot.
	 * @param detailed Whether to include "detailed" information. When true the method will contain much more information about the item at the cost of taking longer to run.
	 * @returns Information about the given slot, or nil if it is empty.
	 * @throws If the slot is out of range.
	 * @tuplereturn
	*/
	function getItemDetail(slot?: number, detailed?: boolean): null | Block

	/**
	*/
	function craft(limit: number): any

}
