AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
  self:SetModel(PW_Billions.CFG.NPC_DISTRIBUTOR_MODEL)
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

util.AddNetworkString("PW_Billions_NPC_Distributor_Open")
function ENT:AcceptInput(inputName, activator, ply, data)
  if inputName == "Use" and ply:IsPlayer() then
    net.Start("PW_Billions_NPC_Distributor_Open")
    net.WriteTable(PW_Billions.NPC_DISTRIBUTOR)
    net.Send(ply)
  end
end

util.AddNetworkString("PW_Billions_NPC_Distributor_Buy")
net.Receive("PW_Billions_NPC_Distributor_Buy", function(len, ply)
  local buyAsCompany = net.ReadBool()
  local itemClass = net.ReadString()
  local itemAmount = net.ReadInt(8)
  local npc = ply:GetEyeTraceNoCursor().Entity

  if PW_Billions.CRAFTABLE.WORKBENCH[itemClass] and (PW_Billions.CRAFTABLE.WORKBENCH[itemClass].buyback or (PW_Billions.CRAFTABLE.WORKBENCH[itemClass].buybackTeams and PW_Billions.CRAFTABLE.WORKBENCH[itemClass].buybackTeams[ply:Team()])) and npc:GetClass() == "pw_billions_npc_distributor" and PW_Billions.NPC_DISTRIBUTOR[itemClass] > 0 then
    local itemPrice = PW_Billions.CRAFTABLE.WORKBENCH[itemClass].price
    local total = itemPrice * itemAmount
    --this option is disabled for now
    if buyAsCompany then
      return
    end
    --company pays for items
    if buyAsCompany and ((ply:isEmployed() and ply:canAddMoney()) or ply:isCompanyOwner()) then
      local company = ply:getCompany()
      if company:canAfford(total) then
        company:addMoney(-total, BANK_BUY)
        --spawn all the items
        for i = 1, itemAmount do
          PW_Billions.NPC_DISTRIBUTOR[itemClass] =  PW_Billions.NPC_DISTRIBUTOR[itemClass] - 1
          local newItem = ents.Create(itemClass)
          newItem:SetPos(npc:GetPos() + Vector(35, 0, 30))
          newItem:setOwnerSid64(ply:getOwnerSid64())
          newItem:Spawn()
        end
      else
        DarkRP.notify(ply, 0, 4, PW_Billions.getPhrase("noBuyMoney"))
      end
    elseif !buyAsCompany then
    --check if player has required level to buy this item
      if PW_Billions.CFG.VLEVEL and PW_Billions.CRAFTABLE.WORKBENCH[itemClass].buybackPlayerLevel and PW_Billions.CRAFTABLE.WORKBENCH[itemClass].buybackPlayerLevel < ply:getDarkRPVar("level") then
        DarkRP.notify(ply, 0, 4, PW_Billions.getPhrase("plyLevelTooLow"))
        return
      end
    --player pays for items
      if ply:canAfford(total) then
        ply:addMoney(total)
        --spawn all the items
        for i = 1, itemAmount do
          PW_Billions.NPC_DISTRIBUTOR[itemClass] =  PW_Billions.NPC_DISTRIBUTOR[itemClass] - 1
          local newItem = ents.Create(itemClass)
          newItem:SetPos(npc:GetPos() + Vector(35, 0, 30))
          newItem:Spawn()
        end
      else
        DarkRP.notify(ply, 0, 4, PW_Billions.getPhrase("noBuyMoneyPly"))
      end
    end
  end
end)

function ENT:StartTouch(ent)
  if !IsFirstTimePredicted() then return end
  if ent:isProduct() or ent:isBox() then
    local company = ent:getCompany()
    if company then
      local itemAmount = ent:getAmount()
      local itemPrice = ent:getPrice()
      local itemClass = ent:GetClass()
      if itemClass == "pw_billions_products_weapon" or itemClass == "pw_billions_supplies_box" then
        if ent:GetProductClass() == nil or ent:GetProductClass() == "" then return end
        itemClass = ent:GetProductClass()
        self:addItem(itemClass, itemAmount)
      else
        self:addItem(itemClass, itemAmount)
      end
      ent:Remove()
      local amount = itemPrice * itemAmount
      if PW_Billions.CFG.TAX_ENABLED then
        local taxAmount = math.ceil(amount * PW_Billions.CFG.TAX[TAX_SELL].amount)
        PW_Billions.addMoneyGovernment(taxAmount)
        company:addMoney(amount - taxAmount, BANK_SALE)
        company:notifyOwner(PW_Billions.getPhrase("soldProducts") .. ": " .. DarkRP.formatMoney(amount) .. ". " .. PW_Billions.getPhrase("tax") .. ": " .. DarkRP.formatMoney(taxAmount))
      else
        company:addMoney(amount, BANK_SALE)
        company:notifyOwner(PW_Billions.getPhrase("soldProducts") .. ": " .. DarkRP.formatMoney(amount))
      end
      company:addXP(PW_Billions.CFG.XPGAIN_ITEMSOLD * (amount / 100))
      hook.Run("PW_Billions_NPC_ItemSold", company, itemClass, itemAmount, amount)
    end
  end
end

--saves bought items
function ENT:addItem(itemClass, itemAmount)
  if PW_Billions.NPC_DISTRIBUTOR[itemClass] then
    PW_Billions.NPC_DISTRIBUTOR[itemClass] = PW_Billions.NPC_DISTRIBUTOR[itemClass] + itemAmount
  else
    PW_Billions.NPC_DISTRIBUTOR[itemClass] = itemAmount
  end
end
