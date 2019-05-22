include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

PW_Billions.NPC_FRAME_W = ScrW() * 0.5
PW_Billions.NPC_FRAME_H = ScrH() * 0.5

PW_Billions.NPC_LIST_W = ScrW() * 0.15
PW_Billions.NPC_LABEL_H = ScrH() * 0.05
PW_Billions.NPC_LABEL_W = ScrW() * 0.3
PW_Billions.NPC_ITEMDESC_H = ScrH() * 0.1

PW_Billions.NPC_BUTTON_W = ScrW() * 0.1
PW_Billions.NPC_BUTTON_H = ScrH() * 0.05
PW_Billions.NPC_TEXTENTRY_W = ScrW() * 0.4
PW_Billions.NPC_TEXTENTRY_H = ScrH() * 0.05
PW_Billions.NPC_SETTINGS_LABEL_W = ScrW() * 0.28
PW_Billions.NPC_SETTINGS_LABEL_H = ScrH() * 0.05

function ENT:Draw()
  local ang = self:GetAngles()
  ang:RotateAroundAxis(self:GetAngles():Up(), 90)
  ang:RotateAroundAxis(self:GetAngles():Right(), 270)
  self:DrawModel()
  cam.Start3D2D(self:GetPos() - ang:Right() * 82, ang, 0.1)
  draw.SimpleTextOutlined(PW_Billions.getPhrase("npcBusiness"), "NPCFont", 0, 0, Color(191, 191, 191, 210), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.6, Color(0, 0, 0, 210))
  cam.End3D2D()
end

net.Receive("PW_Billions_OpenBusinessNPC",function ()
  local frame = vgui.Create("DFrame")
    frame:SetSize(PW_Billions.NPC_FRAME_W, PW_Billions.NPC_FRAME_H)
    frame:Center()
    frame:SetVisible(true)
    frame:SetSkin("Billions")

    if LocalPlayer():isCompanyOwner() then
      frame:SetTitle(PW_Billions.getPhrase("removeT"))
      local pcLabel = vgui.Create("DLabel", frame)
        pcLabel:SetText(PW_Billions.getPhrase("tipF4"))
        pcLabel:SetFont("TutorialTextFont")
        pcLabel:SizeToContents()
        pcLabel:SetContentAlignment(5)
        pcLabel:Dock(BOTTOM)


        --Stuff for full removal below
        local confirmTextEntry

        local removeBusiness = vgui.Create("DButton", frame)
          removeBusiness:SetSize(0, PW_Billions.NPC_BUTTON_H)
          removeBusiness:Center()
          removeBusiness:Dock(BOTTOM)
          removeBusiness:SetText(PW_Billions.getPhrase("fullDel"))
          removeBusiness:AlignRight(10)
          --Send ID to server
          removeBusiness.DoClick = function()
            confirm = confirmTextEntry:GetValue()
            if confirm == PW_Billions.getPhrase("removeConfirm") then
              LocalPlayer():getCompany():remove(false)
              frame:Remove()
            end
          end

        confirmTextEntry = vgui.Create("DTextEntry", frame)
        confirmTextEntry:SetSize(0, frame:GetTall() * 0.08)
        confirmTextEntry:Center()
        confirmTextEntry:Dock(BOTTOM)
        confirmTextEntry:SetFont("FrameTextFont")

        local infoLabel = vgui.Create("DLabel", frame)
          infoLabel:SetText(PW_Billions.getPhrase("fullDelInfo"))
          infoLabel:SetFont("TutorialTextFont")
          infoLabel:SizeToContents()
          infoLabel:SetContentAlignment(5)
          infoLabel:Dock(BOTTOM)

        --stuff for soft removal below
        local freezeLabel = vgui.Create("DLabel", frame)
          freezeLabel:SetText(PW_Billions.getPhrase("freezeInfo"))
          freezeLabel:SetFont("TutorialTextFont")
          freezeLabel:SizeToContents()
          freezeLabel:SetContentAlignment(5)
          freezeLabel:Dock(TOP)

        local freezeBusinessButton = vgui.Create("DButton", frame)
          freezeBusinessButton:SetSize(0, PW_Billions.NPC_BUTTON_H)
          freezeBusinessButton:Center()
          freezeBusinessButton:Dock(TOP)
          freezeBusinessButton:SetText(PW_Billions.getPhrase("freeze"))
          freezeBusinessButton:AlignRight(10)
          --Send ID to server
          freezeBusinessButton.DoClick = function()
            LocalPlayer():getCompany():remove(true)
            frame:Remove()
          end

    elseif LocalPlayer():isEmployed() then
      frame:SetTitle(PW_Billions.getPhrase("registerT"))
      local infoLabel = vgui.Create("DLabel", frame)
        infoLabel:SetText(PW_Billions.getPhrase("employedErr"))
        infoLabel:SizeToContents()
        infoLabel:Center()
    else
      frame:SetTitle(PW_Billions.getPhrase("registerT"))
      local infoLabel = vgui.Create("DLabel", frame)
        infoLabel:SetText(PW_Billions.getPhrase("registerInfo1") .. " " .. DarkRP.formatMoney(PW_Billions.CFG.CREATECOMPANY_PRICE) .. PW_Billions.getPhrase("registerInfo2"))
        infoLabel:SetFont("TutorialTextFont")
        infoLabel:SizeToContents()
        infoLabel:Center()

        local inputBusinessName

        local saveBusiness = vgui.Create("DButton", frame)
          saveBusiness:SetSize(0, PW_Billions.NPC_BUTTON_H)
          saveBusiness:Center()
          saveBusiness:Dock(BOTTOM)
          saveBusiness:AlignRight(10)
          saveBusiness:SetText(PW_Billions.getPhrase("cCreate"))
          --Send ID to server
          saveBusiness.DoClick = function()
            companyName = inputBusinessName:GetValue()
            net.Start("PW_Billions_CreateCompany")
            net.WriteString(companyName)
            net.SendToServer()
            frame:Remove()
          end

        inputBusinessName = vgui.Create("DTextEntry", frame)
        inputBusinessName:SetSize(0, frame:GetTall() * 0.08)
        inputBusinessName:Center()
        inputBusinessName:Dock(BOTTOM)
        inputBusinessName:SetPlaceholderText(PW_Billions.getPhrase("cName"))
        inputBusinessName:SetFont("FrameTextFont")
    end


  frame:MakePopup()
end)
