net.Receive("PW_Billions_Tasks_Completed", function()
  local company = PW_Billions.getCompany(net.ReadString())
  local task = PW_Billions.getTask(net.ReadString())
  hook.Run("PW_Billions_Tasks_Completed", company, task)
end)

hook.Add("PW_Billions_Tasks_Completed", "PW_Billions_Tasks_CompletedInfo", function(company, task)
  if LocalPlayer():getCompany() and LocalPlayer():getCompany() == company then
    surface.PlaySound("billions/task_completed.mp3")
    notification.AddLegacy(PW_Billions.getPhrase("taskCompleted") .. "!", NOTIFY_GENERIC, 4)
  end
end)
