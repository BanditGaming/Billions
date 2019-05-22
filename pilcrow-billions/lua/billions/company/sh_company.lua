PW_Billions.Companies = PW_Billions.Companies or {}

Company = Company or {}
Company.__index = Company
Company.ownerSid64 = ""
Company.name = ""
Company.wallet = 0
Company.level = 1
Company.xp = 0
Company.skillPoints = 0
Company.blueprints = {}
Company.employees = {}
Company.jobs = {}
Company.buildings = {}
Company.employeesCount = 0

function Company:addBlueprint(className)
  if SERVER then
    self.blueprints[className] = true

    net.Start("PW_Billions_Company_AddBlueprint")
    net.WriteString(self:getOwnerSid64())
    net.WriteString(className)
    net.Broadcast()
  elseif CLIENT then
    net.Start("PW_Billions_Company_AddBlueprint")
    net.WriteString(className)
    net.SendToServer()
  end
end

function Company:addBuilding(buildingID)
  if SERVER then
    if PW_Billions.BuildingID_CompanyID[buildingID] == nil then
      PW_Billions.BuildingID_CompanyID[buildingID] = self:getOwnerSid64()
      local owner = player.GetBySteamID64(self:getOwnerSid64())
      for k,v in pairs(PW_Billions.DoorID_BuildingID) do
          if v == buildingID then
            local doorEnt = DarkRP.doorIndexToEnt(k)
            if owner != nil then
              doorEnt:keysOwn(owner)
            end
            doorEnt:setKeysTitle(self:getName())
          end
      end
    end

    net.Start("PW_Billions_AddBuildingCompany")
    net.WriteString(self:getOwnerSid64())
    net.WriteInt(buildingID, 32)
    net.Broadcast()
  elseif CLIENT then
    net.Start("PW_Billions_AddBuildingCompany")
    net.WriteInt(buildingID, 32)
    net.SendToServer()
  end
end

function Company:addJob(jobName, jobSalary, canAddBuilding, canAddJob, canAddMoney, canEmploy, canFire, canOwnKeys, canRemoveBuilding, canSetName, suppressNotification)
  if SERVER then
    self.jobs[jobName] = {
      jobName = jobName,
      salary = jobSalary,
      canAddBuilding = canAddBuilding,
      canAddJob = canAddJob,
      canAddMoney = canAddMoney,
      canEmploy = canEmploy,
      canFire = canFire,
      canOwnKeys = canOwnKeys,
      canRemoveBuilding = canRemoveBuilding,
      canSetName = canSetName
    }

    net.Start("PW_Billions_CompanyAddJob")
    net.WriteString(self:getOwnerSid64())
    net.WriteString(jobName)
    net.WriteTable(self.jobs[jobName])
    net.Broadcast()

    if !suppressNotification then
      self:notifyOwner("Job created!")
    end

    hook.Run("PW_Billions_Company_AddJob", self, jobName)
  elseif CLIENT then
    net.Start("PW_Billions_CompanyAddJob")
    net.WriteString(jobName)
    net.WriteTable({
      salary = jobSalary,
      canAddBuilding = canAddBuilding,
      canAddJob = canAddJob,
      canAddMoney = canAddMoney,
      canEmploy = canEmploy,
      canFire = canFire,
      canOwnKeys = canOwnKeys,
      canRemoveBuilding = canRemoveBuilding,
      canSetName = canSetName
    })
    net.SendToServer()
  end
end

function Company:canAfford(amount)
  if self:getWallet() - amount >= 0 then
    return true
  end
  return false
end

function Company:canProduce(className)
  if self.blueprints[className] or PW_Billions.CRAFTABLE.WORKBENCH[className].needBlueprint == false then
    return true
  end
  return false
end

