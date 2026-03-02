local GeboRune = {}

function GeboRune.GetSlots()
	local slots = {}
	for _, slot in ripairs(Isaac.GetRoomEntities()) do
		if Gebo.IsGeboSlot(slot) then
			table.insert(slots, slot)
		end
	end
	return slots
end

---@param gebo Card | integer
---@param player EntityPlayer
---@param useflags UseFlag | integer
function GeboRune:UseGebo(gebo, player, useflags, rng)
	local slots = GeboRune.GetSlots()
	for _, slot in ipairs(slots) do
		if slot:GetSprite():GetAnimation() ~= "Broken" and slot:GetSprite():GetAnimation() ~= "Death" then
			if Gebo.GetGeboSlot(slot).REPENTOGON then
				if not Gebo.GetData(slot).GeboUses then
					Gebo.GetData(slot).GeboUses = 0
				end
				Gebo.GetData(slot).GeboUses = Gebo.GetData(slot).GeboUses + Gebo.GetGeboSlot(slot).Plays
			else
				if not Gebo.GetData(slot).Gebo then
					local rng = slot:GetDropRNG()
					Gebo.GetData(slot).Gebo = { Uses = Gebo.GetGeboSlot(slot).Plays, rng = rng, Player = player }
				else
					Gebo.GetData(slot).Gebo.Uses = Gebo.GetData(slot).Gebo.Uses + Gebo.GetGeboSlot(slot).Plays
				end
			end
		end
	end
	return true
end
AntibirthRunes:AddInternalCallback(
	AntibirthRunes.Enums.Callbacks.RUN_RUNE_MAIN,
	GeboRune.UseGebo,
	AntibirthRunes.Enums.Runes.GEBO
)

return GeboRune
