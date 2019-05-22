--calculates prices for products
hook.Add("PlayerSay", "calculatePrices", function(ply, text, public)
  if ply:IsSuperAdmin() and text == "/calculatePrices" then
    for k,v in pairs(PW_Billions.CRAFTABLE.WORKBENCH) do
      print("--------------------------------------------------------")
      print(v.name)
      print("Crafting Difficulty: " .. v.craftingDifficulty)
      print("Sell price: " .. v.price)
      local electronicsCost = PW_Billions.PC_BUYITEMS["pw_billions_supplies_electronics"].price * v.electronicsAmount
      local gearsCost = PW_Billions.PC_BUYITEMS["pw_billions_supplies_gears"].price * v.gearsAmount
      local gunpowderCost = PW_Billions.PC_BUYITEMS["pw_billions_supplies_gunpowder"].price * v.gunpowderAmount
      local metalCost = PW_Billions.PC_BUYITEMS["pw_billions_supplies_metal"].price * v.metalAmount
      local plasticCost = PW_Billions.PC_BUYITEMS["pw_billions_supplies_plastic"].price * v.plasticAmount
      local woodCost = PW_Billions.PC_BUYITEMS["pw_billions_supplies_wood"].price * v.woodAmount
      print("Cost: Electronics: " .. electronicsCost .. " Gears: " .. gearsCost .. " Gunpowder: " .. gunpowderCost .. " Metal: " .. metalCost .. " Plastic: " .. plasticCost .. " Wood: " .. woodCost)
      local total = electronicsCost + gearsCost + gunpowderCost + metalCost + plasticCost + woodCost
      print("Total cost: " .. total)
      local tax = v.price * PW_Billions.CFG.TAX[TAX_SELL].amount
      print("Tax amount: " .. tax)
      local profit = v.price - tax - total
      print("Profitability: " .. profit)
    end
  end
end)
