
local DEBUG_MODE = false

LIBS = LIBS or {}
LIBS.DOLMERO = '0.0.1'

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

function isnear(num,x,y,z)
	if math.max(math.abs($posx - x), math.abs($posy - y)) <= num then
		return ($posz == z) 
	end
	return false
end