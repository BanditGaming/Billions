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
	cam.Start3D2D(self:GetPos() + self:GetAngles():Up() * 14, self:GetAngles(), 0.08)
	draw.DrawText(self:GetProductName(), "BoxFont", -45, -40, Color(255, 255, 255, 255))
	cam.End3D2D()
end
