AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("PW_Billions_DisplayPC")
util.AddNetworkString("PW_Billions_BuyItem")
util.AddNetworkString("PW_Billions_GetPlayerEmploymentHistory")
util.AddNetworkString("PW_Billions_EmploymentRequest")

function ENT:Initialize()
  self:SetModel(PW_Billions.CFG.BUSINESSPC_MODEL)
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)
  local obj = self:GetPhysicsObject()

  if obj:IsValid() then
    obj:Wake()
  end
end


function ENT:Use(activator, ply, useType, value)
  self:SetUseType(SIMPLE_USE)

      net.Start("PW_Billions_DisplayPC")
      net.Send(ply)

end

net.Receive("PW_Billions_BuyItem",function(len, ply)
  local itemClass = net.ReadString()
  local itemCount = net.ReadInt(4)
  local eyeTrace = ply:GetEyeTraceNoCursor()
  local pcEnt = eyeTrace.Entity
  if PW_Billions.PC_BUYITEMS[itemClass].license then
    if pcEnt:GetClass() == "pw_billions_businesspc" then
      timer.Create("PW_Billions_BuyItem_Loop_" .. ply:SteamID(), 0.5, itemCount, function()
        if ply:isCompanyOwner() or ply:isEmployed() and ply:canAddMoney() then

          local itemPrice = PW_Billions.PC_BUYITEMS[itemClass].price
          local company = ply:getCompany()

          if itemPrice then
            if company:canAfford(itemPrice) then
              company:addMoney(-itemPrice, BANK_BUY)
              local newItemClass = PW_Billions.PC_BUYITEMS[itemClass].class
              local newItem = ents.Create(newItemClass)
              newItem:SetPos(pcEnt:GetPos() + Vector(0, 0, 60))
              newItem:setOwnerSid64(ply:getOwnerSid64())
              newItem:Spawn()
            else
              DarkRP.notify(ply, 1, 4, "Your company can't afford it!")
            end
          else
            error("BILLIONS: item price not found, make sure you added it in the config! Item: " .. itemNameUpper,1)
          end
        else
          DarkRP.notify(ply, 1, 4, PW_Billions.getPhrase("notAuthorized"))
        end
      end)
    else
      DarkRP.notify(ply, 1, 4, PW_Billions.getPhrase("needLook"))
    end
  else
    DarkRP.notify(ply, 1, 4, PW_Billions.getPhrase("buyRestricted"))
  end
end)

net.Receive("PW_Billions_GetPlayerEmploymentHistory",function (len, ply)
  if ply:isCompanyOwner() or ply:isEmployed() and ply:canEmploy() then
    local selectedPlayerSid64 = net.ReadString()
    MySQLite.query("SELECT * FROM pilcrowrp.pilcrow_billions_employmentHistory WHERE `employeeID` = " .. MySQLite.SQLStr(selectedPlayerSid64), function (table)
      net.Start("PW_Billions_GetPlayerEmploymentHistory")
      net.WriteTable(table)
      net.Send(ply)
    end)
  end
end)
