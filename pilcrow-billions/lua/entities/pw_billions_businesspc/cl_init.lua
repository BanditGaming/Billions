PW_Billions.getPhrase("dontShow")include("shared.lua")

local selectedPlayer = ""

--workaround for displaying shop tutorial on top of pc window
local firstOpen = true
local tutorialFrame

function ENT:Draw()
  self:DrawModel()
end

local function playerEmploymentOfferDetails()
  local frame = vgui.Create("DFrame")
    frame:SetSize(PW_Billions.FRAME_W / 2, PW_Billions.FRAME_H / 2)
    frame:SetTitle(PW_Billions.getPhrase("newEmploymentT"))
    frame:Center()
    frame:SetVisible(true)
    frame:ShowCloseButton(true)
    frame:SetSkin("Billions")

    local playerNameTextField = vgui.Create("DLabel", frame)
      playerNameTextField:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
      playerNameTextField:SetContentAlignment(5)
      playerNameTextField:Dock(TOP)
      playerNameTextField:SetText(selectedPlayer:GetName())

    local jobSelectionBox = vgui.Create("DComboBox",frame)
      jobSelectionBox:SetSize(frame:GetWide(), PW_Billions.PC_ITEMLABEL_H)
      for k, v in pairs(LocalPlayer():getCompany():getJobs()) do
        jobSelectionBox:AddChoice(k, k)
      end
      jobSelectionBox:SetValue("Select a job!")
      jobSelectionBox:Center()

    local sendOfferButton = vgui.Create("DButton", frame)
      sendOfferButton:SetSize(0, PW_Billions.BUTTON_H)
      sendOfferButton:SetText(PW_Billions.getPhrase("sendEmployment"))
      sendOfferButton:Dock(BOTTOM)
      sendOfferButton.DoClick = function()
        local _, chosenJob = jobSelectionBox:GetSelected()
        if IsValid(selectedPlayer) and selectedPlayer:IsPlayer() and chosenJob then
          LocalPlayer():getCompany():sendEmploymentOffer(selectedPlayer, chosenJob)
          frame:Close()
        end
      end

  frame:MakePopup()
end


--[[      TABS CODE     ]]--

local function getShopTab()
  local itemClass = ""

  local shop = vgui.Create("DPanel")
    if LocalPlayer():isCompanyOwner() or LocalPlayer():isEmployed() and LocalPlayer():canAddMoney() then
      local list = vgui.Create("DCategoryList", shop)
      list:SetSize(PW_Billions.PC_LIST_W, 0)
      list:Dock(LEFT)
      local itemPanel = vgui.Create("DPanel", shop)
      itemPanel:Dock(FILL)
      local itemLabel = vgui.Create("DLabel",itemPanel)
      itemLabel:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
      itemLabel:Dock(TOP)
      itemLabel:SetContentAlignment(5)
      itemLabel:SetFont("FrameTitleFont")
      itemLabel:SetText(PW_Billions.getPhrase("chooseItem"))
      local itemDesc = vgui.Create("DLabel", itemPanel)
      itemDesc:SetSize(0, PW_Billions.PC_ITEMDESC_H)
      itemDesc:Dock(TOP)
      itemDesc:SetContentAlignment(5)
      itemDesc:SetVisible(false)
      itemDesc:SetFont("FrameTitleFontSmall")
      local itemBuy2 = vgui.Create("DButton", itemPanel)
      itemBuy2:SetSize(0, PW_Billions.BUTTON_H)
      itemBuy2:Dock(BOTTOM)
      itemBuy2:SetVisible(false)
      itemBuy2.DoClick = function()
        net.Start("PW_Billions_BuyItem")
        net.WriteString(itemClass)
        net.WriteInt(5, 4)
        net.SendToServer()
      end
      local itemBuy = vgui.Create("DButton", itemPanel)
      itemBuy:SetSize(0, PW_Billions.BUTTON_H)
      itemBuy:Dock(BOTTOM)
      itemBuy:SetVisible(false)
      itemBuy.DoClick = function()
        net.Start("PW_Billions_BuyItem")
        net.WriteString(itemClass)
        net.WriteInt(1, 4)
        net.SendToServer()
      end
      local itemIcon = vgui.Create("DModelPanel", itemPanel)
      itemIcon:Dock(FILL)
      itemIcon:SetLookAt( Vector( 0, 0, 0 ) )
      itemIcon:SetSelectable(false)
      itemIcon:SetVisible(false)

        local generalItems = list:Add(PW_Billions.getPhrase("generalItems"))
        --local electronics = list:Add("Electronics Production")
        local tools = list:Add(PW_Billions.getPhrase("tools"))
        --local food = list:Add("Food Production")
        local other = list:Add(PW_Billions.getPhrase("other"))

        local items = {}
          for k,v in pairs(PW_Billions.PC_BUYITEMS) do
            if v.category == "GENERAL" then
              items[k] = generalItems:Add(v.name)
            --elseif v.category == "ELECTRONICS" then
            --  items[k] = electronics:Add(v.name)
            elseif v.category == "TOOLS" then
              items[k] = tools:Add(v.name)
            --elseif v.category == "FOOD" then
            --  items[k] = food:Add(v.name)
            else
              items[k] = other:Add(v.name)
            end

            items[k].DoClick = function()
              itemLabel:SetText(v.name)
              itemDesc:SetText(v.description)
              itemDesc:SetVisible(true)
              itemBuy:SetText(PW_Billions.getPhrase("buyFor") .. " " .. DarkRP.formatMoney(v.price))
              itemBuy:SetVisible(true)
              itemBuy2:SetText(PW_Billions.getPhrase("buy5For") .. " " .. DarkRP.formatMoney(v.price * 5))
              itemBuy2:SetVisible(true)
              itemIcon:SetVisible(true)
              itemIcon:SetModel(v.model)
              itemClass = v.class
            end
          end
    else
      local noPermissionLabel = vgui.Create("DLabel", shop)
      noPermissionLabel:SetText(PW_Billions.getPhrase("noPermission"))
      noPermissionLabel:SetFont("FrameTitleFont")
      noPermissionLabel:SetContentAlignment(5)
      noPermissionLabel:Dock(FILL)
    end


  return shop
end

