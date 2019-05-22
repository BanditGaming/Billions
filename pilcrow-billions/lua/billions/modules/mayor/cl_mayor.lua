net.Receive("PW_Billions_Mayor_AddMoney", function(len)
  PW_Billions.governmentWallet = PW_Billions.governmentWallet + net.ReadInt(32)
end)

net.Receive("PW_Billions_Mayor_AddPoliticalCapital", function(len)
  PW_Billions.mayorPoliticalCapital = net.ReadInt(21)
end)

net.Receive("PW_Billions_Mayor_SetLicense", function(len)
  PW_Billions.PC_BUYITEMS[net.ReadString()].license = net.ReadBool()
end)

net.Receive("PW_Billions_Mayor_SetTax", function(len)
  PW_Billions.CFG.TAX[net.ReadInt(8)].amount = net.ReadFloat()
end)
