include("sh_company.lua")
Company = Company or {}

util.AddNetworkString("PW_Billions_Company_NewCompany")
util.AddNetworkString("PW_Billions_AddBuildingCompany")
util.AddNetworkString("PW_Billions_CompanyAddJob")
util.AddNetworkString("PW_Billions_AddMoneyCompany")
util.AddNetworkString("PW_Billions_EmployCompany")
util.AddNetworkString("PW_Billions_FireCompanyEmployee")
util.AddNetworkString("PW_Billions_RemoveCompany")
util.AddNetworkString("PW_Billions_RemoveCompanyBuilding")
util.AddNetworkString("PW_Billions_CompanyRemoveJob")
util.AddNetworkString("PW_Billions_UpdateCompanyName")
util.AddNetworkString("PW_Billions_Company_UpdateLevelData")
util.AddNetworkString("PW_Billions_Company_Disconnect")
util.AddNetworkString("PW_Billions_Company_LevelUp")

util.AddNetworkString("PW_Billions_CreateCompany")
net.Receive("PW_Billions_CreateCompany", function(len, ply)
  local businessName = net.ReadString()
  local ent = ply:GetEyeTraceNoCursor().Entity
  if !ply:canAfford(PW_Billions.CFG.CREATECOMPANY_PRICE) then
    DarkRP.notify(ply, 0, 4, PW_Billions.getPhrase("cantAfford"))
    return
  end
  if ent:GetClass() == "pw_billions_npc_businesscreator" and !ply:isEmployed() and !ply:isCompanyOwner() then
    ply:addMoney(- PW_Billions.CFG.CREATECOMPANY_PRICE)
    if MySQLite.isMySQL() then
      MySQLite.query("SELECT CONVERT(`ownerSid64`, CHAR(20)), `level`, `xp`, `skillPoints` FROM `pilcrow_billions_businessSaved` WHERE `ownerSid64` = " .. MySQLite.SQLStr(ply:SteamID64()), function(companyData)
        if companyData then
          for k, v in pairs(companyData) do
            local ownerSid64 = v["CONVERT(`ownerSid64`, CHAR(20))"]
            local level = tonumber(v["level"])
            local xp = tonumber(v["xp"])
            local skillPoints = tonumber(v["skillPoints"])
            local company = Company(businessName, ownerSid64, math.floor(PW_Billions.CFG.CREATECOMPANY_PRICE), level, xp, skillPoints)
            company:addToDb()
          end
          --after loading a company load blueprints
          MySQLite.query("SELECT CONVERT(`ownerSid64`, CHAR(20)), `className` FROM `pilcrow_billions_businessBlueprints` WHERE `ownerSid64` = " .. MySQLite.SQLStr(ply:SteamID64()), function(data)
            if data then
              for k,v in pairs(data) do
                PW_Billions.getCompany(v["CONVERT(`ownerSid64`, CHAR(20))"]):addBlueprint(v["className"])
              end
            end
            --hook.Run("PW_Billions_Player_CompanyDataLoaded", ply)
          end)
          MySQLite.query("DELETE FROM `pilcrow_billions_businessSaved` WHERE `ownerSid64` =" .. MySQLite.SQLStr(ply:SteamID64()))
        else
          local company = Company(businessName, ply:SteamID64(), math.floor(PW_Billions.CFG.CREATECOMPANY_PRICE))
          company:addToDb()
        end

      end)
    else
      MySQLite.query("SELECT `ownerSid64`, `level`, `xp`, `skillPoints` FROM `pilcrow_billions_businessSaved` WHERE `ownerSid64` = " .. MySQLite.SQLStr(ply:SteamID64()), function(companyData)
        if companyData then
          for k, v in pairs(companyData) do
            local ownerSid64 = v["ownerSid64"]
            local level = tonumber(v["level"])
            local xp = tonumber(v["xp"])
            local skillPoints = tonumber(v["skillPoints"])
            local company = Company(businessName, ownerSid64, math.floor(PW_Billions.CFG.CREATECOMPANY_PRICE), level, xp, skillPoints)
            company:addToDb()
          end
          --after loading a company load blueprints
          MySQLite.query("SELECT `ownerSid64`, `className` FROM `pilcrow_billions_businessBlueprints` WHERE `ownerSid64` = " .. MySQLite.SQLStr(ply:SteamID64()), function(data)
            if data then
              for k,v in pairs(data) do
                PW_Billions.getCompany(v["ownerSid64"]):addBlueprint(v["className"])
              end
            end
            --hook.Run("PW_Billions_Player_CompanyDataLoaded", ply)
          end)
          MySQLite.query("DELETE FROM `pilcrow_billions_businessSaved` WHERE `ownerSid64` =" .. MySQLite.SQLStr(ply:SteamID64()))
        else
          local company = Company(businessName, ply:SteamID64(), math.floor(PW_Billions.CFG.CREATECOMPANY_PRICE))
          company:addToDb()
        end
      end)
    end


  end
end)

