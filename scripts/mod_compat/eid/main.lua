local EIDRuneSprites = Sprite()
EIDRuneSprites:Load("gfx/ui/eid_rune_icon.anm2", true)

AntibirthRunes:AddModCompat("EID", function()
	local function HodlingTab()
		return EID.Config["ItemReminderEnabled"]
			and EID.holdTabCounter >= 30
			and EID.TabDescThisFrame == false
			and EID.holdTabPlayer ~= nil
	end

	local Descriptions = {
		[AntibirthRunes.Enums.Runes.FEHU] = {
			en_us = {
				name = "Fehu",
				description = "Applies the Midas Touch effect to half the monsters in a room for 5 seconds",
			},
			spa = {
				name = "Fehu",
				description = "Aplica el efecto de Toque de Midas a la mitad de los monstruos en una habitación por 5 segundos",
			},
			ru = {
				name = "Феху",
				description = "Применяет эффект Прикосновения Мидаса к половине монстров в комнате на 5 секунд",
			},
			modifier = function(descObj, player, lang)
				descObj.Description = descObj.Description:gsub("5", "10")
				return descObj
			end,
		},
		[AntibirthRunes.Enums.Runes.GEBO] = {
			en_us = {
				name = "Gebo",
				description = "Interacts with any machine or beggar in the room."
					.. "#Plays beggars 6 times, plays blood machines 4 times, plays other machines 5 times."
					.. "#Machines and beggars have an increased chance to pay out or explode, even paying out at only one play.",
                modifier_description = "Creates random copy of slot or beggar in room",
			},
			spa = {
				name = "Gebo",
				description = "Interactúa con cualquier máquina o mendigo en la habitación."
					.. "#Usa mendigos 6 veces, usa donadores de sangre 4 veces, usa otras máquinas 5 veces."
					.. "#Las máquinas y los mendigos tienen una mayor probabilidad de pagar o explotar, incluso pagando en una sola jugada.",
			},
			ru = {
				name = "Гебо",
				description = "Взаимодействует с любыми машиной или попрошайкой в ​​комнате."
					.. "#Попрошайки - 6 раз, донорские машины - 4 раза, остальные - 5 раз."
					.. "#Машины и попрошайки имеют повышенный шанс на награды или взорваться, даже если заплатят только за одну игру.",
                modifier_description = "Создает случайную копию машины или попрошайки в комнате",
			},
		},
		[AntibirthRunes.Enums.Runes.INGWAZ] = {
			en_us = {
				name = "Ingwaz",
				description = "Unlocks every chest in the room",
                modifier_description = "Activated {{Collectible175}} Dad's Key effect",
			},
			spa = {
				name = "Ingwaz",
				description = "Abre todos los cofres de una sala",
			},
			ru = {
				name = "Игваз",
				description = "Открывает все сундуки в комнате",
                modifier_description = "Activated {{Collectible351}} Mega Bean effect",
			},
		},
		[AntibirthRunes.Enums.Runes.KENAZ] = {
			en_us = {
				name = "Kenaz",
				description = "Poisons all enemies in the room#{{HalfBlackHeart}} Gives half black heart",
                modifier_description = "Активирует эффект {{Collectible351}} Мега боба",
			},
			spa = {
				name = "Kenaz",
				description = "Envenena a todos los enemigos en la sala",
			},
			ru = {
				name = "Кеназ",
				description = "Отравляет всех врагов в комнате",
                modifier_description = "Активирует эффект {{Collectible351}} Мега боба",
			},
		},
		[AntibirthRunes.Enums.Runes.OTHALA] = {
			en_us = {
				name = "Othala",
				description = "Gives 1 random copy of item that Isaac currently has",
			},
			spa = {
				name = "Othala",
				description = "Te da una copia de un objeto ya existente en tu inventario",
			},
			ru = {
				name = "Отала",
				description = "Дает 1 случайную копию предмета, который в данный момент есть у Айзека.",
			},
            modifier = function(descObj, player, lang)
                if lang == "ru" then
                    descObj.Description = descObj.Description:gsub("1 случайную копию предмета, который", "2 случайные копии предметов, которые")
                elseif lang == "en_us" then
                    descObj.Description = descObj.Description:gsub("1 copy of item", "2 copies of items")
                end
				return descObj
			end,
		},
		[AntibirthRunes.Enums.Runes.SOWILO] = {
			en_us = {
				name = "Sowilo",
				description = "Respawn all enemies of the room"
					.. "#Allows you to farm room clear rewards"
					.. "#!!! If used in a greed fight, it can reroll the room into a Shop",
                replace_description = "Rerolls and restarts the entire floor"
			},
			spa = {
				name = "Sowilo",
				description = "Revive a los enemigos de una sala limpia"
					.. "#Permite conseguir más recompensas"
					.. "#!!! Si se usa en una pelea contra Greed, puede cambiar la sala a una tienda",
			},
			ru = {
				name = "Совило",
				description = "Восстанавливает ранее убитых врагов в комнате"
					.. "#Позволяет повторно получить награду за зачистку комнаты"
					.. "#!!! Если использовать в борьбе с жадностью, можно превратить комнату в магазин",
                replace_description = "Текущий уровень перезапускается и генерируется заново",
			},
		},
	}

	for runeId, runeData in pairs(Descriptions) do
        local original_description = {}
        local extra_description = {}
        local replace_description = {}
		for lang, data in pairs(runeData) do
			if type(data) ~= "function" then
				EID:addCard(runeId, data.description, data.name, lang)
                original_description[lang] = data.description
                if type(data.modifier_description) == "string" then
                    extra_description[lang] = data.modifier_description
                end
                if type(data.replace_description) == "string" then
                    replace_description[lang] = data.replace_description
                end
                EID:addIcon("Card"..runeId, "Runes", 0, 12, 12, 0, 0, EIDRuneSprites)
                EID:AddIconToObject(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, runeId, "Card"..runeId)
			end
		end
		EID:addDescriptionModifier("Rune id " .. runeId .. " modifier", function(descObj)
			return descObj
					and descObj.ObjType == EntityType.ENTITY_PICKUP
                    and descObj.ObjVariant == PickupVariant.PICKUP_TAROTCARD
                    and descObj.ObjSubType == runeId
		end, function(descObj)
			local lang = EID:getLanguage()
			local player
			if HodlingTab() then
				player = EID.holdTabPlayer
			elseif descObj and descObj.Entity then
				player = Game():GetNearestPlayer(descObj.Entity.Position)
			end
            local hasMagicChalk, magicChalkId = AntibirthRunes.Helpers:HasMagicChalk(player)
			if player ~= nil and hasMagicChalk then
                local language
                if replace_description[lang] then
                    language = lang
                elseif replace_description["en_us"] then
                    language = "en_us"
                end
                if language ~= nil then
                    descObj.Description = descObj.Description:gsub(original_description[language], replace_description[language])
                end
                if type(runeData.modifier) == "function" then
				    descObj = runeData.modifier(descObj, player, lang)
                end
                local extra_descrition_lang = extra_description[lang] or extra_description["en_us"]
                if extra_descrition_lang ~= nil then
                    descObj.Description = descObj.Description.."#{{Collectible"..magicChalkId.."}} "..extra_descrition_lang
                end
			end
			return descObj
		end)
	end
end)
