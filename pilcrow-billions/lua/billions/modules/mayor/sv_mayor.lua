--[[---------------------------------------------
Global mayor functions
-----------------------------------------------]]
util.AddNetworkString("PW_Billions_Mayor_AddMoney")
function PW_Billions.addMoneyGovernment(amount)
  PW_Billions.governmentWallet = PW_Billions.governmentWallet + amount
  net.Start("PW_Billions_Mayor_AddMoney")
  net.WriteInt(amount, 32)
  net.Broadcast()
end

util.AddNetworkString("PW_Billions_Mayor_AddPoliticalCapital")
function PW_Billions.addPoliticalCapital(capital)
  if PW_Billions.getPoliticalCapital() + capital <= 100 then
    PW_Billions.mayorPoliticalCapital = PW_Billions.mayorPoliticalCapital + capital
  else
    PW_Billions.mayorPoliticalCapital = 100
  end

  net.Start("PW_Billions_Mayor_AddPoliticalCapital")
  net.WriteInt(PW_Billions.mayorPoliticalCapital, 21)
  net.Broadcast()
end

--[[---------------------------------------------
Receiving functions
-----------------------------------------------]]
util.AddNetworkString("PW_Billions_Mayor_BuyWeapon")
net.Receive("PW_Billions_Mayor_BuyWeapon", function(len, ply)
  if ply:isMayor() then
    local itemClass = net.ReadString()
    if isstring(itemClass) then
      PW_Billions.mayorBuyWeapon(itemClass)
    end
  end
end)

util.AddNetworkString("PW_Billions_Mayor_SetLicense")
net.Receive("PW_Billions_Mayor_SetLicense", function(len, ply)
  if ply:isMayor() and PW_Billions.getPoliticalCapital() >= PW_Billions.CFG.MAYOR_LICENSE_CHANGE_COST then
    PW_Billions.addPoliticalCapital(- PW_Billions.CFG.MAYOR_LICENSE_CHANGE_COST)
    local itemClass = net.ReadString()
    local license = net.ReadBool()
    if PW_Billions.PC_BUYITEMS[itemClass] and isbool(license) then
      PW_Billions.setLicense(itemClass, license)
    end
  end
end)

util.AddNetworkString("PW_Billions_Mayor_SetTax")
net.Receive("PW_Billions_Mayor_SetTax", function(len, ply)
  if ply:isMayor() then
    if PW_Billions.getPoliticalCapital() >= PW_Billions.CFG.MAYOR_TAX_CHANGE_COST then
      local taxType = net.ReadInt(8)
      local amount = net.ReadFloat()
      if isnumber(taxType) and isnumber(amount) then
        local taxTable = PW_Billions.CFG.TAX[taxType]
        if taxTable.changeable and amount <= taxTable.MAX_AMOUNT and amount > 0 then
          PW_Billions.addPoliticalCapital(- PW_Billions.CFG.MAYOR_TAX_CHANGE_COST)
          PW_Billions.setTax(taxType, amount)
        else
          DarkRP.notify(ply, 1, 4, PW_Billions.getPhrase("taxTooHigh") .. "!")
        end
      end
    else
      DarkRP.notify(ply, 1, 4 , PW_Billions.getPhrase("notEnoughCapital"))
    end
  end
end)