util.AddNetworkString("PW_Billions_Company_AcceptEmploymentOffer")
net.Receive("PW_Billions_Company_AcceptEmploymentOffer", function(len, ply)
  local ownerSid64 = net.ReadString()
  local jobName = ply.employmentOffers[ownerSid64]
  local company = PW_Billions.getCompany(ownerSid64)
  if jobName and company and company:getJobs()[jobName] then
    ply.employmentOffers[ownerSid64] = nil
    company:employ(ply, jobName)
  end
end)

net.Receive("PW_Billions_AddBuildingCompany", function(len,ply)
  if ply:isCompanyOwner() or ply:isEmployed() and ply:canAddBuilding() then
    local company = ply:getCompany()
    local buildingID = net.ReadInt(32)
    company:addBuilding(buildingID)
  end
end)

net.Receive("PW_Billions_CompanyAddJob", function(len,ply)
  if ply:isCompanyOwner() or ply:isEmployed() and ply:canAddJob() then
    local company = ply:getCompany()
    local jobName = net.ReadString()
    local jobTable = net.ReadTable()
    if isstring(jobName) and jobName != "" and jobTable and isnumber(jobTable.salary) and isbool(jobTable.canAddBuilding) and isbool(jobTable.canAddJob) and isbool(jobTable.canAddMoney) and isbool(jobTable.canEmploy) and isbool(jobTable.canFire) and isbool(jobTable.canOwnKeys) and isbool(jobTable.canRemoveBuilding) and isbool(jobTable.canSetName) then
      company:addJob(jobName, jobTable.salary, jobTable.canAddBuilding, jobTable.canAddJob, jobTable.canAddMoney, jobTable.canEmploy, jobTable.canFire, jobTable.canOwnKeys, jobTable.canRemoveBuilding, jobTable.canSetName)
    end
  end
end)

util.AddNetworkString("PW_Billions_Company_DeclineEmploymentOffer")
net.Receive("PW_Billions_Company_DeclineEmploymentOffer", function(len, ply)
  local ownerSid64 = net.ReadString()
  ply.employmentOffers[ownerSid64] = nil
end)

util.AddNetworkString("PW_Billions_Company_DepositMoney")
net.Receive("PW_Billions_Company_DepositMoney",function(len, ply)
  local amount = net.ReadUInt(32)
  if ply:isCompanyOwner() and isnumber(amount) and amount > 0 then
    ply:getCompany():depositMoney(amount)
  end
end)

net.Receive("PW_Billions_FireCompanyEmployee", function(len, ply)
  if ply:isCompanyOwner() or ply:isEmployed() and ply:canFire() then
    local company = ply:getCompany()
    local playerToFire = net.ReadEntity()
    if playerToFire:IsPlayer() then
      company:fire(playerToFire)
    end
  elseif ply:isEmployed() then
    local playerToFire = net.ReadEntity()
    if playerToFire:IsPlayer() and ply == playerToFire then
      ply:getCompany():fire(ply)
    end
  end
end)

net.Receive("PW_Billions_RemoveCompany", function(len, ply)
  local freeze = net.ReadBool()
  if ply:isCompanyOwner() and isbool(freeze) then
    ply:getCompany():remove(freeze)
  end
end)

net.Receive("PW_Billions_RemoveCompanyBuilding", function(len, ply)
  if ply:isCompanyOwner() or (ply:isEmployed() and ply:canRemoveBuilding()) then
    local buildingID = net.ReadInt(32)
    if isnumber(buildingID) then
      ply:getCompany():removeBuilding(buildingID)
    end
  end
end)

