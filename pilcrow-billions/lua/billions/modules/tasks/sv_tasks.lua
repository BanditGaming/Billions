PW_Billions = PW_Billions or {}
PW_Billions.Tasks = PW_Billions.Tasks or {}

util.AddNetworkString("PW_Billions_Tasks_Add")
util.AddNetworkString("PW_Billions_Tasks_Progress")
util.AddNetworkString("PW_Billions_Tasks_Remove")
util.AddNetworkString("PW_Billions_Tasks_Completed")

Task = Task or {}
Task.__index = Task
Task.id = 0
Task.type = 0
Task.timeType = 0
Task.time = 0
Task.amount = 0
Task.money = 0
Task.xp = 0
Task.className = ""
--[ownerSid64] = itemCount
Task.companyProgress = {}

--generates a random task
function Task:new(timeType)
  local newTask = table.Copy(Task)
  if timeType == TASKS_TIMETYPE_DAILY then
    newTask.timeType = TASKS_TIMETYPE_DAILY
    newTask.amount = math.random(20, 80)
    newTask.xp = math.random(100, 500)
    newTask.money = math.random(500, 1500)
  elseif timeType == TASKS_TIMETYPE_WEEKLY then
    newTask.timeType = TASKS_TIMETYPE_WEEKLY
    newTask.amount = math.random(150, 700)
    newTask.xp = math.random(1000, 4000)
    newTask.money = math.random(4000, 20000)
  end
  newTask.time = os.time()

  newTask.type = math.random(1,2)

  local function addTaskToDB(rowid)
    if !rowid then
      rowid = 1
    else
      rowid = rowid + 1
    end
    newTask.id = tonumber(rowid)
    local className
    while true do
      _, className = table.Random(PW_Billions.CRAFTABLE.WORKBENCH)
      if !PW_Billions.Tasks[className] then
        break
      end
    end
    newTask.className = className
    setmetatable(newTask, Task)

    PW_Billions.Tasks[className] = newTask
    MySQLite.query("INSERT INTO `pilcrow_billions_tasks` (`type`, `timeType`, `time`, `amount`, `className`, `xp`, `money`) VALUES (" .. MySQLite.SQLStr(newTask.type) .. ", " .. MySQLite.SQLStr(newTask.timeType) .. ", " .. MySQLite.SQLStr(newTask.time) .. ", " .. MySQLite.SQLStr(newTask.amount) .. ", " .. MySQLite.SQLStr(className) .. ", " .. MySQLite.SQLStr(newTask.xp) .. ", " .. MySQLite.SQLStr(newTask.money) .. ")")
    net.Start("PW_Billions_Tasks_Add")
    net.WriteString(className)
    net.WriteInt(newTask.id, 24)
    net.WriteInt(newTask.type, 4)
    net.WriteInt(newTask.timeType, 4)
    net.WriteInt(newTask.time, 32)
    net.WriteInt(newTask.amount, 16)
    net.WriteInt(newTask.money, 32)
    net.WriteInt(newTask.xp, 24)
    net.Broadcast()
  end

  if MySQLite.isMySQL() then
    MySQLite.queryValue("SELECT MAX(rowid) FROM `pilcrow_billions_tasks`", addTaskToDB(rowid))
  else
    MySQLite.queryValue("SELECT last_insert_rowid() FROM `pilcrow_billions_tasks`", addTaskToDB(rowid))
  end
end

