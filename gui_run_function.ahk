/*﻿
;Best viewed in Notepad++ with the AHK syntax file installed.
;This file runs through AutoHotkey a highly versatile freeware scripting program.
;
; AutoHotkey Version: 104805
; Language:       English
; Platform:       Windows 7
; Author:         staid03
; Version   Date        Author       Comments
;     0.1   06-MAY-18   staid03      Initial
;
; Script Function:
;    GUI to be the interface to run the function for pinging all sites
;	 on a particular subnet assuming /24 range and 10. prefix.
;
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#singleinstance , force

notepad = C:\Program Files (x86)\Notepad++\notepad++.exe

;gui , color , 98fb98
gui , add , picture , x0 y0 h220 w390 , %a_scriptdir%\bin\background.jpeg
gui , font , s22
gui , add , edit , x80 y25 w220 vSiteIP , 10.20.20.15
gui , add , button , x30 y85 , Site Connection Check
gui , font , s12
gui , add , button , x30 y165 , Edit this script
gui , add , button , x155 y165 , Re-run this script
gui , add , button , x300 y165 , About
gui , show
return

buttonSiteConnectionCheck:
{
	gui , submit , nohide
	
	#Include bin\function_ping_all_sites.ahk
	
	scriptEnd := function_ping_all_sites(siteIP)	
	msgbox ,,, %a_scriptname% %scriptEnd%
}
return

buttonEditThisScript:
{
	ifexist , %notepad%
	{
		run , %notepad% %a_scriptname%
	}
	else
	{
		msgbox ,,, %notepad% does not exist - script ending here
		exit
	}
}
return

buttonRe-runthisscript:
{
	run , %a_scriptname%
}
return
