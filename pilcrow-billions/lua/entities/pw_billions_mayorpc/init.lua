AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
  self:SetModel(PW_Billions.CFG.BUSINESSPC_MODEL)
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)
  local obj = self:GetPhysicsObject()
  self:SetColor(Color(0,0,100,100))
  if obj:IsValid() then
    obj:Wake()
  end
end

util.AddNetworkString("PW_Billions_Mayor_DisplayPC")
function ENT:Use(activator, ply, useType, value)
  self:SetUseType(SIMPLE_USE)
  net.Start("PW_Billions_Mayor_DisplayPC")
  net.Send(ply)
end
