include("shared.lua")

surface.CreateFont("BoxFont", {
	font = "Arial",
	extended = false,
	size = 50,
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

function ENT:Draw()
	self:DrawModel()
	cam.Start3D2D(self:GetPos() + self:GetAngles():Up() * 12, self:GetAngles(), 0.1)
	draw.RoundedBox(0, -150, -185, 300, 370, Color(205, 255, 100, 150))
	draw.DrawText(self:GetProductName(), "BoxFont", -70, -100, Color(255, 255, 255, 255))
	draw.DrawText(PW_Billions.getPhrase("amount") .. ": " .. self:GetProductAmount(), "BoxFont", -90, 15, Color(255, 255, 255, 255))
	cam.End3D2D()
end
