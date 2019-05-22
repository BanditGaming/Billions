include("shared.lua")

function ENT:Draw()
  self:DrawModel()
end


--Display business management window
net.Receive("PW_Billions_Mayor_DisplayPC", function(len)
  --initial frame with panels
  local frame = vgui.Create("DFrame")
    frame:SetSize(PW_Billions.FRAME_W, PW_Billions.FRAME_H)
    frame:SetTitle(PW_Billions.getPhrase("mayorPCT"))
    frame:Center()
    frame:SetVisible(true)
    frame:ShowCloseButton(true)
    frame:SetSkin("Billions")

    if LocalPlayer():isMayor() then
      local sheet = vgui.Create("DPropertySheet", frame)
        sheet:Dock(FILL)

        local itemsPanel = vgui.Create("DScrollPanel", sheet)

          local infoLabel = vgui.Create("DLabel", itemsPanel)
            infoLabel:SetText(PW_Billions.getPhrase("govShop"))
            infoLabel:SetFont("FrameTitleFont")
            infoLabel:SetContentAlignment(5)
            infoLabel:SetSize(0, PW_Billions.SORTINGPANEL_H)
            infoLabel:Dock(TOP)

          for k,v in pairs(PW_Billions.MAYOR_BUYITEMS) do

            local itemSortingPanel = vgui.Create("DPanel", itemsPanel)
              itemSortingPanel:SetSize(0, PW_Billions.SORTINGPANEL_H)
              itemSortingPanel:Dock(TOP)

              local itemLabelPanel = vgui.Create("DPanel", itemSortingPanel)
                itemLabelPanel:SetSize(PW_Billions.SORTINGPANEL_BUTTON_W * 2, PW_Billions.SORTINGPANEL_H)
                itemLabelPanel:Dock(LEFT)
                local itemLabel = vgui.Create("DLabel", itemLabelPanel)
                  itemLabel:SetText(v.name)
                  itemLabel:SetFont("FrameTitleFontSmall")
                  itemLabel:SizeToContents()
                  itemLabel:DockMargin(PW_Billions.SORTINGPANEL_BUTTON_W * 0.2, 0, 0, 0)
                  itemLabel:Dock(LEFT)

              local itemDescLabel = vgui.Create("DLabel", itemSortingPanel)
                itemDescLabel:SetText(v.description)
                itemDescLabel:SetFont("FrameTitleFontSmall")
                itemDescLabel:SizeToContents()
                itemDescLabel:DockMargin(PW_Billions.SORTINGPANEL_BUTTON_W * 0.2, 0, 0, 0)
                itemDescLabel:Dock(LEFT)

              local button = vgui.Create("DButton", itemSortingPanel)
                button:SetSize(PW_Billions.SORTINGPANEL_BUTTON_W, 0)
                button:SetText("BUY")
                button:Dock(RIGHT)
                button.DoClick = function()
                  PW_Billions.mayorBuyWeapon(k)
                end

              local itemPriceLabel = vgui.Create("DLabel", itemSortingPanel)
                itemPriceLabel:SetText(v.price .. "$ / " .. PW_Billions.getPhrase("eligiblePly"))
                itemPriceLabel:SetFont("FrameTextFont")
                itemPriceLabel:SizeToContents()
                itemPriceLabel:DockMargin(0, 0, PW_Billions.SORTINGPANEL_BUTTON_W * 0.2, 0)
                itemPriceLabel:Dock(RIGHT)
          end

        local taxPanel = vgui.Create("DScrollPanel", sheet)
          local taxInfoLabel = vgui.Create("DLabel", taxPanel)
            taxInfoLabel:SetText(PW_Billions.getPhrase("polCostTax") .. " " .. PW_Billions.CFG.MAYOR_TAX_CHANGE_COST)
            taxInfoLabel:SetFont("FrameTitleFont")
            taxInfoLabel:SetContentAlignment(5)
            taxInfoLabel:SetSize(0, PW_Billions.SORTINGPANEL_H)
            taxInfoLabel:Dock(TOP)
          for i,v in ipairs(PW_Billions.CFG.TAX) do
            if v.changeable then
              local taxSortingPanel = vgui.Create("DPanel", taxPanel)
                taxSortingPanel:SetSize(0, PW_Billions.SORTINGPANEL_H * 1.5)
                taxSortingPanel:Dock(TOP)

                local taxNameLabelPanel = vgui.Create("DPanel", taxSortingPanel)
                  taxNameLabelPanel:SetSize(PW_Billions.SORTINGPANEL_BUTTON_W * 2, PW_Billions.SORTINGPANEL_H)
                  taxNameLabelPanel:Dock(LEFT)
                  local taxNameLabel = vgui.Create("DLabel", taxNameLabelPanel)
                    taxNameLabel:SetText(v.name)
                    taxNameLabel:SetFont("FrameTitleFontSmall")
                    taxNameLabel:SizeToContents()
                    taxNameLabel:DockMargin(PW_Billions.SORTINGPANEL_BUTTON_W * 0.2, 0, 0, 0)
                    taxNameLabel:Dock(LEFT)

                  local taxDescLabel = vgui.Create("DLabel", taxSortingPanel)
                    taxDescLabel:SetText(v.description)
                    taxDescLabel:SetFont("FrameTitleFontSmall")
                    taxDescLabel:SizeToContents()
                    taxDescLabel:Dock(LEFT)
                    taxDescLabel:DockMargin(PW_Billions.SORTINGPANEL_BUTTON_W * 0.3, 0, 0, 0)

                  local setTaxButton = vgui.Create("DButton", taxSortingPanel)
                    setTaxButton:SetText(PW_Billions.getPhrase("setTax"))
                    setTaxButton:SetSize(PW_Billions.SORTINGPANEL_BUTTON_W, 0)
                    setTaxButton:Dock(RIGHT)
                  local infoText
                  local taxNumberWang
                  if i == TAX_CHANGENAME then
                      taxNumberWang = vgui.Create("DNumberWang", taxSortingPanel)
                      taxNumberWang:SetSize(PW_Billions.SORTINGPANEL_BUTTON_W * 1, 0)
                      taxNumberWang:SetDecimals(0)
                      taxNumberWang:SetMin(0)
                      taxNumberWang:SetMax(v.MAX_AMOUNT)
                      taxNumberWang:SetValue(v.amount)
                      taxNumberWang:Dock(RIGHT)
                      infoText = PW_Billions.getPhrase("max") .. ": " .. v.MAX_AMOUNT .. "$"
                  else
                      taxNumberWang = vgui.Create("DNumberWang", taxSortingPanel)
                      taxNumberWang:SetSize(PW_Billions.SORTINGPANEL_BUTTON_W * 1, 0)
                      taxNumberWang:SetDecimals(0)
                      taxNumberWang:SetMin(0)
                      taxNumberWang:SetMax(v.MAX_AMOUNT * 100)
                      taxNumberWang:SetValue(v.amount * 100)
                      taxNumberWang:Dock(RIGHT)
                      infoText = PW_Billions.getPhrase("max") .. ": " .. v.MAX_AMOUNT * 100 .. "%"
                  end
                  local typeInfoLabel = vgui.Create("DLabel", taxSortingPanel)
                    typeInfoLabel:SetText(infoText)
                    typeInfoLabel:SetFont("FrameTextFont")
                    typeInfoLabel:SizeToContents()
                    typeInfoLabel:Dock(RIGHT)
                    typeInfoLabel:DockMargin(0, 0, PW_Billions.SORTINGPANEL_BUTTON_W * 0.2, 0)

                    setTaxButton.DoClick = function()
                      if i == TAX_CHANGENAME then
                        PW_Billions.setTax(i, taxNumberWang:GetValue())
                      else
                        PW_Billions.setTax(i, taxNumberWang:GetValue() * 0.01)
                      end
                    end
            end
          end

        local licensePanel = vgui.Create("DScrollPanel", sheet)
          local costInfoLabel = vgui.Create("DLabel", licensePanel)
            costInfoLabel:SetText(PW_Billions.getPhrase("polCostLicense") .. ": " .. PW_Billions.CFG.MAYOR_LICENSE_CHANGE_COST .. " points")
            costInfoLabel:SetFont("FrameTitleFont")
            costInfoLabel:SetContentAlignment(5)
            costInfoLabel:SetSize(0, PW_Billions.SORTINGPANEL_H)
            costInfoLabel:Dock(TOP)
          for k, v in pairs(PW_Billions.PC_BUYITEMS) do
            if v.licenseChangeable then
              local licenseSortingPanel = vgui.Create("DPanel", licensePanel)
                licenseSortingPanel:SetSize(0, PW_Billions.SORTINGPANEL_H)
                licenseSortingPanel:Dock(TOP)
                local itemLabel = vgui.Create("DLabel", licenseSortingPanel)
                  itemLabel:SetText(v.name)
                  itemLabel:SetFont("FrameTitleFontSmall")
                  itemLabel:SizeToContents()
                  itemLabel:DockMargin(PW_Billions.SORTINGPANEL_BUTTON_W * 0.2, 0, 0, 0)
                  itemLabel:Dock(LEFT)
                local button = vgui.Create("DButton", licenseSortingPanel)
                  button:SetSize(PW_Billions.SORTINGPANEL_BUTTON_W, 0)
                  if v.license then
                    button:SetText(PW_Billions.getPhrase("disable"))
                  else
                    button:SetText(PW_Billions.getPhrase("enable"))
                  end
                  button:Dock(RIGHT)
                local currentStatus = vgui.Create("DLabel", licenseSortingPanel)
                  if v.license then
                    currentStatus:SetText(PW_Billions.getPhrase("buyEnabled"))
                  else
                    currentStatus:SetText(PW_Billions.getPhrase("buyDisabled"))
                  end
                  currentStatus:SetFont("FrameTitleFontSmall")
                  currentStatus:SizeToContents()
                  currentStatus:DockMargin(0, 0, PW_Billions.SORTINGPANEL_BUTTON_W * 0.25, 0)
                  currentStatus:Dock(RIGHT)
                  button.DoClick = function()
                    if PW_Billions.getPoliticalCapital() >= PW_Billions.CFG.MAYOR_LICENSE_CHANGE_COST then
                      if v.license then
                        PW_Billions.setLicense(k, false)
                        button:SetText(PW_Billions.getPhrase("enable"))
                        currentStatus:SetText(PW_Billions.getPhrase("buyDisabled"))
                        currentStatus:SizeToContents()
                      else
                        PW_Billions.setLicense(k, true)
                        button:SetText(PW_Billions.getPhrase("disable"))
                        currentStatus:SetText(PW_Billions.getPhrase("buyEnabled"))
                        currentStatus:SizeToContents()
                      end
                    end
                  end
            end
          end

      sheet:AddSheet(PW_Billions.getPhrase("shop"), itemsPanel)
      sheet:AddSheet(PW_Billions.getPhrase("mayorTaxT"), taxPanel)
      sheet:AddSheet(PW_Billions.getPhrase("mayorLicenseT"), licensePanel)
    else
      local noPermissionLabel = vgui.Create("DLabel", frame)
      noPermissionLabel:SetText(PW_Billions.getPhrase("noPermission"))
      noPermissionLabel:SetFont("FrameTitleFont")
      noPermissionLabel:SetContentAlignment(5)
      noPermissionLabel:Dock(FILL)
    end
  frame:MakePopup()
end)
