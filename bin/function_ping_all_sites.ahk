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
;    Function to be called from gui_run_function.ahk
;	 This function will perform the hard work - pinging all sites and
;	 collating the results.
;
*/
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

function_ping_all_sites(siteIP)
{	
	IPcheck := checkIP(siteIP)
	ifequal , IPCheck , 0
	{
		msgbox ,,, Each IP digit must be between 0 and 255 - script ending here
		exit
	}
	
	;BEGIN set up folder for files to go into - - - - - - - - - 
	basedrive = r:
	ifnotexist , %basedrive%
	{
		basedrive = c:
	}
	
	basefolder = %basedrive%\temp
	ifnotexist , %basefolder%
	{
		filecreatedir , %basefolder%
		if errorlevel
		{
			msgbox ,,, %basefolder% does not exist and could not be created - script ending here
			exit
		}
	}

	formattime , atime ,, yyyyMMddHHmmss
	stringsplit , IPSplit , siteIP , .
	SiteSubNet = %IPSplit1%.%IPSplit2%.%IPSplit3%
	pingFolder = %basefolder%\site_connection_test_%atime%_%SiteSubNet%
	filecreatedir ,%pingFolder%
	if errorlevel
	{
		msgbox ,,, %pingFolder% does not exist and could not be created - script ending here
		exit
	}
	;END set up folder for files to go into - - - - - - - - - 
	
	pingEachPossibleIP(pingFolder, SiteSubNet)
	sleep , 25000
	resultsFile = %pingFolder%\%SiteSubNet%.csv
	gatherResultsRaw(SiteSubNet, pingFolder, resultsFile)
	sleep , 2000
	notepad = C:\Program Files (x86)\Notepad++\notepad++.exe
	run , %notepad% %resultsFile%
	scriptEnd = Completed
	return scriptEnd
}

checkIP(siteIP)
{
	IPCheckBoolean := true
	stringsplit , IPSplit , siteIP , .
	ifnotequal , IPSplit1 , 10
	{
		msgbox ,,, The first digit in the IP address must be 10 - script ending here
		exit
	}
	loop , 3
	{
		thisIPpart := IPSplit%a_index%
		if thisIPpart is not integer
		{
			msgbox ,,, All digits of the IP address must be integers between 0 and 255 - script ending here
			exit
		}
		
		;checkIPPart
		ifless , thisIPpart , 0
		{
			IPCheckBoolean := false
		}
		ifgreater , thisIPpart , 255
		{
			IPCheckBoolean := false
		}		
	}
	return IPCheckBoolean
}

pingEachPossibleIP(pingFolder, SiteSubNet)
{
	loop , 256
	{
		thisIPsuffix := a_index
		thisIPsuffix--
		thisIP = %SiteSubNet%.%thisIPsuffix%
		run , %comspec% /c ping -i 255 -w 6000 -n 2 %thisIP% > %pingFolder%\%thisIP%.txt ,, Hide
	}
	return
}

gatherResultsRaw(SiteSubNet, pingFolder, resultsFile)
{
	anum = 0
	loop , 256
	{
		pingAddress = %SiteSubNet%.%anum%
		pingFile = %pingFolder%\%pingAddress%.txt
		filegetsize , pingfilesize , %pingFile%
		ifequal , pingfilesize , 0
		{
			sleep , 2000
		}
		ifnotexist , %pingFile%
		{
			pingOutput = No data attained for this IP
		}
		else
		{
			filereadline , pingOutput , %pingFile% , 4
		}		
		fileappend , %pingAddress%`, %pingOutput%`n, %resultsFile%
		anum++
	}
	
;	The below code ran through the files in Aphabetical order which 
;	is not the same as numerical order, which looks nicer
/*
	loop , %pingFolder%\*.txt
	{
		filegetsize , pingfilesize , %a_loopefilename%
		ifequal , pingfilesize , 0
		{
			sleep , 2000
		}
		stringleft , pingfilecheck , a_loopfilename , 3
		ifnotequal , pingfilecheck , 10.
		{
			continue		
		}
		filereadline , pingOutput , %a_loopfilefullpath% , 4
		stringtrimright , thisIP , a_loopfilename , 4
		fileappend , %thisIP%`, %pingOutput%`n, %resultsFile%
	}
*/
	return
}