local function getLevelTab()
  local itemClass = ""

  local levelTab = vgui.Create("DPropertySheet")
    if LocalPlayer():isCompanyOwner() then
      --unlock new production items
      local unlockableProduction = vgui.Create("DPanel", levelTab)
        local itemPanel = vgui.Create("DPanel", unlockableProduction)
          itemPanel:Dock(FILL)
        local itemLabel = vgui.Create("DLabel",itemPanel)
          itemLabel:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
          itemLabel:Dock(TOP)
          itemLabel:SetContentAlignment(5)
          itemLabel:SetText(PW_Billions.getPhrase("chooseItem"))
          itemLabel:SetFont("FrameTitleFont")
        local unlockItemButton = vgui.Create("DButton", itemPanel)
          unlockItemButton:SetSize(0, PW_Billions.BUTTON_H)
          unlockItemButton:Dock(BOTTOM)
          unlockItemButton:SetVisible(false)
        local itemIcon = vgui.Create("DModelPanel", itemPanel)
          itemIcon:Dock(FILL)
          itemIcon:SetLookAt( Vector( 0, 0, 0 ) )
          itemIcon:SetSelectable(false)
          itemIcon:SetVisible(false)

        local itemDetailsListView = vgui.Create("DListView", unlockableProduction)
          itemDetailsListView:SetSize(PW_Billions.PC_LIST_W, 0)
          itemDetailsListView:Dock(RIGHT)
          itemDetailsListView:AddColumn("")
          itemDetailsListView:AddColumn("Value")

        local levelList = vgui.Create("DCategoryList", unlockableProduction)
          levelList:SetSize(PW_Billions.PC_LIST_W, 0)
          levelList:Dock(LEFT)

          local category0 = levelList:Add("0-4")
            for k,v in pairs(PW_Billions.CRAFTABLE.WORKBENCH) do
              if v.needBlueprint and v.level <= 4 then
                local item = category0:Add(v.name)
                item.DoClick = function()
                  itemLabel:SetText(v.name)
                  unlockItemButton:SetVisible(true)
                  if LocalPlayer():getCompany():canProduce(k) then
                    unlockItemButton:SetText(PW_Billions.getPhrase("alreadyUnlocked"))
                    unlockItemButton:SetEnabled(false)
                  elseif LocalPlayer():getCompany():getLevel() < v.level then
                    unlockItemButton:SetText(PW_Billions.getPhrase("levelTooLow"))
                    unlockItemButton:SetEnabled(false)
                  elseif LocalPlayer():getCompany():getSkillPoints() < v.blueprintCost then
                    unlockItemButton:SetText(PW_Billions.getPhrase("notEnoughSP"))
                    unlockItemButton:SetEnabled(false)
                  else
                    unlockItemButton:SetText(PW_Billions.getPhrase("unlock"))
                    unlockItemButton:SetEnabled(true)
                  end
                  if v.model then
                    itemIcon:SetVisible(true)
                    itemIcon:SetModel(v.model)
                  --try to get model from already existing entity if it was not set in config
                  elseif ents.FindByClass(v.class)[1] then
                    itemIcon:SetVisible(true)
                    itemIcon:SetModel(ents.FindByClass(v.class)[1]:GetModel())
                  else
                    itemIcon:SetVisible(false)
                  end
                  itemDetailsListView:Clear()
                  itemDetailsListView:AddLine(PW_Billions.getPhrase("level"), v.level)
                  itemDetailsListView:AddLine(PW_Billions.getPhrase("skillPoints"), v.blueprintCost)
                  itemDetailsListView:AddLine(PW_Billions.getPhrase("sellPrice"), DarkRP.formatMoney(v.price))
                  itemDetailsListView:AddLine(PW_Billions.getPhrase("craftingDifficulty"), v.craftingDifficulty)
                  itemDetailsListView:AddLine("", "")
                  itemDetailsListView:AddLine(PW_Billions.getPhrase("electronics"), v.electronicsAmount)
                  itemDetailsListView:AddLine(PW_Billions.getPhrase("gears"), v.gearsAmount)
                  itemDetailsListView:AddLine(PW_Billions.getPhrase("gunpowder"), v.gunpowderAmount)
                  itemDetailsListView:AddLine(PW_Billions.getPhrase("metal"), v.metalAmount)
                  itemDetailsListView:AddLine(PW_Billions.getPhrase("plastic"), v.plasticAmount)
                  itemDetailsListView:AddLine(PW_Billions.getPhrase("wood"), v.woodAmount)
                  itemClass = v.class
                end
              end
            end

          local category5 = levelList:Add("5-9")
          for k,v in pairs(PW_Billions.CRAFTABLE.WORKBENCH) do
            if v.needBlueprint and v.level >= 5 and v.level <= 9 then
              local item = category5:Add(v.name)
              item.DoClick = function()
                itemLabel:SetText(v.name)
                unlockItemButton:SetVisible(true)
                if LocalPlayer():getCompany():canProduce(k) then
                  unlockItemButton:SetText(PW_Billions.getPhrase("alreadyUnlocked"))
                  unlockItemButton:SetEnabled(false)
                elseif LocalPlayer():getCompany():getLevel() < v.level then
                  unlockItemButton:SetText(PW_Billions.getPhrase("levelTooLow"))
                  unlockItemButton:SetEnabled(false)
                elseif LocalPlayer():getCompany():getSkillPoints() < v.blueprintCost then
                  unlockItemButton:SetText(PW_Billions.getPhrase("notEnoughSP"))
                  unlockItemButton:SetEnabled(false)
                else
                  unlockItemButton:SetText(PW_Billions.getPhrase("unlock"))
                  unlockItemButton:SetEnabled(true)
                end
                if v.model then
                  itemIcon:SetVisible(true)
                  itemIcon:SetModel(v.model)
                else
                  itemIcon:SetVisible(false)
                end
                itemDetailsListView:Clear()
                itemDetailsListView:AddLine(PW_Billions.getPhrase("level"), v.level)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("skillPoints"), v.blueprintCost)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("sellPrice"), DarkRP.formatMoney(v.price))
                itemDetailsListView:AddLine(PW_Billions.getPhrase("craftingDifficulty"), v.craftingDifficulty)
                itemDetailsListView:AddLine("", "")
                itemDetailsListView:AddLine(PW_Billions.getPhrase("electronics"), v.electronicsAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("gears"), v.gearsAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("gunpowder"), v.gunpowderAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("metal"), v.metalAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("plastic"), v.plasticAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("wood"), v.woodAmount)
                itemClass = v.class
              end
            end
          end

          local category10 = levelList:Add("10-19")
          for k,v in pairs(PW_Billions.CRAFTABLE.WORKBENCH) do
            if v.needBlueprint and v.level >= 10 and v.level <= 19 then
              local item = category10:Add(v.name)
              item.DoClick = function()
                itemLabel:SetText(v.name)
                unlockItemButton:SetVisible(true)
                if LocalPlayer():getCompany():canProduce(k) then
                  unlockItemButton:SetText(PW_Billions.getPhrase("alreadyUnlocked"))
                  unlockItemButton:SetEnabled(false)
                elseif LocalPlayer():getCompany():getLevel() < v.level then
                  unlockItemButton:SetText(PW_Billions.getPhrase("levelTooLow"))
                  unlockItemButton:SetEnabled(false)
                elseif LocalPlayer():getCompany():getSkillPoints() < v.blueprintCost then
                  unlockItemButton:SetText(PW_Billions.getPhrase("notEnoughSP"))
                  unlockItemButton:SetEnabled(false)
                else
                  unlockItemButton:SetText(PW_Billions.getPhrase("unlock"))
                  unlockItemButton:SetEnabled(true)
                end
                if v.model then
                  itemIcon:SetVisible(true)
                  itemIcon:SetModel(v.model)
                else
                  itemIcon:SetVisible(false)
                end
                itemDetailsListView:Clear()
                itemDetailsListView:AddLine(PW_Billions.getPhrase("level"), v.level)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("skillPoints"), v.blueprintCost)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("sellPrice"), DarkRP.formatMoney(v.price))
                itemDetailsListView:AddLine(PW_Billions.getPhrase("craftingDifficulty"), v.craftingDifficulty)
                itemDetailsListView:AddLine("", "")
                itemDetailsListView:AddLine(PW_Billions.getPhrase("electronics"), v.electronicsAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("gears"), v.gearsAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("gunpowder"), v.gunpowderAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("metal"), v.metalAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("plastic"), v.plasticAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("wood"), v.woodAmount)
                itemClass = v.class
              end
            end
          end

          local category20 = levelList:Add("20-29")
          for k,v in pairs(PW_Billions.CRAFTABLE.WORKBENCH) do
            if v.needBlueprint and v.level >= 20 and v.level <= 29 then
              local item = category20:Add(v.name)
              item.DoClick = function()
                itemLabel:SetText(v.name)
                unlockItemButton:SetVisible(true)
                if LocalPlayer():getCompany():canProduce(k) then
                  unlockItemButton:SetText(PW_Billions.getPhrase("alreadyUnlocked"))
                  unlockItemButton:SetEnabled(false)
                elseif LocalPlayer():getCompany():getLevel() < v.level then
                  unlockItemButton:SetText(PW_Billions.getPhrase("levelTooLow"))
                  unlockItemButton:SetEnabled(false)
                elseif LocalPlayer():getCompany():getSkillPoints() < v.blueprintCost then
                  unlockItemButton:SetText(PW_Billions.getPhrase("notEnoughSP"))
                  unlockItemButton:SetEnabled(false)
                else
                  unlockItemButton:SetText(PW_Billions.getPhrase("unlock"))
                  unlockItemButton:SetEnabled(true)
                end
                if v.model then
                  itemIcon:SetVisible(true)
                  itemIcon:SetModel(v.model)
                else
                  itemIcon:SetVisible(false)
                end
                itemDetailsListView:Clear()
                itemDetailsListView:AddLine(PW_Billions.getPhrase("level"), v.level)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("skillPoints"), v.blueprintCost)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("sellPrice"), DarkRP.formatMoney(v.price))
                itemDetailsListView:AddLine(PW_Billions.getPhrase("craftingDifficulty"), v.craftingDifficulty)
                itemDetailsListView:AddLine("", "")
                itemDetailsListView:AddLine(PW_Billions.getPhrase("electronics"), v.electronicsAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("gears"), v.gearsAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("gunpowder"), v.gunpowderAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("metal"), v.metalAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("plastic"), v.plasticAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("wood"), v.woodAmount)
                itemClass = v.class
              end
            end
          end

          local category30 = levelList:Add("30-39")
          for k,v in pairs(PW_Billions.CRAFTABLE.WORKBENCH) do
            if v.needBlueprint and v.level >= 30 and v.level <= 39 then
              local item = category30:Add(v.name)
              item.DoClick = function()
                itemLabel:SetText(v.name)
                unlockItemButton:SetVisible(true)
                if LocalPlayer():getCompany():canProduce(k) then
                  unlockItemButton:SetText(PW_Billions.getPhrase("alreadyUnlocked"))
                  unlockItemButton:SetEnabled(false)
                elseif LocalPlayer():getCompany():getLevel() < v.level then
                  unlockItemButton:SetText(PW_Billions.getPhrase("levelTooLow"))
                  unlockItemButton:SetEnabled(false)
                elseif LocalPlayer():getCompany():getSkillPoints() < v.blueprintCost then
                  unlockItemButton:SetText(PW_Billions.getPhrase("notEnoughSP"))
                  unlockItemButton:SetEnabled(false)
                else
                  unlockItemButton:SetText(PW_Billions.getPhrase("unlock"))
                  unlockItemButton:SetEnabled(true)
                end
                if v.model then
                  itemIcon:SetVisible(true)
                  itemIcon:SetModel(v.model)
                else
                  itemIcon:SetVisible(false)
                end
                itemDetailsListView:Clear()
                itemDetailsListView:AddLine(PW_Billions.getPhrase("level"), v.level)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("skillPoints"), v.blueprintCost)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("sellPrice"), DarkRP.formatMoney(v.price))
                itemDetailsListView:AddLine(PW_Billions.getPhrase("craftingDifficulty"), v.craftingDifficulty)
                itemDetailsListView:AddLine("", "")
                itemDetailsListView:AddLine(PW_Billions.getPhrase("electronics"), v.electronicsAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("gears"), v.gearsAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("gunpowder"), v.gunpowderAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("metal"), v.metalAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("plastic"), v.plasticAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("wood"), v.woodAmount)
                itemClass = v.class
              end
            end
          end

          local category40 = levelList:Add("40-49")
          for k,v in pairs(PW_Billions.CRAFTABLE.WORKBENCH) do
            if v.needBlueprint and v.level >= 40 and v.level <= 49 then
              local item = category40:Add(v.name)
              item.DoClick = function()
                itemLabel:SetText(v.name)
                unlockItemButton:SetVisible(true)
                if LocalPlayer():getCompany():canProduce(k) then
                  unlockItemButton:SetText(PW_Billions.getPhrase("alreadyUnlocked"))
                  unlockItemButton:SetEnabled(false)
                elseif LocalPlayer():getCompany():getLevel() < v.level then
                  unlockItemButton:SetText(PW_Billions.getPhrase("levelTooLow"))
                  unlockItemButton:SetEnabled(false)
                elseif LocalPlayer():getCompany():getSkillPoints() < v.blueprintCost then
                  unlockItemButton:SetText(PW_Billions.getPhrase("notEnoughSP"))
                  unlockItemButton:SetEnabled(false)
                else
                  unlockItemButton:SetText(PW_Billions.getPhrase("unlock"))
                  unlockItemButton:SetEnabled(true)
                end
                if v.model then
                  itemIcon:SetVisible(true)
                  itemIcon:SetModel(v.model)
                else
                  itemIcon:SetVisible(false)
                end
                itemDetailsListView:Clear()
                itemDetailsListView:AddLine(PW_Billions.getPhrase("level"), v.level)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("skillPoints"), v.blueprintCost)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("sellPrice"), DarkRP.formatMoney(v.price))
                itemDetailsListView:AddLine(PW_Billions.getPhrase("craftingDifficulty"), v.craftingDifficulty)
                itemDetailsListView:AddLine("", "")
                itemDetailsListView:AddLine(PW_Billions.getPhrase("electronics"), v.electronicsAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("gears"), v.gearsAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("gunpowder"), v.gunpowderAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("metal"), v.metalAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("plastic"), v.plasticAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("wood"), v.woodAmount)
                itemClass = v.class
              end
            end
          end

          local category50 = levelList:Add("50+")
          for k,v in pairs(PW_Billions.CRAFTABLE.WORKBENCH) do
            if v.needBlueprint and v.level >= 50 then
              local item = category50:Add(v.name)
              item.DoClick = function()
                itemLabel:SetText(v.name)
                unlockItemButton:SetVisible(true)
                if LocalPlayer():getCompany():canProduce(k) then
                  unlockItemButton:SetText(PW_Billions.getPhrase("alreadyUnlocked"))
                  unlockItemButton:SetEnabled(false)
                elseif LocalPlayer():getCompany():getLevel() < v.level then
                  unlockItemButton:SetText(PW_Billions.getPhrase("levelTooLow"))
                  unlockItemButton:SetEnabled(false)
                elseif LocalPlayer():getCompany():getSkillPoints() < v.blueprintCost then
                  unlockItemButton:SetText(PW_Billions.getPhrase("notEnoughSP"))
                  unlockItemButton:SetEnabled(false)
                else
                  unlockItemButton:SetText(PW_Billions.getPhrase("unlock"))
                  unlockItemButton:SetEnabled(true)
                end
                if v.model then
                  itemIcon:SetVisible(true)
                  itemIcon:SetModel(v.model)
                else
                  itemIcon:SetVisible(false)
                end
                itemDetailsListView:Clear()
                itemDetailsListView:AddLine(PW_Billions.getPhrase("level"), v.level)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("skillPoints"), v.blueprintCost)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("sellPrice"), DarkRP.formatMoney(v.price))
                itemDetailsListView:AddLine(PW_Billions.getPhrase("craftingDifficulty"), v.craftingDifficulty)
                itemDetailsListView:AddLine("", "")
                itemDetailsListView:AddLine(PW_Billions.getPhrase("electronics"), v.electronicsAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("gears"), v.gearsAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("gunpowder"), v.gunpowderAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("metal"), v.metalAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("plastic"), v.plasticAmount)
                itemDetailsListView:AddLine(PW_Billions.getPhrase("wood"), v.woodAmount)
                itemClass = v.class
              end
            end
          end

          unlockItemButton.DoClick = function()
            if itemClass then
              LocalPlayer():getCompany():addBlueprint(itemClass)
              --addUnlockables()
              unlockItemButton:SetText(PW_Billions.getPhrase("alreadyUnlocked"))
              unlockItemButton:SetEnabled(false)
            end
          end
      --other stuff to unlock
      local unlockableOther = vgui.Create("DPanel", levelTab)
        local unlockableOtherLabel = vgui.Create("DLabel", unlockableOther)
          unlockableOtherLabel:SetText(PW_Billions.getPhrase("comingSoon"))
          unlockableOtherLabel:SetContentAlignment(5)
          unlockableOtherLabel:Dock(FILL)

    levelTab:AddSheet("Production", unlockableProduction)
    levelTab:AddSheet("Other", unlockableOther)

  else
    local noPermissionPanel = vgui.Create("DPanel", levelTab)
      noPermissionPanel:Dock(FILL)
      local noPermissionLabel = vgui.Create("DLabel", noPermissionPanel)
        noPermissionLabel:SetText(PW_Billions.getPhrase("noPermission"))
        noPermissionLabel:SetFont("FrameTitleFont")
        noPermissionLabel:SetContentAlignment(5)
        noPermissionLabel:Dock(FILL)
  end

  return levelTab