function Task:addProgress(company)
  if self.companyProgress[company:getOwnerSid64()] then
    self.companyProgress[company:getOwnerSid64()] = self.companyProgress[company:getOwnerSid64()] + 1
  else
    self.companyProgress[company:getOwnerSid64()] = 1
  end
  if company:getEmployees() then
    for k,v in pairs(company:getEmployees()) do
      net.Start("PW_Billions_Tasks_Progress")
      net.WriteString(self:getClass())
      net.WriteInt(self:getProgress(company), 16)
      net.Send(v)
    end
  end
  net.Start("PW_Billions_Tasks_Progress")
  net.WriteString(self:getClass())
  net.WriteInt(self:getProgress(company), 16)
  net.Send(company:getOwner())
  if self.companyProgress[company:getOwnerSid64()] == self.amount then
    company:addXP(self:getXP())
    company:addMoney(self:getMoney())
    company:notifyOwner(PW_Billions.getPhrase("taskCompleted") .. "! +" .. self:getXP() .. " " .. PW_Billions.getPhrase("xp") .. ", +" .. DarkRP.formatMoney(self:getMoney()))
    hook.Run("PW_Billions_Tasks_Completed", company, self)
    net.Start("PW_Billions_Tasks_Completed")
    net.WriteString(company:getOwnerSid64())
    net.WriteString(self:getClass())
    net.Broadcast()
  end
  if self.companyProgress[company:getOwnerSid64()] == 1 then
    MySQLite.query("INSERT INTO `pilcrow_billions_businessTasks` (`ownerSid64`, `taskID`, `progress`) VALUES (" .. MySQLite.SQLStr(company:getOwnerSid64()) .. ", " .. MySQLite.SQLStr(self:getID()) .. ", " .. MySQLite.SQLStr(self:getProgress(company)) .. ")")
  else
    MySQLite.query("UPDATE `pilcrow_billions_businessTasks` SET `progress` = " .. MySQLite.SQLStr(self:getProgress(company)) .. " WHERE `ownerSid64` = " .. MySQLite.SQLStr(company:getOwnerSid64()) .. " AND `taskID` = " .. MySQLite.SQLStr(self:getID()))
  end
end

function Task:getProgress(company)
  if isstring(company) then
    return self.companyProgress[company]
  end
  return self.companyProgress[company:getOwnerSid64()]
end

function Task:remove()
  MySQLite.query("DELETE FROM `pilcrow_billions_businessTasks` WHERE `taskID` = " .. self.id)
  MySQLite.query("DELETE FROM `pilcrow_billions_tasks` WHERE `rowid` = " .. self.id)
  PW_Billions.Tasks[self.className] = nil
  net.Start("PW_Billions_Tasks_Remove")
  net.WriteString(self.className)
  net.Broadcast()
end

setmetatable( Task, { __call = Task.new } )

function PW_Billions.checkTasks()
  if PW_Billions.Tasks then
    for k,v in pairs(PW_Billions.Tasks) do
      local difference = v:getDateDifference()
      local remove = false
      if v.timeType == TASKS_TIMETYPE_DAILY then
        if difference >= 1 then
          remove = true
        elseif PW_Billions.CRAFTABLE.WORKBENCH[v:getClass()] == nil then
          remove = true
        end
        if remove then
          v:remove()
          Task:new(TASKS_TIMETYPE_DAILY)
        end
      elseif v.timeType == TASKS_TIMETYPE_WEEKLY then
        if difference >= 7 then
          remove = true
        elseif PW_Billions.CRAFTABLE.WORKBENCH[v:getClass()] == nil then
          remove = true
        end
        if remove then
          v:remove()
          Task:new(TASKS_TIMETYPE_WEEKLY)
        end
      end
    end
  end
end

