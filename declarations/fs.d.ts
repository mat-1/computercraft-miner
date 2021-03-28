/** @noSelfInFile */

declare namespace fs {
	/**
	 * Returns true if a path is mounted to the parent filesystem.
	 * 
	 * The root filesystem "/" is considered a mount, along with disk folders and the rom folder. Other programs (such as network shares) can exstend this to make other mount types by correctly assigning their return value for getDrive.
	 * @param path The path to check.
	 * @returns If the path is mounted, rather than a normal file/folder.
	*/
	function isDriveRoot(path: string)
}