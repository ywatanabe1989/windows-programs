#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Global variables to store the two most recent window IDs
global window1 := ""
global window2 := ""

; Set up a timer to check for window activation every 100ms
SetTimer, CheckActiveWindow, 100

; Hotkey Win+S to swap windows
#s::SwapWindows()

CheckActiveWindow:
    WinGetActiveStats, title, width, height, x, y
    WinGet, activeID, ID, A
    
    if (activeID != window1 and activeID != window2)
    {
        window2 := window1
        window1 := activeID
    }
return

SwapWindows()
{
    if (window1 != "" and window2 != "")
    {
        ; Get positions of both windows
        WinGetPos, x1, y1,,, ahk_id %window1%
        WinGetPos, x2, y2,,, ahk_id %window2%
        
        ; Swap positions
        WinMove, ahk_id %window1%,, x2, y2
        WinMove, ahk_id %window2%,, x1, y1
        
        ; Get process names for the message
        WinGet, process1, ProcessName, ahk_id %window1%
        WinGet, process2, ProcessName, ahk_id %window2%
        
        ; MsgBox, Swapped %process1% with %process2%
    }
    else
    {
        ; MsgBox, Not enough windows activated yet.
    }
}
