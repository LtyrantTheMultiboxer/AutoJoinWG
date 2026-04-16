-- The main data table
AutoJoinWG = AutoJoinWG or {}
AutoJoinWG.Enabled = true 

-- 1. The Toggle Button
local btn = CreateFrame("Button", "AutoJoinWGToggle", UIParent, "UIPanelButtonTemplate")
btn:SetSize(160, 30)
btn:SetPoint("CENTER", 0, 0) 
btn:SetText("WG Auto-Join: |cff00ff00ON|r")
btn:SetMovable(true)
btn:EnableMouse(true)
btn:SetClampedToScreen(true) -- Prevents dragging it completely off-screen

-- Make it draggable (Hold Shift to move)
btn:RegisterForDrag("LeftButton")
btn:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
btn:SetScript("OnDragStop", btn.StopMovingOrSizing)

-- Simple Tooltip
btn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("Wintergrasp Auto-Join")
    GameTooltip:AddLine("Hold |cffffd100Shift|r to drag this button.", 1, 1, 1)
    GameTooltip:Show()
end)
btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- Toggle Logic
btn:SetScript("OnClick", function(self)
    AutoJoinWG.Enabled = not AutoJoinWG.Enabled
    if AutoJoinWG.Enabled then
        self:SetText("WG Auto-Join: |cff00ff00ON|r")
    else
        self:SetText("WG Auto-Join: |cffff0000OFF|r")
    end
end)

-- 2. Slash Command to Reset Position
SLASH_WGRESET1 = "/wgreset"
SlashCmdList["WGRESET"] = function()
    btn:ClearAllPoints()
    btn:SetPoint("CENTER", 0, 0)
    print("|cff00ff00AutoJoinWG: Position reset to center.|r")
end

-- 3. The Event Logic
AutoJoinWG.frame = CreateFrame("FRAME")
AutoJoinWG.frame:RegisterEvent("BATTLEFIELD_MGR_QUEUE_INVITE")

AutoJoinWG.eventHandler = function(self, event, ...)
    if (event == "BATTLEFIELD_MGR_QUEUE_INVITE" and AutoJoinWG.Enabled) then
        BattlefieldMgrQueueInviteResponse(1,1)
        StaticPopup_Hide("BFMGR_INVITED_TO_QUEUE")
        StaticPopup_Hide("BFMGR_INVITED_TO_QUEUE_WARMUP")
    end
end

AutoJoinWG.frame:SetScript("OnEvent", AutoJoinWG.eventHandler)
