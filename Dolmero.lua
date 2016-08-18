
local DEBUG_MODE = false

LIBS = LIBS or {}
LIBS.DOLMERO = '0.0.1'

-- @name	kite
-- @desc	Keeps the given monsters in your screen while moving along your waypoints.
-- @param	xRange how close to keep the monsters on the x-axis
-- @param	yRange	-||-
-- @param	name¹, name², name*, ...	The monsters to consider.
function kite(xRange, yRange, ...)
	local monsters = {...}
	local waitformob = false
	foreach creature m 'fmr' do
		if (table.find(monsters, m.name) and m.dist <= 8 and m.hppc > 20) then
			if $posx - m.posx > xRange then
				if $posx - $wptx < 0 then
					waitformob = true
					break
				end
			elseif m.posx - $posx > xRange then
				if $posx - $wptx > 0 then
					waitformob = true
					break
				end
			end
			if $posy - m.posy > yRange then
				if $posy - $wpty < 0 then
					waitformob = true
					break
				end
			elseif m.posy - $posy > yRange then
				if $posy - $wpty > 0 then
					waitformob = true
					break
				end
			end
		end
	end
	if waitformob then
		pausewalking(2000)
	else
		pausewalking(0)
	end
end

-- @name	kiteuntil
-- @desc	Uses kite() until you have a set number of monsters close to you.
-- @param	num how many monsters the bot should gather before turning targeting on.
-- @param	name¹, name², name*, ...	The monsters to consider.
function kiteuntil(num, ...)
	local monsters = {...}
	local closeAmount = 0
	foreach creature m 'fmr' do
		if (table.find(monsters, m.name) and m.dist <= 8) then
			if m.dist <= 5 then
				closeAmount = closeAmount + 1
			end
		end
	end
	if closeAmount < num then
		if closeAmount == 0 then
			setsetting('Targeting/Enabled', 'no')
		end
		if getsetting('Targeting/Enabled') == 'no' then
			kite(5,4, unpack(monsters))
		end
	else
		setsetting('Targeting/Enabled', 'yes')
	end
end

-- @name	isnear
-- @desc	Checks if you are near the given coordinates.
-- @param	num the maximum range from the given sqm that is considered as 'near'
-- @param	xyz  xyz of the sqm
-- @returns boolean
function isnear(num,x,y,z)
	if math.max(math.abs($posx - x), math.abs($posy - y)) <= num then
		return ($posz == z) 
	end
	return false
end

-- @name	naturalsell
-- @desc	Sells your items in a more natural order, like a human would.
-- @param	cat the category to sell
function naturalsell(cat)
	selllist = {}
	foreach lootingitem l cat do
		table.insert(selllist, l)
	end
	table.sort(selllist, function(a,b) return tradecount('sell', a.id) > tradecount('sell', b.id) end)
	for _, v in ipairs(selllist) do
		sellitems(v.id, tradecount('sell', v.id))
		wait($ping*3,$ping*5)
	end
end

-- NOT TESTED
-- @name	togglepause
-- @desc	toggles pause
function togglepause()
	if getsetting("Cavebot/Enabled") == 'yes' or getsetting("Targeting/Enabled") == 'yes' then
		setsetting("Cavebot/Enabled", 'no')
		setsetting("Targeting/Enabled", 'no')
	else
		setsetting("Cavebot/Enabled", 'yes')
		setsetting("Targeting/Enabled", 'yes')
	end
end
