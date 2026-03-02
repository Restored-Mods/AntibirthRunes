local EIDRuneSprites = Sprite()
EIDRuneSprites:Load("gfx/ui/eid_rune_icon.anm2", true)

AntibirthRunes:AddModCompat("EID", function()
	for runeId, runeData in pairs(AntibirthRunes.Constants.Descriptions) do
		for lang, data in pairs(runeData) do
			EID:addCard(runeId, data.description, data.name, lang)
			EID:addIcon("Card" .. runeId, "Runes", 0, 12, 12, 0, 0, EIDRuneSprites)
			EID:AddIconToObject(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, runeId, "Card" .. runeId)
		end
	end
end)
