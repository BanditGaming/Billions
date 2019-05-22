ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Spawnable = false

ENT.PrintName = "Weapon"
ENT.Author = "Yogosh"
ENT.Category = "Billions"

function ENT:SetupDataTables()
  self:NetworkVar("String", 0, "ProductName")
  self:NetworkVar("String", 1, "ProductClass")
end
