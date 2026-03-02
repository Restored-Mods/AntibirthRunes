local OthalaRune = {}

---@param othala Card | integer
---@param player EntityPlayer
---@param useflags UseFlag | integer
function OthalaRune:UseOthala(othala, player, useflags, rng, extra)
	local randomItems = {}
	if REPENTOGON then
		local itemConfig = Isaac.GetItemConfig()
		local history = player:GetHistory()

		local itemsTable = history:GetCollectiblesHistory()
		if #itemsTable > 0 then
			for _ = 1, extra do
				local index, item, collectConfig
				repeat
					index = rng:RandomInt(1, #itemsTable)
					item = itemsTable[index]:GetItemID()
					collectConfig = itemConfig:GetCollectible(item)
					if collectConfig.Type == ItemType.ITEM_ACTIVE or collectConfig:HasTags(ItemConfig.TAG_QUEST) then
						table.remove(itemsTable, index)
					else
						table.insert(randomItems, item)
						break
					end
				until #itemsTable == 0
			end
		end
	elseif player:GetCollectibleCount() > 0 then
		local playersItems = {}
		for item = 1, AntibirthRunes.Helpers:GetMaxCollectibleID() do
			local itemConfig = Isaac.GetItemConfig():GetCollectible(item)
			if
				player:HasCollectible(item)
				and itemConfig
				and itemConfig.Type ~= ItemType.ITEM_ACTIVE
				and itemConfig.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
			then
				for _ = 1, player:GetCollectibleNum(item, true) do
					table.insert(playersItems, item)
				end
			end
		end
		playersItems = AntibirthRunes.Helpers:Shuffle(playersItems)
		if #playersItems > 0 then
			for _ = 1, extra do
				local randomItem = rng:RandomInt(#playersItems) + 1
				table.insert(randomItems, playersItems[randomItem])
			end
		end
	end
	while #randomItems > 0 do
		player:AnimateCollectible(randomItems[1], "UseItem", "PlayerPickup")
		player:QueueItem(Isaac.GetItemConfig():GetCollectible(randomItems[1]))
		SFXManager():Play(SoundEffect.SOUND_POWERUP1, 1, 0)
		table.remove(randomItems, 1)
	end
	return true
end
AntibirthRunes:AddInternalCallback(
	AntibirthRunes.Enums.Callbacks.RUN_RUNE_MAIN,
	OthalaRune.UseOthala,
	AntibirthRunes.Enums.Runes.OTHALA,
	1
)

return OthalaRune
