AntibirthRunes = RegisterMod("Antibirth Runes", 1)
local mod = AntibirthRunes
local json = require("json")
local Runes = {}

include("scripts.enums")
include("scripts.helpers")
include("libs.gebo.main")
include("scripts.runes.fehu")
include("scripts.runes.gebo")
include("scripts.runes.ingwaz")
include("scripts.runes.kenaz")
include("scripts.runes.othala")
include("scripts.runes.sowilo")
include("scripts.mod_compat.main")


local function RefreshSaveData()
	if mod:HasData() then
		mod.SavedData = json.decode(mod:LoadData())
		if not mod.SavedData or type(mod.SavedData.BookAPI) ~= "number" or type(mod.SavedData.GeboData) ~= "table" then
			mod.SavedData = {
				BookAPI = 3,
				GeboData = {},
			}

			mod:SaveData(json.encode(mod.SavedData))
		end
		local prevAPI = mod.SavedData.BookAPI
		mod.SavedData.BookAPI = AntibirthRunes.Helpers:CheckAvailableAPI(prevAPI)
		if prevAPI ~= mod.SavedData.BookAPI then
			mod:SaveData(json.encode(mod.SavedData))
		end
	else
		mod.SavedData = {
			BookAPI = 3,
			GeboData = {},
		}

		mod:SaveData(json.encode(mod.SavedData))
	end
end

RefreshSaveData()

if ModConfigMenu and not REPENTOGON then
	local RunesMCM = "Antibirth Runes"
	ModConfigMenu.UpdateCategory(RunesMCM, {
		Info = { "Configuration for API mod." },
	})

	ModConfigMenu.AddSetting(RunesMCM, {
		Type = ModConfigMenu.OptionType.NUMBER,
		CurrentSetting = function()
			return mod.SavedData.BookAPI
		end,
		Default = 1,
		Minimum = 1,
		Maximum = 3,
		Display = function()
			return "Preffered API to use: " .. AntibirthRunes.Enums.UseAPI[mod.SavedData.BookAPI]
		end,
		OnChange = function(currentNum)
			mod.SavedData.BookAPI = AntibirthRunes.Helpers:CheckAvailableAPI(currentNum, mod.SavedData.BookAPI)
			mod:SaveData(json.encode(mod.SavedData))
		end,
		Info = "Preffered API for animations.",
	})
end

if not REPENTOGON then
	function Runes:SaveData(isSaving)
		if isSaving then
			mod.SavedData.GeboData = Gebo.GetSaveData()
			mod:SaveData(json.encode(mod.SavedData))
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, Runes.SaveData)
	mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
		Runes:SaveData(true)
	end)

	function Runes:LoadData(isLoading)
		if isLoading then
			RefreshSaveData()
			Gebo.LoadSaveData(mod.SavedData.GeboData)
		else
			mod.SavedData.GeboData = {}
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Runes.LoadData)
end

--ripairs stuff from revel
function ripairs_it(t, i)
	i = i - 1
	local v = t[i]
	if v == nil then
		return v
	end
	return i, v
end
function ripairs(t)
	return ripairs_it, t, #t + 1
end
