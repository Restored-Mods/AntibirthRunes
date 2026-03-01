local FehuRune = {}

---@param fehu Card | integer
---@param player EntityPlayer
---@param useflags UseFlag | integer
function FehuRune:UseFehu(fehu, player, useflags)
	local rng = player:GetCardRNG(fehu)
	AntibirthRunes.Helpers:PlayGiantBook("Fehu", AntibirthRunes.Enums.SoundEffect.RUNE_FEHU, player, rng)
	local entities = {}
	for _, e in pairs(Isaac.GetRoomEntities()) do
		if
			e:IsActiveEnemy(false)
			and e:IsEnemy()
			and e:IsVulnerableEnemy()
			and not EntityRef(e).IsCharmed
			and not EntityRef(e).IsFriendly
		then
			table.insert(entities, e)
		end
	end
	local div = AntibirthRunes.Helpers:HasMagicChalkOrRunicTablet(player) and 1 or 2
	entities = AntibirthRunes.Helpers:Shuffle(entities, rng)
	for i = 1, math.ceil(#entities / div) do
		entities[i]:AddMidasFreeze(EntityRef(player), 300 / div)
	end
	Game():GetRoom():TurnGold()
end
AntibirthRunes:AddCallback(ModCallbacks.MC_USE_CARD, FehuRune.UseFehu, AntibirthRunes.Enums.Runes.FEHU)