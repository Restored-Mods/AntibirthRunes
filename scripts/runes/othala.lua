local OthalaRune = {}

---@param othala Card | integer
---@param player EntityPlayer
---@param useflags UseFlag | integer
function OthalaRune:UseOthala(othala, player, useflags)
	local rng = player:GetCardRNG(othala)
	AntibirthRunes.Helpers:PlayGiantBook("Othala", AntibirthRunes.Enums.SoundEffect.RUNE_OTHALA, player, rng)
	if REPENTOGON then
		local itemConfig = Isaac.GetItemConfig()
		local history = player:GetHistory()

		local itemsTable = history:GetCollectiblesHistory()
		if #itemsTable == 0 then
			return
		end
		local index, item, collectConfig
		local itemsToGet = AntibirthRunes.Helpers:HasMagicChalk(player) and 2 or 1
		for _ = 1, itemsToGet do
			repeat
				index = rng:RandomInt(1, #itemsTable)
				item = itemsTable[index]:GetItemID()
				collectConfig = itemConfig:GetCollectible(item)
				if
					collectConfig.Hidden
					or collectConfig.Type == ItemType.ITEM_ACTIVE
					or collectConfig:HasTags(ItemConfig.TAG_QUEST)
				then
					table.remove(itemsTable, index)
					index = nil
				end
			until index or #itemsTable == 0
			if index then
				player:AnimateCollectible(item, "UseItem", "PlayerPickup")
				player:QueueItem(Isaac.GetItemConfig():GetCollectible(item))
				SFXManager():Play(SoundEffect.SOUND_POWERUP1, 1, 0)
			end
			index = nil
		end
	else
		if player:GetCollectibleCount() > 0 then
			local playersItems = {}
			for item = 1, AntibirthRunes.Helpers:GetMaxCollectibleID() do
				local itemConfig = Isaac.GetItemConfig():GetCollectible(item)
				if
					player:HasCollectible(item)
					and itemConfig.Type ~= ItemType.ITEM_ACTIVE
					and itemConfig.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
					and not itemConfig.Hidden
				then
					for _ = 1, player:GetCollectibleNum(item, true) do
						table.insert(playersItems, item)
					end
				end
			end
			playersItems = AntibirthRunes.Helpers:Shuffle(playersItems)
			if #playersItems > 0 then
				local randomItem = player:GetCardRNG(othala):RandomInt(#playersItems) + 1
				player:AnimateCollectible(playersItems[randomItem], "UseItem", "PlayerPickup")
				player:QueueItem(Isaac.GetItemConfig():GetCollectible(playersItems[randomItem]))
				SFXManager():Play(SoundEffect.SOUND_POWERUP1, 1, 0)
			end
			if AntibirthRunes.Helpers:HasMagicChalk(player) then
				if #playersItems > 0 then
					local randomItem = player:GetCardRNG(othala):RandomInt(#playersItems) + 1
					player:AnimateCollectible(playersItems[randomItem], "UseItem", "PlayerPickup")
					player:QueueItem(Isaac.GetItemConfig():GetCollectible(playersItems[randomItem]))
					SFXManager():Play(SoundEffect.SOUND_POWERUP1, 1, 0)
				end
			end
		end
	end
end
AntibirthRunes:AddCallback(ModCallbacks.MC_USE_CARD, OthalaRune.UseOthala, AntibirthRunes.Enums.Runes.OTHALA)
