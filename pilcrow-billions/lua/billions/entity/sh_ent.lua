local ENTITY = FindMetaTable("Entity")

function ENTITY:getAmount()
  if self:isBox() then
    return self:GetProductAmount()
  elseif PW_Billions.CRAFTABLE.WORKBENCH[self:GetClass()] then
    return 1
  elseif PW_Billions.PC_BUYITEMS[self:GetClass()] then
    return 1
  elseif self:GetClass() == "pw_billions_products_weapon" then
    return 1
  end
  return false
end

function ENTITY:getName()
  if self:isBox() then
    local name = self:GetProductName()
    if name != "Empty" then
      return name
    else
      return false
    end
  end
  local itemTable = PW_Billions.CRAFTABLE.WORKBENCH[self:GetClass()]
  if itemTable then
    return itemTable.name
  end
  itemTable = PW_Billions.PC_BUYITEMS[self:GetClass()]
  if itemTable then
    return itemTable.name
  end
  return false
end

function ENTITY:getPrice()
  if self:isBox() and self:GetProductClass() != "" then
    return PW_Billions.CRAFTABLE.WORKBENCH[self:GetProductClass()].price
  end
  if self:GetClass() == "pw_billions_products_weapon" then
    return PW_Billions.CRAFTABLE.WORKBENCH[self:GetProductClass()].price
  end
  if PW_Billions.CRAFTABLE.WORKBENCH[self:GetClass()] then
    return PW_Billions.CRAFTABLE.WORKBENCH[self:GetClass()].price
  end
  if PW_Billions.PC_BUYITEMS[self:GetClass()] then
    return PW_Billions.PC_BUYITEMS[self:GetClass()].price
  end
  return false
end

function ENTITY:getCompany()
  local ownerSid64 = self:getOwnerSid64()
  if ownerSid64 then
    return PW_Billions.getCompany(ownerSid64)
  end
  return false
end

function ENTITY:getOwnerSid64()
  if self.ownerSid64 then
    return self.ownerSid64
  end
  return false
end

function ENTITY:isProduct()
  local entClass = self:GetClass()
  if PW_Billions.CRAFTABLE.WORKBENCH[entClass] then
    return true
  elseif entClass == "pw_billions_products_weapon" and PW_Billions.CRAFTABLE.WORKBENCH[self:GetProductClass()] then
    return true
  end
  return false
end

function ENTITY:isBox()
  if self:GetClass() == "pw_billions_supplies_box" then
    return true
  end
  return false
end

function ENTITY:isWorkbench()
  if self:GetClass() == "pw_billions_supplies_workbench" then
    return true
  end
  return false
end

function ENTITY:setOwnerSid64(ownerSid64)
  if SERVER then
    self.ownerSid64 = ownerSid64
    net.Start("PW_Billions_Entity_setOwnerSid64")
    net.WriteString(ownerSid64)
    net.WriteEntity(self)
    net.Broadcast()
  elseif CLIENT then
    net.Start("PW_Billions_Entity_setOwnerSid64")
    net.WriteString(ownerSid64)
    net.WriteEntity(self)
    net.SendToServer()
  end
end