--only for PW_Billions_Tasks_Load hook
local function loadTasks(tasks)
  if tasks then
    for k,v in pairs(tasks) do
      local newTask = table.Copy(Task)
      newTask.id = tonumber(v["rowid"])
      newTask.type = tonumber(v["type"])
      newTask.timeType = tonumber(v["timeType"])
      newTask.time = tonumber(v["time"])
      newTask.amount = tonumber(v["amount"])
      newTask.money = tonumber(v["money"])
      newTask.xp = tonumber(v["xp"])
      newTask.className = tostring(v["className"])
      setmetatable(newTask, Task)
      PW_Billions.Tasks[v["className"]] = newTask
      print("Billions: Task loaded. ID:" .. newTask.id)
    end
    for k,v in pairs(PW_Billions.Tasks) do
      if MySQLite.isMySQL() then
        MySQLite.query("SELECT CONVERT(`ownerSid64`, CHAR(20)), taskID, progress FROM `pilcrow_billions_businessTasks` WHERE `taskID` = " .. tonumber(v:getID()), function(businessTaskTable)
          if businessTaskTable then
            for k2,v2 in pairs(businessTaskTable) do
              v.companyProgress[tostring(v2["CONVERT(`ownerSid64`, CHAR(20))"])] = tonumber(v2["progress"])
            end
          end
        end)
      else
        MySQLite.query("SELECT * FROM `pilcrow_billions_businessTasks` WHERE `taskID` = " .. tonumber(v:getID()), function(businessTaskTable)
          if businessTaskTable then
            for k2,v2 in pairs(businessTaskTable) do
              v.companyProgress[tostring(v2["ownerSid64"])] = tonumber(v2["progress"])
            end
          end
        end)
      end
    end
    PW_Billions.checkTasks()
  end

  --if there is less/more tasks than in config, add/remove tasks
  local dailyCount = 0
  local weeklyCount = 0
  if PW_Billions.Tasks then
    for k,v in pairs(PW_Billions.Tasks) do
      if v.timeType == TASKS_TIMETYPE_DAILY then
        dailyCount = dailyCount + 1
      elseif v.timeType == TASKS_TIMETYPE_WEEKLY then
        weeklyCount = weeklyCount + 1
      end
    end
  end
  local dailyDifference = PW_Billions.CFG.TASKS_DAILY_AMOUNT - dailyCount
  local weeklyDifference = PW_Billions.CFG.TASKS_WEEKLY_AMOUNT - weeklyCount
  if dailyDifference > 0 then
    for i = 1, dailyDifference do
      Task:new(TASKS_TIMETYPE_DAILY)
    end
  elseif dailyDifference < 0 then
    for i = 1, math.abs(dailyDifference) do
      local task = table.Random(PW_Billions.Tasks)
      task:remove()
    end
  end
  if weeklyDifference > 0 then
    for i = 1, weeklyDifference do
      Task:new(TASKS_TIMETYPE_WEEKLY)
    end
  elseif weeklyDifference < 0 then
    for i = 1, math.abs(weeklyDifference) do
      local task = table.Random(PW_Billions.Tasks)
      task:remove()
    end
  end


  hook.Run("PW_Billions_Tasks_Loaded")
  print("Billions: Tasks loaded")
end

hook.Add("PW_Billions_DBInitialized", "PW_Billions_Tasks_Load", function()
  print("Billions: Loading tasks")
  if MySQLite.isMySQL() then
    MySQLite.query("SELECT * FROM `pilcrow_billions_tasks`", function(tasks)
      loadTasks(tasks)
    end)
  else
    MySQLite.query("SELECT rowid, * FROM `pilcrow_billions_tasks`", function(tasks)
      loadTasks(tasks)
    end)
  end
end)

hook.Add("PW_Billions_Workbench_ItemCrafted", "PW_Billions_Tasks_Check", function(ply, company, className)
  if PW_Billions.Tasks[className] and PW_Billions.Tasks[className].type == TASKS_TYPE_PRODUCTION then
    PW_Billions.Tasks[className]:addProgress(company)
  end
end)

hook.Add("PW_Billions_NPC_ItemSold", "PW_Billions_Tasks_ItemSold", function(company, itemClass, itemAmount)
  if PW_Billions.getTask(itemClass) and PW_Billions.getTask(itemClass).type == TASKS_TYPE_SELL then
    for i = 1, itemAmount do
      PW_Billions.getTask(itemClass):addProgress(company)
    end
  end
end)

hook.Add("PW_Billions_Player_CompanyDataLoaded", "PW_Billions_Tasks_SendTasks", function(ply)
  if PW_Billions.getTasks() then
    for k,v in pairs(PW_Billions.getTasks()) do
      net.Start("PW_Billions_Tasks_Add")
      net.WriteString(k)
      net.WriteInt(v.id, 24)
      net.WriteInt(v.type, 4)
      net.WriteInt(v.timeType, 4)
      net.WriteInt(v.time, 32)
      net.WriteInt(v.amount, 16)
      net.WriteInt(v.money, 32)
      net.WriteInt(v.xp, 24)
      net.Send(ply)
      if ply:isCompanyOwner() and v:getProgress(ply:getCompany()) then
        net.Start("PW_Billions_Tasks_Progress")
        net.WriteString(v:getClass())
        net.WriteInt(v:getProgress(ply:getCompany()), 16)
        net.Send(ply)
      end
    end
  end
end)

hook.Add("PW_Billions_Company_Employ", "PW_Billions_Tasks_SendProgress", function(company, ply)
  if PW_Billions.getTasks() then
    for k,v in pairs(PW_Billions.getTasks()) do
      if v:getProgress(company) then
        net.Start("PW_Billions_Tasks_Progress")
        net.WriteString(v:getClass())
        net.WriteInt(v:getProgress(company), 16)
        net.Send(ply)
      end
    end
  end
end)
