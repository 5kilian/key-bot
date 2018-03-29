#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <misc.au3>

Local $gui = GUICreate("Tims Key Bot", 200, 100)
GUICtrlCreateLabel("Key", 40, 10)
GUICtrlCreateLabel("Freq", 135, 10)
Local $key = GUICtrlCreateInput("1", 20, 30, 70, 20)
Local $freq = GUICtrlCreateInput("5.000", 110, 30, 70, 20)
GUICtrlCreateUpDown($freq)

Local $run = GUICtrlCreateButton("Run", 65, 60, 70, 20)

Local $stopText = GUICtrlCreateLabel("Stop with Ecs", 70, 80)
Local $pressKey = GUICtrlCreateLabel("Press the key you need.", 30, 80)
GUICtrlSetState($pressKey, $GUI_HIDE)
GUICtrlSetState($stopText, $GUI_HIDE)

GUISetState(@SW_SHOW, $gui)

Local $running = false
Local $timer = TimerInit()
Local $sleeptime = 5000;
Local $currentKey = "1";

HotKeySet("{Esc}", "captureEsc")

Local $Keycodes = StringSplit("01|02|04|05|06" & _
    "|08|09|0C|0D|10|11|12|13|14|1B|20|21|22" & _
    "|23|24|25|26|27|28|29|2A|2B|2C|2D|2E|30" & _
    "|31|32|33|34|35|36|37|38|39|41|42|43|44" & _
    "|45|46|47|48|49|4A|4B|4C|4D|4E|4F|50|51" & _
    "|52|53|54|55|56|57|58|59|5A|5B|5C|60|61" & _
    "|62|63|64|65|66|67|68|69|6A|6B|6C|6D|6E" & _
    "|6F|70|71|72|73|74|75|76|77|78|79|7A|7B" & _
    "|90|91|A0|A1|A2|A3|A4|A5", "|")

While 1
   $msg = GUIGetMsg()

   If $running Then
	  If TimerDiff($timer) > $sleeptime Then
		 $currentKey = StringRight($currentInput, 1)
		 Send($currentKey)
		 $timer = TimerInit()
	  EndIf
   EndIf

   $currentInput = String(GUICtrlRead($key));
   If Stringlen($currentInput) > 1 Then
	  $currentKey = StringRight($currentInput, 1)
	  GUICtrlSetData($key, $currentKey)
   EndIf

   Switch $msg
;	  Case $key
;		 GUICtrlSetState($run, $GUI_DISABLE)
;		 GUICtrlSetState($pressKey, $GUI_SHOW)
	  Case $run
		 $running = Not $running
		 handleRunning()
		 $sleeptime = GUICtrlRead($freq) * 1000;
	  Case $GUI_EVENT_CLOSE
		 ExitLoop
   EndSwitch
WEnd

Func captureEsc()
   $running = false
   handleRunning()
EndFunc

Func handleRunning()
   If $running Then
	  GUICtrlSetState($stopText, $GUI_SHOW)
	  GUICtrlSetState($key, $GUI_DISABLE)
	  GUICtrlSetState($freq, $GUI_DISABLE)
	  GUICtrlSetData($run, "Stop")
   Else
	  GUICtrlSetState($stopText, $GUI_HIDE)
	  GUICtrlSetState($key, $GUI_ENABLE)
	  GUICtrlSetState($freq, $GUI_ENABLE)
	  GUICtrlSetData($run, "Run")
	  $timer = TimerInit()
   EndIf
EndFunc

Func chooseKey()
   $keyPressed = false
   Do
	  For $i in $Keycodes
		 If _IsPressed(String($i)) Then
			$currentKey = String($i)
			$keyPressed = true
			ExitLoop
		 EndIf
	  Next
   Until $keyPressed
   GUICtrlSetData($key, $currentKey)
   GUICtrlSetState($pressKey, $GUI_HIDE)
   GUICtrlSetState($run, $GUI_ENABLE)
EndFunc