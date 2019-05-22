PW_Billions = PW_Billions or {}
PW_Billions.MODULE_TUTORIAL = true
--loads tutorial table
function PW_Billions.loadTutorialTable()
  sql.Query("CREATE TABLE IF NOT EXISTS pilcrow_billions_tutorials (enabled INTEGER(1) NOT NULL, shop INTEGER(1) NOT NULL, unlockable INTEGER(1) NOT NULL, bank INTEGER(1) NOT NULL, employment_create INTEGER(1) NOT NULL, employment_employees INTEGER(1) NOT NULL, employment_hire INTEGER(1) NOT NULL)")
  local tutorialData = sql.QueryRow("SELECT * FROM pilcrow_billions_tutorials", 1)
  if tutorialData then
    LocalPlayer().billionsTutorial = tobool(tutorialData.enabled)
    LocalPlayer().billionsTutorial_Shop = tobool(tutorialData.shop)
    LocalPlayer().billionsTutorial_Unlockable = tobool(tutorialData.unlockable)
    LocalPlayer().billionsTutorial_Bank = tobool(tutorialData.bank)
    LocalPlayer().billionsTutorial_EmploymentCreate = tobool(tutorialData.employment_create)
    LocalPlayer().billionsTutorial_EmploymentEmployees = tobool(tutorialData.employment_employees)
    LocalPlayer().billionsTutorial_EmploymentHire = tobool(tutorialData.employment_hire)
  end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:isTutorialEnabled(tutorialType)
  if tutorialType == "shop" then
    return LocalPlayer().billionsTutorial_Shop
  elseif tutorialType == "unlockable" then
    return LocalPlayer().billionsTutorial_Unlockable
  elseif tutorialType == "bank" then
    return LocalPlayer().billionsTutorial_Bank
  elseif tutorialType == "employmentCreate" then
    return LocalPlayer().billionsTutorial_EmploymentCreate
  elseif tutorialType == "employmentEmployees" then
    return LocalPlayer().billionsTutorial_EmploymentEmployees
  elseif tutorialType == "employmentHire" then
    return LocalPlayer().billionsTutorial_EmploymentHire
  end
  return LocalPlayer().billionsTutorial
end

function PLAYER:setTutorialEnabled(isEnabled, tutorialType)
  if tutorialType == nil then
    if isEnabled then
      sql.Query("UPDATE pilcrow_billions_tutorials SET enabled = 1")
      LocalPlayer().billionsTutorial = true
    else
      sql.Query("UPDATE pilcrow_billions_tutorials SET enabled = 0")
      LocalPlayer().billionsTutorial = false
    end
  elseif tutorialType == "shop" then
    if isEnabled then
      sql.Query("UPDATE pilcrow_billions_tutorials SET shop = 1")
      LocalPlayer().billionsTutorial_Shop = true
    else
      sql.Query("UPDATE pilcrow_billions_tutorials SET shop = 0")
      LocalPlayer().billionsTutorial_Shop = false
    end
  elseif tutorialType == "unlockable" then
    if isEnabled then
      sql.Query("UPDATE pilcrow_billions_tutorials SET unlockable = 1")
      LocalPlayer().billionsTutorial_Unlockable = true
    else
      sql.Query("UPDATE pilcrow_billions_tutorials SET unlockable = 0")
      LocalPlayer().billionsTutorial_Unlockable = false
    end
  elseif tutorialType == "bank" then
    if isEnabled then
      sql.Query("UPDATE pilcrow_billions_tutorials SET bank = 1")
      LocalPlayer().billionsTutorial_Bank = true
    else
      sql.Query("UPDATE pilcrow_billions_tutorials SET bank = 0")
      LocalPlayer().billionsTutorial_Bank = false
    end
  elseif tutorialType == "employmentCreate" then
    if isEnabled then
      sql.Query("UPDATE pilcrow_billions_tutorials SET employment_create = 1")
      LocalPlayer().billionsTutorial_EmploymentCreate = true
    else
      sql.Query("UPDATE pilcrow_billions_tutorials SET employment_create = 0")
      LocalPlayer().billionsTutorial_EmploymentCreate = false
    end
  elseif tutorialType == "employmentEmployees" then
    if isEnabled then
      sql.Query("UPDATE pilcrow_billions_tutorials SET employment_employees = 1")
      LocalPlayer().billionsTutorial_EmploymentEmployees = true
    else
      sql.Query("UPDATE pilcrow_billions_tutorials SET employment_employees = 0")
      LocalPlayer().billionsTutorial_EmploymentEmployees = false
    end
  elseif tutorialType == "employmentHire" then
    if isEnabled then
      sql.Query("UPDATE pilcrow_billions_tutorials SET employment_hire = 1")
      LocalPlayer().billionsTutorial_EmploymentHire = true
    else
      sql.Query("UPDATE pilcrow_billions_tutorials SET employment_hire = 0")
      LocalPlayer().billionsTutorial_EmploymentHire = false
    end
  end
end

--displays tutorial popup if the player did not play this mod before
function PW_Billions.displayTutorialPopup()
  local isFirstTime = sql.QueryValue("SELECT enabled FROM pilcrow_billions_tutorials", 1)
  if isFirstTime == nil then
    sql.Query("INSERT INTO pilcrow_billions_tutorials VALUES (1, 1, 1, 1, 1, 1, 1)")
    LocalPlayer().billionsTutorial_Shop = true
    LocalPlayer().billionsTutorial_Unlockable = true
    LocalPlayer().billionsTutorial_Bank = true
    LocalPlayer().billionsTutorial_EmploymentCreate = true
    LocalPlayer().billionsTutorial_EmploymentEmployees = true
    LocalPlayer().billionsTutorial_EmploymentHire = true

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Billions: Enable Tutorials")
    frame:SetSkin("Billions")
    frame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
      local confirmLabel = vgui.Create("DLabel", frame)
      confirmLabel:SetText(PW_Billions.getPhrase("tutorialNotification"))
      confirmLabel:SizeToContents()
      confirmLabel:SetContentAlignment(5)
      confirmLabel:Dock(TOP)

      local buttonPanel = vgui.Create("DPanel", frame)
      buttonPanel:SetSize(0, PW_Billions.SMALL_FRAME_H * 0.5)
      buttonPanel:Dock(BOTTOM)
        local yesButton = vgui.Create("DButton", buttonPanel)
        yesButton:SetText("YES")
        yesButton:SetWide(PW_Billions.SMALL_FRAME_W * 0.5)
        yesButton:Dock(LEFT)
        yesButton.DoClick = function()
          LocalPlayer():setTutorialEnabled(true)
          frame:Close()
        end
        local noButton = vgui.Create("DButton", buttonPanel)
        noButton:SetText("NO")
        noButton:SetWide(PW_Billions.SMALL_FRAME_W * 0.5)
        noButton:Dock(RIGHT)
        noButton.DoClick = function()
          LocalPlayer():setTutorialEnabled(false)
          frame:Close()
        end
    frame:Center()
    frame:MakePopup()
  end
end
