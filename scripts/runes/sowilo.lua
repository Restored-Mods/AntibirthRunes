local SowiloRune = {}

---@param sowilo Card | integer
---@param player EntityPlayer
---@param useflags UseFlag | integer
function SowiloRune:UseSowilo(sowilo, player, useflags)
	local rng = player:GetCardRNG(sowilo)
	AntibirthRunes.Helpers:PlayGiantBook("Sowilo", AntibirthRunes.Enums.SoundEffect.RUNE_SOWILO, player, rng)

	if AntibirthRunes.Helpers:HasMagicChalkOrRunicTablet(player) then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
	else
		player:UseActiveItem(CollectibleType.COLLECTIBLE_D7, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
	end
end
AntibirthRunes:AddCallback(ModCallbacks.MC_USE_CARD, SowiloRune.UseSowilo, AntibirthRunes.Enums.Runes.SOWILO)