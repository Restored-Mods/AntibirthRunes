local Helpers = {}

local GiantBookColors = {
	["poof2"] = Color(0, 0, 0, 0.8, 0, 0, 0),
	["poof"] = Color(0.2, 0.1, 0.3, 1, 0, 0, 0),
	["bg"] = Color(0.117, 0.0117, 0.2, 1, 0, 0, 0),
}

function Helpers:GetMaxCollectibleID()
	return Isaac.GetItemConfig():GetCollectibles().Size - 1
end

function Helpers:GetMaxTrinketID()
	return Isaac.GetItemConfig():GetTrinkets().Size - 1
end

---@param rng RNG | integer?
---@param seed integer?
---@return RNG
function Helpers:GetRNG(rng, seed)
    if rng == nil or type(rng) == "number" then
        seed = rng
        rng = RNG()
    end
    seed = seed or Random()
    rng:SetSeed(math.max(1, seed), 35)
    return rng
end

function Helpers:CheckAvailableAPI(api, prevAPI, forward)
	if not GiantBookAPI and not ScreenAPI then
		return 3
	end
	if not prevAPI then
		prevAPI = api
	end	
	if api < prevAPI then
		if api == 2 and not ScreenAPI then
			api = 1
		end
		if api == 1 and not GiantBookAPI then
			api = 3
		end
	else
		if api == 1 and not GiantBookAPI then
			api = 2
		end
		if api == 2 and not ScreenAPI then
			api = 3
		end
	end
	return api
end

---@param player EntityPlayer
---@return boolean, CollectibleType | integer?
function Helpers:HasMagicChalk(player)
	local magicchalk = Isaac.GetItemIdByName("Magic Chalk")
	return magicchalk > 0 and player:HasCollectible(magicchalk)
end

---@param player EntityPlayer
---@return boolean
function Helpers:HasRunicTablet(player)
	return  RunicTablet and player:HasCollectible(RunicTablet.Collectible.RunicTablet.ID)
end

---@param player EntityPlayer
---@return boolean
function Helpers:HasMagicChalkOrRunicTablet(player)
	return Helpers:HasMagicChalk(player) or Helpers:HasRunicTablet(player)
end

---@param gfx string
---@param sfx SoundEffect | integer
---@param player EntityPlayer
---@param rng RNG?
function Helpers:PlayGiantBook(gfx, sfx, player, rng)
	if REPENTOGON then
        ItemOverlay.Show(Isaac.GetGiantBookIdByName(gfx), 0, player)
    else
        local sound = nil
		if Options.AnnouncerVoiceMode == 2 or Options.AnnouncerVoiceMode == 0 and rng:RandomInt(4) == 0 then
			sound = sfx
		end
		local bookAPI = AntibirthRunes.SavedData.BookAPI
		if GiantBookAPI and bookAPI == 1 then
			GiantBookAPI.playGiantBook(
				"Appear",
				gfx .. ".png",
				GiantBookColors["poof"],
				GiantBookColors["bg"],
				GiantBookColors["poof2"],
				sound
			)
		elseif bookAPI ~= 1 or not GiantBookAPI then
			if ScreenAPI and bookAPI == 2 then
				ScreenAPI.PlayGiantbook("gfx/ui/giantbook/" .. gfx .. ".png", "Appear", p, Isaac.GetItemConfig():GetCard(Isaac.GetCardIdByName(gfx)), GiantBookColors)
			end
			if sound then
				SFXManager():Play(sound, 1, 0)
			end
		end
    end
	Helpers:PlaySound(sfx, rng)
end

---@param sound SoundEffect | integer
---@param rng RNG?
function Helpers:PlaySound(sound, rng)
	if not rng then
		rng = RNG()
		rng:SetSeed(math.max(1, Isaac.GetFrameCount()), 35)
	end
	if Options.AnnouncerVoiceMode == 2 or Options.AnnouncerVoiceMode == 0 and rng:RandomInt(4) == 0 then
		SFXManager():Play(sound, 1, 0)
	end
end

---@param toCopy table
---@return table
local function Copy(toCopy)
	local copy = {}
	for index, value in pairs(toCopy) do
		if type(value) == "table" then
			copy[index] = Copy(value)
		else
			copy[index] = value
		end
	end

	return copy
end

---@param list table
---@param rng RNG | integer?
---@return table
function Helpers:Shuffle(list, rng)
	rng = Helpers:GetRNG(rng)
	local size, shuffled = #list, Copy(list)
	for i = size, 2, -1 do
		local j = rng:RandomInt(i) + 1
		shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
	end
	return shuffled
end

AntibirthRunes.Helpers = Helpers