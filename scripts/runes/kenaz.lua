local KenazRune = {}

---@param kenaz Card | integer
---@param player EntityPlayer
---@param useflags UseFlag | integer
function KenazRune:UseKenaz(kenaz, player, useflags)
	local rng = player:GetCardRNG(kenaz)
	AntibirthRunes.Helpers:PlayGiantBook("Kenaz", AntibirthRunes.Enums.SoundEffect.RUNE_KENAZ, player, rng)
	player:AddCollectible(CollectibleType.COLLECTIBLE_TOXIC_SHOCK, 0, false, 0, 0)
	player:RemoveCollectible(CollectibleType.COLLECTIBLE_TOXIC_SHOCK, true, 0, true)
	player:AddBlackHearts(1)
	if AntibirthRunes.Helpers:HasMagicChalk(player) then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_MEGA_BEAN, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
	end
end
AntibirthRunes:AddCallback(ModCallbacks.MC_USE_CARD, KenazRune.UseKenaz, AntibirthRunes.Enums.Runes.KENAZ)