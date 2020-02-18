#cs
	TODO
	* Preferences



#ce

; Immer einbinden?
#include <Array.au3>
#include <string.au3>
#include <WinAPIFiles.au3>
#include <TrayConstants.au3>
;private files
#include "funcs.au3"
; GUI
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=c:\users\markus\onedrive\autoit\auto-clicker\forms\clicker.kxf
$Form1_1 = GUICreate("Auto-Clicker", 733, 463, 414, 180)
$Button1 = GUICtrlCreateButton("Start", 608, 410, 92, 31)
$Input1 = GUICtrlCreateInput("1000", 30, 20, 99, 24)
$Label1 = GUICtrlCreateLabel("ms Step", 138, 20, 63, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Start/Stop: F3", 490, 410, 104, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Input2 = GUICtrlCreateInput("100", 30, 59, 99, 24)
$Label3 = GUICtrlCreateLabel("ms random", 138, 59, 83, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$times = GUICtrlCreateInput("0", 414, 20, 40, 24)
$Label4 = GUICtrlCreateLabel("Execute:", 335, 20, 66, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label5 = GUICtrlCreateLabel("times; 0 = infinte", 463, 20, 119, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Input3 = GUICtrlCreateInput("5000", 486, 362, 99, 24)
$ms = GUICtrlCreateLabel("ms start delay", 594, 362, 102, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label6 = GUICtrlCreateLabel("Preferences:", 305, 69, 94, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$dropdown = GUICtrlCreateCombo("Last Used", 414, 69, 139, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
$loadbtn = GUICtrlCreateButton("Load", 561, 69, 70, 31)
$progress = GUICtrlCreateProgress(134, 404, 336, 30)
$Checkbox1 = GUICtrlCreateCheckbox("2. Click:", 32, 160, 97, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$step2 = GUICtrlCreateInput("1000", 30, 196, 99, 24)
$Label7 = GUICtrlCreateLabel("ms Step", 138, 196, 63, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$random2 = GUICtrlCreateInput("100", 30, 235, 99, 24)
$Label8 = GUICtrlCreateLabel("ms random", 138, 235, 83, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
; END GUI
AutoItSetOption("GUICloseOnESC", 0)

Global $running = 0 ;
Global $ini_path = "settings.ini"
Global $start = 0 ;

;Read ini file
readPref("LastUse")
updateCombo($dropdown, readSections())

; ESC detect
HotKeySet("{F3}", "captureEsc")

;gui events
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Button1
			;Button
			buttonClicked()

		Case $loadbtn
			;Load BTN
			loadPre()

	EndSwitch
WEnd

Func captureEsc()
	; ... can do stuff here
	;stopClick()
	buttonClicked()
EndFunc   ;==>captureEsc

; button clicked
Func buttonClicked()
	If $running == 0 Then

		$delay = GUICtrlRead($Input1)
		$random = GUICtrlRead($Input2)
		$times = GUICtrlRead($times)
		$start_time = GUICtrlRead($Input3)

		$stp2 = GUICtrlRead($step2)
		$rnd2 = GUICtrlRead($random2)
		if GUICtrlRead($Checkbox1) == $GUI_CHECKED THEN
			$click2 = true
		Else
			$click2 = false
		EndIf


		GUICtrlSetData($Button1, "Stop")
		;GUICtrlSetData($output, "started")
		startClick($delay, $random, $times, $start_time, $click2, $stp2, $rnd2)


	Else

		stopClick()
	EndIf

EndFunc   ;==>buttonClicked

;start clicker
Func startClick($stp1, $random, $times, $start_time, $click2, $stp2, $rnd2)
	;GUICtrlSetData($output, "s: " & $start_time)

	;save settings (last used)
	savePref("LastUse", $stp1, $random, $times, $start_time)
	tool("Clicker started. ", "Stop the clicker with F3.")
	$start = TimerInit()

	$running = 1 ;
	If $times == 0 Then $times = 100000
	If $random >= $stp1 Then $random = $random / 4 ;
	_sleep($start_time)

	For $i = 1 To $times Step +1
		;GUICtrlSetData($output, "loop: " & $i)
		If $running == 1 Then
			MouseClick("Left") ;cliccck
			$extra = Random(-$random, $random, 1) ;random value
			$special = Random(0, 100, 1) ;get special number
			_sleep($stp1 + $extra) ;sleep normal time
			If $special < 10 Then _sleep($stp1 / 2 + $extra * 2) ;in 10% of cases there is some extra time

			If $click2 == true THEN
				MouseClick("Left") ;cliccck
				$extra = Random(-$rnd2, $rnd2, 1) ;random value
				$special = Random(0, 100, 1) ;get special number
				_sleep($stp2 + $extra) ;sleep normal time (2nd)
				If $special < 10 Then _sleep($stp2 / 2 + $extra * 2)
			EndIf
		Else
			Return
		EndIf


	Next

	stopClick()

EndFunc   ;==>startClick

;stop clickern
Func stopClick()

	$running = 0 ;
	;GUICtrlSetData($output, "stopped")
	GUICtrlSetData($Button1, "Start")
	GUICtrlSetData($progress, 0)
	$time = Ceiling(TimerDiff($start) / 1000)
	tool("Clicker stopped. ", $time & " seconds passed")

EndFunc   ;==>stopClick

;sleep with interrupts
Func _sleep($dur)
	;If $running == 1 then
	;	Return
	;else
	;	$running = 1
	;EndIf

	If $dur > 100 Then
		$rest = Mod($dur, 100)
		$nums = Floor($dur / 100)

		For $j = 1 To $nums Step +1
			If $running == 0 Then
				;GUICtrlSetData($output, "exit!")
				Return
			Else
				Sleep(100)
				$percent = Round(100 * (100 * $j) / $dur)
				GUICtrlSetData($progress, $percent)
				;GUICtrlSetData($output, "zzz: " & $j)
			EndIf
		Next
		Sleep($rest)
		GUICtrlSetData($progress, 100)
	Else
		Sleep($dur)
	EndIf
	GUICtrlSetData($progress, 0)
EndFunc   ;==>_sleep


Func savePref($cat, $delay, $random, $times, $start_time)

	IniWrite($ini_path, $cat, "step", $delay)
	IniWrite($ini_path, $cat, "random", $random)
	IniWrite($ini_path, $cat, "times", $times)
	IniWrite($ini_path, $cat, "delay", $start_time)

EndFunc   ;==>savePref

Func readPref($cat)
	$array = IniReadSection($ini_path, $cat)

	If @error == 0 Then

		GUICtrlSetData($Input1, $array[1][1]) ;delay
		GUICtrlSetData($Input2, $array[2][1]) ;random
		GUICtrlSetData($times, $array[3][1]) ;times
		GUICtrlSetData($Input3, $array[4][1]) ; start_time

	EndIf

EndFunc   ;==>readPref

Func readSections()
	$array = IniReadSectionNames($ini_path)

	If @error == 0 Then Return $array

	Return 0 ;

EndFunc   ;==>readSections

Func updateCombo($comb, $array)

	If ($array == 0) Then
		$line = "Preset"
	Else
		$line = "" ;
		For $i = 1 To $array[0] Step +1
			If $i > 1 Then $line = $line & "|"
			$line = $line & $array[$i]

		Next
	EndIf

	GUICtrlSetData($comb, $line)

EndFunc   ;==>updateCombo

Func loadPre()
	$cat = GUICtrlRead($dropdown)
	readPref($cat)

EndFunc   ;==>loadPre
