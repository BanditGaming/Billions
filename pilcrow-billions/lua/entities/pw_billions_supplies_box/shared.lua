ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Spawnable = false

ENT.PrintName = "Box"
ENT.Author = "Yogosh"
ENT.Category = "Billions"

function ENT:SetupDataTables()
  self:NetworkVar("Int", 0, "ProductAmount")
  self:NetworkVar("String", 0, "ProductName")
  self:NetworkVar("String", 1, "ProductClass")
end
