AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
  self:SetModel(PW_Billions.PC_BUYITEMS[self:GetClass()].model)
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)

  local obj = self:GetPhysicsObject()
  if obj:IsValid() then
    obj:Wake()
  end
end

function ENT:Use(activator, caller, useType, value)
  self:SetUseType(SIMPLE_USE)
  DarkRP.notify(caller, 0, 4, "Place it on a workbench to start working!")
end

function ENT:StartTouch(ent)
  if ent:isWorkbench() then
    ent:addToWorkbench(self)
    ent:suppliesCheck()
  end
end
