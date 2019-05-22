PW_Billions = PW_Billions or {}
PW_Billions.Tasks = PW_Billions.Tasks or {}
Task = Task or {}
function PW_Billions.getTasks()
  return PW_Billions.Tasks
end

function PW_Billions.getTask(itemClass)
  return PW_Billions.Tasks[itemClass] or false
end

function Task:getAmount()
  return self.amount
end

function Task:getClass()
  return self.className
end

function Task:getID()
  return self.id
end

function Task:getMoney()
  return self.money
end

function Task:getType()
  return self.type
end

function Task:getXP()
  return self.xp
end

function Task:getDateDifference()
  local difference = os.difftime(os.time(), self.time) / 60 / 60 / 24
  return difference
end
