AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
  self:SetModel("models/Items/BoxMRounds.mdl")
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)

  local obj = self:GetPhysicsObject()
  if obj:IsValid() then
    obj:Wake()
  end
end

function ENT:Use(activator, caller, useType, value)
  if not IsFirstTimePredicted() then return end
  local product = ents.Create(self:GetProductClass())
  product:SetPos(self:GetPos() + Vector(0, 0, 23))
  product:Spawn()
  local obj = product:GetPhysicsObject()
  if obj:IsValid() then
    obj:Wake()
  end
  self:Remove()
end
