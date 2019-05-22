AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--TODO use networked GetProductClass instead of productIndex
ENT.productIndex = "pw_billions_products_radio"

local itemCraftedSound = Sound("billions/item_crafted.mp3")

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
  self:SetProductClass(self.productIndex)
end

function ENT:Use(activator, caller, useType, value)
  DarkRP.notify(caller, 0, 4, PW_Billions.getPhrase("workbToolInfo"))
end

function ENT:AcceptInput(inputName, activator, caller, data)
  if inputName == "workbenchToolPrimary" and self:GetElectronicsAmount() >= PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].electronicsAmount and self:GetGearsAmount() >= PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].gearsAmount and self:GetGunpowderAmount() >= PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].gunpowderAmount and self:GetMetalAmount() >= PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].metalAmount and self:GetPlasticAmount() >= PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].plasticAmount and self:GetWoodAmount() >= PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].woodAmount then
    local newProgress = self:GetWorkProgress() + (PW_Billions.CFG.WORKBENCH_SPEED / PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].craftingDifficulty) * 50
    self:SetWorkProgress(newProgress)
    if self:GetWorkProgress() >= 1000 then
      self:EmitSound(itemCraftedSound)
      self:SetWorkProgress(0)
      self:SetElectronicsAmount(self:GetElectronicsAmount() - PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].electronicsAmount)
      self:SetGearsAmount(self:GetGearsAmount() - PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].gearsAmount)
      self:SetGunpowderAmount(self:GetGunpowderAmount() - PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].gunpowderAmount)
      self:SetMetalAmount(self:GetMetalAmount() - PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].metalAmount)
      self:SetPlasticAmount(self:GetPlasticAmount() - PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].plasticAmount)
      self:SetWoodAmount(self:GetWoodAmount() - PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].woodAmount)

      --spawn the crafted item
      local newItem
      if PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].isWeapon then
        newItem = ents.Create("pw_billions_products_weapon")
      else
        newItem = ents.Create(PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].class)
      end
      newItem:SetPos(self:GetPos() + Vector(0,0,30))
      newItem:setOwnerSid64(self:getOwnerSid64())
      newItem:Spawn()
      self:EmitSound("billions/item_crafted.mp3", 100)
      if PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].isWeapon then
        newItem:SetProductName(PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].name)
        newItem:SetProductClass(self.productIndex)
      end
      local company = activator:getCompany()
      if company then
        company:addXP(PW_Billions.CFG.XPGAIN_ITEMCRAFTED)
        company:notifyOwner(PW_Billions.getPhrase("gained") .. " " .. PW_Billions.CFG.XPGAIN_ITEMCRAFTED .. " XP")
        if !activator:isCompanyOwner() then
          DarkRP.notify(activator, 0, 4, PW_Billions.getPhrase("gained") .. " " .. PW_Billions.CFG.XPGAIN_ITEMCRAFTED .. " XP")
        end
        hook.Run("PW_Billions_Workbench_ItemCrafted", activator, company, self.productIndex)
        net.Start("PW_Billions_Workbench_ItemCrafted")
        net.WriteEntity(activator)
        net.WriteString(company:getOwnerSid64())
        net.WriteString(self.productIndex)
        net.Broadcast()
      end
      self:suppliesCheck()
    end
  end
end

--sets current product of that workbench
util.AddNetworkString("PW_Billions_WorkbenchProductSelection")
net.Receive("PW_Billions_WorkbenchProductSelection", function(len, ply)
  local itemClass = net.ReadString()
  if PW_Billions.isItemValid(itemClass) then
    --if a company that owns this workbench does not have a required blueprint for this item, return false
    if ply:getCompany():canProduce(itemClass) == false then
      DarkRP.notify(ply, 1, 4, PW_Billions.getPhrase("noBlueprint"))
      return false
    end
    --get the workbench that user wants to set item for
    local workbench = ply:GetEyeTraceNoCursor().Entity
    if (ply:isCompanyOwner() or ply:isEmployed()) and workbench:GetClass() == "pw_billions_supplies_workbench" and ply:getOwnerSid64() == workbench:getOwnerSid64() then
      --check if company has the required level
      if PW_Billions.CRAFTABLE.WORKBENCH[itemClass].level > ply:getCompany():getLevel() then return end
      workbench.productIndex = itemClass
      workbench:SetProductClass(itemClass)
      workbench:SetWorkProgress(0)
      workbench:suppliesCheck()
    end
  end
end)

--changes networked variable based on amount of supplies - false if not enough to make an item
function ENT:suppliesCheck()
  if self:GetElectronicsAmount() >= PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].electronicsAmount and self:GetGearsAmount() >= PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].gearsAmount and self:GetGunpowderAmount() >= PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].gunpowderAmount and self:GetMetalAmount() >= PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].metalAmount and self:GetPlasticAmount() >= PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].plasticAmount and self:GetWoodAmount() >= PW_Billions.CRAFTABLE.WORKBENCH[self.productIndex].woodAmount then
    self:SetEnoughSupplies(true)
  else
    self:SetEnoughSupplies(false)
  end
end
