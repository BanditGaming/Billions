PW_Billions = PW_Billions or {}

function PW_Billions.allCleanup()
  for k,v in pairs(ents.GetAll()) do
    if (v:isBox() or v:isProduct() or v:isWorkbench()) and v:getOwnerSid64() and !PW_Billions.getCompany(v:getOwnerSid64()) then
      v:Remove()
    end
  end
end

function PW_Billions.boxCleanup()
  for k,v in pairs(ents.GetAll()) do
    if v:isBox() and v:getOwnerSid64() and !PW_Billions.getCompany(v:getOwnerSid64()) then
      v:Remove()
    end
  end
end

function PW_Billions.productsCleanup()
  for k,v in pairs(ents.GetAll()) do
    if v:isProduct() and v:getOwnerSid64() and !PW_Billions.getCompany(v:getOwnerSid64()) then
      v:Remove()
    end
  end
end

function PW_Billions.workbenchCleanup()
  for k,v in pairs(ents.GetAll()) do
    if v:isWorkbench() and v:getOwnerSid64() and !PW_Billions.getCompany(v:getOwnerSid64()) then
      v:Remove()
    end
  end
end
