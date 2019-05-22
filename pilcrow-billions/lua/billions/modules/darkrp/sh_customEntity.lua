--items available to buy with f4 menu
hook.Add("loadCustomDarkRPItems", "Billions_loadf4_entities", function()
  DarkRP.createEntity("Business PC", {
    ent = "pw_billions_businesspc",
    model = PW_Billions.CFG.BUSINESSPC_MODEL,
    price = 100,
    max = 10,
    cmd = "buybusinesspc",
    customCheck = function(ply)
      if ply:isCompanyOwner() or ply:isEmployed() then
        return true
      end
      return false
    end,
    CustomCheckFailMsg = function(ply, entTable)
      DarkRP.notify(ply, 1, 4, PW_Billions.getPhrase("buyErrorCompany"))
    end
  })
  DarkRP.createEntity("Mayor PC", {
    ent = "pw_billions_mayorpc",
    model = PW_Billions.CFG.BUSINESSPC_MODEL,
    price = 100,
    max = 10,
    cmd = "buymayorpc",
    customCheck = function(ply)
      if ply:isMayor() then
        return true
      end
      return false
    end,
    CustomCheckFailMsg = function(ply, entTable)
      DarkRP.notify(ply, 1, 4, PW_Billions.getPhrase("buyErrorMayor"))
    end
  })
end)
