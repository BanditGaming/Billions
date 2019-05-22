AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("PW_Billions_OpenBusinessNPC")

function ENT:Initialize()
  self:SetModel(PW_Billions.CFG.NPC_BUSINESS_CREATOR_MODEL)
  self:SetHullType(HULL_HUMAN)
  self:SetHullSizeNormal()
  self:SetNPCState(NPC_STATE_SCRIPT)
  self:SetSolid(SOLID_BBOX)
  self:CapabilitiesAdd(CAP_ANIMATEDFACE)
  self:CapabilitiesAdd(CAP_TURN_HEAD)
  self:SetMoveType(MOVETYPE_STEP)
  self:SetSchedule(SCHED_FALL_TO_GROUND)
  self:SetUseType(SIMPLE_USE)
  self:SetSequence("idle")
end

function ENT:AcceptInput(inputName, activator, ply, data)
  if inputName == "Use" and ply:IsPlayer() then
    net.Start("PW_Billions_OpenBusinessNPC")
    net.Send(ply)
  end
end
