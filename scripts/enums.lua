local Enums = {}

Enums.Runes = {
	GEBO = Isaac.GetCardIdByName("Gebo"),
	KENAZ = Isaac.GetCardIdByName("Kenaz"),
	FEHU = Isaac.GetCardIdByName("Fehu"),
	OTHALA = Isaac.GetCardIdByName("Othala"),
	SOWILO = Isaac.GetCardIdByName("Sowilo"),
	INGWAZ = Isaac.GetCardIdByName("Ingwaz"),
}

Enums.SoundEffect = {
	RUNE_GEBO = Isaac.GetSoundIdByName("Gebo"),
	RUNE_KENAZ = Isaac.GetSoundIdByName("Kenaz"),
	RUNE_FEHU = Isaac.GetSoundIdByName("Fehu"),
	RUNE_OTHALA = Isaac.GetSoundIdByName("Othala"),
	RUNE_SOWILO = Isaac.GetSoundIdByName("Sowilo"),
	RUNE_INGWAZ = Isaac.GetSoundIdByName("Ingwaz"),
}

Enums.Callbacks = {
    INGWAZ_OPEN_CHEST = "INGWAZ_OPEN_CHEST"
}

Enums.UseAPI = {
	[1] = "GiantBook API",
	[2] = "Screen API",
	[3] = "None",
}

AntibirthRunes.Enums = Enums