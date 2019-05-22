PW_Billions.mayorPoliticalCapital = 100
PW_Billions.governmentWallet = PW_Billions.governmentWallet or 0

--[[---------------------------------------------
Mayor Player functions
-----------------------------------------------]]
local PLAYER = FindMetaTable("Player")

function PLAYER:isMayor()
  if self:Team() == PW_Billions.CFG.TEAM_MAYOR then
    return true
  end
  return false
end

--[[---------------------------------------------
Global mayor functions
-----------------------------------------------]]

function PW_Billions.mayorBuyWeapon(itemClass)
  if SERVER then
    if PW_Billions.MAYOR_BUYITEMS[itemClass] then
      local playerList = {}
      if PW_Billions.MAYOR_BUYITEMS[itemClass].mayor then
        table.Merge(playerList, team.GetPlayers(PW_Billions.CFG.TEAM_MAYOR))
      end
      if PW_Billions.MAYOR_BUYITEMS[itemClass].police then
        for k,v in pairs(PW_Billions.CFG.TEAM_POLICE) do
          table.Merge(playerList, team.GetPlayers(v))
        end
      end
      for i,v in ipairs(PW_Billions.MAYOR_BUYITEMS[itemClass].teams) do
        if v then
          for i2,v2 in ipairs(PW_Billions.CFG.TEAM[i]) do
            table.Merge(playerList, team.GetPlayers(v2))
          end
        end
      end

      for k,v in pairs(playerList) do
        if !v:HasWeapon(itemClass) then
          if PW_Billions.getMoneyGovernment() < PW_Billions.MAYOR_BUYITEMS[itemClass].price then return end
          PW_Billions.addMoneyGovernment(- PW_Billions.MAYOR_BUYITEMS[itemClass].price)
          v:Give(itemClass)
        end
      end
    end
  elseif CLIENT then
    net.Start("PW_Billions_Mayor_BuyWeapon")
    net.WriteString(itemClass)
    net.SendToServer()
  end
end

function PW_Billions.getMoneyGovernment()
  return PW_Billions.governmentWallet
end

function PW_Billions.getPoliticalCapital()
  return PW_Billions.mayorPoliticalCapital
end

function PW_Billions.setLicense(className, canBuy)
  if SERVER then
    if PW_Billions.PC_BUYITEMS[className].licenseChangeable then
      PW_Billions.PC_BUYITEMS[className].license = canBuy

      local licenseMessage = PW_Billions.PC_BUYITEMS[className].name
      if PW_Billions.PC_BUYITEMS[className].license then
        licenseMessage = licenseMessage .. " " .. PW_Billions.getPhrase("availablePurchase") .. "."
      else
        licenseMessage = licenseMessage .. " " .. PW_Billions.getPhrase("notAvailablePurchase") .. "."
      end

      for k,v in pairs(player.GetAll()) do
        v:ChatPrint(licenseMessage)
        DarkRP.notify(v, 0, 4, "License change!")
      end

      net.Start("PW_Billions_Mayor_SetLicense")
      net.WriteString(className)
      net.WriteBool(canBuy)
      net.Broadcast()
    end
  elseif CLIENT then
    net.Start("PW_Billions_Mayor_SetLicense")
    net.WriteString(className)
    net.WriteBool(canBuy)
    net.SendToServer()
  end
end

function PW_Billions.setTax(taxType, amount)
  if SERVER then
    amount = math.Round(amount, 2)
    local taxMessage = PW_Billions.getPhrase("mayorChangedTax") .. " "
    if taxType == TAX_CHANGENAME then
      taxMessage = taxMessage .. PW_Billions.getPhrase("nameChangeTax") .. " " .. PW_Billions.getPhrase("from") .. " " .. DarkRP.formatMoney(PW_Billions.CFG.TAX[taxType].amount) .. " " .. PW_Billions.getPhrase("to") .. " " .. DarkRP.formatMoney(amount)
    elseif taxType == TAX_INCOME then
      taxMessage = taxMessage .. PW_Billions.getPhrase("incomeTax") .. " " .. PW_Billions.getPhrase("from") .. " " .. PW_Billions.CFG.TAX[taxType].amount * 100 .. "% " .. PW_Billions.getPhrase("to") .. " " .. amount * 100 .. "%"
    elseif taxType == TAX_SELL then
      taxMessage = taxMessage .. PW_Billions.getPhrase("vat") .. " " .. PW_Billions.getPhrase("from") .. " " .. PW_Billions.CFG.TAX[taxType].amount * 100 .. "% " .. PW_Billions.getPhrase("to") .. " " .. amount * 100 .. "%"
    elseif taxType == TAX_WITHDRAW then
      taxMessage = taxMessage .. PW_Billions.getPhrase("withdrawTax") .. " " .. PW_Billions.getPhrase("from") .. " " .. PW_Billions.CFG.TAX[taxType].amount * 100 .. "% " .. PW_Billions.getPhrase("to") .. " " .. amount * 100 .. "%"
    end

    for k,v in pairs(player.GetAll()) do
      v:ChatPrint(taxMessage)
      if PW_Billions.CFG.TAX[taxType].amount > amount then
        DarkRP.notify(v, 0, 4, PW_Billions.getPhrase("taxCut") .. "!")
      else
        DarkRP.notify(v, 0, 4, PW_Billions.getPhrase("taxRise") .. "!")
      end
    end
    PW_Billions.CFG.TAX[taxType].amount = amount

    net.Start("PW_Billions_Mayor_SetTax")
    net.WriteInt(taxType, 8)
    net.WriteFloat(amount)
    net.Broadcast()
  elseif CLIENT then
    net.Start("PW_Billions_Mayor_SetTax")
    net.WriteInt(taxType, 8)
    net.WriteFloat(amount)
    net.SendToServer()
  end
end
