include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
  local ang = self:GetAngles()
  ang:RotateAroundAxis(self:GetAngles():Up(), 90)
  ang:RotateAroundAxis(self:GetAngles():Right(), 270)
  self:DrawModel()
  cam.Start3D2D(self:GetPos() - ang:Right() * 82, ang, 0.1)
  draw.SimpleTextOutlined(PW_Billions.getPhrase("npcDistributor"), "NPCFont", 0, 0, Color(191, 191, 191, 210), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.6, Color(0, 0, 0, 210))
  cam.End3D2D()
end

net.Receive("PW_Billions_NPC_Distributor_Open", function(len)
  PW_Billions.NPC_DISTRIBUTOR = net.ReadTable()

  local frame = vgui.Create("DFrame")
  frame:SetSize(PW_Billions.FRAME_W, PW_Billions.FRAME_H)
  frame:SetTitle(PW_Billions.getPhrase("distributorT"))
  frame:Center()
  frame:SetSkin("Billions")

  local scrollPanel = vgui.Create("DScrollPanel", frame)
  scrollPanel:Dock(FILL)

  local list = vgui.Create("DIconLayout", scrollPanel)
  list:Dock(FILL)

  local listItems = {}
  for k,v in pairs(PW_Billions.NPC_DISTRIBUTOR) do
    if (PW_Billions.CRAFTABLE.WORKBENCH[k].buyback or (PW_Billions.CRAFTABLE.WORKBENCH[k].buybackTeams and PW_Billions.CRAFTABLE.WORKBENCH[k].buybackTeams[LocalPlayer():Team()])) and v > 0 then
      listItems[k] = list:Add("DPanel", list)
      listItems[k].OwnLine = true
      listItems[k]:Dock(TOP)
      listItems[k]:SetSize(0, PW_Billions.BUTTON_H)
      listItems[k]["itemLabel"] = vgui.Create("DLabel", listItems[k])
      listItems[k]["itemLabel"]:SetText(PW_Billions.CRAFTABLE.WORKBENCH[k].name)
      listItems[k]["itemLabel"]:SetFont("FrameTitleFontSmall")
      listItems[k]["itemLabel"]:SizeToContents()
      listItems[k]["itemLabel"]:DockMargin(ScrW() * 0.05, 0, ScrW() * 0.05, 0)
      listItems[k]["itemLabel"]:Dock(LEFT)

      listItems[k]["buyNumber"] = vgui.Create("DNumberWang", listItems[k])
      listItems[k]["buyNumber"]:SetMax(v)
      listItems[k]["buyNumber"]:SetDecimals(0)
      listItems[k]["buyButton"] = vgui.Create("DButton", listItems[k])
      listItems[k]["buyButton"]:SetText(PW_Billions.getPhrase("BUY"))
      listItems[k]["buyButton"]:Dock(RIGHT)
      listItems[k]["itemAmount"] = ""
      listItems[k]["buyButton"].DoClick = function()
        if listItems[k]["buyNumber"]:GetValue() > 0 then
          net.Start("PW_Billions_NPC_Distributor_Buy")
          net.WriteBool(false)
          net.WriteString(k)
          net.WriteInt(listItems[k]["buyNumber"]:GetValue(), 8)
          net.SendToServer()
          listItems[k]["itemAmount"]:SetText(PW_Billions.getPhrase("available") .. ": " .. v - listItems[k]["buyNumber"]:GetValue())
        end
      end
      --[[
      listItems[k]["buyButtonCompany"] = vgui.Create("DButton", listItems[k])
      listItems[k]["buyButtonCompany"]:SetText("Buy with company funds")
      listItems[k]["buyButtonCompany"]:Dock(RIGHT)
      listItems[k]["buyButtonCompany"]:SizeToContents()
      listItems[k]["buyButtonCompany"].DoClick = function()
        if listItems[k]["buyNumber"]:GetValue() > 0 then
          net.Start("PW_Billions_NPC_Distributor_Buy")
          net.WriteBool(true)
          net.WriteString(k)
          net.WriteInt(listItems[k]["buyNumber"]:GetValue(), 8)
          net.SendToServer()
          listItems[k]["itemAmount"]:SetText("Available: " .. v - listItems[k]["buyNumber"]:GetValue())
        end
      end
      ]]
      listItems[k]["buyNumber"]:Dock(RIGHT)
      listItems[k]["buyNumber"]:SetFont("FrameTextFont")
      listItems[k]["itemAmount"] = vgui.Create("DLabel", listItems[k])
      listItems[k]["itemAmount"]:SetText(PW_Billions.getPhrase("available") .. ": " .. v)
      listItems[k]["itemAmount"]:SetFont("FrameTextFont")
      listItems[k]["itemAmount"]:SizeToContents()
      listItems[k]["itemAmount"]:Dock(RIGHT)
      listItems[k]["itemAmount"]:DockMargin(0, 0, ScrW() * 0.02, 0)

      listItems[k]["itemPriceLabel"] = vgui.Create("DLabel", listItems[k])
      listItems[k]["itemPriceLabel"]:SetText(PW_Billions.getPhrase("price") .. ": " .. PW_Billions.CRAFTABLE.WORKBENCH[k].buybackPrice)
      listItems[k]["itemPriceLabel"]:SetFont("FrameTextFont")
      listItems[k]["itemPriceLabel"]:SizeToContents()
      listItems[k]["itemPriceLabel"]:Dock(RIGHT)
      listItems[k]["itemPriceLabel"]:DockMargin(0, 0, ScrW() * 0.02, 0)
      if PW_Billions.CFG.VLEVEL and PW_Billions.CRAFTABLE.WORKBENCH[k].buybackPlayerLevel then
        listItems[k]["itemLevelLabel"] = vgui.Create("DLabel", listItems[k])
        listItems[k]["itemLevelLabel"]:SetText(PW_Billions.getPhrase("level") .. ": " .. PW_Billions.CRAFTABLE.WORKBENCH[k].buybackPlayerLevel)
        listItems[k]["itemLevelLabel"]:SetFont("FrameTextFont")
        listItems[k]["itemLevelLabel"]:SizeToContents()
        listItems[k]["itemLevelLabel"]:Dock(RIGHT)
        listItems[k]["itemLevelLabel"]:DockMargin(0, 0, ScrW() * 0.02, 0)

        if LocalPlayer():getDarkRPVar("level") < PW_Billions.CRAFTABLE.WORKBENCH[k].buybackPlayerLevel then
          listItems[k]["buyButton"]:SetEnabled(false)
        end

      end
    end
  end
  frame:MakePopup()
end)
