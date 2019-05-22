AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
  self:SetModel(PW_Billions.PC_BUYITEMS[self:GetClass()].model)
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)
  self:SetUseType(SIMPLE_USE)
  local obj = self:GetPhysicsObject()

  if obj:IsValid() then
    obj:Wake()
  end

  self:SetProductName("Empty")
  self:SetProductAmount(0)
  --product owner var set by businesspc
end
--[[
function ENT:StartTouch(ent)
  if ent:isProduct() then
    local entName = ent:getName()
    local entClass = ent:GetClass()

    if self:GetProductAmount() == 0 then
      ent:Remove()
      self:SetProductName(entName)
      self:SetProductClass(entClass)
      self:SetProductAmount(1)
    elseif self:GetProductName() == entName and self:GetProductAmount() < PW_Billions.CFG.BOXCAP then
      ent:Remove()
      self:SetProductAmount(self:GetProductAmount() + 1)
    end
  end
end]]

function ENT:Touch(ent)
end

function ENT:Use(activator, caller, useType, value)
  if self:GetProductAmount() > 0 then
    local newAmount = self:GetProductAmount() - 1
    self:SetProductAmount(newAmount)
    local productClass = "pw_billions_products_" .. string.lower(self:GetProductName())
    local product = ents.Create(productClass)
    product:SetVar("ProductOwner", self:GetVar("ProductOwner"))
    product:SetPos(self:GetPos() + Vector(0, 0, 23))
    product:Spawn()
    local obj = product:GetPhysicsObject()

    if obj:IsValid() then
      obj:Sleep()
    end
  end

  if self:GetProductAmount() == 0 then
    self:SetProductName("Empty")
    self:SetProductClass("")
  end
end
