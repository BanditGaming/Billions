hook.Add("playerGetSalary", "MayorPoliticalCapital", function(ply, amount)
  if ply:isMayor() then
    PW_Billions.addPoliticalCapital(PW_Billions.CFG.MAYOR_POLITICAL_CAPITAL_GAIN)
  end
end)
