local IngwazRune = {}

local chests = {
    [PickupVariant.PICKUP_CHEST] = true,
    [PickupVariant.PICKUP_BOMBCHEST] = true,
    [PickupVariant.PICKUP_SPIKEDCHEST] = true,
    [PickupVariant.PICKUP_ETERNALCHEST] = true,
    [PickupVariant.PICKUP_MIMICCHEST] = true,
    [PickupVariant.PICKUP_OLDCHEST] = true,
    [PickupVariant.PICKUP_WOODENCHEST] = true,
    [PickupVariant.PICKUP_MEGACHEST] = true,
    [PickupVariant.PICKUP_HAUNTEDCHEST] = true,
    [PickupVariant.PICKUP_LOCKEDCHEST] = true,
    [PickupVariant.PICKUP_REDCHEST] = true,
    [PickupVariant.PICKUP_MOMSCHEST] = true,
}

local function IsChest(pickup)
	return chests[pickup.Variant] ~= nil
end

---@param ingwaz Card | integer
---@param player EntityPlayer
---@param useflags UseFlag | integer
function IngwazRune:UseIngwaz(ingwaz, player, useflags)
	local entities = Isaac.GetRoomEntities()
	local rng = player:GetCardRNG(ingwaz)
	AntibirthRunes.Helpers:PlayGiantBook("Ingwaz", AntibirthRunes.Enums.SoundEffect.RUNE_INGWAZ, player, rng)
	local isInvinsible = false
	for i = 1, #entities do
		if entities[i]:ToPickup() then
			local pickup = entities[i]:ToPickup()
			if IsChest(pickup) then
				pickup:TryOpenChest(player)
			else
			end
			local callbacks = Isaac.GetCallbacks(AntibirthRunes.Enums.Callbacks.INGWAZ_OPEN_CHEST)
			for _, callback in ipairs(callbacks) do
				if callback.Param and callback.Param == pickup.Variant then
					local ret = callback.Function(pickup, player, isInvinsible)
					if type(ret) == "boolean" and ret == true then
						isInvinsible = ret
					end
				end
			end
		end
	end
	if AntibirthRunes.Helpers:HasMagicChalk(player) then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
	end
end
AntibirthRunes:AddCallback(ModCallbacks.MC_USE_CARD, IngwazRune.UseIngwaz, AntibirthRunes.Enums.Runes.INGWAZ)