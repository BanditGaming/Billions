net.Receive("PW_Billions_Entity_setOwnerSid64", function(len)
  local ownerSid64 = net.ReadString()
  local ent = net.ReadEntity()
  ent.ownerSid64 = ownerSid64
end)
