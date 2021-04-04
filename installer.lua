term.clear()

local PROGRAMS_URL = 'https://gist.githubusercontent.com/mat-1/988098939dca9d25897edd5f191dd91c/raw/computercraft-programs.json?' .. os.epoch()

local response = http.get(PROGRAMS_URL)
local programsList = textutils.unserializeJSON(response.readAll())
response.close()


local selectedProgramIndex = 1

term.setPaletteColour(colors.gray, 0x333333)
-- we make magenta into gray because it's not used anywhere else
term.setPaletteColour(colors.magenta, 0xaaaaaa)


function checkProgramInstalled(programName)
	return fs.exists(programName .. '.lua')
end


function checkProgramOutdated(programName)
	local programFileName = programName .. '.lua'

	local localProgramHandle = fs.open(programFileName, 'r')
	local localProgramContents = localProgramHandle.readAll()
	localProgramHandle.close()

	-- find the url of the program by iterating over the programs list
	local externalProgramUrl
	for _, program in ipairs(programsList) do
		if program.name == programName then
			externalProgramUrl = program.raw
		end
	end
	
	local externalProgramResponse = http.get(externalProgramUrl .. '?' .. os.epoch())

	if externalProgramResponse == nil then
		return false
	end

	local externalProgramContents = externalProgramResponse.readAll()
	externalProgramResponse.close()

	-- if the contents of the downloaded program and the external program are different, throw an error
	return externalProgramContents ~= localProgramContents
end


function installProgram(programName)
	local externalProgramUrl
	local externalProgramIndex

	for programIndex, program in ipairs(programsList) do
		if program.name == programName then
			externalProgramUrl = program.raw
			externalProgramIndex = programIndex
		end
	end

	local externalProgramResponse = http.get(externalProgramUrl .. '?' .. os.epoch())
	local externalProgramContents = externalProgramResponse.readAll()

	local localProgramHandle = fs.open(programName .. '.lua', 'w')
	localProgramHandle.write(externalProgramContents)
	localProgramHandle.close()

	programsList[externalProgramIndex].installed = true
	programsList[externalProgramIndex].outdated = false
end

function uninstallProgram(programName)
	local externalProgramIndex

	for programIndex, program in ipairs(programsList) do
		if program.name == programName then
			externalProgramIndex = programIndex
		end
	end

	local localProgramHandle = fs.delete(programName .. '.lua')

	programsList[externalProgramIndex].installed = false
	programsList[externalProgramIndex].outdated = nil
end


function drawPrograms()
	local width, height = term.getSize()
	paintutils.drawFilledBox(2, 2, width - 1, height - 1, colors.gray)
	
	
	local titleText = 'Programs'
	
	term.setTextColour(colors.white)
	term.setCursorPos(width / 2 - string.len(titleText) / 2, 3)
	term.write(titleText)

	for programIndex, program in ipairs(programsList) do
		local programColor

		local programIsSelected = programIndex == selectedProgramIndex

		programColor = colors.lightGray
		if programIsSelected then
			-- gray
			programColor = colors.magenta
		end

		paintutils.drawFilledBox(3, 3 + programIndex * 2, width - 2, 3 + programIndex * 2, programColor)

		term.setTextColour(colors.black)

		local programDisplayName = program.name

		if (
			programsList[programIndex].installed ~= false and
			(programsList[programIndex].installed == true or checkProgramInstalled(program.name))
		) then

			programsList[programIndex].installed = true

			if (
				programsList[programIndex].outdated ~= false
				and (programsList[programIndex].outdated == true or checkProgramOutdated(program.name))
			) then
				programDisplayName = programDisplayName .. ' (outdated)'
				programsList[programIndex].outdated = true
			else
				programsList[programIndex].outdated = false
				programDisplayName = programDisplayName .. ' (installed)'
			end
		else
			programsList[programIndex].installed = false
		end

		if programIsSelected then
			term.setCursorPos(3, 3 + programIndex * 2)
			term.write('>' .. programDisplayName)
		else
			term.setCursorPos(4, 3 + programIndex * 2)
			term.write(programDisplayName)
		end

	end
	term.setCursorPos(1, height)
	
	term.setBackgroundColour(colors.black)
	term.setTextColour(colors.white)
end

drawPrograms()


function selectProgram()
	local selectedProgram = programsList[selectedProgramIndex]
	if (not selectedProgram.installed or selectedProgram.outdated) then
		installProgram(selectedProgram.name)
	elseif (selectedProgram.installed and not selectedProgram.outdated) then
		uninstallProgram(selectedProgram.name)
	end

	-- paintutils.drawFilledBox(2, 2, width - 1, height - 1, colors.gray)
end

while true do
    local _, key = os.pullEvent("key")
	if key == keys.up and selectedProgramIndex > 1 then
		selectedProgramIndex = selectedProgramIndex - 1
	elseif key == keys.down and selectedProgramIndex < #programsList then
		selectedProgramIndex = selectedProgramIndex + 1
	elseif key == keys.enter then
		selectProgram()
	end
	drawPrograms()
end