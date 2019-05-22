ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Spawnable = false

ENT.PrintName = "Workbench"
ENT.Author = "Yogosh"
ENT.Category = "Billions"

function ENT:SetupDataTables()
  self:NetworkVar("Int", 0, "WorkProgress")
  self:NetworkVar("Int", 1, "ElectronicsAmount")
  self:NetworkVar("Int", 2, "GearsAmount")
  self:NetworkVar("Int", 3, "GunpowderAmount")
  self:NetworkVar("Int", 4, "MetalAmount")
  self:NetworkVar("Int", 5, "PlasticAmount")
  self:NetworkVar("Int", 6, "WoodAmount")
  self:NetworkVar("String", 0, "ProductClass")
  self:NetworkVar("Bool", 0, "EnoughSupplies")
end
