PW_Billions = PW_Billions or {}
PW_Billions.FRAME_W = ScrW() * 0.8
PW_Billions.FRAME_H = ScrH() * 0.8

PW_Billions.PC_LIST_W = ScrW() * 0.15
PW_Billions.PC_ITEMLABEL_H = ScrH() * 0.05
PW_Billions.PC_ITEMDESC_H = ScrH() * 0.1

PW_Billions.BUTTON_W = ScrW() * 0.1
PW_Billions.BUTTON_H = ScrH() * 0.05
PW_Billions.PC_TEXTENTRY_W = ScrW() * 0.4
PW_Billions.PC_TEXTENTRY_H = ScrH() * 0.06
PW_Billions.PC_SETTINGS_LABEL_W = ScrW() * 0.28
PW_Billions.PC_SETTINGS_LABEL_H = ScrH() * 0.05

--For small confirmation boxes
PW_Billions.SMALL_FRAME_W = ScrW() * 0.4
PW_Billions.SMALL_FRAME_H = ScrH() * 0.4
PW_Billions.SMALL_LABEL = ScrW() * 0.15
PW_Billions.SMALL_LABEL = ScrH() * 0.05

--For company settings panel and mayorpc license list in businessPC
PW_Billions.SORTINGPANEL_H = ScrH() * 0.07
PW_Billions.SORTINGPANEL_BUTTON_W = ScrW() * 0.08
PW_Billions.TEXTENTRY_W = ScrW() * 0.4

surface.CreateFont( "FrameTitleFont", {
	font = "Jura",
	extended = false,
	size = ScrW() * 0.014,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "FrameTitleFontSmall", {
	font = "Jura",
	extended = false,
	size = ScrW() * 0.012,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "FrameTextFont", {
	font = "Jura",
	extended = false,
	size = ScrW() * 0.01,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "FrameTabFont", {
	font = "Jura",
	extended = false,
	size = ScrW() * 0.0097,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "FrameListViewColumnFont", {
	font = "Jura",
	extended = false,
	size = ScrW() * 0.0095,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "TutorialTextFont", {
	font = "Resamitz",
	extended = false,
	size = ScrW() * 0.0113,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "ButtonFont", {
	font = "Jura",
	extended = false,
	size = ScrW() * 0.012,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "WindowCloseButtonFont", {
	font = "Jura",
	extended = false,
	size = ScrW() * 0.011,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "NPCFont", {
	font = "Jura",
	extended = false,
	size = 54,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )
