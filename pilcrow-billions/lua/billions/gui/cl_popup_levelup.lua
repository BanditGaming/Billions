hook.Add("PW_Billions_Company_LevelUp", "PW_Billions_GUI_LevelUp", function(company, currentLevel, pastLevel, addedSkillPoints)
  if LocalPlayer():getCompany() and LocalPlayer():getCompany() == company then
    surface.PlaySound("billions/level_up.mp3")

    local alpha = 0
    local skillPointMessage = false
    --changes the font (blursize) based on the timer for a nice level up animation
    local fontCount = 1
    timer.Create("PW_Billions_AlphaTimer", 0.1, 30, function()
      alpha = alpha + 8.5
      if alpha == 255 then
        skillPointMessage = true
      end

      fontCount = fontCount + 1
    end)
    hook.Add("HUDPaint", "PW_Billions_GUI_LevelUp_Draw", function()
      surface.SetTextColor(172, 172, 185, alpha)
      surface.SetTextPos(ScrW() * 0.425, ScrH() * 0.12)
      surface.SetFont("LevelPopupFont" .. fontCount)
      surface.DrawText(PW_Billions.getPhrase("levelUp"))
      if skillPointMessage then
        surface.SetTextColor(200, 200, 208, 255)
        surface.SetTextPos(ScrW() * 0.45, ScrH() * 0.19)
        surface.SetFont("LevelPopupFontSmall")
        surface.DrawText("+ " .. addedSkillPoints .. " " .. PW_Billions.getPhrase("skillPoints"))
      end
    end)

    timer.Simple(8, function()
      hook.Remove("HUDPaint", "PW_Billions_GUI_LevelUp_Draw")
    end)
  end
end)

surface.CreateFont( "LevelPopupFont1", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 4.5,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont2", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 3.8,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont3", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 3.5,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont4", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 3.1,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont5", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 2.8,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont6", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 2.5,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont7", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 2.4,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont8", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 2.3,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont9", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 2.2,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont10", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 2.1,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont11", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 2,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont12", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 1.9,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )
surface.CreateFont( "LevelPopupFont13", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 1.8,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont14", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 1.7,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont15", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 1.6,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont16", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 1.5,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont17", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 1.4,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont18", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 1.3,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont19", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 1.2,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont20", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 1.1,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont21", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 1,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont22", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 0.9,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont23", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 0.72,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont24", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 0.55,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont25", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 0.35,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont26", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 0.26,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont27", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 0.2,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont28", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 0.14,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont29", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 0.1,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont30", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 0.05,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFont31", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.04,
  weight = 500,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )

surface.CreateFont( "LevelPopupFontSmall", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.015,
  weight = 500,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false
} )
