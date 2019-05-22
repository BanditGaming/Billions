util.AddNetworkString("PW_Billions_Workbench_ItemCrafted")

local ENTITY = FindMetaTable("Entity")

function ENTITY:addToWorkbench(ent)
  local class = ent:GetClass()
  if class == "pw_billions_supplies_electronics" and self:GetElectronicsAmount() < PW_Billions.CFG.WORKBENCH_SUPPLYCAP then
    ent:Remove()
    self:SetElectronicsAmount(self:GetElectronicsAmount() + 1)
    return true
  elseif class == "pw_billions_supplies_gears" and self:GetGearsAmount() < PW_Billions.CFG.WORKBENCH_SUPPLYCAP then
    ent:Remove()
    self:SetGearsAmount(self:GetGearsAmount() + 1)
    return true
  elseif class == "pw_billions_supplies_gunpowder" and self:GetGunpowderAmount() < PW_Billions.CFG.WORKBENCH_SUPPLYCAP then
    ent:Remove()
    self:SetGunpowderAmount(self:GetGunpowderAmount() + 1)
    return true
  elseif class == "pw_billions_supplies_metal" and self:GetMetalAmount() < PW_Billions.CFG.WORKBENCH_SUPPLYCAP then
    ent:Remove()
    self:SetMetalAmount(self:GetMetalAmount() + 1)
    return true
  elseif class == "pw_billions_supplies_plastic" and self:GetPlasticAmount() < PW_Billions.CFG.WORKBENCH_SUPPLYCAP then
    ent:Remove()
    self:SetPlasticAmount(self:GetPlasticAmount() + 1)
    return true
  elseif class == "pw_billions_supplies_wood" and self:GetWoodAmount() < PW_Billions.CFG.WORKBENCH_SUPPLYCAP then
    ent:Remove()
    self:SetWoodAmount(self:GetWoodAmount() + 1)
    return true
  end
  return false
end
