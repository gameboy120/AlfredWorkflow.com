#!/usr/bin/osascript
#Bilal Syed Hussain
-- based of https://github.com/qlassiqa/alfred-workflow
on run argv
	set workflowFolder to do shell script "pwd"
	
	set w to load script POSIX file (workflowFolder & "/workflow.scpt")
	--set w to load script POSIX file ("/Users/bilalh/Dropbox/Settings/Alfred/Alfred.alfredpreferences/workflows/user.workflow.04A18A78-FE3E-4C20-9D98-C187F7DC0BE6/workflow.scpt")
	
	set wf to w's new_workflow()
	set q to ""
	try
		set q to w's q_trim(item 1 of argv)
		if q ≠ "" then
			set q to item 1 of argv as number
			if q < 0 then set q to ""
			if q > 5 then set q to ""
			if (q as integer) - q ≠ 0 and 2 * q mod 2 ≠ 1 then set q to ""
		end if
		
	on error
		set q to ""
	end try
	
	if q is "" then
		
		repeat with i from 0 to 5
			set s to " stars"
			if i = 1 then set s to " star"
			
			get_result of wf with isValid given theUid:"", theArg:i, theTitle:make_stars(20 * i), theAutocomplete:"", theSubtitle:"Sets the current rating to " & i & s, theIcon:"icons/" & i & ".png", theType:""
			
			if i > 2 and i < 5 then
				get_result of wf with isValid given theUid:"", theArg:i + 0.5, theTitle:make_stars(20 * i + 10), theAutocomplete:"", theSubtitle:"Sets the current rating to " & i & "½ stars", theIcon:"icons/" & i + 1 & ".png", theType:""
			end if
			
		end repeat
		
	else
		set r to q as integer
		get_result of wf with isValid given theUid:"", theArg:q, theTitle:make_stars(20 * q), theAutocomplete:"", theSubtitle:"Sets the current rating to " & q & " stars", theIcon:"icons/" & r & ".png", theType:""
	end if
	
	tell application "iTunes"
		set oldrating to ((rating of current track) / 20) as number
		set fulltrack to (artist of current track) & " - " & (name of current track) & " - " & (album of current track)
	end tell
	
	
	get_result of wf without isValid given theUid:"x", theArg:missing value, theTitle:"Current Rating: " & (oldrating as text) & " stars", theAutocomplete:"", theSubtitle:fulltrack, theIcon:"icon.png", theType:""
	wf's to_xml("")
	
end run

on make_stars(rating)
	set ret to "" as Unicode text
	set stars to rating div 20
	set half to rating mod 20 = 10
	repeat with i from 1 to stars
		set ret to ret & "★"
	end repeat
	if half then set ret to ret & "½"
	if ret = "" then set ret to "No stars"
	return ret
end make_stars