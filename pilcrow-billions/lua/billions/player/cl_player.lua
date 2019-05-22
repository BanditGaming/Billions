local PLAYER = FindMetaTable("Player")

function PLAYER:acceptEmploymentOffer(ownerSid64)
  if self:isCompanyOwner() == false and self:isEmployed() == false then
    self.employmentOffers[ownerSid64] = nil
    net.Start("PW_Billions_Company_AcceptEmploymentOffer")
    net.WriteString(ownerSid64)
    net.SendToServer()
  end
end

function PLAYER:declineEmploymentOffer(ownerSid64)
  self.employmentOffers[ownerSid64] = nil
  net.Start("PW_Billions_Company_DeclineEmploymentOffer")
  net.WriteString(ownerSid64)
  net.SendToServer()
end

function PLAYER:getEmploymentOffers()
  return self.employmentOffers
end

net.Receive("PW_Billions_Display_EmploymentOffers", function(len)
  local frame = vgui.Create("DFrame")
    frame:SetTitle(PW_Billions.getPhrase("jobsT"))
    frame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
    frame:Center()
    frame:SetSkin("Billions")

    local leaveCompanyButton = vgui.Create("DButton", frame)
      leaveCompanyButton:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
      leaveCompanyButton:Dock(TOP)
      leaveCompanyButton:SetText(PW_Billions.getPhrase("leaveComp"))
      if LocalPlayer():isEmployed() then
        leaveCompanyButton.DoClick = function()
          LocalPlayer():getCompany():fire(LocalPlayer())
          frame:Close()
        end
      else
        leaveCompanyButton:SetDisabled(true)
      end

    local offers = LocalPlayer():getEmploymentOffers()
      for k,v in pairs(offers) do
        local panel = vgui.Create("DPanel", frame)
          panel:SetSize(0, PW_Billions.PC_ITEMLABEL_H)
          panel:Dock(TOP)
          local company = PW_Billions.getCompany(k)
          local companyNameLabel = vgui.Create("DLabel", panel)
            companyNameLabel:SetText(PW_Billions.getPhrase("company") .. ": " .. company:getName())
            companyNameLabel:SizeToContents()
            companyNameLabel:Dock(LEFT)
          local jobNameLabel = vgui.Create("DLabel", panel)
            jobNameLabel:SetText(" " .. PW_Billions.getPhrase("jobName") .. ": " .. v)
            jobNameLabel:SizeToContents()
            jobNameLabel:Dock(LEFT)
          local salaryLabel = vgui.Create("DLabel", panel)
            salaryLabel:SetText(" " .. PW_Billions.getPhrase("salary") .. ": " .. company:getJob(v).salary)
            salaryLabel:SizeToContents()
            salaryLabel:Dock(LEFT)
          local denyButton = vgui.Create("DButton", panel)
            denyButton:SetText(PW_Billions.getPhrase("deny"))
            denyButton:Dock(RIGHT)
            denyButton.DoClick = function()
              LocalPlayer():declineEmploymentOffer(k)
              frame:Close()
            end
          local acceptButton = vgui.Create("DButton", panel)
            acceptButton:SetText(PW_Billions.getPhrase("accept"))
            acceptButton:Dock(RIGHT)
            acceptButton.DoClick = function()
              LocalPlayer():acceptEmploymentOffer(k)
              frame:Close()
            end
      end

    frame:MakePopup()
end)
