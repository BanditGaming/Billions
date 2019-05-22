PW_Billions = PW_Billions or {}

--HUD 1
surface.CreateFont( "PW_HUDFont", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.016,
  weight = 500,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = false,
  additive = false,
  outline = false
} )

surface.CreateFont( "PW_HUDFontSmall", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.0117,
  weight = 500,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = false,
  additive = false,
  outline = false
} )

surface.CreateFont( "PW_HUDFontSmallest", {
  font = "Verdana",
  extended = false,
  size = ScrW() * 0.009,
  weight = 500,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = false,
  additive = false,
  outline = false
} )

--HUD 2 and 3
surface.CreateFont( "PW_HUDFont2", {
  font = "Corporate Gothic NBP",
  extended = false,
  size = ScrW() * 0.016,
  weight = 500,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = false,
  additive = false,
  outline = false
} )

surface.CreateFont( "PW_HUDFont2Smallest", {
  font = "Corporate Gothic NBP",
  extended = false,
  size = ScrW() * 0.0102,
  weight = 500,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = false,
  additive = false,
  outline = false
} )

if PW_Billions.CFG.HUD_ENABLE then
  hook.Add("HUDPaint", "DrawBillionsHUD", function()
    if PW_Billions.CFG.HUD_TYPE == 1 then --basic
      if LocalPlayer():isCompanyOwner() or LocalPlayer():isEmployed() then
        surface.SetDrawColor(30, 30, 30, 200)
        surface.DrawRect(0, 0, ScrW(), ScrH() * 0.04)

        surface.SetFont("PW_HUDFont")
        surface.SetTextColor(217, 217, 217, 245)

        surface.SetTextPos(ScrW() * 0.01, ScrH() * 0.006)
        surface.DrawText(PW_Billions.getPhrase("company") .. ": " .. LocalPlayer():getCompany():getName())
        surface.SetTextPos(ScrW() * 0.25, ScrH() * 0.006)
        surface.DrawText(" | " .. PW_Billions.getPhrase("money") .. ": " .. DarkRP.formatMoney(LocalPlayer():getCompany():getWallet()))
        surface.SetTextPos(ScrW() * 0.38, ScrH() * 0.006)
        surface.DrawText(" | " .. PW_Billions.getPhrase("level") .. ": " .. LocalPlayer():getCompany():getLevel())
        surface.SetTextPos(ScrW() * 0.46, ScrH() * 0.006)
        surface.DrawText(" | " .. PW_Billions.getPhrase("xp") .. ": " .. LocalPlayer():getCompany():getXP() .. "/" .. LocalPlayer():getCompany():getRequiredXP())
        surface.SetTextPos(ScrW() * 0.63, ScrH() * 0.006)
        surface.DrawText(" | " .. PW_Billions.getPhrase("skillPoints") .. ": " .. LocalPlayer():getCompany():getSkillPoints())
        surface.SetTextPos(ScrW() * 0.76, ScrH() * 0.006)
        surface.DrawText(" | " .. PW_Billions.getPhrase("employees") .. ": " .. LocalPlayer():getCompany():getEmployeesCount())
        --tasks
        surface.SetTextPos(ScrW() * 0.879, ScrH() * 0.006)
        surface.DrawText("| " .. PW_Billions.getPhrase("tasks"))
        surface.DrawRect(ScrW() * 0.88, ScrH() * 0.04, ScrW() * 0.12, ScrH() * 0.07 * PW_Billions.TasksCount)
        --loop through and display all tasks
        local count = 0
        for k,v in pairs(PW_Billions.getTasks()) do
          surface.SetFont("PW_HUDFontSmall")
          surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.045 + (ScrH() * 0.07 * count))
          local typeName
          if v.type == TASKS_TYPE_PRODUCTION then
            typeName = PW_Billions.getPhrase("produce")
          else
            typeName = PW_Billions.getPhrase("sell")
          end
          surface.DrawText(typeName .. " " .. PW_Billions.CRAFTABLE.WORKBENCH[k].name)

          surface.SetFont("PW_HUDFontSmallest")
          surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.069 + (ScrH() * 0.07 * count))
          surface.DrawText(PW_Billions.getPhrase("reward") .. ": " .. v.xp .. " XP, " .. DarkRP.formatMoney(v.money))

          --background to the progress bar
          surface.SetDrawColor(59, 59, 69, 140)
          surface.DrawRect(ScrW() * 0.88, ScrH() * 0.04 + (ScrH() * 0.07 * (count + 1)) - ScrH() * 0.02, ScrW() * 0.12, ScrH() * 0.02)

          --progress bar
          if v.progressPercentage > 1 then
            surface.SetDrawColor(186, 186, 196, 255)
            surface.DrawRect(ScrW() * 0.88, ScrH() * 0.04 + (ScrH() * 0.07 * (count + 1)) - ScrH() * 0.02, ScrW() * 0.12, ScrH() * 0.02)
          elseif v.progressPercentage > 0 then
            surface.SetDrawColor(106, 106, 124, 255)
            surface.DrawRect(ScrW() * 0.88, ScrH() * 0.04 + (ScrH() * 0.07 * (count + 1)) - ScrH() * 0.02, ScrW() * 0.12 * v:getProgressPercentage(), ScrH() * 0.02)
          end

          --readable progress count
          surface.SetTextPos(ScrW() * 0.885, (ScrH() * 0.04 + (ScrH() * 0.07 * (count + 1)) - ScrH() * 0.02) + ScrH() * 0.0028)
          if v.progressPercentage < 1 then
            surface.DrawText(v.progress .. "/" .. v.amount)
          else
            surface.DrawText(PW_Billions.getPhrase("completed"))
          end

          --time left
          surface.SetTextPos(ScrW() * 0.945, (ScrH() * 0.04 + (ScrH() * 0.07 * (count + 1)) - ScrH() * 0.02) + ScrH() * 0.0028)
          surface.DrawText(PW_Billions.getPhrase("daysLeft") .. ": " .. math.Truncate(v:getDaysLeft(), 1))

          count = count + 1
        end
      elseif LocalPlayer():isMayor() then
        surface.SetDrawColor(30, 30, 30, 230)
        surface.DrawRect(0, 0, ScrW(), ScrH() * 0.04)

        surface.SetFont("PW_HUDFont")
        surface.SetTextColor(255, 255, 255, 200)

        surface.SetTextPos(ScrW() * 0.12, ScrH() * 0.006)
        surface.DrawText(PW_Billions.getPhrase("politicalCapital") .. ": " .. PW_Billions.getPoliticalCapital())
        surface.SetTextPos(ScrW() * 0.42, ScrH() * 0.006)
        surface.DrawText(PW_Billions.getPhrase("governmentMoney") .. ": " .. PW_Billions.getMoneyGovernment() .. "$")
        surface.SetTextPos(ScrW() * 0.72, ScrH() * 0.006)
        local companies = 0
        for _ in pairs(PW_Billions.Companies) do companies = companies + 1 end
        surface.DrawText(PW_Billions.getPhrase("currentCompanies") .. ": " .. companies)
      end
    elseif PW_Billions.CFG.HUD_TYPE == 2 then --right
      if LocalPlayer():isCompanyOwner() or LocalPlayer():isEmployed() then

        surface.SetDrawColor(30, 30, 30, 200)
        --ScrH() * 0.07 == hight of one box
        surface.DrawRect(ScrW() * 0.88, 0, ScrW() * 0.12, ScrH() * 0.07 * (PW_Billions.TasksCount + 6.5))

        surface.SetFont("PW_HUDFont2")
        surface.SetTextColor(217, 217, 217, 240)
        surface.SetDrawColor(153, 153, 153, 240)

        --company name box
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005)
        surface.DrawText(PW_Billions.getPhrase("company") .. ":")
        local textW, textH = surface.GetTextSize(PW_Billions.getPhrase("company") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + textH)
        surface.DrawText(LocalPlayer():getCompany():getName())

        --company funds box
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07, ScrW(), ScrH() * 0.07)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 1))
        surface.DrawText(PW_Billions.getPhrase("money") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("money") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + (ScrH() * 0.07 * 1) + textH)
        surface.DrawText(DarkRP.formatMoney(LocalPlayer():getCompany():getWallet()))

        --level box
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 2, ScrW(), ScrH() * 0.07 * 2)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 2))
        surface.DrawText(PW_Billions.getPhrase("level") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("level") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + (ScrH() * 0.07 * 2) + textH)
        surface.DrawText(LocalPlayer():getCompany():getLevel())

        --xp box
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 3, ScrW(), ScrH() * 0.07 * 3)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 3))
        surface.DrawText(PW_Billions.getPhrase("xp") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("xp") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + (ScrH() * 0.07 * 3) + textH)
        surface.DrawText(LocalPlayer():getCompany():getXP() .. " / " .. LocalPlayer():getCompany():getRequiredXP())

        --skill points box
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 4, ScrW(), ScrH() * 0.07 * 4)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 4))
        surface.DrawText(PW_Billions.getPhrase("skillPoints") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("skillPoints") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + (ScrH() * 0.07 * 4) + textH)
        surface.DrawText(LocalPlayer():getCompany():getSkillPoints())

        --employees box
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 5, ScrW(), ScrH() * 0.07 * 5)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 5))
        surface.DrawText(PW_Billions.getPhrase("employees") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("employees") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + (ScrH() * 0.07 * 5) + textH)
        surface.DrawText(LocalPlayer():getCompany():getEmployeesCount())

        --tasks
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 6, ScrW(), ScrH() * 0.07 * 6)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 6))
        surface.DrawText(PW_Billions.getPhrase("tasks"))
        surface.SetDrawColor(217, 217, 217, 50)

        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 6.5, ScrW(), ScrH() * 0.07 * 6.5)

        --loop through and display all tasks
        local count = 0
        for k,v in pairs(PW_Billions.getTasks()) do
          --task title
          surface.SetFont("PW_HUDFont2")
          surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * (count + 6.5)))
          local typeName
          if v.type == TASKS_TYPE_PRODUCTION then
            typeName = PW_Billions.getPhrase("produce")
          else
            typeName = PW_Billions.getPhrase("sell")
          end
          typeName = typeName .. " " .. PW_Billions.CRAFTABLE.WORKBENCH[k].name
          surface.DrawText(typeName)

          --reward text
          surface.SetFont("PW_HUDFont2Smallest")
          surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.03 + (ScrH() * 0.07 * (count + 6.5)))
          surface.DrawText(PW_Billions.getPhrase("reward") .. ": " .. v.xp .. " XP, " .. DarkRP.formatMoney(v.money))

          --background to the progress bar
          surface.SetDrawColor(59, 59, 69, 140)
          surface.DrawRect(ScrW() * 0.88, (ScrH() * 0.07 * (count + 1 + 6.5)) - ScrH() * 0.02, ScrW() * 0.12, ScrH() * 0.02)

          --progress bar
          if v.progressPercentage > 1 then
            surface.SetDrawColor(186, 186, 196, 255)
            surface.DrawRect(ScrW() * 0.88, (ScrH() * 0.07 * (count + 1 + 6.5)) - ScrH() * 0.02, ScrW() * 0.12, ScrH() * 0.02)
          elseif v.progressPercentage > 0 then
            surface.SetDrawColor(106, 106, 124, 255)
            surface.DrawRect(ScrW() * 0.88, (ScrH() * 0.07 * (count + 1 + 6.5)) - ScrH() * 0.02, ScrW() * 0.12 * v:getProgressPercentage(), ScrH() * 0.02)
          end

          --readable progress count
          surface.SetTextPos(ScrW() * 0.885, ((ScrH() * 0.07 * (count + 1 + 6.5)) - ScrH() * 0.02) + ScrH() * 0.0028)
          if v.progressPercentage < 1 then
            surface.DrawText(v.progress .. "/" .. v.amount)
          else
            surface.DrawText(PW_Billions.getPhrase("completed"))
          end

          --time left
          surface.SetTextPos(ScrW() * 0.945, ((ScrH() * 0.07 * (count + 1 + 6.5)) - ScrH() * 0.02) + ScrH() * 0.0028)
          surface.DrawText(PW_Billions.getPhrase("daysLeft") .. ": " .. math.Truncate(v:getDaysLeft(), 1))

          --dividing line
          if count != 0 then
            surface.SetDrawColor(217, 217, 217, 240)
            surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * (6.5 + count), ScrW(), ScrH() * 0.07 * (6.5 + count))
          end

          count = count + 1
        end
      elseif LocalPlayer():isMayor() then
        surface.SetDrawColor(30, 30, 30, 200)
        --ScrH() * 0.07 == hight of one box
        surface.DrawRect(ScrW() * 0.88, 0, ScrW() * 0.12, ScrH() * 0.07 * 3.5)

        surface.SetFont("PW_HUDFont2")
        surface.SetTextColor(217, 217, 217, 240)
        surface.SetDrawColor(217, 217, 217, 50)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005)
        surface.DrawText(PW_Billions.getPhrase("government"))
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 0.5, ScrW(), ScrH() * 0.07 * 0.5)

        surface.SetDrawColor(153, 153, 153, 240)

        --political capital
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 0.5))
        surface.DrawText(PW_Billions.getPhrase("politicalCapital") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("politicalCapital") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + (ScrH() * 0.07 * 0.5) + textH)
        surface.DrawText(PW_Billions.getPoliticalCapital())
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 1.5, ScrW(), ScrH() * 0.07 * 1.5)

        --money
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 1.5))
        surface.DrawText(PW_Billions.getPhrase("money") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("money") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + (ScrH() * 0.07 * 1.5) + textH)
        surface.DrawText(DarkRP.formatMoney(PW_Billions.getMoneyGovernment()))
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 2.5, ScrW(), ScrH() * 0.07 * 2.5)

        --online companies
        local companies = 0
        for _ in pairs(PW_Billions.Companies) do companies = companies + 1 end
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 2.5))
        surface.DrawText(PW_Billions.getPhrase("activeCompanies") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("activeCompanies") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + (ScrH() * 0.07 * 2.5) + textH)
        surface.DrawText(companies)

      end
    elseif PW_Billions.CFG.HUD_TYPE == 3 then --left

      if LocalPlayer():isCompanyOwner() or LocalPlayer():isEmployed() then

        surface.SetDrawColor(30, 30, 30, 200)
        --ScrH() * 0.07 == hight of one box
        surface.DrawRect(0, 0, ScrW() * 0.12, ScrH() * 0.07 * (PW_Billions.TasksCount + 6.5))

        surface.SetFont("PW_HUDFont2")
        surface.SetTextColor(217, 217, 217, 240)
        surface.SetDrawColor(153, 153, 153, 240)

        --company name box
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005)
        surface.DrawText(PW_Billions.getPhrase("company") .. ":")
        local textW, textH = surface.GetTextSize(PW_Billions.getPhrase("company") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + textH)
        surface.DrawText(LocalPlayer():getCompany():getName())

        --company funds box
        surface.DrawLine(0, ScrH() * 0.07, ScrW() * 0.12, ScrH() * 0.07)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 1))
        surface.DrawText(PW_Billions.getPhrase("money") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("money") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + (ScrH() * 0.07 * 1) + textH)
        surface.DrawText(DarkRP.formatMoney(LocalPlayer():getCompany():getWallet()))

        --level box
        surface.DrawLine(0, ScrH() * 0.07 * 2, ScrW() * 0.12, ScrH() * 0.07 * 2)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 2))
        surface.DrawText(PW_Billions.getPhrase("level") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("level") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + (ScrH() * 0.07 * 2) + textH)
        surface.DrawText(LocalPlayer():getCompany():getLevel())

        --xp box
        surface.DrawLine(0, ScrH() * 0.07 * 3, ScrW() * 0.12, ScrH() * 0.07 * 3)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 3))
        surface.DrawText(PW_Billions.getPhrase("xp") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("xp") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + (ScrH() * 0.07 * 3) + textH)
        surface.DrawText(LocalPlayer():getCompany():getXP() .. " / " .. LocalPlayer():getCompany():getRequiredXP())

        --skill points box
        surface.DrawLine(0, ScrH() * 0.07 * 4, ScrW() * 0.12, ScrH() * 0.07 * 4)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 4))
        surface.DrawText(PW_Billions.getPhrase("skillPoints") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("skillPoints") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + (ScrH() * 0.07 * 4) + textH)
        surface.DrawText(LocalPlayer():getCompany():getSkillPoints())

        --employees box
        surface.DrawLine(0, ScrH() * 0.07 * 5, ScrW() * 0.12, ScrH() * 0.07 * 5)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 5))
        surface.DrawText(PW_Billions.getPhrase("employees") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("employees") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + (ScrH() * 0.07 * 5) + textH)
        surface.DrawText(LocalPlayer():getCompany():getEmployeesCount())

        --tasks
        surface.DrawLine(0, ScrH() * 0.07 * 6, ScrW() * 0.12, ScrH() * 0.07 * 6)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 6))
        surface.DrawText(PW_Billions.getPhrase("tasks"))
        surface.SetDrawColor(153, 153, 153, 50)

        surface.DrawLine(0, ScrH() * 0.07 * 6.5, ScrW() * 0.12, ScrH() * 0.07 * 6.5)

        --loop through and display all tasks
        local count = 0
        for k,v in pairs(PW_Billions.getTasks()) do
          --task title
          surface.SetFont("PW_HUDFont2")
          surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * (count + 6.5)))
          local typeName
          if v.type == TASKS_TYPE_PRODUCTION then
            typeName = PW_Billions.getPhrase("produce")
          else
            typeName = PW_Billions.getPhrase("sell")
          end
          typeName = typeName .. " " .. PW_Billions.CRAFTABLE.WORKBENCH[k].name
          surface.DrawText(typeName)

          --reward text
          surface.SetFont("PW_HUDFont2Smallest")
          surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.03 + (ScrH() * 0.07 * (count + 6.5)))
          surface.DrawText(PW_Billions.getPhrase("reward") .. ": " .. v.xp .. " XP, " .. DarkRP.formatMoney(v.money))

          --background to the progress bar
          surface.SetDrawColor(59, 59, 69, 140)
          surface.DrawRect(0, (ScrH() * 0.07 * (count + 1 + 6.5)) - ScrH() * 0.02, ScrW() * 0.12, ScrH() * 0.02)

          --progress bar
          if v.progressPercentage > 1 then
            surface.SetDrawColor(186, 186, 196, 255)
            surface.DrawRect(0, (ScrH() * 0.07 * (count + 1 + 6.5)) - ScrH() * 0.02, ScrW() * 0.12, ScrH() * 0.02)
          elseif v.progressPercentage > 0 then
            surface.SetDrawColor(106, 106, 124, 255)
            surface.DrawRect(0, (ScrH() * 0.07 * (count + 1 + 6.5)) - ScrH() * 0.02, ScrW() * 0.12 * v:getProgressPercentage(), ScrH() * 0.02)
          end

          --readable progress count
          surface.SetTextPos(ScrW() * 0.005, ((ScrH() * 0.07 * (count + 1 + 6.5)) - ScrH() * 0.02) + ScrH() * 0.0028)
          if v.progressPercentage < 1 then
            surface.DrawText(v.progress .. "/" .. v.amount)
          else
            surface.DrawText(PW_Billions.getPhrase("completed"))
          end

          --time left
          surface.SetTextPos(ScrW() * 0.065, ((ScrH() * 0.07 * (count + 1 + 6.5)) - ScrH() * 0.02) + ScrH() * 0.0028)
          surface.DrawText(PW_Billions.getPhrase("daysLeft") .. ": " .. math.Truncate(v:getDaysLeft(), 1))

          --dividing line
          if count != 0 then
            surface.SetDrawColor(153, 153, 153, 240)
            surface.DrawLine(0, ScrH() * 0.07 * (6.5 + count), ScrW() * 0.12, ScrH() * 0.07 * (6.5 + count))
          end

          count = count + 1
        end
      elseif LocalPlayer():isMayor() then
        surface.SetDrawColor(30, 30, 30, 200)
        --ScrH() * 0.07 == hight of one box
        surface.DrawRect(0, 0, ScrW() * 0.12, ScrH() * 0.07 * 3.5)

        surface.SetFont("PW_HUDFont2")
        surface.SetTextColor(217, 217, 217, 240)
        surface.SetDrawColor(217, 217, 217, 50)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005)
        surface.DrawText(PW_Billions.getPhrase("government"))
        surface.DrawLine(0, ScrH() * 0.07 * 0.5, ScrW() * 0.12, ScrH() * 0.07 * 0.5)

        surface.SetDrawColor(153, 153, 153, 240)

        --political capital
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 0.5))
        surface.DrawText(PW_Billions.getPhrase("politicalCapital") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("politicalCapital") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + (ScrH() * 0.07 * 0.5) + textH)
        surface.DrawText(PW_Billions.getPoliticalCapital())
        surface.DrawLine(0, ScrH() * 0.07 * 1.5, ScrW() * 0.12, ScrH() * 0.07 * 1.5)

        --money
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 1.5))
        surface.DrawText(PW_Billions.getPhrase("money") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("money") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + (ScrH() * 0.07 * 1.5) + textH)
        surface.DrawText(DarkRP.formatMoney(PW_Billions.getMoneyGovernment()))
        surface.DrawLine(0, ScrH() * 0.07 * 2.5, ScrW() * 0.12, ScrH() * 0.07 * 2.5)

        --online companies
        local companies = 0
        for _ in pairs(PW_Billions.Companies) do companies = companies + 1 end
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 2.5))
        surface.DrawText(PW_Billions.getPhrase("activeCompanies") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("activeCompanies") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + (ScrH() * 0.07 * 2.5) + textH)
        surface.DrawText(companies)

      end
    elseif PW_Billions.CFG.HUD_TYPE == 4 then --mini left

      if LocalPlayer():isCompanyOwner() or LocalPlayer():isEmployed() then

        surface.SetDrawColor(30, 30, 30, 200)
        --ScrH() * 0.07 == hight of one box
        surface.DrawRect(0, 0, ScrW() * 0.12, ScrH() * 0.07 * (PW_Billions.TasksCount + 4.5))

        surface.SetFont("PW_HUDFont2")
        surface.SetTextColor(217, 217, 217, 240)
        surface.SetDrawColor(153, 153, 153, 240)

        --company name box
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005)
        surface.DrawText(PW_Billions.getPhrase("company") .. ":")
        local textW, textH = surface.GetTextSize(PW_Billions.getPhrase("company") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + textH)
        surface.DrawText(LocalPlayer():getCompany():getName())

        --company funds box
        surface.DrawLine(0, ScrH() * 0.07, ScrW() * 0.12, ScrH() * 0.07)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 1))
        surface.DrawText(PW_Billions.getPhrase("money") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("money") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + (ScrH() * 0.07 * 1) + textH)
        surface.DrawText(DarkRP.formatMoney(LocalPlayer():getCompany():getWallet()))

        --level box
        surface.DrawLine(0, ScrH() * 0.07 * 2, ScrW() * 0.12, ScrH() * 0.07 * 2)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 2))
        surface.DrawText(PW_Billions.getPhrase("level") .. ": " .. LocalPlayer():getCompany():getLevel())

        --xp box
        surface.DrawLine(0, ScrH() * 0.07 * 2.5, ScrW() * 0.12, ScrH() * 0.07 * 2.5)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 2.5))
        surface.DrawText(PW_Billions.getPhrase("xp") .. ": " .. LocalPlayer():getCompany():getXP() .. " / " .. LocalPlayer():getCompany():getRequiredXP())

        --skill points box
        surface.DrawLine(0, ScrH() * 0.07 * 3, ScrW() * 0.12, ScrH() * 0.07 * 3)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 3))
        surface.DrawText(PW_Billions.getPhrase("skillPoints") .. ": " .. LocalPlayer():getCompany():getSkillPoints())

        --employees box
        surface.DrawLine(0, ScrH() * 0.07 * 3.5, ScrW() * 0.12, ScrH() * 0.07 * 3.5)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 3.5))
        surface.DrawText(PW_Billions.getPhrase("employees") .. ": " .. LocalPlayer():getCompany():getEmployeesCount())

        --tasks
        surface.DrawLine(0, ScrH() * 0.07 * 4, ScrW() * 0.12, ScrH() * 0.07 * 4)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 4))
        surface.DrawText(PW_Billions.getPhrase("tasks"))
        surface.SetDrawColor(153, 153, 153, 50)

        surface.DrawLine(0, ScrH() * 0.07 * 4.5, ScrW() * 0.12, ScrH() * 0.07 * 4.5)

        --loop through and display all tasks
        local count = 0
        for k,v in pairs(PW_Billions.getTasks()) do
          --task title
          surface.SetFont("PW_HUDFont2")
          surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * (count + 4.5)))
          local typeName
          if v.type == TASKS_TYPE_PRODUCTION then
            typeName = PW_Billions.getPhrase("produce")
          else
            typeName = PW_Billions.getPhrase("sell")
          end
          typeName = typeName .. " " .. PW_Billions.CRAFTABLE.WORKBENCH[k].name
          surface.DrawText(typeName)

          --reward text
          surface.SetFont("PW_HUDFont2Smallest")
          surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.03 + (ScrH() * 0.07 * (count + 4.5)))
          surface.DrawText(PW_Billions.getPhrase("reward") .. ": " .. v.xp .. " XP, " .. DarkRP.formatMoney(v.money))

          --background to the progress bar
          surface.SetDrawColor(59, 59, 69, 140)
          surface.DrawRect(0, (ScrH() * 0.07 * (count + 1 + 4.5)) - ScrH() * 0.02, ScrW() * 0.12, ScrH() * 0.02)

          --progress bar
          if v.progressPercentage > 1 then
            surface.SetDrawColor(186, 186, 196, 255)
            surface.DrawRect(0, (ScrH() * 0.07 * (count + 1 + 4.5)) - ScrH() * 0.02, ScrW() * 0.12, ScrH() * 0.02)
          elseif v.progressPercentage > 0 then
            surface.SetDrawColor(106, 106, 124, 255)
            surface.DrawRect(0, (ScrH() * 0.07 * (count + 1 + 4.5)) - ScrH() * 0.02, ScrW() * 0.12 * v:getProgressPercentage(), ScrH() * 0.02)
          end

          --readable progress count
          surface.SetTextPos(ScrW() * 0.005, ((ScrH() * 0.07 * (count + 1 + 4.5)) - ScrH() * 0.02) + ScrH() * 0.0028)
          if v.progressPercentage < 1 then
            surface.DrawText(v.progress .. "/" .. v.amount)
          else
            surface.DrawText(PW_Billions.getPhrase("completed"))
          end

          --time left
          surface.SetTextPos(ScrW() * 0.065, ((ScrH() * 0.07 * (count + 1 + 4.5)) - ScrH() * 0.02) + ScrH() * 0.0028)
          surface.DrawText(PW_Billions.getPhrase("daysLeft") .. ": " .. math.Truncate(v:getDaysLeft(), 1))

          --dividing line
          if count != 0 then
            surface.SetDrawColor(153, 153, 153, 240)
            surface.DrawLine(0, ScrH() * 0.07 * (4.5 + count), ScrW() * 0.12, ScrH() * 0.07 * (4.5 + count))
          end

          count = count + 1
        end
      elseif LocalPlayer():isMayor() then
        surface.SetDrawColor(30, 30, 30, 200)
        --ScrH() * 0.07 == hight of one box
        surface.DrawRect(0, 0, ScrW() * 0.12, ScrH() * 0.07 * 3.5)

        surface.SetFont("PW_HUDFont2")
        surface.SetTextColor(217, 217, 217, 240)
        surface.SetDrawColor(217, 217, 217, 50)
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005)
        surface.DrawText(PW_Billions.getPhrase("government"))
        surface.DrawLine(0, ScrH() * 0.07 * 0.5, ScrW() * 0.12, ScrH() * 0.07 * 0.5)

        surface.SetDrawColor(153, 153, 153, 240)

        --political capital
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 0.5))
        surface.DrawText(PW_Billions.getPhrase("politicalCapital") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("politicalCapital") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + (ScrH() * 0.07 * 0.5) + textH)
        surface.DrawText(PW_Billions.getPoliticalCapital())
        surface.DrawLine(0, ScrH() * 0.07 * 1.5, ScrW() * 0.12, ScrH() * 0.07 * 1.5)

        --money
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 1.5))
        surface.DrawText(PW_Billions.getPhrase("money") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("money") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + (ScrH() * 0.07 * 1.5) + textH)
        surface.DrawText(DarkRP.formatMoney(PW_Billions.getMoneyGovernment()))
        surface.DrawLine(0, ScrH() * 0.07 * 2.5, ScrW() * 0.12, ScrH() * 0.07 * 2.5)

        --online companies
        local companies = 0
        for _ in pairs(PW_Billions.Companies) do companies = companies + 1 end
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.005 + (ScrH() * 0.07 * 2.5))
        surface.DrawText(PW_Billions.getPhrase("activeCompanies") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("activeCompanies") .. ":")
        surface.SetTextPos(ScrW() * 0.005, ScrH() * 0.006 + (ScrH() * 0.07 * 2.5) + textH)
        surface.DrawText(companies)

      end
    elseif PW_Billions.CFG.HUD_TYPE == 5 then --mini right
      if LocalPlayer():isCompanyOwner() or LocalPlayer():isEmployed() then

        surface.SetDrawColor(30, 30, 30, 200)
        --ScrH() * 0.07 == hight of one box
        surface.DrawRect(ScrW() * 0.88, 0, ScrW() * 0.12, ScrH() * 0.07 * (PW_Billions.TasksCount + 4.5))

        surface.SetFont("PW_HUDFont2")
        surface.SetTextColor(217, 217, 217, 240)
        surface.SetDrawColor(153, 153, 153, 240)

        --company name box
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005)
        surface.DrawText(PW_Billions.getPhrase("company") .. ":")
        local textW, textH = surface.GetTextSize(PW_Billions.getPhrase("company") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + textH)
        surface.DrawText(LocalPlayer():getCompany():getName())

        --company funds box
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07, ScrW(), ScrH() * 0.07)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 1))
        surface.DrawText(PW_Billions.getPhrase("money") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("money") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + (ScrH() * 0.07 * 1) + textH)
        surface.DrawText(DarkRP.formatMoney(LocalPlayer():getCompany():getWallet()))

        --level box
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 2, ScrW(), ScrH() * 0.07 * 2)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 2))
        surface.DrawText(PW_Billions.getPhrase("level") .. ": " .. LocalPlayer():getCompany():getLevel())

        --xp box
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 2.5, ScrW(), ScrH() * 0.07 * 2.5)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 2.5))
        surface.DrawText(PW_Billions.getPhrase("xp") .. ": " .. LocalPlayer():getCompany():getXP() .. " / " .. LocalPlayer():getCompany():getRequiredXP())

        --skill points box
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 3, ScrW(), ScrH() * 0.07 * 3)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 3))
        surface.DrawText(PW_Billions.getPhrase("skillPoints") .. ": " .. LocalPlayer():getCompany():getSkillPoints())

        --employees box
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 3.5, ScrW(), ScrH() * 0.07 * 3.5)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 3.5))
        surface.DrawText(PW_Billions.getPhrase("employees") .. ": " .. LocalPlayer():getCompany():getEmployeesCount())

        --tasks
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 4, ScrW(), ScrH() * 0.07 * 4)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 4))
        surface.DrawText(PW_Billions.getPhrase("tasks"))
        surface.SetDrawColor(217, 217, 217, 50)

        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 4.5, ScrW(), ScrH() * 0.07 * 4.5)

        --loop through and display all tasks
        local count = 0
        for k,v in pairs(PW_Billions.getTasks()) do
          --task title
          surface.SetFont("PW_HUDFont2")
          surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * (count + 4.5)))
          local typeName
          if v.type == TASKS_TYPE_PRODUCTION then
            typeName = PW_Billions.getPhrase("produce")
          else
            typeName = PW_Billions.getPhrase("sell")
          end
          typeName = typeName .. " " .. PW_Billions.CRAFTABLE.WORKBENCH[k].name
          surface.DrawText(typeName)

          --reward text
          surface.SetFont("PW_HUDFont2Smallest")
          surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.03 + (ScrH() * 0.07 * (count + 4.5)))
          surface.DrawText(PW_Billions.getPhrase("reward") .. ": " .. v.xp .. " XP, " .. DarkRP.formatMoney(v.money))

          --background to the progress bar
          surface.SetDrawColor(59, 59, 69, 140)
          surface.DrawRect(ScrW() * 0.88, (ScrH() * 0.07 * (count + 1 + 4.5)) - ScrH() * 0.02, ScrW() * 0.12, ScrH() * 0.02)

          --progress bar
          if v.progressPercentage > 1 then
            surface.SetDrawColor(186, 186, 196, 255)
            surface.DrawRect(ScrW() * 0.88, (ScrH() * 0.07 * (count + 1 + 4.5)) - ScrH() * 0.02, ScrW() * 0.12, ScrH() * 0.02)
          elseif v.progressPercentage > 0 then
            surface.SetDrawColor(106, 106, 124, 255)
            surface.DrawRect(ScrW() * 0.88, (ScrH() * 0.07 * (count + 1 + 4.5)) - ScrH() * 0.02, ScrW() * 0.12 * v:getProgressPercentage(), ScrH() * 0.02)
          end

          --readable progress count
          surface.SetTextPos(ScrW() * 0.885, ((ScrH() * 0.07 * (count + 1 + 4.5)) - ScrH() * 0.02) + ScrH() * 0.0028)
          if v.progressPercentage < 1 then
            surface.DrawText(v.progress .. "/" .. v.amount)
          else
            surface.DrawText(PW_Billions.getPhrase("completed"))
          end

          --time left
          surface.SetTextPos(ScrW() * 0.945, ((ScrH() * 0.07 * (count + 1 + 4.5)) - ScrH() * 0.02) + ScrH() * 0.0028)
          surface.DrawText(PW_Billions.getPhrase("daysLeft") .. ": " .. math.Truncate(v:getDaysLeft(), 1))

          --dividing line
          if count != 0 then
            surface.SetDrawColor(217, 217, 217, 240)
            surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * (4.5 + count), ScrW(), ScrH() * 0.07 * (4.5 + count))
          end

          count = count + 1
        end
      elseif LocalPlayer():isMayor() then
        surface.SetDrawColor(30, 30, 30, 200)
        --ScrH() * 0.07 == hight of one box
        surface.DrawRect(ScrW() * 0.88, 0, ScrW() * 0.12, ScrH() * 0.07 * 3.5)

        surface.SetFont("PW_HUDFont2")
        surface.SetTextColor(217, 217, 217, 240)
        surface.SetDrawColor(217, 217, 217, 50)
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005)
        surface.DrawText(PW_Billions.getPhrase("government"))
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 0.5, ScrW(), ScrH() * 0.07 * 0.5)

        surface.SetDrawColor(153, 153, 153, 240)

        --political capital
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 0.5))
        surface.DrawText(PW_Billions.getPhrase("politicalCapital") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("politicalCapital") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + (ScrH() * 0.07 * 0.5) + textH)
        surface.DrawText(PW_Billions.getPoliticalCapital())
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 1.5, ScrW(), ScrH() * 0.07 * 1.5)

        --money
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 1.5))
        surface.DrawText(PW_Billions.getPhrase("money") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("money") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + (ScrH() * 0.07 * 1.5) + textH)
        surface.DrawText(DarkRP.formatMoney(PW_Billions.getMoneyGovernment()))
        surface.DrawLine(ScrW() * 0.88, ScrH() * 0.07 * 2.5, ScrW(), ScrH() * 0.07 * 2.5)

        --online companies
        local companies = 0
        for _ in pairs(PW_Billions.Companies) do companies = companies + 1 end
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.005 + (ScrH() * 0.07 * 2.5))
        surface.DrawText(PW_Billions.getPhrase("activeCompanies") .. ":")
        textW, textH = surface.GetTextSize(PW_Billions.getPhrase("activeCompanies") .. ":")
        surface.SetTextPos(ScrW() * 0.885, ScrH() * 0.006 + (ScrH() * 0.07 * 2.5) + textH)
        surface.DrawText(companies)

      end
    end
  end)
end