function Company:fire(ply)
  if SERVER then
    self.employees[ply:SteamID64()] = nil
    ply:setOwnerSid64("")
    ply:setJobName("")
    ply:updateJob(ply:getJobTable().name)
    ply:changeTeam(PW_Billions.CFG.TEAM_CITIZEN, true, true)
    DarkRP.notify(ply, 0, 4, "You have been fired from " .. self.name)
    self:notifyOwner("Player " .. ply:Name() .. " left your company!")

    net.Start("PW_Billions_FireCompanyEmployee")
    net.WriteString(self:getOwnerSid64())
    net.WriteEntity(ply)
    net.Broadcast()
  elseif CLIENT then
    net.Start("PW_Billions_FireCompanyEmployee")
    net.WriteEntity(ply)
    net.SendToServer()
  end
end

function Company:getBlueprints()
  return self.blueprints
end

function Company:getEmployees()
  return self.employees
end

function Company:getJob(jobName)
  if self.jobs[jobName] then
    return self.jobs[jobName]
  end
  return false
end

function Company:getJobs()
  return self.jobs
end

function Company:getLevel()
  return self.level
end

function Company:getName()
  return self.name
end

function Company:getOwner()
  local owner = player.GetBySteamID64(self:getOwnerSid64())
  return owner
end

function Company:getOwnerSid64()
  return self.ownerSid64
end

function Company:getRequiredXP()
  --xp needed for next level
  local requiredXP = 200 * (self:getLevel() + 1)
  return requiredXP
end

function Company:getSkillPoints()
  return self.skillPoints
end

function Company:getWallet()
  return self.wallet
end

function Company:getXP()
  return self.xp
end

function Company:remove(freeze)
  if SERVER then
    self:withdrawMoney(self:getOwner(), self:getWallet(), PW_Billions.getPhrase(companyClosure))

    --freezing allows the player to keep the progress
    if freeze then
      MySQLite.begin()
        MySQLite.queueQuery("INSERT INTO `pilcrow_billions_businessSaved`(`ownerSid64`, `level`, `xp`, `skillPoints`) SELECT `ownerSid64`, `level`, `xp`, `skillPoints` FROM `pilcrow_billions_business` WHERE `ownerSid64` =" .. MySQLite.SQLStr(self:getOwnerSid64()))
        MySQLite.queueQuery("DELETE FROM `pilcrow_billions_business` WHERE `ownerSid64` =" .. MySQLite.SQLStr(self:getOwnerSid64()))
        MySQLite.queueQuery("DELETE FROM `pilcrow_billions_businessTasks` WHERE `ownerSid64` =" .. MySQLite.SQLStr(self:getOwnerSid64()))
      MySQLite.commit()
    else
      --fully remove business from db
      MySQLite.begin()
        MySQLite.queueQuery("DELETE FROM `pilcrow_billions_businessBlueprints` WHERE `ownerSid64` =" .. MySQLite.SQLStr(self:getOwnerSid64()))
        MySQLite.queueQuery("DELETE FROM `pilcrow_billions_business` WHERE `ownerSid64` =" .. MySQLite.SQLStr(self:getOwnerSid64()))
        MySQLite.queueQuery("DELETE FROM `pilcrow_billions_businessTasks` WHERE `ownerSid64` =" .. MySQLite.SQLStr(self:getOwnerSid64()))
      MySQLite.commit()
    end

    for k,v in pairs(self:getEmployees()) do
      if v:IsPlayer() then
        self:fire(v)
      end
    end

    net.Start("PW_Billions_RemoveCompany")
    net.WriteString(self:getOwnerSid64())
    net.Broadcast()

    self:getOwner():updateJob(self:getOwner():getJobTable().name)
    PW_Billions.Companies[self:getOwnerSid64()] = nil
    PW_Billions.allCleanup()
  elseif CLIENT then
    net.Start("PW_Billions_RemoveCompany")
    net.WriteBool(freeze)
    net.SendToServer()
  end
end

function Company:removeBuilding(buildingID)
  if SERVER then
    if PW_Billions.BuildingID_CompanyID[buildingID] == self:getOwnerSid64() then
      PW_Billions.BuildingID_CompanyID[buildingID] = nil
      local owner = self:getOwner()

      for k,v in pairs(PW_Billions.DoorID_BuildingID) do
        if v == buildingID then
          local doorEnt = DarkRP.doorIndexToEnt(k)
          doorEnt:removeAllKeysExtraOwners()
          if owner != nil then
            doorEnt:keysUnOwn(owner)
          end
        end
      end
    end

    net.Start("PW_Billions_RemoveCompanyBuilding")
    net.WriteString(self:getOwnerSid64())
    net.WriteInt(buildingID, 32)
    net.Broadcast()

  elseif CLIENT then
    net.Start("PW_Billions_RemoveCompanyBuilding")
    net.WriteInt(buildingID, 32)
    net.SendToServer()
  end
