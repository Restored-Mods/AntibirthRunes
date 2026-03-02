AntibirthRunes:AddModCompat("RunicTablet", function()
	AntibirthRunes:AddInternalPriorityCallback(
		AntibirthRunes.Enums.Callbacks.RUN_RUNE_EXTRA,
		-1,
		function(_, fehu, player, useflags, rng, time, div)
			if AntibirthRunes.Helpers:HasRunicTablet(player) then
				AntibirthRunes.Runes.FEHU:UseFehu(fehu, player, useflags, rng, time, div)
				return true
			end
		end,
		AntibirthRunes.Enums.Runes.FEHU,
		300,
		1
	)
	AntibirthRunes:AddInternalPriorityCallback(
		AntibirthRunes.Enums.Callbacks.RUN_RUNE_EXTRA,
		-1,
		function(_, gebo, player, useflags, rng)
			if AntibirthRunes.Helpers:HasRunicTablet(player) then
				local slots = AntibirthRunes.Runes.GEBO.GetSlots()
				if rng:RandomInt(2) == 0 and #slots > 0 then
					local slot = slots[rng:RandomInt(#slots) + 1]
					if Gebo.IsGeboSlot(slot) then
						local rng = slot:GetDropRNG()
						local newslot = Isaac.Spawn(
							slot.Type,
							slot.Variant,
							slot.SubType,
							Game():GetRoom():FindFreeTilePosition(slot.Position, 9999),
							Vector.Zero,
							nil
						)
						if Gebo.GetGeboSlot(slot).REPENTOGON then
							Gebo.GetData(newslot).GeboUses = Gebo.GetGeboSlot(slot).Plays
						else
							Gebo.GetData(newslot).Gebo =
								{ Uses = Gebo.GetGeboSlot(slot).Plays, rng = rng, Player = player }
						end
						SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0, false)
					end
				end
				return true
			end
		end,
		AntibirthRunes.Enums.Runes.GEBO
	)
	AntibirthRunes:AddInternalPriorityCallback(
		AntibirthRunes.Enums.Callbacks.RUN_RUNE_EXTRA,
		-1,
		function(_, sowilo, player, useflags, rng)
			if AntibirthRunes.Helpers:HasRunicTablet(player) then
				player:UseActiveItem(
					CollectibleType.COLLECTIBLE_MEGA_BEAN,
					UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER
				)
				return true
			end
		end,
		AntibirthRunes.Enums.Runes.KENAZ
	)
	AntibirthRunes:AddInternalPriorityCallback(
		AntibirthRunes.Enums.Callbacks.RUN_RUNE_MAIN,
		-1,
		function(_, othala, player, useflags, rng, extra)
			if AntibirthRunes.Helpers:HasRunicTablet(player) then
				AntibirthRunes.Runes.OTHALA:UseOthala(othala, player, useflags, rng, extra)
				return true
			end
		end,
		AntibirthRunes.Enums.Runes.OTHALA,
		2
	)
	AntibirthRunes:AddInternalPriorityCallback(
		AntibirthRunes.Enums.Callbacks.RUN_RUNE_EXTRA,
		-1,
		function(_, sowilo, player, useflags, rng)
			if AntibirthRunes.Helpers:HasRunicTablet(player) then
				player:UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
				return true
			end
		end,
		AntibirthRunes.Enums.Runes.INGWAZ
	)
	AntibirthRunes:AddInternalPriorityCallback(
		AntibirthRunes.Enums.Callbacks.RUN_RUNE_MAIN,
		-1,
		function(_, sowilo, player, useflags, rng)
			if AntibirthRunes.Helpers:HasRunicTablet(player) then
				player:UseActiveItem(
					CollectibleType.COLLECTIBLE_FORGET_ME_NOW,
					UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER
				)
				return true
			end
		end,
		AntibirthRunes.Enums.Runes.SOWILO
	)
    for _, rune in pairs(AntibirthRunes.Enums.Runes) do
		RunicTablet.Collectible.RunicTablet.CUSTOM_EFFECTS[rune] = true
	end
end)

AntibirthRunes:AddModCompat(function()
	return EID and RunicTablet
end, function()
	local function HodlingTab()
		return EID.Config["ItemReminderEnabled"]
			and EID.holdTabCounter >= 30
			and EID.TabDescThisFrame == false
			and EID.holdTabPlayer ~= nil
	end

	local descriptions = {
		modifiers = {
			[AntibirthRunes.Enums.Runes.FEHU] = function(descObj, player, language)
				descObj.Description = descObj.Description:gsub("5", "{{ColorShinyPurple}}10{{CR}}")
				descObj.Description = descObj.Description:gsub("half", "all")
				descObj.Description =
					descObj.Description:gsub("к половине монстров", "ко всем монстрам")
				return descObj
			end,
			[AntibirthRunes.Enums.Runes.OTHALA] = function(descObj, player, lang)
				if lang == "ru" then
					descObj.Description = descObj.Description:gsub(
						"1 случайную копию предмета, который",
						"{{ColorShinyPurple}}2{{CR}} случайные копии предметов, которые"
					)
				elseif lang == "en_us" then
					descObj.Description =
						descObj.Description:gsub("1 copy of item", "{{ColorShinyPurple}}2{{CR}} copies of items")
				end
				return descObj
			end,
		},
		appends = {
			[AntibirthRunes.Enums.Runes.GEBO] = {
				en_us = "Creates random copy of slot or beggar in room",
				--spa = "",
				ru = "Создает случайную копию машины или попрошайки в комнате",
			},
			[AntibirthRunes.Enums.Runes.INGWAZ] = {
				en_us = "Activates {{Collectible175}} Dad's Key effect",
				--spa = "",
				ru = "Актиирует эффект {{Collectible175}} Папиного ключа",
			},
			[AntibirthRunes.Enums.Runes.KENAZ] = {
				en_us = "Activates {{Collectible351}} Mega Bean effect",
				--spa = "",
				ru = "Активирует эффект {{Collectible351}} Мега боба",
			},
		},
		replaces = {
			[AntibirthRunes.Enums.Runes.SOWILO] = {
				en_us = "Rerolls and restarts the entire floor",
				--spa = "",
				ru = "Текущий уровень перезапускается и генерируется заново",
			},
		},
	}

	for rune, desc in pairs(AntibirthRunes.Constants.Descriptions) do
        for i = #RunicTablet.Compat.EID.MODIFIERS, 1, -1 do
            if RunicTablet.Compat.EID.MODIFIERS[i][1] == "RR_RUNICTABLET_APPEND_"..rune then
                table.remove(RunicTablet.Compat.EID.MODIFIERS, i)
            end
        end
        local runic_modifier_name = "KK_" .. string.gsub(string.upper(RunicTablet.Name), " ", "") .. "_" .. "RR_RUNICTABLET_APPEND_" .. rune
        EID:removeDescriptionModifier(runic_modifier_name)
		EID:addDescriptionModifier("RunicTabletCompatRune_" .. rune, function(descObj)
			return descObj
				and descObj.ObjType == EntityType.ENTITY_PICKUP
				and descObj.ObjVariant == PickupVariant.PICKUP_TAROTCARD
				and descObj.ObjSubType == rune
		end, function(descObj)
			local language = EID:getLanguage()
			local player
			if HodlingTab() then
				player = EID.holdTabPlayer
			elseif descObj and descObj.Entity then
				player = Game():GetNearestPlayer(descObj.Entity.Position)
			end
			if player and player:HasCollectible(RunicTablet.Collectible.RunicTablet.ID) then
				if descriptions.replaces and descriptions.replaces[rune] then
					local original
                    if desc[language] and desc[language].description then
                        original = desc[language].description
                    end 
                    if original == nil and desc["en_us"] and desc["en_us"].description then
                        original = desc["en_us"].description
                    end
					local replace = descriptions.replaces[rune][language] or descriptions.replaces[rune]["en_us"]
					if original ~= nil and replace ~= nil then
						descObj.Description = descObj.Description:gsub(original, replace)
					end
				end
				if descriptions.modifiers and descriptions.modifiers[rune] then
					descObj = descriptions.modifiers[rune](descObj, player, language)
				end
				if descriptions.appends and descriptions.appends[rune] then
					local append = descriptions.appends[rune][language] or descriptions.appends[rune]["en_us"]
					if append ~= nil then
						descObj.Description = descObj.Description .. "#{{Collectible" .. RunicTablet.Collectible.RunicTablet.ID .. "}} " .. append
					end
				end
			end
			return descObj
		end)
	end
end)
