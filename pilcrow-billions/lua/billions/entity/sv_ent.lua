local ENTITY = FindMetaTable("Entity")

function ENTITY:addToBox(ent)
  if self:isBox() and ent:isProduct() and ent:GetClass() != "pw_billions_products_weapon" then
    local entName = ent:getName()
    local entClass = ent:GetClass()

    if self:GetProductAmount() == 0 then
      ent:Remove()
      self:SetProductName(entName)
      self:SetProductClass(entClass)
      self:SetProductAmount(1)
      return true
    elseif self:GetProductName() == entName and self:GetProductAmount() < PW_Billions.CFG.BOXCAP then
      ent:Remove()
      self:SetProductAmount(self:GetProductAmount() + 1)
      return true
    end
  end
  return false
end

util.AddNetworkString("PW_Billions_Entity_setOwnerSid64")

net.Receive("PW_Billions_Entity_setOwnerSid64", function(len, ply)
  local ownerSid64 = net.ReadString()
  local ent = net.ReadEntity()

  if IsValid(ent) and IsEntity(ent) and ply:getOwnerSid64() == ent:getOwnerSid64() and (ent:isProduct() or ent:isBox()) then
    ent:setOwnerSid64(ownerSid64)
  end
end)
