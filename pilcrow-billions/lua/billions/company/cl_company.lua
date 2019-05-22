Company = Company or {}

net.Receive("PW_Billions_Company_NewCompany", function(len)
  local ownerSid64 = net.ReadString()
  local name = net.ReadString()
  local wallet = net.ReadInt(32)
  local level = net.ReadUInt(32)
  local xp = net.ReadUInt(32)
  local skillPoints = net.ReadUInt(32)
  local blueprints = net.ReadTable()
  local jobs = net.ReadTable()
  local newCompany = table.Copy(Company)
  newCompany.ownerSid64 = ownerSid64
  newCompany.name = string.Left(string.Trim(name), 25)
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
  if blueprints then
    newCompany.blueprints = blueprints
  end
  if jobs then
    newCompany.jobs = jobs
  end

  setmetatable(newCompany, Company)

  local owner = player.GetBySteamID64(ownerSid64)
  if owner then
    owner:setOwnerSid64(ownerSid64)
  end

  PW_Billions.Companies[newCompany.ownerSid64] = newCompany

  hook.Run("PW_Billions_Company_NewCompany", newCompany, false)
end)

net.Receive("PW_Billions_Company_AddBlueprint", function(len)
  local ownerSid64 = net.ReadString()
  local className = net.ReadString()
  PW_Billions.getCompany(ownerSid64).blueprints[className] = true
end)

net.Receive("PW_Billions_AddBuildingCompany", function(len)
  local ownerSid64 = net.ReadString()
  local buildingID = net.ReadInt(32)
  PW_Billions.BuildingID_CompanyID[buildingID] = ownerSid64
end)

net.Receive("PW_Billions_CompanyAddJob", function(len)
  local ownerSid64 = net.ReadString()
  local jobName = net.ReadString()
  local jobTable = net.ReadTable()
  local company = PW_Billions.getCompany(ownerSid64)

  company.jobs[jobName] = jobTable

  hook.Run("PW_Billions_Company_AddJob", company, jobName)
end)

net.Receive("PW_Billions_AddMoneyCompany", function(len)
  local ownerSid64 = net.ReadString()
  local company = PW_Billions.getCompany(ownerSid64)
  local amount = net.ReadInt(32)

  company.wallet = company.wallet + amount
  hook.Run("PW_Billions_Company_AddMoney", company, amount, company:getWallet())
end)

net.Receive("PW_Billions_EmployCompany", function(len)
  local ownerSid64 = net.ReadString()
  local company = PW_Billions.getCompany(ownerSid64)
  local ply = player.GetBySteamID64(net.ReadString())
  local jobName = net.ReadString()

  ply:setJobName(jobName)
  ply:setOwnerSid64(ownerSid64)
  company.employees[ply:SteamID64()] = ply
  company.employeesCount = company.employeesCount + 1
  hook.Run("PW_Billions_Company_Employ", company, ply, jobName)
end)

net.Receive("PW_Billions_FireCompanyEmployee", function(len)
  local ownerSid64 = net.ReadString()
  local ply = net.ReadEntity()
  local company = PW_Billions.getCompany(ownerSid64)
  if IsValid(ply) then
    company.employees[ply:SteamID64()] = nil
    ply:setOwnerSid64("")
    ply:setJobName("")
  else
    --fix if player left the server (PlayerDisconnected)
    for k,v in pairs(company.employees) do
      if !player.GetBySteamID64(k) then
        company.employees[k] = nil
        break
      end
    end
  end
  company.employeesCount = company.employeesCount - 1
end)

net.Receive("PW_Billions_RemoveCompany", function(len)
  local ownerSid64 = net.ReadString()
  PW_Billions.Companies[ownerSid64] = nil
end)

net.Receive("PW_Billions_RemoveCompanyBuilding", function(len)
  local ownerSid64 = net.ReadString()
  local company = PW_Billions.getCompany(ownerSid64)
  local buildingID = net.ReadInt(32)
  company.buildings[buildingID] = nil
end)

net.Receive("PW_Billions_CompanyRemoveJob", function(len)
  local ownerSid64 = net.ReadString()
  local jobName = net.ReadString()
  PW_Billions.getCompany(ownerSid64).jobs[jobName] = nil
end)

net.Receive("PW_Billions_Company_SendEmploymentOffer", function(len)
  local ownerSid64 = net.ReadString()
  local jobName = net.ReadString()
  LocalPlayer().employmentOffers[ownerSid64] = jobName
end)

net.Receive("PW_Billions_UpdateCompanyName", function(len)
  local ownerSid64 = net.ReadString()
  local company = PW_Billions.getCompany(ownerSid64)
  company.name = net.ReadString()
end)

net.Receive("PW_Billions_Company_Disconnect", function(len)
  PW_Billions.Companies[net.ReadString()] = nil
end)

net.Receive("PW_Billions_Company_UpdateLevelData", function(len)
  local company = PW_Billions.getCompany(net.ReadString())
  company.xp = net.ReadInt(32)
  company.level = net.ReadInt(8)
end)

net.Receive("PW_Billions_Company_UpdateSkillPoints", function(len)
  local company = PW_Billions.getCompany(net.ReadString())
  company.skillPoints = net.ReadInt(11)
end)

--[[-----------------------------------------------------
FUNCTIONS
-------------------------------------------------------]]

function Company:depositMoney(amount)
  if isnumber(amount) and amount > 0 then
    net.Start("PW_Billions_Company_DepositMoney")
    net.WriteUInt(amount, 32)
    net.SendToServer()
  end
end

function Company:sendEmploymentOffer(ply, jobName)
  if ply:isEmployed() == false and self:getJobs()[jobName] then
    net.Start("PW_Billions_Company_SendEmploymentOffer")
    net.WriteEntity(ply)
    net.WriteString(jobName)
    net.SendToServer()
  end
end

function Company:getEmployeesCount()
  return self.employeesCount
end
