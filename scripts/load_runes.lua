local Runes = {}

local lowestRuneId, highestRuneId
for _, id in pairs(AntibirthRunes.Enums.Runes) do
    lowestRuneId = lowestRuneId == nil and id or math.min(lowestRuneId, id)
    highestRuneId = highestRuneId == nil and id or math.max(highestRuneId, id)
end

local internalCallbacks = {}

function AntibirthRunes:AddInternalPriorityCallback(id, priority, func, rune, ...)
    if not internalCallbacks[id] then
        internalCallbacks[id] = {}
    end
    local index = 1
    local callbacks = internalCallbacks[id]
    for i = #callbacks, 1, -1 do
        local callback = callbacks[i]
        if priority >= callback.Priority then
            index = i + 1
            break
        end
    end
    table.insert(callbacks, index, {
        Priority = priority,
        Function = func,
        CallbackID = id,
        Rune = rune,
        Params = {...},
    })
end

local function GetInternalCallbacks(id)
    return internalCallbacks[id] or {}
end

function AntibirthRunes:AddInternalCallback(id, func, rune, ...)
    AntibirthRunes:AddInternalPriorityCallback(id, 0, func, rune, ...)
end

AntibirthRunes.Runes = {}
AntibirthRunes.Runes.FEHU = include("scripts.runes.fehu")
AntibirthRunes.Runes.GEBO = include("scripts.runes.gebo")
AntibirthRunes.Runes.INGWAZ = include("scripts.runes.ingwaz")
AntibirthRunes.Runes.KENAZ = include("scripts.runes.kenaz")
AntibirthRunes.Runes.OTHALA = include("scripts.runes.othala")
AntibirthRunes.Runes.SOWILO = include("scripts.runes.sowilo")

local function RunCallbacks(id, rune, player, useflags, rng)
    for _, callback in ipairs(GetInternalCallbacks(id)) do
        if callback.Rune == rune then
            local ret = callback.Function(_, rune, player, useflags, rng, table.unpack(callback.Params))
            if ret ~= nil then
                break
            end
        end
    end
end

function Runes:UseRune(rune, player, useflags)
    if rune < lowestRuneId or rune > highestRuneId then
        return
    end
    local rng = player:GetCardRNG(rune)
	AntibirthRunes.Helpers:PlayGiantBook(AntibirthRunes.Enums.RuneNames[rune], Isaac.GetSoundIdByName(AntibirthRunes.Enums.RuneNames[rune]), player, rng)
    RunCallbacks(AntibirthRunes.Enums.Callbacks.RUN_RUNE_MAIN, rune, player, useflags, rng)
    RunCallbacks(AntibirthRunes.Enums.Callbacks.RUN_RUNE_EXTRA, rune, player, useflags, rng)
end
AntibirthRunes:AddCallback(ModCallbacks.MC_USE_CARD, Runes.UseRune)