	-- force more room4s and room2Cs
	for i = 0, 2 do
		local zone = 1
		local temp2 = 0

		if i == 2 then y_min = 2 else y_min = Transition[i] end
		if i == 0 then y_max = MapHeight - 2 else y_max = Transition[i - 1] - 2 end
		x_min = 1
		x_max = MapWidth - 2
		
		if Room4Amount[i] < 1 then -- we want at least 1 ROOM4
			print("forcing a ROOM4 into zone " .. i)
			temp = 0

			for y = y_min, y_max do
				for x = x_min, x_max do
					if MapTemp[x][y] == 3 then
						if MapTemp[x + 1][y] > 0 or MapTemp[x + 1][y + 1] > 0 or MapTemp[x + 1][y - 1] > 0 or MapTemp[x + 2][y] > 0 or x == x_max then
							MapTemp[x + 1][y] = 1
							temp = 1
						elseif MapTemp[x - 1][y] > 0 or MapTemp[x - 1][y + 1] > 0 or MapTemp[x - 1][y - 1] > 0 or MapTemp[x - 2][y] > 0 or x == x_min then
							MapTemp[x - 1][y] = 1
							temp = 1
						elseif MapTemp[x][y + 1] > 0 or MapTemp[x + 1][y + 1] > 0 or MapTemp[x - 1][y + 1] > 0 or MapTemp[x][y + 2] > 0 or i == 0 and y == y_max then
							MapTemp[x][y + 1] = 1
							temp = 1
						elseif MapTemp[x][y - 1] > 0 or MapTemp[x + 1][y - 1] > 0 or MapTemp[x - 1][y - 1] > 0 or MapTemp[x][y - 2] > 0 or i < 2 and y == y_min then
							MapTemp[x][y-1] = 1
							temp = 1
						end

						if temp == 1 then
							MapTemp[x][y] = 4 -- turn this room into a ROOM4
							print("ROOM4 forced into slot (" .. x .. ", " .. y .. ")")
							Room4Amount[i] += 1
							Room3Amount[i] -= 1
							Room1Amount[i] += 1
						end
					end

					if temp == 1 then
						break
					end
				end

				if temp == 1 then
					break
				end
			end

			if temp == 0 then
				warn("Couldn't place ROOM4 in zone " .. i)
			end
		end

		if Room2CAmount[i] < 1 then -- we want at least 1 ROOM2C
			print("forcing a ROOM2C into zone " .. i)
			temp = 0

			for y = y_max, y_min, -1 do
				for x = x_min, x_max do
					if MapTemp[x][y] == 1 then
						if MapTemp[x - 1][y] > 0 then -- see if adding some rooms is possible
							if MapTemp[x + 1][y - 1] + MapTemp[x + 1][y + 1] + MapTemp[x + 2][y] == 0 and x < x_max then
								if MapTemp[x + 1][y - 2] + MapTemp[x + 2][y - 1] + MapTemp[x + 1][y - 1] == 0 and (y > y_min or i == 2) then
									MapTemp[x][y] = 2
									MapTemp[x + 1][y] = 2
									print("ROOM2C forced into slot (" .. x + 1 .. ", " .. y .. ")")
									MapTemp[x + 1][y - 1] = 1
									temp = 1
								elseif MapTemp[x + 1][y + 2] + MapTemp[x + 2][y + 1] + MapTemp[x + 1][y + 1] == 0 and (y < y_max or i > 0) then
									MapTemp[x][y] = 2
									MapTemp[x + 1][y] = 2
									print("ROOM2C forced into slot (" .. x + 1 .. ", " .. y .. ")")
									MapTemp[x + 1][y + 1] = 1
									temp = 1
								end
							end
						elseif MapTemp[x + 1][y] > 0 then
							if MapTemp[x - 1][y - 1] + MapTemp[x - 1][y + 1] + MapTemp[x - 2][y] == 0 and x > x_min then
								if MapTemp[x - 1][y - 2] + MapTemp[x - 2][y - 1] + MapTemp[x - 1][y - 1] == 0 and (y > y_min or i == 2) then
									MapTemp[x][y] = 2
									MapTemp[x - 1][y] = 2
									print("ROOM2C forced into slot (" .. x - 1 .. ", " .. y .. ")")
									MapTemp[x - 1][y - 1] = 1
									temp = 1
								elseif MapTemp[x - 1][y + 2] + MapTemp[x - 2][y + 1] + MapTemp[x - 1][y + 1] == 0 and (y < y_max or i > 0) then
									MapTemp[x][y] = 2
									MapTemp[x - 1][y] = 2
									print("ROOM2C forced into slot (" .. x - 1 .. ", " .. y .. ")")
									MapTemp[x - 1][y + 1] = 1
									temp = 1
								end
							end
						elseif MapTemp[x][y - 1] > 0 then
							if MapTemp[x - 1][y + 1] + MapTemp[x + 1][y + 1] + MapTemp[x][y + 2] == 0 and (y < y_max or i > 0) then
								if MapTemp[x - 2][y + 1] + MapTemp[x - 1][y + 2] + MapTemp[x - 1][y + 1] == 0 and x > x_min then
									MapTemp[x][y] = 2
									MapTemp[x][y + 1] = 2
									print("ROOM2C forced into slot (" .. x .. ", " .. y + 1 .. ")")
									MapTemp[x - 1][y + 1] = 1
									temp = 1
								elseif MapTemp[x + 2][y + 1] + MapTemp[x + 1][y + 2] + MapTemp[x + 1][y + 1] == 0 and x < x_max then
									MapTemp[x][y] = 2
									MapTemp[x][y + 1] = 2
									print("ROOM2C forced into slot (" .. x .. ", " .. y + 1 .. ")")
									MapTemp[x + 1][y + 1] = 1
									temp = 1
								end
							end
						elseif MapTemp[x][y + 1] > 0 then
							if MapTemp[x - 1][y - 1] + MapTemp[x + 1][y - 1] + MapTemp[x][y - 2] == 0 and (y > y_min or i == 2) then
								if MapTemp[x - 2][y - 1] + MapTemp[x - 1][y - 2] + MapTemp[x - 1][y - 1] == 0 and x > x_min then
									MapTemp[x][y] = 2
									MapTemp[x][y - 1] = 2
									print("ROOM2C forced into slot (" .. x .. ", " .. y - 1 .. ")")
									MapTemp[x - 1][y - 1] = 1
									temp = 1
								elseif MapTemp[x + 2][y - 1] + MapTemp[x + 1][y - 2] + MapTemp[x + 1][y - 1] == 0 and x < x_max then
									MapTemp[x][y] = 2
									MapTemp[x][y - 1] = 2
									print("ROOM2C forced into slot (" .. x .. ", " .. y - 1 .. ")")
									MapTemp[x + 1][y - 1] = 1
									temp = 1
								end
							end
						end

						if temp == 1 then
							Room2CAmount[i] += 1
							Room2Amount[i] += 1
						end
					end
					if temp == 1 then
						break
					end
				end
				if temp == 1 then
					break
				end
			end
			if temp == 0 then
				warn("Couldn't place ROOM2C in zone " .. i)
			end
		end
	end