end

local function getBankTab()
  local selectionType = ""
  local selectedName = ""
  local selectedPlayerOrCompany

  local bankSheet = vgui.Create("DPropertySheet")

    local bankDetailsSheet = vgui.Create("DPanel", bankSheet)
      if LocalPlayer():isCompanyOwner() or LocalPlayer():isEmployed() and LocalPlayer():canAddMoney() then
        local nameLabel = vgui.Create("DLabel", bankDetailsSheet)
        nameLabel:SetText(LocalPlayer():getCompany():getName())
        nameLabel:SetFont("FrameTitleFont")
        nameLabel:SetContentAlignment(5)
        nameLabel:SetSize(0, PW_Billions.PC_ITEMLABEL_H * 2)
        nameLabel:Dock(TOP)

        local idLabel = vgui.Create("DLabel", bankDetailsSheet)
        idLabel:SetText(PW_Billions.getPhrase("id") .. ": " .. LocalPlayer():getOwnerSid64())
        idLabel:SetFont("FrameTitleFontSmall")
        idLabel:SetContentAlignment(5)
        idLabel:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
        idLabel:Dock(TOP)

        local localCompanyWalletLabel = vgui.Create("DLabel", bankDetailsSheet)
        localCompanyWalletLabel:SetText(PW_Billions.getPhrase("money") .. ": " .. DarkRP.formatMoney(LocalPlayer():getCompany():getWallet()))
        localCompanyWalletLabel:SetFont("FrameTitleFontSmall")
        localCompanyWalletLabel:SetContentAlignment(5)
        localCompanyWalletLabel:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
        localCompanyWalletLabel:Dock(TOP)

        local sendButton = vgui.Create("DButton", bankDetailsSheet)
          sendButton:SetText(PW_Billions.getPhrase("depositMoney"))
          sendButton:SetSize(0, PW_Billions.BUTTON_H * 1.5)
          sendButton:Dock(BOTTOM)
          if !LocalPlayer():isCompanyOwner() then
            sendButton:SetEnabled(false)
          end

        local amountPanel = vgui.Create("DPanel", bankDetailsSheet)
          amountPanel:SetSize(0, PW_Billions.PC_ITEMLABEL_H * 1.5)
          amountPanel:Dock(BOTTOM)
            local amountInfoText = vgui.Create("DLabel", amountPanel)
              amountInfoText:SetText(PW_Billions.getPhrase("amount") .. ": ")
              amountInfoText:SetFont("FrameTextFont")
              amountInfoText:Dock(LEFT)
            local amountNumberWang = vgui.Create("DNumberWang", amountPanel)
              amountNumberWang:SetFont("FrameTextFont")
              amountNumberWang:SetNumeric(true)
              amountNumberWang:SetMin(1)
              amountNumberWang:Dock(FILL)

        local depositLabel = vgui.Create("DLabel", bankDetailsSheet)
          depositLabel:SetText(PW_Billions.getPhrase("depositMoney"))
          depositLabel:SetFont("FrameTitleFontSmall")
          depositLabel:SetContentAlignment(5)
          depositLabel:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
          depositLabel:Dock(BOTTOM)

          sendButton.DoClick = function()
            LocalPlayer():getCompany():depositMoney(amountNumberWang:GetValue())
          end
        hook.Add("PW_Billions_Company_AddMoney", "PW_Billions_VGUI_RefreshCompanyWallet", function(company, amount, currentWallet)
          if company == LocalPlayer():getCompany() then
            localCompanyWalletLabel:SetText(PW_Billions.getPhrase("money") .. ": " .. DarkRP.formatMoney(LocalPlayer():getCompany():getWallet()))
          end
        end)

        --[[
        local bankHistoryList = vgui.Create("DListView", bankDetailsSheet)
        bankHistoryList:SetMultiSelect(false)
        bankHistoryList:AddColumn("Sender")
        bankHistoryList:AddColumn("Receiver")
        bankHistoryList:AddColumn("Transaction type")
        bankHistoryList:AddColumn("Amount")
        bankHistoryList:AddColumn("Title")
        bankHistoryList:AddColumn("Date/Time of transaction")
        bankHistoryList:SetVisible(true)
        bankHistoryList:Dock(FILL)
        ]]
      else
        local noPermissionLabel = vgui.Create("DLabel", bankDetailsSheet)
        noPermissionLabel:SetText(PW_Billions.getPhrase("noPermission"))
        noPermissionLabel:SetFont("FrameTitleFont")
        noPermissionLabel:SetContentAlignment(5)
        noPermissionLabel:Dock(FILL)
      end

    local sendTransferSheet = vgui.Create("DPanel", bankSheet)
      if LocalPlayer():isCompanyOwner() or LocalPlayer():isEmployed() and LocalPlayer():canAddMoney() then

          local companiesList = vgui.Create("DCategoryList", sendTransferSheet)

          local companiesCategory = companiesList:Add("Companies")
            companiesCategory:SetExpanded(true)
            companiesList:Dock(LEFT)
            companiesList:SetSize(PW_Billions.PC_LIST_W, 0)

          local playersCategory = companiesList:Add("Players")
            playersCategory:SetExpanded(true)

          local nameLabel = vgui.Create("DLabel", sendTransferSheet)
            nameLabel:SetContentAlignment(5)
            nameLabel:SetText(PW_Billions.getPhrase("name"))
            nameLabel:SetFont("FrameTitleFont")
            nameLabel:SetSize(0, PW_Billions.PC_ITEMLABEL_H * 2)
            nameLabel:SetVisible(false)
            nameLabel:Dock(TOP)

          local sid64Label = vgui.Create("DLabel", sendTransferSheet)
            sid64Label:SetContentAlignment(5)
            sid64Label:SetText("SteamID64")
            sid64Label:SetFont("FrameTitleFontSmall")
            sid64Label:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
            sid64Label:SetVisible(false)
            sid64Label:Dock(TOP)

          local levelLabel = vgui.Create("DLabel", sendTransferSheet)
            levelLabel:SetFont("FrameTitleFontSmall")
            levelLabel:SetContentAlignment(5)
            levelLabel:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
            levelLabel:SetVisible(false)
            levelLabel:Dock(TOP)

          local walletLabel = vgui.Create("DLabel", sendTransferSheet)
            walletLabel:SetFont("FrameTitleFontSmall")
            walletLabel:SetContentAlignment(5)
            walletLabel:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
            walletLabel:SetVisible(false)
            walletLabel:Dock(TOP)

          local sendButton = vgui.Create("DButton", sendTransferSheet)
            sendButton:SetSize(0, PW_Billions.BUTTON_H * 1.5)
            sendButton:SetText("Send Transfer")
            sendButton:Dock(BOTTOM)
            sendButton:SetVisible(false)

          local amountPanel = vgui.Create("DPanel", sendTransferSheet)
            amountPanel:SetSize(0, PW_Billions.PC_ITEMLABEL_H * 1.5)
            amountPanel:SetVisible(false)
            amountPanel:Dock(TOP)
              local amountInfoText = vgui.Create("DLabel", amountPanel)
                amountInfoText:SetText(PW_Billions.getPhrase("amount") .. ": ")
                amountInfoText:SetFont("FrameTextFont")
                amountInfoText:Dock(LEFT)
              local amount = vgui.Create("DNumberWang", amountPanel)
                amount:SetFont("FrameTextFont")
                amount:SetNumeric(true)
                amount:SetMin(1)
                amount:Dock(FILL)

          local transferTitle = vgui.Create("DTextEntry", sendTransferSheet)
            transferTitle:SetVisible(false)
            transferTitle:SetSize(0, PW_Billions.PC_ITEMLABEL_H * 2)
            transferTitle:SetPlaceholderText(PW_Billions.getPhrase("transferTitle"))
            transferTitle:SetFont("FrameTextFont")
            transferTitle:SetContentAlignment(5)
            transferTitle:Dock(TOP)

          --Transaction confirmation window
          sendButton.DoClick = function()
            if amount:GetValue() > 0 then
              local confirmWindow = vgui.Create("DFrame")
              confirmWindow:SetSkin("Billions")
              confirmWindow:SetTitle(PW_Billions.getPhrase("sendTransferT"))
              confirmWindow:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
                local confirmLabel = vgui.Create("DLabel", confirmWindow)
                confirmLabel:SetText(PW_Billions.getPhrase("transferConfirm"))
                confirmLabel:SetFont("FrameTitleFont")
                confirmLabel:SetContentAlignment(5)
                confirmLabel:Dock(TOP)
                local nameConfirmLabel = vgui.Create("DLabel", confirmWindow)
                nameConfirmLabel:SetText(PW_Billions.getPhrase("To") .. ": " .. selectedName)
                nameConfirmLabel:SetFont("FrameTitleFontSmall")
                nameConfirmLabel:SetContentAlignment(5)
                nameConfirmLabel:Dock(TOP)
                local amountConfirmLabel = vgui.Create("DLabel", confirmWindow)
                amountConfirmLabel:SetText(PW_Billions.getPhrase("amount") .. ": " .. DarkRP.formatMoney(amount:GetValue()))
                amountConfirmLabel:SetFont("FrameTitleFontSmall")
                amountConfirmLabel:SetContentAlignment(5)
                amountConfirmLabel:Dock(TOP)
                if PW_Billions.CFG.TAX_ENABLED and selectionType == "player" then
                  local amountAfterTaxConfirmLabel = vgui.Create("DLabel", confirmWindow)
                  amountAfterTaxConfirmLabel:SetText(PW_Billions.getPhrase("amountAfterTax") .. ": " .. DarkRP.formatMoney(math.floor(amount:GetValue() - amount:GetValue() * PW_Billions.CFG.TAX[TAX_WITHDRAW].amount)))
                  amountAfterTaxConfirmLabel:SetFont("FrameTitleFontSmall")
                  amountAfterTaxConfirmLabel:SetContentAlignment(5)
                  amountAfterTaxConfirmLabel:Dock(TOP)
                end
                local titleConfirmLabel = vgui.Create("DLabel", confirmWindow)
                titleConfirmLabel:SetText(PW_Billions.getPhrase("title") .. ": " .. transferTitle:GetValue())
                titleConfirmLabel:SetFont("FrameTextFont")
                titleConfirmLabel:SetContentAlignment(5)
                titleConfirmLabel:Dock(TOP)
                local buttonPanel = vgui.Create("DPanel", confirmWindow)
                buttonPanel:Dock(FILL)
                  local yesButton = vgui.Create("DButton", buttonPanel)
                  yesButton:SetText(PW_Billions.getPhrase("yes"))
                  yesButton:SetWide(PW_Billions.SMALL_FRAME_W * 0.5)
                  yesButton:Dock(LEFT)
                  yesButton.DoClick = function()
                    if selectionType == "company" then
                      LocalPlayer():getCompany():sendMoney(selectedPlayerOrCompany:getOwnerSid64(), amount:GetValue(), transferTitle:GetValue())
                    elseif selectionType == "player" then
                      LocalPlayer():getCompany():withdrawMoney(selectedPlayerOrCompany, amount:GetValue(), transferTitle:GetValue())
                    end
                    confirmWindow:Close()
                  end
                  local noButton = vgui.Create("DButton", buttonPanel)
                  noButton:SetText(PW_Billions.getPhrase("no"))
                  noButton:SetWide(PW_Billions.SMALL_FRAME_W * 0.5)
                  noButton:Dock(RIGHT)
                  noButton.DoClick = function()
                    confirmWindow:Close()
                  end

              confirmWindow:Center()
              confirmWindow:MakePopup()
            end
          end

          local infoText = vgui.Create("DLabel", sendTransferSheet)
          infoText:SetText(PW_Billions.getPhrase("infoTransfer"))
          infoText:SetContentAlignment(5)
          infoText:Dock(FILL)

          for k, v in pairs(PW_Billions.Companies) do
            if v != LocalPlayer():getCompany() then
              local button = companiesCategory:Add(v:getName())
              button.DoClick = function()
                infoText:SetVisible(false)
                nameLabel:SetText(v:getName())
                if v:getOwner() then
                  sid64Label:SetText(PW_Billions.getPhrase("owner") .. ": " .. v:getOwner():GetName() .. "         SteamID64: " .. v:getOwnerSid64())
                else
                  sid64Label:SetText(PW_Billions.getPhrase("owner") .. ": OFFLINE         SteamID64: " .. v:getOwnerSid64())
                end
                levelLabel:SetText(PW_Billions.getPhrase("level") .. ": " .. v:getLevel())
                walletLabel:SetText(PW_Billions.getPhrase("bank") .. ": " .. DarkRP.formatMoney(v:getWallet()))
                nameLabel:SetVisible(true)
                sid64Label:SetVisible(true)
                levelLabel:SetVisible(true)
                walletLabel:SetVisible(true)
                sendButton:SetVisible(true)
                amountPanel:SetVisible(true)
                transferTitle:SetVisible(true)
                selectionType = "company"
                selectedName = v:getName()
                selectedPlayerOrCompany = v
              end
            end
          end
          for k, v in pairs(player.GetAll()) do
            local button = playersCategory:Add(v:GetName())
            button.DoClick = function()
              infoText:SetVisible(false)
              nameLabel:SetText(v:GetName())
              sid64Label:SetText("SteamID64: " .. v:SteamID64())
              nameLabel:SetVisible(true)
              sid64Label:SetVisible(true)
              walletLabel:SetVisible(false)
              amountPanel:SetVisible(true)
              transferTitle:SetVisible(true)
              sendButton:SetVisible(true)
              selectionType = "player"
              selectedName = v:GetName()
              selectedPlayerOrCompany = v
            end
          end
      else
        local noPermissionLabel = vgui.Create("DLabel", sendTransferSheet)
        noPermissionLabel:SetText(PW_Billions.getPhrase("noPermission"))
        noPermissionLabel:SetFont("FrameTitleFont")
        noPermissionLabel:SetContentAlignment(5)
        noPermissionLabel:Dock(FILL)
      end

  bankSheet:AddSheet(PW_Billions.getPhrase("bankInfoT"), bankDetailsSheet)
  bankSheet:AddSheet(PW_Billions.getPhrase("transferT"), sendTransferSheet)
  return bankSheet
