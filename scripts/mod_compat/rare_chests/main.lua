AntibirthRunes:AddModCompat("RareChests", function()
	AntibirthRunes:AddCallback(
		AntibirthRunes.Enums.Callbacks.INGWAZ_OPEN_CHEST,
		RareChests.openCardboardChest,
		CARDBOARD_CHEST
	)
	AntibirthRunes:AddCallback(
		AntibirthRunes.Enums.Callbacks.INGWAZ_OPEN_CHEST,
		RareChests.openFileCabinet,
		FILE_CABINET
	)
	AntibirthRunes:AddCallback(AntibirthRunes.Enums.Callbacks.INGWAZ_OPEN_CHEST, RareChests.openCursedChest, SLOT_CHEST)
	AntibirthRunes:AddCallback(AntibirthRunes.Enums.Callbacks.INGWAZ_OPEN_CHEST, RareChests.openTombChest, TOMB_CHEST)
	AntibirthRunes:AddCallback(AntibirthRunes.Enums.Callbacks.INGWAZ_OPEN_CHEST, RareChests.openDevilChest, DEVIL_CHEST)
	AntibirthRunes:AddCallback(AntibirthRunes.Enums.Callbacks.INGWAZ_OPEN_CHEST, function(pickup, player, isInvincible)
		if not isInvincible then
            isInvincible = true
			if REPENTOGON then
				player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, false, 1, true)
			else
				player:SetMinDamageCooldown(5)
			end
		end
		RareChests.openCursedChest(pickup, player)
        return isInvincible
	end, CURSED_CHEST)
    AntibirthRunes:AddCallback(AntibirthRunes.Enums.Callbacks.INGWAZ_OPEN_CHEST, RareChests.openBloodChest, BLOOD_CHEST)
    AntibirthRunes:AddCallback(AntibirthRunes.Enums.Callbacks.INGWAZ_OPEN_CHEST, RareChests.openPenitentChest, PENITENT_CHEST)
end)
