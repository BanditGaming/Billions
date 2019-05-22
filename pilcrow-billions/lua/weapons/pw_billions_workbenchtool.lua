SWEP.PrintName			= "Hammer"
SWEP.Author			=  "Yogosh"
SWEP.Instructions	 = "LMB on the workbench to work, RMB to select product."
SWEP.Category = "Billions"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Slot = 4
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModel = "models/weapons/v_hammer.mdl"
SWEP.WorldModel = "models/weapons/w_hammer.mdl"
SWEP.HoldType = "melee"
SWEP.Primary.Damage = 0
SWEP.base = "crowbar"

function SWEP:PrimaryAttack()
  local trace = self.Owner:GetEyeTrace()

  if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
    if SERVER then
      local workbench = trace.Entity
      if workbench:GetClass() == "pw_billions_supplies_workbench" then
        workbench:Input("workbenchToolPrimary", self.Owner, self, nil)
      end
    end
    local effectData = EffectData()
    effectData:SetOrigin(trace.HitPos)
    self:EmitSound("weapons/hammer/impact1.wav")
    self:SendWeaponAnim(ACT_VM_HITCENTER)
  else
    self:EmitSound("weapons/hammer/swing1.wav")
    self:SendWeaponAnim(ACT_VM_MISSCENTER)
  end
  if SERVER then
  	self.Owner:SetAnimation(PLAYER_ATTACK1)
  end
  self.Owner:DoAttackEvent()
  self:SetNextPrimaryFire(CurTime() + .43)
end

function SWEP:SecondaryAttack()
  if CLIENT then
    if not IsFirstTimePredicted() then return end
    local eyeTrace = self.Owner:GetEyeTraceNoCursor()
    local workbench = eyeTrace.Entity
    if workbench:GetClass() == "pw_billions_supplies_workbench" then

      local frame = vgui.Create("DFrame")
      frame:SetSize(PW_Billions.SMALL_FRAME_W, PW_Billions.SMALL_FRAME_H)
      frame:SetTitle("Product Selection")
      frame:Center()
      frame:SetSkin("Billions")

        local scrollPanel = vgui.Create("DScrollPanel", frame)
        scrollPanel:Dock(FILL)

        local buttons = {}

        for k,v in pairs(PW_Billions.CRAFTABLE.WORKBENCH) do
          if LocalPlayer():getCompany():canProduce(k) then
            buttons[k] = scrollPanel:Add("DButton", scrollPanel)
            buttons[k]:SetText(v.name .. "    Supplies: E/" .. v.electronicsAmount .. " GE/" .. v.gearsAmount .. " GU/" .. v.gunpowderAmount .. " M/" .. v.metalAmount .. " P/" .. v.plasticAmount .. " W/" .. v.woodAmount)
            buttons[k]:Dock(TOP)
            buttons[k].DoClick = function()
              net.Start("PW_Billions_WorkbenchProductSelection")
              net.WriteString(k)
              net.SendToServer()
              frame:Close()
            end
          end
        end

      frame:MakePopup()
    end
  end
end