end

local function getEmploymentTab()
  local employmentPropertySheet =  vgui.Create("DPropertySheet")

    --CREATE/EDIT JOBS
    local jobCreationSheet = vgui.Create("DPanel", employmentPropertySheet)
      if LocalPlayer():isCompanyOwner() or LocalPlayer():isEmployed() and LocalPlayer():canAddJob() then
        local jobInfoLabel = vgui.Create("DLabel", jobCreationSheet)
          jobInfoLabel:SetText(PW_Billions.getPhrase("createModify"))
          jobInfoLabel:SetFont("FrameTitleFont")
          jobInfoLabel:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
          jobInfoLabel:SetContentAlignment(5)
          jobInfoLabel:Dock(TOP)

        local jobList = vgui.Create("DComboBox", jobCreationSheet)
          jobList:AddChoice(PW_Billions.getPhrase("newJob"), false, true)
          for k,v in pairs(LocalPlayer():getCompany():getJobs()) do
            jobList:AddChoice(k, v)
          end
          jobList:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
          jobList:SetContentAlignment(5)
          jobList:Dock(TOP)
        hook.Add("PW_Billions_Company_AddJob", "PW_Billions_VGUI_RefreshJobList", function()
          jobList:Clear()
          jobList:AddChoice(PW_Billions.getPhrase("newJob"), false, true)
          for k,v in pairs(LocalPlayer():getCompany():getJobs()) do
            jobList:AddChoice(k, v)
          end
        end)
        local jobNameTextEntry = vgui.Create("DTextEntry", jobCreationSheet)
          jobNameTextEntry:SetSize(0, PW_Billions.PC_TEXTENTRY_H)
          jobNameTextEntry:SetPlaceholderText(PW_Billions.getPhrase("jobName"))
          jobNameTextEntry:Dock(TOP)

        local jobSalaryPanel = vgui.Create("DPanel", jobCreationSheet)
          jobSalaryPanel:SetSize(0, PW_Billions.PC_TEXTENTRY_H)
          jobSalaryPanel:Dock(TOP)

          local jobSalaryLabel = vgui.Create("DLabel", jobSalaryPanel)
            jobSalaryLabel:SetSize(PW_Billions.BUTTON_W, 0)
            jobSalaryLabel:SetText(PW_Billions.getPhrase("salary") .. ":")
            jobSalaryLabel:SetFont("FrameTextFont")
            jobSalaryLabel:Dock(LEFT)

          local jobSalaryNumberWang = vgui.Create("DNumberWang", jobSalaryPanel)
            jobSalaryNumberWang:SetSize(PW_Billions.BUTTON_W * 2, 0)
            jobSalaryNumberWang:SetPlaceholderText(PW_Billions.getPhrase("salary"))
            jobSalaryNumberWang:SetMin(1)
            jobSalaryNumberWang:SetMax(1000000)
            jobSalaryNumberWang:SetNumeric(true)
            jobSalaryNumberWang:SetDecimals(0)
            jobSalaryNumberWang:Dock(RIGHT)

        local permissionLabel = vgui.Create("DLabel", jobCreationSheet)
          permissionLabel:SetText(PW_Billions.getPhrase("selectPermissions"))
          permissionLabel:SetFont("FrameTitleFontSmall")
          permissionLabel:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
          permissionLabel:Dock(TOP)
        --[[
        local canAddBuilding = vgui.Create("DCheckBoxLabel", jobCreationSheet)
          canAddBuilding:SetText("(WIP) Can add building - can a player with this job buy buildings (doors) for the company (with company funds)")
          canAddBuilding:Dock(TOP)
          canAddBuilding:SetDisabled(true)
          ]]
        local canAddJob = vgui.Create("DCheckBoxLabel", jobCreationSheet)
          canAddJob:SetText(PW_Billions.getPhrase("addjobPermission"))
          canAddJob:SetFont("FrameTextFont")
          canAddJob:Dock(TOP)

        local canAddMoney = vgui.Create("DCheckBoxLabel", jobCreationSheet)
          canAddMoney:SetText(PW_Billions.getPhrase("addMoneyPermission"))
          canAddMoney:SetFont("FrameTextFont")
          canAddMoney:Dock(TOP)

        local canEmploy = vgui.Create("DCheckBoxLabel", jobCreationSheet)
          canEmploy:SetText(PW_Billions.getPhrase("employPermission"))
          canEmploy:SetFont("FrameTextFont")
          canEmploy:Dock(TOP)

        local canFire = vgui.Create("DCheckBoxLabel", jobCreationSheet)
          canFire:SetText(PW_Billions.getPhrase("firePermission"))
          canFire:SetFont("FrameTextFont")
          canFire:Dock(TOP)
          --[[
        local canOwnKeys = vgui.Create("DCheckBoxLabel", jobCreationSheet)
          canOwnKeys:SetText("(WIP) Can own keys - gives player with this job keys to all buildings owned by the company")
          canOwnKeys:Dock(TOP)
          canOwnKeys:SetDisabled(true)

        local canRemoveBuilding = vgui.Create("DCheckBoxLabel", jobCreationSheet)
          canRemoveBuilding:SetText("(WIP) Can remove building - player will be able to sell buildings currently owned by the company")
          canRemoveBuilding:Dock(TOP)
          canRemoveBuilding:SetDisabled(true)
          ]]
        local canSetName = vgui.Create("DCheckBoxLabel", jobCreationSheet)
          canSetName:SetText(PW_Billions.getPhrase("setNamePermission"))
          canSetName:SetFont("FrameTextFont")
          canSetName:Dock(TOP)

          --canAddBuilding:SetValue(false)
          canAddJob:SetValue(false)
          canAddMoney:SetValue(false)
          canEmploy:SetValue(false)
          canFire:SetValue(false)
          --canOwnKeys:SetValue(false)
          --canRemoveBuilding:SetValue(false)
          canSetName:SetValue(false)

        local saveButton = vgui.Create("DButton", jobCreationSheet)
          saveButton:SetText(PW_Billions.getPhrase("createJob"))
          saveButton:SetSize(0, PW_Billions.BUTTON_H)
          saveButton:Dock(BOTTOM)
          saveButton.DoClick = function()
            LocalPlayer():getCompany():addJob(jobNameTextEntry:GetValue(), jobSalaryNumberWang:GetValue(), false, canAddJob:GetChecked(), canAddMoney:GetChecked(), canEmploy:GetChecked(), canFire:GetChecked(), false, false, canSetName:GetChecked())
          end

        jobList.OnSelect = function(pnl, id, val)
          local jobName, selectedJob = jobList:GetSelected()
          if selectedJob then
            jobNameTextEntry:SetText(jobName)
            jobSalaryNumberWang:SetValue(selectedJob.salary)
            --canAddBuilding:SetValue(selectedJob.canAddBuilding)
            canAddJob:SetValue(selectedJob.canAddJob)
            canAddMoney:SetValue(selectedJob.canAddMoney)
            canEmploy:SetValue(selectedJob.canEmploy)
            canFire:SetValue(selectedJob.canFire)
            --canOwnKeys:SetValue(selectedJob.canOwnKeys)
            --canRemoveBuilding:SetValue(selectedJob.canRemoveBuilding)
            canSetName:SetValue(selectedJob.canSetName)
            saveButton:SetText(PW_Billions.getPhrase("updateJob"))
          else
            jobNameTextEntry:SetText("")
            jobSalaryNumberWang:SetValue(1)
            --canAddBuilding:SetValue(false)
            canAddJob:SetValue(false)
            canAddMoney:SetValue(false)
            canEmploy:SetValue(false)
            canFire:SetValue(false)
            --canOwnKeys:SetValue(false)
            --canRemoveBuilding:SetValue(false)
            canSetName:SetValue(false)
            saveButton:SetText(PW_Billions.getPhrase("createJob"))
          end
        end
      else
        local noPermissionLabel = vgui.Create("DLabel", jobCreationSheet)
        noPermissionLabel:SetText(PW_Billions.getPhrase("noPermission"))
        noPermissionLabel:SetFont("FrameTitleFont")
        noPermissionLabel:SetContentAlignment(5)
        noPermissionLabel:Dock(FILL)
      end

    --EMPLOYEE MANAGEMENT
    local employeesSheet = vgui.Create("DPanel", employmentPropertySheet)
      if LocalPlayer():isCompanyOwner() or LocalPlayer():isEmployed() and LocalPlayer():canFire() then
        local employeesList = vgui.Create("DCategoryList", employeesSheet)
        employeesList:SetSize(PW_Billions.PC_LIST_W, 0)
        employeesList:Dock(LEFT)

        local employeePanel = vgui.Create("DPanel", employeesSheet)
          employeePanel:SetSize(0, PW_Billions.PC_ITEMLABEL_H + PW_Billions.PC_ITEMDESC_H)
          employeePanel:Dock(TOP)

            local employeeNameLabel = vgui.Create("DLabel",employeePanel)
              employeeNameLabel:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
              employeeNameLabel:Dock(TOP)
              employeeNameLabel:SetContentAlignment(5)
              employeeNameLabel:SetText(PW_Billions.getPhrase("choosePlayerList"))
              employeeNameLabel:SetFont("FrameTitleFont")

            local employeeDescriptionLabel = vgui.Create("DLabel", employeePanel)
              employeeDescriptionLabel:SetSize(0, PW_Billions.PC_ITEMDESC_H)
              employeeDescriptionLabel:Dock(TOP)
              employeeDescriptionLabel:SetContentAlignment(5)
              employeeDescriptionLabel:SetVisible(false)
              employeeNameLabel:SetFont("FrameTitleFontSmall")

        local fireButton = vgui.Create("DButton", employeesSheet)
          fireButton:SetSize(0, PW_Billions.BUTTON_H)
          fireButton:Dock(BOTTOM)
          fireButton:SetVisible(false)
          fireButton.DoClick = function()
            LocalPlayer():getCompany():fire(selectedPlayer)
          end
          fireButton:SetText("Fire")
        local employeesListCategory = employeesList:Add(PW_Billions.getPhrase("employees"))
        local employeesListItems = {}

        if LocalPlayer():getCompany() then
          for k,v in pairs(LocalPlayer():getCompany():getEmployees()) do
            employeesListItems[k] = employeesListCategory:Add(v:GetName())

            --if client clicks on an employee or other player, show player's details
            employeesListItems[k].DoClick = function()
              employeeNameLabel:SetText(v:GetName())
              employeeDescriptionLabel:SetText(v:SteamID64())
              employeeDescriptionLabel:SetVisible(true)
              fireButton:SetVisible(true)
              --save selected player to a variable
              selectedPlayer = v
            end
          end
        end
      else
        local noPermissionLabel = vgui.Create("DLabel", employeesSheet)
        noPermissionLabel:SetText(PW_Billions.getPhrase("noPermission"))
        noPermissionLabel:SetFont("FrameTitleFont")
        noPermissionLabel:SetContentAlignment(5)
        noPermissionLabel:Dock(FILL)
      end

    --NEW PLAYERS EMPLOYMENT
    local employmentSheet = vgui.Create("DPanel", employmentPropertySheet)
      if LocalPlayer():isCompanyOwner() or LocalPlayer():isEmployed() and LocalPlayer():canEmploy() then
        local availablePlayersList = vgui.Create("DCategoryList", employmentSheet)
          availablePlayersList:SetSize(PW_Billions.PC_LIST_W, 0)
          availablePlayersList:Dock(LEFT)

        local playerNameLabel = vgui.Create("DLabel",employmentSheet)
          playerNameLabel:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
          playerNameLabel:Dock(TOP)
          playerNameLabel:SetContentAlignment(5)
          playerNameLabel:SetText(PW_Billions.getPhrase("choosePlayerList"))
          playerNameLabel:SetFont("FrameTitleFont")

        local playerDesc = vgui.Create("DLabel", employmentSheet)
          playerDesc:SetSize(0, PW_Billions.PC_ITEMDESC_H)
          playerDesc:Dock(TOP)
          playerDesc:SetContentAlignment(5)
          playerDesc:SetVisible(false)
          playerDesc:SetFont("FrameTitleFont")

        local sendEmploymentOffer = vgui.Create("DButton", employmentSheet)
          sendEmploymentOffer:SetSize(0, PW_Billions.BUTTON_H)
          sendEmploymentOffer:Dock(BOTTOM)
          sendEmploymentOffer:SetText(PW_Billions.getPhrase("sendEmployment"))
          sendEmploymentOffer:SetVisible(false)
          sendEmploymentOffer.DoClick = function()
            playerEmploymentOfferDetails()
          end

        local employmentHistoryList = vgui.Create("DListView", employmentSheet)
          employmentHistoryList:SetMultiSelect(false)
          employmentHistoryList:AddColumn(PW_Billions.getPhrase("index"))
          employmentHistoryList:AddColumn(PW_Billions.getPhrase("businessName"))
          employmentHistoryList:AddColumn(PW_Billions.getPhrase("ownersSid64"))
          employmentHistoryList:AddColumn(PW_Billions.getPhrase("dateTimeEmployed"))
          employmentHistoryList:AddColumn(PW_Billions.getPhrase("jobName"))
          employmentHistoryList:SetVisible(false)

        local getEmploymentHistory = vgui.Create("DButton", employmentSheet)
          getEmploymentHistory:SetSize(0, PW_Billions.BUTTON_H)
          getEmploymentHistory:Dock(BOTTOM)
          getEmploymentHistory:SetText(PW_Billions.getPhrase("requestEmplHist"))
          getEmploymentHistory:SetVisible(false)
          getEmploymentHistory.DoClick = function()
            employmentHistoryList:Clear()
            net.Start("PW_Billions_GetPlayerEmploymentHistory")
            net.WriteString(selectedPlayer:SteamID64())
            net.SendToServer()
          end

        employmentHistoryList:Dock(FILL)

        --shows details about selected player's past employment that are retrieved from a db serverside
        net.Receive("PW_Billions_GetPlayerEmploymentHistory", function ()
          local playerHistTable = net.ReadTable()
          for k,v in pairs(playerHistTable) do
            employmentHistoryList:AddLine(k, v.businessName, v.ownerSid64, v.dateTime, v.position)
          end
        end)

        local allPlayersListCategory = availablePlayersList:Add(PW_Billions.getPhrase("availablePlayers"))
        local allPlayersListItems = {}
        for k,v in pairs(player.GetAll()) do
          if v:isCompanyOwner() == false and v:isEmployed() == false then
            allPlayersListItems[k] = allPlayersListCategory:Add(v:GetName())
            allPlayersListItems[k].DoClick = function()
              employmentHistoryList:Clear()
              playerNameLabel:SetText(v:GetName())
              playerDesc:SetText(v:SteamID64())
              playerDesc:SetVisible(true)
              sendEmploymentOffer:SetVisible(true)
              getEmploymentHistory:SetVisible(true)
              employmentHistoryList:SetVisible(true)
              selectedPlayer = v
            end
          end
        end
      else
        local noPermissionLabel = vgui.Create("DLabel", employmentSheet)
          noPermissionLabel:SetText(PW_Billions.getPhrase("noPermission"))
          noPermissionLabel:SetFont("FrameTitleFont")
          noPermissionLabel:SetContentAlignment(5)
          noPermissionLabel:Dock(FILL)
      end

  employmentPropertySheet:AddSheet(PW_Billions.getPhrase("createJobsT"), jobCreationSheet)
  employmentPropertySheet:AddSheet(PW_Billions.getPhrase("employees"), employeesSheet)
  employmentPropertySheet:AddSheet(PW_Billions.getPhrase("hirePlayersT"), employmentSheet)

  employmentPropertySheet.OnActiveTabChanged = function(smth, old, new)
    if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
      tutorialFrame:Close()
      tutorialFrame = nil
    end
    if new:GetText() == PW_Billions.getPhrase("createJobsT") then
      if LocalPlayer():isTutorialEnabled() and LocalPlayer():isTutorialEnabled("employmentCreate") then

        tutorialFrame = vgui.Create("DFrame")
          tutorialFrame:SetSkin("Billions")
          tutorialFrame:SetTitle(PW_Billions.getPhrase("jobsTutT"))
          tutorialFrame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
          tutorialFrame:Center()

          local label = vgui.Create("DLabel", tutorialFrame)
            label:SetText(PW_Billions.getPhrase("tutorialEmployees"))
            label:SetFont("TutorialTextFont")
            label:SizeToContents()
            label:SetContentAlignment(5)
            label:Center()

          local disableButton = vgui.Create("DButton", tutorialFrame)
            disableButton:SetText(PW_Billions.getPhrase("dontShow"))
            disableButton.DoClick = function()
              LocalPlayer():setTutorialEnabled(false, "employmentCreate")
              tutorialFrame:Close()
            end
            disableButton:Dock(BOTTOM)
            label:Dock(FILL)

          tutorialFrame:MakePopup()
      end
    elseif new:GetText() == PW_Billions.getPhrase("employees") then
      if LocalPlayer():isTutorialEnabled() and LocalPlayer():isTutorialEnabled("employmentEmployees") then
        tutorialFrame = vgui.Create("DFrame")
          tutorialFrame:SetSkin("Billions")
          tutorialFrame:SetTitle(PW_Billions.getPhrase("employeesTutT"))
          tutorialFrame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
          tutorialFrame:Center()

          local label = vgui.Create("DLabel", tutorialFrame)
            label:SetText(PW_Billions.getPhrase("employeesManage"))
            label:SetFont("TutorialTextFont")
            label:SizeToContents()
            label:SetContentAlignment(5)
            label:Center()

          local disableButton = vgui.Create("DButton", tutorialFrame)
            disableButton:SetText(PW_Billions.getPhrase("dontShow"))
            disableButton.DoClick = function()
              LocalPlayer():setTutorialEnabled(false, "employmentEmployees")
              tutorialFrame:Close()
            end
            disableButton:Dock(BOTTOM)
            label:Dock(FILL)

          tutorialFrame:MakePopup()
      end
    elseif new:GetText() == PW_Billions.getPhrase("hirePlayersT") then
      if LocalPlayer():isTutorialEnabled() and LocalPlayer():isTutorialEnabled("employmentHire") then
        tutorialFrame = vgui.Create("DFrame")
          tutorialFrame:SetSkin("Billions")
          tutorialFrame:SetTitle(PW_Billions.getPhrase("employTutT"))
          tutorialFrame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
          tutorialFrame:Center()

          local label = vgui.Create("DLabel", tutorialFrame)
            label:SetText(PW_Billions.getPhrase("tutorialHire"))
            label:SetFont("TutorialTextFont")
            label:SizeToContents()
            label:SetContentAlignment(5)
            label:Center()

          local disableButton = vgui.Create("DButton", tutorialFrame)
            disableButton:SetText(PW_Billions.getPhrase("dontShow"))
            disableButton.DoClick = function()
              LocalPlayer():setTutorialEnabled(false, "employmentHire")
              tutorialFrame:Close()
            end
            disableButton:Dock(BOTTOM)
            label:Dock(FILL)

          tutorialFrame:MakePopup()
      end
    end
  end

  return employmentPropertySheet
