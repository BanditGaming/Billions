function PW_Billions.getCompany(ply)
  local sid64
  if isstring(ply) then
    sid64 = ply
    return PW_Billions.Companies[sid64]
  elseif isentity(ply) and ply:IsPlayer() then
    sid64 = ply:SteamID64()
    return PW_Billions.Companies[sid64]
  end
  return false
end

function PW_Billions.getCompanyByName(name)
  for k,v in pairs(PW_Billions.Companies) do
    if v.name == name then
      return v
    end
  end
  return false
end