net.Receive("PW_Billions_CompanyRemoveJob", function(len, ply)
  if ply:isCompanyOwner() or ply:isEmployed() and ply:canAddJob() then
    ply:getCompany():removeJob(net.ReadString())
  end
end)

net.Receive("PW_Billions_UpdateCompanyName", function(len, ply)
  if ply:isCompanyOwner() or (ply:isEmployed() and ply:canSetName()) then
    if !ply:getCompany():canAfford(PW_Billions.CFG.TAX[TAX_CHANGENAME].amount) then
      ply:getCompany():notifyOwner(PW_Billions.getPhrase("cantAfford"))
      return
    end
    ply:getCompany():addMoney(- PW_Billions.CFG.TAX[TAX_CHANGENAME].amount)
    PW_Billions.addMoneyGovernment(PW_Billions.CFG.TAX[TAX_CHANGENAME].amount)
    local name = net.ReadString()
    if isstring(name) then
      ply:getCompany():setName(name)
    end
  end
end)

util.AddNetworkString("PW_Billions_Company_AddBlueprint")
net.Receive("PW_Billions_Company_AddBlueprint", function(len, ply)
  if ply:isCompanyOwner() then
    local className = net.ReadString()
    if PW_Billions.CRAFTABLE.WORKBENCH[className] and !ply:getCompany():canProduce(className) then
      local company = ply:getCompany()
      local blueprintCost = PW_Billions.CRAFTABLE.WORKBENCH[className].blueprintCost
      if company:getSkillPoints() >= blueprintCost then
        company:addSkillPoints(- blueprintCost)
        company:addBlueprint(className)
        MySQLite.query("INSERT INTO `pilcrow_billions_businessBlueprints` (`ownerSid64`, `className`) VALUES (" .. MySQLite.SQLStr(company:getOwnerSid64()) .. ", " .. MySQLite.SQLStr(className) .. ")")
      end
    end
  end
end)

util.AddNetworkString("PW_Billions_Company_SendEmploymentOffer")
net.Receive("PW_Billions_Company_SendEmploymentOffer", function(len, ply)
  if ply:isCompanyOwner() or (ply:isEmployed() and ply:canEmploy()) then
    local newEmployee = net.ReadEntity()
    local jobName = net.ReadString()
    local company = ply:getCompany()
    if newEmployee:IsPlayer() and newEmployee:isEmployed() == false and newEmployee:isCompanyOwner() == false and company:getJobs()[jobName] then
      newEmployee.employmentOffers[company:getOwnerSid64()] = jobName
      net.Start("PW_Billions_Company_SendEmploymentOffer")
      net.WriteString(company:getOwnerSid64())
      net.WriteString(jobName)
      net.Send(newEmployee)
      DarkRP.notify(newEmployee, 0, 4, PW_Billions.getPhrase("newEmploymentOffer") .. ": " .. company:getName() .. ". " .. PW_Billions.getPhrase("typeJobs"))
    end
  end
end)

util.AddNetworkString("PW_Billions_Company_SendMoney")
net.Receive("PW_Billions_Company_SendMoney", function(len, ply)
  if ply:isCompanyOwner() or (ply:isEmployed() and ply:canAddMoney()) then
    local receiverSid64 = net.ReadString()
    local amount = net.ReadInt(32)
    local title = net.ReadString()
    if isstring(receiverSid64) and isnumber(amount) and amount >= 1 and isstring(title) then
      ply:getCompany():sendMoney(receiverSid64, math.Round(amount, 0), title)
    end
  end
end)

util.AddNetworkString("PW_Billions_Company_WithdrawMoney")
net.Receive("PW_Billions_Company_WithdrawMoney", function(len, ply)
  if ply:isCompanyOwner() or ply:isEmployed() and ply:canAddMoney() then
    local ply2 = net.ReadEntity()
    local amount = net.ReadInt(32)
    local title = net.ReadString()
    if ply2:IsPlayer() and isnumber(amount) and amount >= 1 and isstring(title) then
      ply:getCompany():withdrawMoney(ply2, math.Round(amount, 0), title)
    end
  end
end)

--[[--------------------------------------------------
  FUNCTIONS
----------------------------------------------------]]

