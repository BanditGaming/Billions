AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
  self:SetModel(PW_Billions.CRAFTABLE.WORKBENCH[self:GetClass()].model)
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)

  local obj = self:GetPhysicsObject()
  if obj:IsValid() then
    obj:Wake()
  end
end

function ENT:StartTouch(ent)
  ent:addToBox(self)
end
