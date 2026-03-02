local KenazRune = {}

---@param kenaz Card | integer
---@param player EntityPlayer
---@param useflags UseFlag | integer
function KenazRune:UseKenaz(kenaz, player, useflags, rng)
	player:AddCollectible(CollectibleType.COLLECTIBLE_TOXIC_SHOCK, 0, false, 0, 0)
	player:RemoveCollectible(CollectibleType.COLLECTIBLE_TOXIC_SHOCK, true, 0, true)
	player:AddBlackHearts(1)
	return true
end
AntibirthRunes:AddInternalCallback(
	AntibirthRunes.Enums.Callbacks.RUN_RUNE_MAIN,
	KenazRune.UseKenaz,
	AntibirthRunes.Enums.Runes.KENAZ
)

return KenazRune