end

local function getCompanySettingsTab()
  local companySettings = vgui.Create("DPanel")


    --Text field to set company name
    if LocalPlayer():isCompanyOwner() then
      --set name
      local settingsPanel1 = vgui.Create("DPanel", companySettings)
        settingsPanel1:SetSize(0, PW_Billions.SORTINGPANEL_H)
        settingsPanel1:Dock(TOP)

        local nameLabel = vgui.Create("DLabel", settingsPanel1)
          nameLabel:SetText(PW_Billions.getPhrase("settingsName") .. ": " .. DarkRP.formatMoney(PW_Billions.CFG.TAX[TAX_CHANGENAME].amount))
          nameLabel:SetFont("FrameTitleFontSmall")
          nameLabel:Dock(LEFT)
          nameLabel:DockMargin(ScrW() * 0.01, 0, 0, 0)
          nameLabel:SizeToContents()
        local setNameButton = vgui.Create("DButton", settingsPanel1)
          setNameButton:SetText(PW_Billions.getPhrase("setName"))
          setNameButton:SetFont("FrameTitleFontSmall")
          setNameButton:SetSize(PW_Billions.BUTTON_W, 0)
          setNameButton:Dock(RIGHT)
        local companyNameField = vgui.Create("DTextEntry", settingsPanel1)
          companyNameField:SetSize(PW_Billions.TEXTENTRY_W * 0.75, 0)
          companyNameField:SetFont("FrameTitleFontSmall")
          companyNameField:Dock(RIGHT)
          companyNameField:SetPlaceholderText(PW_Billions.getPhrase("newName"))
          setNameButton.DoClick = function()
            if companyNameField:GetValue() != "" then
              print(companyNameField:GetValue())
              LocalPlayer():getCompany():setName(companyNameField:GetValue())
            end
          end

      --reset tutorials
      if PW_Billions.MODULE_TUTORIAL then
        local settingsPanel2 = vgui.Create("DPanel", companySettings)
          settingsPanel2:SetSize(0, PW_Billions.SORTINGPANEL_H)
          settingsPanel2:Dock(TOP)

          local nameLabel2 = vgui.Create("DLabel", settingsPanel2)
            nameLabel2:Dock(LEFT)
            nameLabel2:DockMargin(ScrW() * 0.01, 0, 0, 0)

          local confirmButton2 = vgui.Create("DButton", settingsPanel2)
            confirmButton2:SetSize(PW_Billions.BUTTON_W, 0)
            confirmButton2:Dock(RIGHT)

            local function reloadTutorials()
              if LocalPlayer():isTutorialEnabled() then
                nameLabel2:SetText(PW_Billions.getPhrase("disableTut"))
                nameLabel2:SetFont("FrameTitleFontSmall")
                confirmButton2:SetText(PW_Billions.getPhrase("disable"))
                confirmButton2:SetFont("FrameTitleFontSmall")
              else
                nameLabel2:SetText(PW_Billions.getPhrase("disableTut"))
                nameLabel2:SetFont("FrameTitleFontSmall")
                confirmButton2:SetText(PW_Billions.getPhrase("enable"))
                confirmButton2:SetFont("FrameTitleFontSmall")
              end
              nameLabel2:SizeToContents()
            end

            reloadTutorials()

            confirmButton2.DoClick = function()
              if LocalPlayer():isTutorialEnabled() then
                LocalPlayer():setTutorialEnabled(false)
              else
                LocalPlayer():setTutorialEnabled(true)
              end
              reloadTutorials()
            end


        local settingsPanel3 = vgui.Create("DPanel", companySettings)
          settingsPanel3:SetSize(0, PW_Billions.SORTINGPANEL_H)
          settingsPanel3:Dock(TOP)

          local nameLabel3 = vgui.Create("DLabel", settingsPanel3)
            nameLabel3:SetText(PW_Billions.getPhrase("resetTut"))
            nameLabel3:SetFont("FrameTitleFontSmall")
            nameLabel3:DockMargin(ScrW() * 0.01, 0, 0, 0)
            nameLabel3:Dock(LEFT)
            nameLabel3:SizeToContents()

          local confirmButton3 = vgui.Create("DButton", settingsPanel3)
            confirmButton3:SetText(PW_Billions.getPhrase("reset"))
            confirmButton3:SetFont("FrameTitleFontSmall")
            confirmButton3:SetSize(PW_Billions.BUTTON_W, 0)
            confirmButton3:Dock(RIGHT)
            confirmButton3.DoClick = function()
              LocalPlayer():setTutorialEnabled(true, "shop")
              LocalPlayer():setTutorialEnabled(true, "unlockable")
              LocalPlayer():setTutorialEnabled(true, "bank")
              LocalPlayer():setTutorialEnabled(true, "employmentCreate")
              LocalPlayer():setTutorialEnabled(true, "employmentEmployees")
              LocalPlayer():setTutorialEnabled(true, "employmentHire")
            end
      end

      local setNaviButtons = vgui.Create("DPanel", companySettings)
        setNaviButtons:SetSize(0, PW_Billions.SORTINGPANEL_H)
        setNaviButtons:Dock(TOP)
        local setNaviButtonsLabel = vgui.Create("DLabel", setNaviButtons)
          setNaviButtonsLabel:SetText(PW_Billions.getPhrase("showButtons"))
          setNaviButtonsLabel:SetFont("FrameTitleFontSmall")
          setNaviButtonsLabel:Dock(LEFT)
          setNaviButtonsLabel:DockMargin(ScrW() * 0.01, 0, 0, 0)
          setNaviButtonsLabel:SizeToContents()
        local setNaviButtonsButton = vgui.Create("DButton", setNaviButtons)
          if PW_Billions.CFG.GUI_PCNAVIBUTTONS then
            setNaviButtonsButton:SetText(PW_Billions.getPhrase("disable"))
          else
            setNaviButtonsButton:SetText(PW_Billions.getPhrase("enable"))
          end
          setNaviButtonsButton:SetFont("FrameTitleFontSmall")
          setNaviButtonsButton:SetSize(PW_Billions.BUTTON_W, 0)
          setNaviButtonsButton:Dock(RIGHT)
          setNaviButtonsButton.DoClick = function()
            if PW_Billions.CFG.GUI_PCNAVIBUTTONS then
              PW_Billions.CFG.GUI_PCNAVIBUTTONS = false
              setNaviButtonsButton:SetText(PW_Billions.getPhrase("enable"))
            else
              PW_Billions.CFG.GUI_PCNAVIBUTTONS = true
              setNaviButtonsButton:SetText(PW_Billions.getPhrase("disable"))
            end
          end


      local settingsPanelLast = vgui.Create("DPanel", companySettings)
        settingsPanelLast:SetSize(0, PW_Billions.SORTINGPANEL_H)
        settingsPanelLast:Dock(BOTTOM)

        local nameLabelLast = vgui.Create("DLabel", settingsPanelLast)
          nameLabelLast:SetText(PW_Billions.getPhrase("removeCompanyInfo"))
          nameLabelLast:SetFont("FrameTitleFontSmall")
          nameLabelLast:DockMargin(ScrW() * 0.01, 0, 0, 0)
          nameLabelLast:Dock(LEFT)
          nameLabelLast:SizeToContents()

    else
      local noPermissionLabel = vgui.Create("DLabel", companySettings)
        noPermissionLabel:SetText(PW_Billions.getPhrase("noPermission"))
        noPermissionLabel:SetFont("FrameTitleFont")
        noPermissionLabel:SetContentAlignment(5)
        noPermissionLabel:Dock(FILL)
    end

  return companySettings
