PW_Billions = PW_Billions or {}
PW_Billions.Tasks = PW_Billions.Tasks or {}
PW_Billions.TasksCount = PW_Billions.TasksCount or 0

Task = Task or {}
Task.__index = Task
Task.id = 0
Task.type = 0
Task.timeType = 0
Task.time = 0
Task.dateDifference = 0
Task.amount = 0
Task.money = 0
Task.xp = 0

Task.progress = 0
--float 0-1 for gui
Task.progressPercentage = 0

function Task:getDaysLeft()
  if self.timeType == TASKS_TIMETYPE_DAILY then
    return 1 - self.dateDifference
  elseif self.timeType == TASKS_TIMETYPE_WEEKLY then
    return 7 - self.dateDifference
  end
end

function Task:getProgress()
  return self.progress
end

function Task:getProgressPercentage()
  return self.progressPercentage
end

setmetatable( Task, { __call = Task.new } )

net.Receive("PW_Billions_Tasks_Add", function()
  local className = net.ReadString()
  local newTask = table.Copy(Task)
  newTask.id = net.ReadInt(24)
  newTask.type = net.ReadInt(4)
  newTask.timeType = net.ReadInt(4)
  newTask.time = net.ReadInt(32)
  newTask.amount = net.ReadInt(16)
  newTask.money = net.ReadInt(32)
  newTask.xp = net.ReadInt(24)
  setmetatable(newTask, Task)
  newTask.dateDifference = newTask:getDateDifference()
  PW_Billions.Tasks[className] = newTask
  PW_Billions.Tasks[className].progress = 0
  PW_Billions.TasksCount = PW_Billions.TasksCount + 1
end)

net.Receive("PW_Billions_Tasks_Remove", function()
  PW_Billions.Tasks[net.ReadString()] = nil
  PW_Billions.TasksCount = PW_Billions.TasksCount - 1
end)

net.Receive("PW_Billions_Tasks_Progress", function()
  local task = PW_Billions.getTask(net.ReadString())
  task.progress = net.ReadInt(16)
  task.progressPercentage = task:getProgress() / task:getAmount()
  task.dateDifference = task:getDateDifference()
end)