function Company:new(name, ownerSid64, wallet, level, xp, skillPoints)
  local ply = player.GetBySteamID64(ownerSid64)
  local newCompany = table.Copy(Company)
  newCompany.ownerSid64 = tostring(ownerSid64)
  newCompany.name = string.Left(string.Trim(name), 25)
  if wallet != nil and isnumber(wallet) then
    newCompany.wallet = wallet
  end
  if isnumber(wallet) then
    newCompany.wallet = wallet
  end
  if isnumber(level) then
    newCompany.level = level
  end
  if isnumber(xp) then
    newCompany.xp = xp
  end
  if isnumber(skillPoints) then
    newCompany.skillPoints = skillPoints
  end

  setmetatable(newCompany, Company)

  ply:updateJob("[" .. newCompany:getName() .. "] " .. PW_Billions.getPhrase("owner"))

  PW_Billions.Companies[newCompany.ownerSid64] = newCompany

  hook.Run("PW_Billions_Company_NewCompany", newCompany, false)

  net.Start("PW_Billions_Company_NewCompany")
  net.WriteString(newCompany:getOwnerSid64())
  net.WriteString(newCompany:getName())
  net.WriteInt(newCompany:getWallet(), 32)
  net.WriteUInt(newCompany:getLevel(), 32)
  net.WriteUInt(newCompany:getXP(), 32)
  net.WriteUInt(newCompany:getSkillPoints(), 32)
  net.WriteTable(newCompany:getBlueprints())
  net.WriteTable(newCompany:getJobs())
  net.Broadcast()

  newCompany:addJob("Worker", 50, false, false, false, false, false, false, false, false, true)
  newCompany:notifyOwner(PW_Billions.getPhrase("buyPcNotification"))
  return newCompany
end

function Company:addMoney(amount, transactionType, title, receiverSid64)
  self.wallet = self.wallet + amount
  MySQLite.query("UPDATE `pilcrow_billions_business` SET `wallet`= `wallet` + " .. MySQLite.SQLStr(amount) .. " WHERE `ownerSid64`=" .. MySQLite.SQLStr(self:getOwnerSid64()))

  if PW_Billions.CFG.BANKLOG then
    local logAmount = math.abs(amount)
    if transactionType and title and receiverSid64 then
      if MySQLite.isMySQL() then
        MySQLite.query("INSERT INTO `pilcrow_billions_businessBankLog` (`senderSid64`, `receiverSid64`, `transactionType`, `amount`, `title`, `dateTime`) VALUES (" .. MySQLite.SQLStr(self:getOwnerSid64()) .. ", " .. MySQLite.SQLStr(receiverSid64) .. ", " .. MySQLite.SQLStr(transactionType) .. ", " .. MySQLite.SQLStr(logAmount) .. ", " .. MySQLite.SQLStr(title) .. ", NOW())")
      else
        MySQLite.query("INSERT INTO `pilcrow_billions_businessBankLog` (`senderSid64`, `receiverSid64`, `transactionType`, `amount`, `title`, `dateTime`) VALUES (" .. MySQLite.SQLStr(self:getOwnerSid64()) .. ", " .. MySQLite.SQLStr(receiverSid64) .. ", " .. MySQLite.SQLStr(transactionType) .. ", " .. MySQLite.SQLStr(logAmount) .. ", " .. MySQLite.SQLStr(title) .. ", datetime('now'))")
      end
    elseif transactionType and receiverSid64 then
      if MySQLite.isMySQL() then
        MySQLite.query("INSERT INTO `pilcrow_billions_businessBankLog` (`senderSid64`, `receiverSid64`, `transactionType`, `amount`, `dateTime`) VALUES (" .. MySQLite.SQLStr(self:getOwnerSid64()) .. ", " .. MySQLite.SQLStr(receiverSid64) .. ", " .. MySQLite.SQLStr(transactionType) .. ", " .. MySQLite.SQLStr(logAmount) .. ", NOW())")
      else
        MySQLite.query("INSERT INTO `pilcrow_billions_businessBankLog` (`senderSid64`, `receiverSid64`, `transactionType`, `amount`, `dateTime`) VALUES (" .. MySQLite.SQLStr(self:getOwnerSid64()) .. ", " .. MySQLite.SQLStr(receiverSid64) .. ", " .. MySQLite.SQLStr(transactionType) .. ", " .. MySQLite.SQLStr(logAmount) .. ", datetime('now'))")
      end
    elseif transactionType then
      if MySQLite.isMySQL() then
        MySQLite.query("INSERT INTO `pilcrow_billions_businessBankLog` (`receiverSid64`, `transactionType`, `amount`, `dateTime`) VALUES (" .. MySQLite.SQLStr(self:getOwnerSid64()) .. ", " .. MySQLite.SQLStr(transactionType) .. ", " .. MySQLite.SQLStr(logAmount) .. ", NOW())")
      else
        MySQLite.query("INSERT INTO `pilcrow_billions_businessBankLog` (`receiverSid64`, `transactionType`, `amount`, `dateTime`) VALUES (" .. MySQLite.SQLStr(self:getOwnerSid64()) .. ", " .. MySQLite.SQLStr(transactionType) .. ", " .. MySQLite.SQLStr(logAmount) .. ", datetime('now'))")
      end
    end
  end

  net.Start("PW_Billions_AddMoneyCompany")
  net.WriteString(self:getOwnerSid64())
  net.WriteInt(amount, 32)
  net.Broadcast()
