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
	local addInvFrames = false
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
					callback.Function(pickup, player)
				end
			end
			if RepentancePlusMod then
				if pickup.Variant == RepentancePlusMod.CustomPickups.FLESH_CHEST then
					RepentancePlusMod.openFleshChest(pickup)
				elseif pickup.Variant == RepentancePlusMod.CustomPickups.SCARLET_CHEST then
					RepentancePlusMod.openScarletChest(pickup)
				elseif pickup.Variant == RepentancePlusMod.CustomPickups.BLACK_CHEST then
					RepentancePlusMod.openBlackChest(pickup)
				end
			end
			if RareChests then
				if pickup.Variant == CARDBOARD_CHEST then
					RareChests.openCardboardChest(pickup, player)
				elseif pickup.Variant == FILE_CABINET then
					RareChests.openFileCabinet(pickup, player)
				elseif pickup.Variant == SLOT_CHEST then
					RareChests.openCursedChest(pickup, player)
				elseif pickup.Variant == TOMB_CHEST then
					RareChests.openTombChest(pickup)
				elseif pickup.Variant == DEVIL_CHEST then
					RareChests.openDevilChest(pickup, player)
				elseif pickup.Variant == CURSED_CHEST then
					if not addInvFrames then
						addInvFrames = true
						if REPENTOGON then
							player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, false, 1, true)
						else
							player:SetMinDamageCooldown(5)
						end
					end
					RareChests.openCursedChest(pickup, player)
				elseif pickup.Variant == BLOOD_CHEST then
					RareChests.openBloodChest(pickup)
				elseif pickup.Variant == PENITENT_CHEST then
					RareChests.openPenitentChest(pickup)
				end
			end
		end
	end
	if AntibirthRunes.Helpers:HasMagicChalk(player) then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
	end
end
AntibirthRunes:AddCallback(ModCallbacks.MC_USE_CARD, IngwazRune.UseIngwaz, AntibirthRunes.Enums.Runes.INGWAZ)