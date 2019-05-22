include("shared.lua")

surface.CreateFont("BoxFontLarge", {
  font = "Jura",
  extended = false,
  size = 80,
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
})

surface.CreateFont("BoxFontMedium", {
  font = "Jura",
  extended = false,
  size = 60,
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
})

surface.CreateFont("BoxFont", {
  font = "Jura",
  extended = false,
  size = 40,
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
})

ENT.lastWorkProgress = 0

function ENT:Draw()
  local ang = self:GetAngles()
  ang:RotateAroundAxis(self:GetAngles():Up() ,90)
  self:DrawModel()
  cam.Start3D2D(self:GetPos() + ang:Up() * 17.5, ang, 0.1)
  draw.RoundedBox(0, -550, -190, 1100, 370, Color(59, 59, 69, 190))
  surface.SetFont("BoxFontLarge")
  local workbenchTextW, _ = surface.GetTextSize(PW_Billions.getPhrase("workbench"))
  draw.DrawText(PW_Billions.getPhrase("workbench"), "BoxFontLarge", - (workbenchTextW / 2), -170, Color(255, 255, 255, 255))
  surface.SetFont("BoxFontMedium")
  local currentProductTextW, _ = surface.GetTextSize(PW_Billions.getPhrase("currentProduct") .. ": " .. PW_Billions.CRAFTABLE.WORKBENCH[self:GetProductClass()].name)
  draw.DrawText(PW_Billions.getPhrase("currentProduct") .. ": " .. PW_Billions.CRAFTABLE.WORKBENCH[self:GetProductClass()].name, "BoxFontMedium", - (currentProductTextW / 2), -60, Color(255, 255, 255, 255))
  if !self:GetEnoughSupplies() then
    local noSuppliesTextW, _ = surface.GetTextSize(PW_Billions.getPhrase("noSupplies"))
    draw.DrawText(PW_Billions.getPhrase("noSupplies"), "BoxFontMedium", - (noSuppliesTextW / 2), 10, Color(255, 0, 0, 255))
  end
  draw.DrawText(PW_Billions.getPhrase("electronics") .. ": " .. self:GetElectronicsAmount(), "BoxFont", -530, -170, Color(255, 255, 255, 255))
  draw.DrawText(PW_Billions.getPhrase("gears") .. ": " .. self:GetGearsAmount(), "BoxFont", -530, -135, Color(255, 255, 255, 255))
  draw.DrawText(PW_Billions.getPhrase("gunpowder") .. ": " .. self:GetGunpowderAmount(), "BoxFont", -530, -100, Color(255, 255, 255, 255))
  draw.DrawText(PW_Billions.getPhrase("metal") .. ": " .. self:GetMetalAmount(), "BoxFont", -530, -65, Color(255, 255, 255, 255))
  draw.DrawText(PW_Billions.getPhrase("plastic") .. ": " .. self:GetPlasticAmount(), "BoxFont", -530, -30, Color(255, 255, 255, 255))
  draw.DrawText(PW_Billions.getPhrase("wood") .. ": " .. self:GetWoodAmount(), "BoxFont", -530, 5, Color(255, 255, 255, 255))
  draw.RoundedBox(0, -375, 110, 750, 50, Color(0, 0, 0, 255))
  if self:GetWorkProgress() != self.lastWorkProgress and !timer.Exists("PW_Billions_Workbench_WorkProgress") then
    timer.Create("PW_Billions_Workbench_WorkProgress", 0.03, 30, function()
      local addAmount
      if PW_Billions.CRAFTABLE.WORKBENCH[self:GetProductClass()].craftingDifficulty < 10 then
        addAmount = 10
      elseif PW_Billions.CRAFTABLE.WORKBENCH[self:GetProductClass()].craftingDifficulty >= 10 and PW_Billions.CRAFTABLE.WORKBENCH[self:GetProductClass()].craftingDifficulty < 20 then
        addAmount = 6
      elseif PW_Billions.CRAFTABLE.WORKBENCH[self:GetProductClass()].craftingDifficulty >= 20 and PW_Billions.CRAFTABLE.WORKBENCH[self:GetProductClass()].craftingDifficulty < 30 then
        addAmount = 3
      elseif PW_Billions.CRAFTABLE.WORKBENCH[self:GetProductClass()].craftingDifficulty >= 30 then
        addAmount = 1.5
      end
      if self:GetWorkProgress() > self.lastWorkProgress then
        self.lastWorkProgress = self.lastWorkProgress + addAmount
      end
      if self:GetWorkProgress() < self.lastWorkProgress then
        self.lastWorkProgress = self:GetWorkProgress()
      end
    end)
  end
  draw.RoundedBox(0, -370, 115, 740 * self.lastWorkProgress / 1000, 40, Color(255, 0, 0, 255))
  cam.End3D2D()
end
