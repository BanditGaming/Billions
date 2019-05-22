--send player company data when first connected to the server
local function setupCompanyData2(ply)
  for k,v in pairs(PW_Billions.Companies) do
    net.Start("PW_Billions_Company_NewCompany")
    net.WriteString(v:getOwnerSid64())
    net.WriteString(v:getName())
    net.WriteInt(v:getWallet(), 32)
    net.WriteUInt(v:getLevel(), 32)
    net.WriteUInt(v:getXP(), 32)
    net.WriteUInt(v:getSkillPoints(), 32)
    net.WriteTable(v:getBlueprints())
    net.WriteTable(v:getJobs())
    net.Send(ply)
  end
end

hook.Add("PlayerInitialSpawn", "SetupCompanyData", function(ply)
  local sid = ply:SteamID64()
  if MySQLite.isMySQL() then
    MySQLite.query("SELECT CONVERT(`ownerSid64`, CHAR(20)), `name`, `wallet`, `level`, `xp`, `skillPoints` FROM `pilcrow_billions_business` WHERE `ownerSid64` = " .. MySQLite.SQLStr(sid), function(companyData)
      if companyData then
        for k, v in pairs(companyData) do
          local ownerSid64 = v["CONVERT(`ownerSid64`, CHAR(20))"]
          local name = v["name"]
          local wallet = tonumber(v["wallet"])
          local level = tonumber(v["level"])
          local xp = tonumber(v["xp"])
          local skillPoints = tonumber(v["skillPoints"])
          Company(name, ownerSid64, wallet, level, xp, skillPoints)
        end

        --after loading companies, load their blueprints
        MySQLite.query("SELECT CONVERT(`ownerSid64`, CHAR(20)), `className` FROM `pilcrow_billions_businessBlueprints` WHERE `ownerSid64` = " .. MySQLite.SQLStr(sid), function(data)
          if data then
            for k,v in pairs(data) do
              PW_Billions.getCompany(v["CONVERT(`ownerSid64`, CHAR(20))"]):addBlueprint(v["className"])
            end
          end
        end)
      end
      hook.Run("PW_Billions_Player_CompanyDataLoaded", ply)
    end)
  else
    MySQLite.query("SELECT `ownerSid64`, `name`, `wallet`, `level`, `xp`, `skillPoints` FROM `pilcrow_billions_business` WHERE `ownerSid64` = " .. MySQLite.SQLStr(sid), function(companyData)
      if companyData then
        for k, v in pairs(companyData) do
          local ownerSid64 = v["ownerSid64"]
          local name = v["name"]
          local wallet = tonumber(v["wallet"])
          local level = tonumber(v["level"])
          local xp = tonumber(v["xp"])
          local skillPoints = tonumber(v["skillPoints"])
          Company(name, ownerSid64, wallet, level, xp, skillPoints)
        end
      --after loading companies, load their blueprints
        MySQLite.query("SELECT `ownerSid64`, `className` FROM `pilcrow_billions_businessBlueprints` WHERE `ownerSid64` = " .. MySQLite.SQLStr(sid), function(data)
          if data then
            for k,v in pairs(data) do
              PW_Billions.getCompany(v["ownerSid64"]):addBlueprint(v["className"])
            end
          end
        end)
      end
      hook.Run("PW_Billions_Player_CompanyDataLoaded", ply)
    end)
  end
  setupCompanyData2(ply)
end)

--pays employed players from their company budget instead of darkrp system
hook.Add("playerGetSalary", "playerGetCompanySalary", function(ply, amount)
  if ply:isEmployed() then
    if ply:getCompany():canAfford(ply:getSalary()) then
      ply:getCompany():addMoney(- ply:getSalary(), BANK_SALARY, PW_Billions.getPhrase("salaryInfo") .. " " .. ply:Name() .. " (" .. ply:SteamID64() .. ")", "0")
      ply:getCompany():addXP(PW_Billions.CFG.XPGAIN_EMPLOYEESALARY)
      if PW_Billions.CFG.TAX_ENABLED then
        local salaryTax = math.ceil(ply:getSalary() * PW_Billions.CFG.TAX[TAX_INCOME].amount)
        local salary = ply:getSalary() - salaryTax
        PW_Billions.addMoneyGovernment(salaryTax)
        return false, PW_Billions.getPhrase("salaryReceived") .. " (" .. salary .. ") " .. PW_Billions.getPhrase("from") .. " " .. ply:getCompany():getName() .. ", " .. PW_Billions.getPhrase("tax") .. ": " .. salaryTax, salary
      else
        return false, PW_Billions.getPhrase("salaryReceived") .. " (" ..  ply:getSalary() .. ") " .. PW_Billions.getPhrase("from") .. " " .. ply:getCompany():getName()
      end
    else
      ply:getCompany():notifyOwner(PW_Billions.getPhrase("noMoneySalary"))
      return false, PW_Billions.getPhrase("noMoneySalaryPly"), 0
    end
  elseif ply:isCompanyOwner() then
    return true, nil, 0
  end
end)

hook.Add("playerCanChangeTeam", "checkIfPlayerIsEmployed", function(ply, team, force)
  if ply:isEmployed() or ply:isCompanyOwner() then
    return false, PW_Billions.getPhrase("needToLeave")
  end
end)

hook.Add("PlayerDisconnected", "companyEmployeeCleanup", function(ply)
  if ply:isEmployed() then
    ply:getCompany():fire(ply)
  elseif ply:isCompanyOwner() then
    ply:getCompany():disconnect()
  end
end)

--workaround for PlayerInitialSpawn (player gets assigned a team after that) to update DarkRP job name if a player is a company owner
hook.Add("PlayerSpawn", "updateJobName", function(ply)
  if ply:isCompanyOwner() then
    ply:updateJob("[" .. ply:getCompany():getName() .. "] " .. PW_Billions.getPhrase("owner"))
  end
end)

util.AddNetworkString("PW_Billions_Display_EmploymentOffers")
hook.Add("PlayerSay", "PW_Billions_Display_EmploymentOffers", function(ply, text, public)
  if text == "/jobs" then
    net.Start("PW_Billions_Display_EmploymentOffers")
    net.Send(ply)
  end
end)
