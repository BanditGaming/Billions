local PLAYER = FindMetaTable("Player")

--PLAYER.PW_Billions = PLAYER.PW_Billions or {}
--PLAYER.ownerSid64 = PLAYER.ownerSid64 or ""
--PLAYER.positionName = PLAYER.positionName or ""
PLAYER.employmentOffers = {}

function PLAYER:canAddBuilding()
  if self:getCompany().jobs[self:getPositionName()].canAddBuilding then
    return true
  end
  return false
end

function PLAYER:canAddJob()
  if self:getCompany().jobs[self:getPositionName()].canAddJob then
    return true
  end
  return false
end

function PLAYER:canAddMoney()
  if self:getCompany().jobs[self:getPositionName()].canAddMoney then
    return true
  end
  return false
end

function PLAYER:canEmploy()
  if self:getCompany().jobs[self:getPositionName()].canEmploy then
    return true
  end
  return false
end

function PLAYER:canFire()
  if self:getCompany().jobs[self:getPositionName()].canFire then
    return true
  end
  return false
end

function PLAYER:canOwnKeys()
  if self:getCompany().jobs[self:getPositionName()].canOwnKeys then
    return true
  end
  return false
end

function PLAYER:canRemoveBuilding()
  if self:getCompany().jobs[self:getPositionName()].canRemoveBuilding then
    return true
  end
  return false
end

function PLAYER:canSetName()
  if self:getCompany().jobs[self:getPositionName()].canSetName then
    return true
  end
  return false
end

function PLAYER:isCompanyOwner()
  if PW_Billions.Companies[self:SteamID64()] then
    return true
  else
    return false
  end
end

function PLAYER:isEmployed()
  if self:getOwnerSid64() and self:getOwnerSid64() != "" and self:getOwnerSid64() != self:SteamID64() then
    return true
  else
    return false
  end
end

function PLAYER:getCompany()
  if self:getOwnerSid64() != "" and self:getOwnerSid64() != self:SteamID64() then
    return PW_Billions.getCompany(self:getOwnerSid64())
  elseif self:isCompanyOwner() then
    return PW_Billions.getCompany(self:SteamID64())
  end
  return false
end

function PLAYER:getJobName()
  return self:getPositionName()
end

function PLAYER:getOwnerSid64()
  if self:isCompanyOwner() then
    return self:SteamID64()
  end
  return self.ownerSid64
end

function PLAYER:getPositionName()
  if self:isCompanyOwner() then
    return PW_Billions.getPhrase("owner")
  else
    return self.positionName
  end
end

function PLAYER:getSalary()
  return self:getCompany().jobs[self:getPositionName()].salary
end

function PLAYER:setOwnerSid64(sid64)
  self.ownerSid64 = sid64
end

function PLAYER:setJobName(jobName)
  self:setPositionName(jobName)
end

function PLAYER:setPositionName(positionName)
  self.positionName = positionName
end