end

--Display business management window
net.Receive("PW_Billions_DisplayPC", function()
  if PW_Billions.CFG.GUI == 1 then
    --initial frame with panels
    local frame = vgui.Create("DFrame")
      frame:SetSize(PW_Billions.FRAME_W, PW_Billions.FRAME_H)
      frame:SetTitle(PW_Billions.getPhrase("businessPCT"))
      frame:Center()
      frame:SetVisible(true)
      frame:ShowCloseButton(true)
      frame:SetSkin("Billions")

    local sheet = vgui.Create("DPropertySheet", frame)
      sheet:Dock(FILL)
      sheet:SetSkin("Billions")


      --[[      SHOP TAB      ]]--
      local shopTab = getShopTab()
      shopTab:SetSkin("Billions")
      sheet:AddSheet(PW_Billions.getPhrase("shop"), shopTab)

     --[[       LEVEL TAB     ]]
      local levelTab = getLevelTab()
      levelTab:SetSkin("Billions")
      sheet:AddSheet(PW_Billions.getPhrase("unlockable"), levelTab)

      --[[      BANK TAB      ]]--
      local bankTab = getBankTab()
      bankTab:SetSkin("Billions")
      sheet:AddSheet(PW_Billions.getPhrase("bank"), bankTab)

      --[[      EMPLOYMENT TAB      ]]--
      local employmentTab = getEmploymentTab()
      employmentTab:SetSkin("Billions")
      sheet:AddSheet(PW_Billions.getPhrase("employment"), employmentTab)

      --[[      SETTINGS TAB      ]]--
      local companySettingsTab = getCompanySettingsTab()
      companySettingsTab:SetSkin("Billions")
      sheet:AddSheet(PW_Billions.getPhrase("settings"), companySettingsTab)

    frame.OnClose = function()
      hook.Remove("PW_Billions_Company_AddJob", "PW_Billions_VGUI_RefreshJobList")
      hook.Remove("PW_Billions_Company_AddMoney", "PW_Billions_VGUI_RefreshCompanyWallet")
      firstOpen = true
      if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
        tutorialFrame:Close()
        tutorialFrame = nil
      end
    end

    frame:MakePopup()

    --display shop tutorial
    if PW_Billions.MODULE_TUTORIAL then
      PW_Billions.loadTutorialTable()
      PW_Billions.displayTutorialPopup()

    --tutorial windows
      sheet.OnActiveTabChanged = function(smth, old, new)
        if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
          tutorialFrame:Close()
          tutorialFrame = nil
        end
        if new:GetText() == PW_Billions.getPhrase("shop") then
          if LocalPlayer():isTutorialEnabled() and LocalPlayer():isTutorialEnabled("shop") then
            tutorialFrame = vgui.Create("DFrame")
              tutorialFrame:SetSkin("Billions")
              tutorialFrame:SetTitle(PW_Billions.getPhrase("shopTutT"))
              tutorialFrame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
              tutorialFrame:Center()

              local label = vgui.Create("DLabel", tutorialFrame)
                label:SetText(PW_Billions.getPhrase("tutorialShop"))
                label:SetFont("TutorialTextFont")
                label:SizeToContents()
                label:SetContentAlignment(5)
                label:Center()

              local disableButton = vgui.Create("DButton", tutorialFrame)
                disableButton:SetText(PW_Billions.getPhrase("dontShow"))
                disableButton.DoClick = function()
                  LocalPlayer():setTutorialEnabled(false, "shop")
                  tutorialFrame:Close()
                end
                disableButton:Dock(BOTTOM)
                label:Dock(FILL)

              tutorialFrame:MakePopup()
          end
        elseif new:GetText() == PW_Billions.getPhrase("unlockable") then
          if LocalPlayer():isTutorialEnabled() and LocalPlayer():isTutorialEnabled("unlockable") then
            tutorialFrame = vgui.Create("DFrame")
              tutorialFrame:SetSkin("Billions")
              tutorialFrame:SetTitle(PW_Billions.getPhrase("unlockableTutT"))
              tutorialFrame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
              tutorialFrame:Center()

              local label = vgui.Create("DLabel", tutorialFrame)
                label:SetText(PW_Billions.getPhrase("tutorialUnlockable"))
                label:SetFont("TutorialTextFont")
                label:SizeToContents()
                label:SetContentAlignment(5)
                label:Center()

              local disableButton = vgui.Create("DButton", tutorialFrame)
                disableButton:SetText(PW_Billions.getPhrase("dontShow"))
                disableButton.DoClick = function()
                  LocalPlayer():setTutorialEnabled(false, "unlockable")
                  tutorialFrame:Close()
                end
                disableButton:Dock(BOTTOM)
                label:Dock(FILL)

              tutorialFrame:MakePopup()
          end
        elseif new:GetText() == PW_Billions.getPhrase("bank") then
          if LocalPlayer():isTutorialEnabled() and LocalPlayer():isTutorialEnabled("bank") then
            tutorialFrame = vgui.Create("DFrame")
              tutorialFrame:SetSkin("Billions")
              tutorialFrame:SetTitle(PW_Billions.getPhrase("bankTutT"))
              tutorialFrame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
              tutorialFrame:Center()

              local label = vgui.Create("DLabel", tutorialFrame)
                label:SetText(PW_Billions.getPhrase("tutorialBank"))
                label:SetFont("TutorialTextFont")
                label:SizeToContents()
                label:SetContentAlignment(5)
                label:Center()

              local disableButton = vgui.Create("DButton", tutorialFrame)
                disableButton:SetText(PW_Billions.getPhrase("dontShow"))
                disableButton.DoClick = function()
                  LocalPlayer():setTutorialEnabled(false, "bank")
                  tutorialFrame:Close()
                end
                disableButton:Dock(BOTTOM)
                label:Dock(FILL)

              tutorialFrame:MakePopup()
          end
        --workaround for displaying employment tutorial on first open
        elseif new:GetText() == PW_Billions.getPhrase("employment") then
          if LocalPlayer():isTutorialEnabled() and LocalPlayer():isTutorialEnabled("employmentCreate") then
            tutorialFrame = vgui.Create("DFrame")
              tutorialFrame:SetSkin("Billions")
              tutorialFrame:SetTitle(PW_Billions.getPhrase("jobsTutT"))
              tutorialFrame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
              tutorialFrame:Center()

              local label = vgui.Create("DLabel", tutorialFrame)
                label:SetText(PW_Billions.getPhrase("tutorialEmployees"))
                label:SetFont("TutorialTextFont")
                label:SizeToContents()
                label:SetContentAlignment(5)
                label:Center()

              local disableButton = vgui.Create("DButton", tutorialFrame)
                disableButton:SetText(PW_Billions.getPhrase("dontShow"))
                disableButton.DoClick = function()
                  LocalPlayer():setTutorialEnabled(false, "employmentCreate")
                  tutorialFrame:Close()
                end
                disableButton:Dock(BOTTOM)
                label:Dock(FILL)

              tutorialFrame:MakePopup()
          end
        end
      end

      --workaround for displaying shop tutorial on top of pc window
      if firstOpen and LocalPlayer():isTutorialEnabled() and LocalPlayer():isTutorialEnabled("shop") then
        if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
          tutorialFrame:Close()
          tutorialFrame = nil
        end
        firstOpen = false
        tutorialFrame = vgui.Create("DFrame")
          tutorialFrame:SetSkin("Billions")
          tutorialFrame:SetTitle(PW_Billions.getPhrase("shopTutT"))
          tutorialFrame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
          tutorialFrame:Center()

          local label = vgui.Create("DLabel", tutorialFrame)
            label:SetText(PW_Billions.getPhrase("tutorialShop"))
            label:SetFont("TutorialTextFont")
            label:SizeToContents()
            label:SetContentAlignment(5)
            label:Center()

          local disableButton = vgui.Create("DButton", tutorialFrame)
            disableButton:SetText(PW_Billions.getPhrase("dontShow"))
            disableButton.DoClick = function()
              LocalPlayer():setTutorialEnabled(false, "shop")
              tutorialFrame:Close()
            end
            disableButton:Dock(BOTTOM)
            label:Dock(FILL)

          tutorialFrame:MakePopup()
      end
    end

  else
    --Load new GUI
    local frame = vgui.Create("DFrame")
      frame:SetSize(PW_Billions.FRAME_W, PW_Billions.FRAME_H)
      frame:SetTitle(PW_Billions.getPhrase("businessPCT"))
      frame:Center()
      frame:SetVisible(true)
      frame:ShowCloseButton(true)
      frame:SetSkin("Billions")

      local shopTutorial
      local unlockableTutorial
      local bankTutorial
      local employmentTutorial

      --display shop tutorial
      if PW_Billions.MODULE_TUTORIAL then
        PW_Billions.loadTutorialTable()
        PW_Billions.displayTutorialPopup()

      --tutorial windows
        shopTutorial = function()
          if LocalPlayer():isTutorialEnabled() and LocalPlayer():isTutorialEnabled("shop") then
            tutorialFrame = vgui.Create("DFrame")
              tutorialFrame:SetSkin("Billions")
              tutorialFrame:SetTitle(PW_Billions.getPhrase("shopTutT"))
              tutorialFrame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
              tutorialFrame:Center()

              local label = vgui.Create("DLabel", tutorialFrame)
                label:SetText(PW_Billions.getPhrase("tutorialShop"))
                label:SetFont("TutorialTextFont")
                label:SizeToContents()
                label:SetContentAlignment(5)
                label:Center()

              local disableButton = vgui.Create("DButton", tutorialFrame)
                disableButton:SetText(PW_Billions.getPhrase("dontShow"))
                disableButton.DoClick = function()
                  LocalPlayer():setTutorialEnabled(false, "shop")
                  tutorialFrame:Close()
                end
                disableButton:Dock(BOTTOM)
                label:Dock(FILL)

              tutorialFrame:MakePopup()
          end
        end

        unlockableTutorial = function()
          if LocalPlayer():isTutorialEnabled() and LocalPlayer():isTutorialEnabled("unlockable") then
            tutorialFrame = vgui.Create("DFrame")
              tutorialFrame:SetSkin("Billions")
              tutorialFrame:SetTitle(PW_Billions.getPhrase("unlockableTutT"))
              tutorialFrame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
              tutorialFrame:Center()

              local label = vgui.Create("DLabel", tutorialFrame)
                label:SetText(PW_Billions.getPhrase("tutorialUnlockable"))
                label:SetFont("TutorialTextFont")
                label:SizeToContents()
                label:SetContentAlignment(5)
                label:Center()

              local disableButton = vgui.Create("DButton", tutorialFrame)
                disableButton:SetText(PW_Billions.getPhrase("dontShow"))
                disableButton.DoClick = function()
                  LocalPlayer():setTutorialEnabled(false, "unlockable")
                  tutorialFrame:Close()
                end
                disableButton:Dock(BOTTOM)
                label:Dock(FILL)

              tutorialFrame:MakePopup()
          end
        end

        bankTutorial = function()
            if LocalPlayer():isTutorialEnabled() and LocalPlayer():isTutorialEnabled("bank") then
            tutorialFrame = vgui.Create("DFrame")
              tutorialFrame:SetSkin("Billions")
              tutorialFrame:SetTitle(PW_Billions.getPhrase("bankTutT"))
              tutorialFrame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
              tutorialFrame:Center()

              local label = vgui.Create("DLabel", tutorialFrame)
                label:SetText(PW_Billions.getPhrase("tutorialBank"))
                label:SetFont("TutorialTextFont")
                label:SizeToContents()
                label:SetContentAlignment(5)
                label:Center()

              local disableButton = vgui.Create("DButton", tutorialFrame)
                disableButton:SetText(PW_Billions.getPhrase("dontShow"))
                disableButton.DoClick = function()
                  LocalPlayer():setTutorialEnabled(false, "bank")
                  tutorialFrame:Close()
                end
                disableButton:Dock(BOTTOM)
                label:Dock(FILL)

              tutorialFrame:MakePopup()
          end
        end

          --workaround for displaying employment tutorial on first open
        employmentTutorial = function()
          if LocalPlayer():isTutorialEnabled() and LocalPlayer():isTutorialEnabled("employmentCreate") then
            tutorialFrame = vgui.Create("DFrame")
              tutorialFrame:SetSkin("Billions")
              tutorialFrame:SetTitle(PW_Billions.getPhrase("jobsTutT"))
              tutorialFrame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
              tutorialFrame:Center()

              local label = vgui.Create("DLabel", tutorialFrame)
                label:SetText(PW_Billions.getPhrase("tutorialEmployees"))
                label:SetFont("TutorialTextFont")
                label:SizeToContents()
                label:SetContentAlignment(5)
                label:Center()

              local disableButton = vgui.Create("DButton", tutorialFrame)
                disableButton:SetText(PW_Billions.getPhrase("dontShow"))
                disableButton.DoClick = function()
                  LocalPlayer():setTutorialEnabled(false, "employmentCreate")
                  tutorialFrame:Close()
                end
                disableButton:Dock(BOTTOM)
                label:Dock(FILL)

              tutorialFrame:MakePopup()
          end
        end

      end



      local iconPanel = vgui.Create("DPanel", frame)
        if PW_Billions.CFG.GUI_PCNAVIBUTTONS then
          iconPanel:SetSize(PW_Billions.BUTTON_H * 0.75, 0)
        else
          iconPanel:SetSize(PW_Billions.BUTTON_H, 0)
        end
        iconPanel:Dock(LEFT)

      local buttonPanel
      if PW_Billions.CFG.GUI_PCNAVIBUTTONS then
        buttonPanel = vgui.Create("DPanel", frame)
          buttonPanel:SetSize(PW_Billions.BUTTON_W * 0.75, 0)
          buttonPanel:Dock(LEFT)
      end

      --set the main panel to shop tab when opening the frame
      local displayPanel = getShopTab()
        displayPanel:SetParent(frame)
        displayPanel:SetSkin("Billions")
        displayPanel:Dock(FILL)

      if PW_Billions.CFG.GUI_PCNAVIBUTTONS then
        --add a navigational button
        local shopButton = vgui.Create("DButton", buttonPanel)
          shopButton:SetText(PW_Billions.getPhrase("shop"))
          shopButton:SetSize(0, PW_Billions.BUTTON_H * 0.75)
          shopButton:Dock(TOP)
          shopButton.DoClick = function()
            displayPanel:Remove()
            displayPanel = getShopTab()
            displayPanel:SetParent(frame)
            displayPanel:SetSkin("Billions")
            displayPanel:Dock(FILL)
            if PW_Billions.MODULE_TUTORIAL then
              if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
                tutorialFrame:Close()
                tutorialFrame = nil
              end
              shopTutorial()
            end
          end

        local levelButton = vgui.Create("DButton", buttonPanel)
          levelButton:SetText(PW_Billions.getPhrase("unlockable"))
          levelButton:SetSize(0, PW_Billions.BUTTON_H * 0.75)
          levelButton:Dock(TOP)
          levelButton.DoClick = function()
            displayPanel:Remove()
            displayPanel = getLevelTab()
            displayPanel:SetParent(frame)
            displayPanel:SetSkin("Billions")
            displayPanel:Dock(FILL)
            if PW_Billions.MODULE_TUTORIAL then
              if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
                tutorialFrame:Close()
                tutorialFrame = nil
              end
              unlockableTutorial()
            end
          end

        local bankButton = vgui.Create("DButton", buttonPanel)
          bankButton:SetText(PW_Billions.getPhrase("bank"))
          bankButton:SetSize(0, PW_Billions.BUTTON_H * 0.75)
          bankButton:Dock(TOP)
          bankButton.DoClick = function()
            displayPanel = getBankTab()
            displayPanel:SetParent(frame)
            displayPanel:SetSkin("Billions")
            displayPanel:Dock(FILL)
            if PW_Billions.MODULE_TUTORIAL then
              if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
                tutorialFrame:Close()
                tutorialFrame = nil
              end
              bankTutorial()
            end
          end

        local employmentButton = vgui.Create("DButton", buttonPanel)
          employmentButton:SetText(PW_Billions.getPhrase("employment"))
          employmentButton:SetSize(0, PW_Billions.BUTTON_H * 0.75)
          employmentButton:Dock(TOP)
          employmentButton.DoClick = function()
            displayPanel = getEmploymentTab()
            displayPanel:SetParent(frame)
            displayPanel:SetSkin("Billions")
            displayPanel:Dock(FILL)
            if PW_Billions.MODULE_TUTORIAL then
              if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
                tutorialFrame:Close()
                tutorialFrame = nil
              end
              employmentTutorial()
            end
          end

        local settingsButton = vgui.Create("DButton", buttonPanel)
          settingsButton:SetText(PW_Billions.getPhrase("settings"))
          settingsButton:SetSize(0, PW_Billions.BUTTON_H * 0.75)
          settingsButton:Dock(TOP)
          settingsButton.DoClick = function()
            displayPanel = getCompanySettingsTab()
            displayPanel:SetParent(frame)
            displayPanel:SetSkin("Billions")
            displayPanel:Dock(FILL)
            if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
              tutorialFrame:Close()
              tutorialFrame = nil
            end
          end
      end

        --add an icon
        local shopIcon = vgui.Create("DImageButton", iconPanel, "PCNavIcon")
          shopIcon:SetImage("icons/billions/cart-12.png")
          if PW_Billions.CFG.GUI_PCNAVIBUTTONS then
            shopIcon:SetSize(0, PW_Billions.BUTTON_H * 0.75)
          else
            shopIcon:SetSize(0, PW_Billions.BUTTON_H)
            shopIcon:SetTooltip(PW_Billions.getPhrase("shop"))
          end
          shopIcon:Dock(TOP)
          shopIcon.DoClick =  function()
            displayPanel:Remove()
            displayPanel = getShopTab()
            displayPanel:SetParent(frame)
            displayPanel:SetSkin("Billions")
            displayPanel:Dock(FILL)
            if PW_Billions.MODULE_TUTORIAL then
              if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
                tutorialFrame:Close()
                tutorialFrame = nil
              end
              shopTutorial()
            end
          end

        local levelIcon = vgui.Create("DImageButton", iconPanel, "PCNavIcon")
          levelIcon:SetImage("icons/billions/locked.png")
          if PW_Billions.CFG.GUI_PCNAVIBUTTONS then
            levelIcon:SetSize(0, PW_Billions.BUTTON_H * 0.75)
          else
            levelIcon:SetSize(0, PW_Billions.BUTTON_H)
            levelIcon:SetTooltip(PW_Billions.getPhrase("unlockable"))
          end
          levelIcon:Dock(TOP)
          levelIcon.DoClick = function()
            displayPanel:Remove()
            displayPanel = getLevelTab()
            displayPanel:SetParent(frame)
            displayPanel:SetSkin("Billions")
            displayPanel:Dock(FILL)
            if PW_Billions.MODULE_TUTORIAL then
              if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
                tutorialFrame:Close()
                tutorialFrame = nil
              end
              unlockableTutorial()
            end
          end

        local bankIcon = vgui.Create("DImageButton", iconPanel, "PCNavIcon")
          bankIcon:SetImage("icons/billions/strongbox.png")
          if PW_Billions.CFG.GUI_PCNAVIBUTTONS then
            bankIcon:SetSize(0, PW_Billions.BUTTON_H * 0.75)
          else
            bankIcon:SetSize(0, PW_Billions.BUTTON_H)
            bankIcon:SetTooltip(PW_Billions.getPhrase("bank"))
          end
          bankIcon:Dock(TOP)
          bankIcon.DoClick = function()

            displayPanel = getBankTab()
            displayPanel:SetParent(frame)
            displayPanel:SetSkin("Billions")
            displayPanel:Dock(FILL)
            if PW_Billions.MODULE_TUTORIAL then
              if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
                tutorialFrame:Close()
                tutorialFrame = nil
              end
              bankTutorial()
            end
          end

        local employmentIcon = vgui.Create("DImageButton", iconPanel, "PCNavIcon")
          employmentIcon:SetImage("icons/billions/team-management.png")
          if PW_Billions.CFG.GUI_PCNAVIBUTTONS then
            employmentIcon:SetSize(0, PW_Billions.BUTTON_H * 0.75)
          else
            employmentIcon:SetSize(0, PW_Billions.BUTTON_H)
            employmentIcon:SetTooltip(PW_Billions.getPhrase("employment"))
          end
          employmentIcon:Dock(TOP)
          employmentIcon.DoClick = function()
            displayPanel = getEmploymentTab()
            displayPanel:SetParent(frame)
            displayPanel:SetSkin("Billions")
            displayPanel:Dock(FILL)
            if PW_Billions.MODULE_TUTORIAL then
              if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
                tutorialFrame:Close()
                tutorialFrame = nil
              end
              employmentTutorial()
            end
          end

        local settingsIcon = vgui.Create("DImageButton", iconPanel, "PCNavIcon")
          settingsIcon:SetImage("icons/billions/settings-work-tool.png")
          if PW_Billions.CFG.GUI_PCNAVIBUTTONS then
            settingsIcon:SetSize(0, PW_Billions.BUTTON_H * 0.75)
          else
            settingsIcon:SetSize(0, PW_Billions.BUTTON_H)
            settingsIcon:SetTooltip(PW_Billions.getPhrase("settings"))
          end
          settingsIcon:Dock(TOP)
          settingsIcon.DoClick = function()
            displayPanel = getCompanySettingsTab()
            displayPanel:SetParent(frame)
            displayPanel:SetSkin("Billions")
            displayPanel:Dock(FILL)
          end


    frame.OnClose = function()
      hook.Remove("PW_Billions_Company_AddJob", "PW_Billions_VGUI_RefreshJobList")
      hook.Remove("PW_Billions_Company_AddMoney", "PW_Billions_VGUI_RefreshCompanyWallet")
      firstOpen = true
      if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
        tutorialFrame:Close()
        tutorialFrame = nil
      end
    end

    frame:MakePopup()

      --workaround for displaying shop tutorial on first open
    if PW_Billions.MODULE_TUTORIAL and firstOpen and LocalPlayer():isTutorialEnabled() and LocalPlayer():isTutorialEnabled("shop") then
      if IsValid(tutorialFrame) and ispanel(tutorialFrame) then
        tutorialFrame:Close()
        tutorialFrame = nil
      end
      firstOpen = false
      tutorialFrame = vgui.Create("DFrame")
        tutorialFrame:SetSkin("Billions")
        tutorialFrame:SetTitle(PW_Billions.getPhrase("shopTutT"))
        tutorialFrame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
        tutorialFrame:Center()

        local label = vgui.Create("DLabel", tutorialFrame)
          label:SetText(PW_Billions.getPhrase("tutorialShop"))
          label:SetFont("TutorialTextFont")
          label:SizeToContents()
          label:SetContentAlignment(5)
          label:Center()

        local disableButton = vgui.Create("DButton", tutorialFrame)
          disableButton:SetText(PW_Billions.getPhrase("dontShow"))
          disableButton.DoClick = function()
            LocalPlayer():setTutorialEnabled(false, "shop")
            tutorialFrame:Close()
          end
          disableButton:Dock(BOTTOM)
          label:Dock(FILL)

        tutorialFrame:MakePopup()
    end
  end
end)