end

function Company:removeJob(jobName)
  if SERVER then
    if jobName != "Worker" and self.jobs[jobName] then
      self.jobs[jobName] = nil

      for k,v in pairs(self:getEmployees()) do
        if v:getJobName() == jobName then
          v:setJobName("Worker")
        end
      end

      net.Start("PW_Billions_CompanyRemoveJob")
      net.WriteString(self:getOwnerSid64())
      net.WriteString(jobName)
      net.Broadcast()
    end
  elseif CLIENT and self.jobs[jobName] and (LocalPlayer():isCompanyOwner() or LocalPlayer():isEmployed() and LocalPlayer():canAddJob()) then
    net.Start("PW_Billions_CompanyRemoveJob")
    net.WriteString(jobName)
    net.SendToServer()
  end
end

--sending money to other companies
function Company:sendMoney(receiverSid64, amount, title)
  if SERVER then
    if amount > 0 and self:canAfford(amount) then
      self:addMoney(-amount, BANK_SEND, title, receiverSid64)
      if isstring(receiverSid64) then
        PW_Billions.getCompany(receiverSid64):addMoney(amount)
      else
        receiver:addMoney(amount)
      end
    end
  elseif CLIENT then
    net.Start("PW_Billions_Company_SendMoney")
    net.WriteString(receiverSid64)
    net.WriteInt(amount, 32)
    net.WriteString(title)
    net.SendToServer()
  end
end

function Company:setName(name)
  if SERVER then
    name = string.Left(string.Trim(name), 25)
    self.name = name
    --update company name in db
    MySQLite.query("UPDATE `pilcrow_billions_business` SET `name`= " .. MySQLite.SQLStr(name) .. " WHERE `ownerSid64` = " .. MySQLite.SQLStr(self:getOwnerSid64()))

    for k,v in pairs(self:getEmployees()) do
      v:updateJob(v:getJobName() .. PW_Billions.getPhrase("at") .. self:getName())
    end
    self:getOwner():updateJob(PW_Billions.getPhrase("ownerOf") .. self:getName())

    --broadcast new company name to all clients
    net.Start("PW_Billions_UpdateCompanyName")
    net.WriteString(self:getOwnerSid64())
    net.WriteString(name)
    net.Broadcast()

  elseif CLIENT then
    net.Start("PW_Billions_UpdateCompanyName")
    net.WriteString(name)
    net.SendToServer()
  end
end

function Company:withdrawMoney(ply, amount, title)
  if SERVER then
    if amount > 0 and self:canAfford(amount) then
      local taxAmount = 0
      self:addMoney(-amount, BANK_WITHDRAW, title, ply:SteamID64())
      if PW_Billions.CFG.TAX_ENABLED then
        taxAmount = amount * PW_Billions.CFG.TAX[TAX_WITHDRAW].amount
        amount = amount - taxAmount
        taxAmount = math.ceil(taxAmount)
        amount = math.floor(amount)
        PW_Billions.addMoneyGovernment(taxAmount)
        ply:addMoney(amount)
      else
        ply:addMoney(amount)
      end
      self:notifyOwner(PW_Billions.getPhrase("withdrawal") .. ": " .. DarkRP.formatMoney(amount) .. ". " .. PW_Billions.getPhrase("tax") .. ": " .. DarkRP.formatMoney(taxAmount) .. ". " .. PW_Billions.getPhrase("toPlayer") .. ": " .. ply:GetName())
    end
  elseif CLIENT then
    net.Start("PW_Billions_Company_WithdrawMoney")
    net.WriteEntity(ply)
    net.WriteInt(amount, 32)
    net.WriteString(title)
    net.SendToServer()
  end
end
