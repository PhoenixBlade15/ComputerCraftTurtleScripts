width = -1
height = -1
length = -1
fuelLevel = turtle.getFuelLevel()
didRefuel = false
inventorySpace = 16

fuelGoal = -1
-- 1 coal is 80
-- 1 log or plank is 15


-- Digs in specificd direction and sucks up all items
-- 0 is infront
-- 1 is up
-- 2 is down
function digAndSuck(direction)
	if ( direction == "0" ) then
		turtle.dig()
	elseif ( direction == "1" ) then
		turtle.digUp()
	else
		turtle.digDown()
	end
	suckAll()
end


-- Calls each suck function to make sure items are sucked up
function suckAll()
	turtle.suck()
	turtle.suckUp()
	turtle.suckDown()
end


-- Tries to refuel to above the fuel goal
function tryRefuel()
	repeat
		fuelLevel = turtle.getFuelLevel()
	
		-- Checks if fuel level is above the fuel goal
		if ( fuelLevel > fuelGoal ) then
			didRefuel = true
		else 
			didRefuel = false
		end
		
		-- Tries to refuel out of each inventory slot
		if ( didRefuel == false ) then
			for i = 1, inventorySpace, 1 do
				turtle.select(i)
				didRefuel = turtle.refuel(1)
				if ( didRefuel == true ) then
					break
				end		
			end
		end
		
		-- Checks if refueling passed and tells user if did or not
		if ( didRefuel ) then
			fuelLevel = turtle.getFuelLevel()
			io.write("Fuel level is " .. fuelLevel .. ". \n \n")
		else
			io.write("Could not refuel, fuel goal is set to " .. fuelGoal .. " and fuel level is " .. fuelLevel .. ". \n \n")
		end
	until ( fuelLevel >= fuelGoal )	
end


-- Gets the goal of fuel level from the user
repeat

	io.write("What is the desired fuel level(81 or above)? \n - 1 coal is 80 fuel \n - 1 wood is 15 fuel \n")
	fuelGoal = tonumber( io.read() )
	
	-- Outputs to user a message if not a valid number
	if ( (fuelGoal == nil) or (fuelGoal < 81) ) then 
		io.write("Not a number 81 or above. \n \n")
	end
	
until ( (type(fuelGoal) == "number") and (fuelGoal > 80) )

-- Refuels the turtle and if it can't tells the user
tryRefuel()

-- Gets width of the tunnel user would like
repeat

	io.write("What is the width? \n")
	width = tonumber( io.read() )
	
	-- Outputs to user a message if not number or 1 or above
	if ( ( width == nil ) or ( width < 1 ) ) then 
		io.write("Not a number above 0. \n")
	end
	
until ( ( type(width) == "number" ) and ( width > 0 ) )

-- Gets the height of the tunnel user would like
repeat

	io.write("What is the height? \n - Even numbers above 1. \n")
	height = tonumber( io.read() )
	
	-- Outputs to user a message if not number or 1 or above
	if ( ( height == nil ) or ( height < 1 ) or ( height % 2 == 1 ) ) then 
		io.write("Not a number above 0 that is odd. \n")
	end
	
until ( ( type(height) == "number" ) and ( height > 0 ) and ( height % 2 == 0 ) )

-- Gets the length of the tunnel user would like
repeat

	io.write("What is the length? \n")
	length = tonumber( io.read() )
	
	-- Outputs to user a message if not number or 1 or above
	if ( ( length == nil ) or ( length < 1 ) ) then 
		io.write("Not a number above 0. \n")
	end
	
until ( ( type(length) == "number" ) and ( length > 0 ) )

-- For each layer
for x = 0, length - 2, 1 do

	-- For each row
	for y = 0, height - 1, 1 do
	
		-- Each block in a row
		for z = 0, width - 2, 1 do 
			
			tryRefuel()
			digAndSuck("0")
			
			-- Checks to see if need to move to side
			if ( width > 1 ) then
			
				-- Checks which row on and then decide which way to move about
				if ( y % 2 == 0 ) then
					turtle.turnRight()
					digAndSuck("0")
					turtle.forward()
					turtle.turnLeft()
				else
					turtle.turnLeft()
					digAndSuck("0")
					turtle.forward()
					turtle.turnRight()
				end

			end
			digAndSuck("0")
		end
		
			if ( y ~= height - 1 ) then
				-- Checks which layer on to decide to move up or down
				if ( x % 2 == 0 ) then
					digAndSuck("1")
					turtle.up()
				else
					digAndSuck("2")
					turtle.down()
				end
			end
		
	end
	digAndSuck("0")
	turtle.forward()
end