end

util.AddNetworkString("PW_Billions_Company_NewCompany_Created")

function Company:addToDb()

  if MySQLite.isMySQL() then
    MySQLite.begin()
    MySQLite.queueQuery("INSERT INTO `pilcrow_billions_business` (`ownerSid64`, `name`, `wallet`, `level`, `xp`, `skillPoints`) VALUES (" .. MySQLite.SQLStr(self:getOwnerSid64()) .. ", " .. MySQLite.SQLStr(self:getName()) .. ", " .. MySQLite.SQLStr(self:getWallet()) .. ", " .. MySQLite.SQLStr(self:getLevel()) .. ", " .. MySQLite.SQLStr(self:getXP()) .. ", " .. MySQLite.SQLStr(self:getSkillPoints()) .. ")")
    MySQLite.queueQuery("INSERT INTO `pilcrow_billions_employmentHistory` (`employeeID`, `ownerSid64`, `businessName`, `dateTime`, `position`) VALUES (" .. MySQLite.SQLStr(self:getOwnerSid64()) .. ", " .. MySQLite.SQLStr(self:getOwnerSid64()) .. ", " .. MySQLite.SQLStr(self:getName()) .. ", NOW(), '" .. MySQLite.SQLStr(PW_Billions.getPhrase("owner")) .. "')")
    MySQLite.commit()
  else
    MySQLite.begin()
    MySQLite.queueQuery("INSERT INTO `pilcrow_billions_business` (`ownerSid64`, `name`, `wallet`, `level`, `xp`, `skillPoints`) VALUES (" .. MySQLite.SQLStr(self:getOwnerSid64()) .. ", " .. MySQLite.SQLStr(self:getName()) .. ", " .. MySQLite.SQLStr(self:getWallet()) .. ", " .. MySQLite.SQLStr(self:getLevel()) .. ", " .. MySQLite.SQLStr(self:getXP()) .. ", " .. MySQLite.SQLStr(self:getSkillPoints()) .. ")")
    MySQLite.commit()
  end

  self:notifyOwner(PW_Billions.getPhrase("companyCreated") .. "!")

  local ply = self:getOwner()
  if isentity(ply) and ply:IsPlayer() then
    if ply:Team() != PW_Billions.CFG.TEAM_CITIZEN then
      ply:SetTeam(PW_Billions.CFG.TEAM_CITIZEN)
    end
    ply:updateJob("[" .. self:getName() .. "] " .. PW_Billions.getPhrase("owner"))
  end

  hook.Run("PW_Billions_Company_NewCompany", newCompany, true)
  net.Start("PW_Billions_Company_NewCompany_Created")
  net.WriteString(self:getOwnerSid64())
  net.Broadcast()
end

util.AddNetworkString("PW_Billions_Company_UpdateSkillPoints")

function Company:addSkillPoints(amount)
  self.skillPoints = self.skillPoints + amount

  MySQLite.query("UPDATE `pilcrow_billions_business` SET  `skillPoints` = " .. MySQLite.SQLStr(self:getSkillPoints()) .. " WHERE `ownerSid64` = " .. MySQLite.SQLStr(self:getOwnerSid64()))

  net.Start("PW_Billions_Company_UpdateSkillPoints")
  net.WriteString(self:getOwnerSid64())
  net.WriteInt(self:getSkillPoints(), 12)
  net.Broadcast()
