--[[--------------------------------------------------------------------
	Broker_Time
	Shows time. Click to open the calendar.
	Copyright (c) 2014 Phanx. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info-BrokerTime.html
	http://www.curse.com/addons/wow/broker-saved
----------------------------------------------------------------------]]

local Clock = LibStub("LibDataBroker-1.1"):NewDataObject("Time", {
	type  = "data object",
	icon  = "Interface\\TimeManager\\GlobeIcon",
	text  = "--:--",
	label = GetLocale() == "deDE"  and "Zeit" 
		or GetLocale():match("^es") and "Hora" 
		or GetLocale() == "frFR"    and "Heure" 
		or GetLocale() == "itIT"    and "Ora" 
		or GetLocale():match("^pt") and "Hora" 
		or GetLocale() == "ruRU"    and "Время" 
		or GetLocale() == "koKR"    and "시간" 
		or GetLocale() == "zhCN"    and "时间" 
		or GetLocale() == "zhTW"    and "時候" 
		or "Time",
})

local function GetTooltipPoint(self, offset)
	local x, y = GetCursorPosition()
	if (y * 2) > UIParent:GetHeight() then
		return "TOP", self, "BOTTOM", 0, offset  and -offset or 0
	else
		return "BOTTOM", self, "TOP", 0, offset or 0
	end
end

function Clock:OnClick(button)
	if button == "RightButton" then
		ToggleCalendar()
	else
		ToggleTimeManager()
		if TimeManagerFrame:IsShown() then
			TimeManagerFrame:SetClampedToScreen()
			TimeManagerFrame:ClearAllPoints()
			TimeManagerFrame:SetPoint(GetTooltipPoint(self))
		end
	end
end

function Clock:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint(GetTooltipPoint(self))
	TimeManagerClockButton_UpdateTooltip()
end

function Clock:OnLeave()
	GameTooltip:Hide()
end

local INTERVAL, t = 1, 0
local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function(self, elapsed)
	t = t + elapsed
	if t > INTERVAL then
		local text = GameTime_GetTime(not GetCVarBool("timeMgrUseMilitaryTime"))
		if TimeManager_ShouldCheckAlarm() then
			TimeManager_CheckAlarm(elapsed)
		end
		if TimeManagerClockButton.alarmFiring then
			Clock.text = "*** " .. text .. " ***"
		else
			Clock.text = text
		end
		t = 0
	end
end)
