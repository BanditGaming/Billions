AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
  self:SetModel("models/props_borealis/bluebarrel001.mdl")
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
end