end

function Company:addXP(amount, loop)
  --save level and skillPoints for hook
  local startingLvl = self:getLevel()
  local startingSkillPoints = self:getSkillPoints()

  local requiredXP = self:getRequiredXP()
  --xp after adding the amount
  local xpSum = self.xp + amount
  --if got the xp needed for the next level and will not go over levelcap
  if xpSum >= requiredXP and self.level + 1 <= PW_Billions.CFG.LEVELCAP then
    self.level = self.level + 1
    if self.level <= 3 then
      self:addSkillPoints(1)
    elseif self.level > 3 and self.level <= 15 then
      self:addSkillPoints(2)
    else
      self:addSkillPoints(3)
    end
    self.xp = xpSum - requiredXP
  else
    self.xp = self.xp + amount
  end

  if self:getXP() >= self:getRequiredXP() then
    self:addXP(0, true)
    return
  end

  if loop then return end

  MySQLite.query("UPDATE `pilcrow_billions_business` SET `level` = " .. MySQLite.SQLStr(self:getLevel()) .. ", `xp` = " .. MySQLite.SQLStr(self:getXP()) .. " WHERE `ownerSid64` = " .. MySQLite.SQLStr(self:getOwnerSid64()) )

  net.Start("PW_Billions_Company_UpdateLevelData")
  net.WriteString(self:getOwnerSid64())
  net.WriteInt(self:getXP(), 32)
  net.WriteInt(self:getLevel(), 8)
  net.Broadcast()

  if startingLvl < self:getLevel() then
    local addedSkillPoints = self:getSkillPoints() - startingSkillPoints
    hook.Run("PW_Billions_Company_LevelUp", self, self:getLevel(), startingLvl, addedSkillPoints)
    net.Start("PW_Billions_Company_LevelUp")
    net.WriteString(self:getOwnerSid64())
    net.WriteInt(startingLvl, 16)
    net.WriteInt(addedSkillPoints, 4)
    net.Broadcast()
  end
end

function Company:depositMoney(amount)
  if amount > 0 and self:getOwner() and self:getOwner():canAfford(amount) then
    self:getOwner():addMoney(-amount)
    self:addMoney(amount, BANK_DEPOSIT)
  end
end

function Company:disconnect()
  for k,v in pairs(self:getEmployees()) do
    self:fire(v)
  end
  net.Start("PW_Billions_Company_Disconnect")
  net.WriteString(self:getOwnerSid64())
  net.Broadcast()
  PW_Billions.Companies[self:getOwnerSid64()] = nil
  PW_Billions.allCleanup()
end

function Company:employ(ply, jobName)
  if IsValid(ply) and ply:isCompanyOwner() == false and ply:isEmployed() == false then
    if ply:Team() != PW_Billions.CFG.TEAM_CITIZEN then
      ply:SetTeam(PW_Billions.CFG.TEAM_CITIZEN)
    end
    ply:setOwnerSid64(self:getOwnerSid64())
    ply:setJobName(jobName)
    --override darkrp job name
    ply:updateJob("[" .. self:getName() .. "] " .. jobName)
    self.employees[ply:SteamID64()] = ply
    DarkRP.notify(ply, 0, 4, PW_Billions.getPhrase("gotHired") .. " " .. self.name)
    self:notifyOwner(PW_Billions.getPhrase("youHired") .. " " .. ply:Name())

    net.Start("PW_Billions_EmployCompany")
    net.WriteString(self:getOwnerSid64())
    net.WriteString(ply:SteamID64())
    net.WriteString(jobName)
    net.Broadcast()

    hook.Run("PW_Billions_Company_Employ", self, ply, jobName)
  end
end

function Company:notifyOwner(message)
  DarkRP.notify(self:getOwner(), 0 , 4, message)
end

function Company:payEmployee(ply)
  local salary = ply:getSalary()
  if self:canAfford(salary) then
    self:addMoney(- salary, BANK_SALARY, nil, ply:SteamID64())
    ply:addMoney(salary)
    DarkRP.notify(ply, 0, 4, PW_Billions.getPhrase("payday") .. ", " .. DarkRP.formatMoney(salary))
  else
    DarkRP.notify(ply, 0, 4, PW_Billions.getPhrase("cantAffordSalary"))
  end
end

setmetatable( Company, { __call = Company.new } )
