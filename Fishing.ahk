﻿#Requires AutoHotkey v2.0
#SingleInstance Force

global MaxFishingTries := 10     ; In Seconds
global MaxPerfectTries := 20   ; In Seconds

global FishingPromptLocation := [840, 738]
global PerfectPromptLocation := [900, 732]

global PromptColors := [0x333333, 0xBCBCBC, 0xBCBCBB, 0xFFFFFF]

f3::
{
	bait := ""
	while(!isInteger(bait)) {
		input := InputBox("The script is now running.`nPress F4 to stop the script.`n`nHow much bait do you want to try and use:", "Auto Fishing", "", 500)
		if(input.Result = "Cancel")
			bait := 0
		else
			bait := input.value
	}
	if(bait>=0)
		startFishing(bait)
}
f4::
{
	MsgBox("The script has been stopped.", "Auto Fishing", "Iconi T2")
	Reload
}

startFishing(bait:= 500){
	current := 0
	while(current < bait){
		current++
		ToolTip(Format("Looking for Fishing Prompt: {1}/{2}...", current, bait), 10, 10)
		if (!watchForFishingPrompt()){
			MsgBox("Unable to fish here.`nScript has been stopped.", "Auto Fishing", "Iconx")
			Reload 
		}
		ToolTip(Format("Fishing with bait: {1}/{2}...", current, bait), 10, 10)
		castLine()
		if (watchForPerfect())
			Send "{e}"
	}
	
	ToolTip(Format("Done Fishing with {1} bait(s).", bait), 10, 10)
}

watchForFishingPrompt(){
	global

	loop MaxFishingTries{
		Color := PixelGetColor(FishingPromptLocation[1], FishingPromptLocation[2])	
		if (HasVal(PromptColors, Color))
			return true
		Sleep(1000)
	}
	return false	
}

castLine(){
	Send "{e Down}"
	Sleep 750
	Send "{e Up}"
}

watchForPerfect(){
	global

	looping := true
	tries := 0
	loop MaxPerfectTries * 100 {
		Color := PixelGetColor(PerfectPromptLocation[1], PerfectPromptLocation[2])		
		if (HasVal(PromptColors, Color)) {
			return true
		}
		Sleep 10
	}
	return false
}

HasVal(haystack, needle) {
	for index, value in haystack
		if (value = needle)
			return true
	return false
}