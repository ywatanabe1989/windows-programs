
#Persistent
#SingleInstance Force
; ----------------------------------------
; Constants
; ----------------------------------------
; File to monitor
syncFile := "C:\Users\wyusu\Documents\wsl-sync.txt"
; Wait time constants (in milliseconds)
waitActivate := 300
waitAfterSelect := 30
waitAfterPaste := 30
waitBeforeReturn := 50
waitAfterKeyRelease := 30
waitAfterTerminalActivate := 30
; Variables to track the last active window
global lastActiveWindow := ""
global lastTwoWindows := []
global terminalWindowTitle := ""
; Get initial file modification time
FileGetTime, lastModified, %syncFile%, M
; Track active windows before switching to terminal
SetTimer, TrackActiveWindow, 100
; Check file for changes
SetTimer, CheckFileChanges, 100
return
TrackActiveWindow:
; Get current window information
WinGetTitle, currentWindow, A
; Skip if title is empty
if (currentWindow = "")
    return
; Save the terminal window title when in it
if (InStr(currentWindow, "WSL") || InStr(currentWindow, "Ubuntu") || InStr(currentWindow, "Emacs")) {
    terminalWindowTitle := currentWindow
    return
}
; Store the active window that's not terminal
if (currentWindow != lastActiveWindow) {
    ; Shift the window history
    if (lastActiveWindow != "") {
        lastTwoWindows[2] := lastTwoWindows[1]
        lastTwoWindows[1] := lastActiveWindow
    }
    lastActiveWindow := currentWindow
}
return
CheckFileChanges:
; Check if file modification time has changed
FileGetTime, currentModified, %syncFile%, M
if (currentModified != lastModified) {
    ; File has been updated, read content
    FileRead, fileContent, %syncFile%
    ; If we have a last active window, send text there
    if (lastActiveWindow != "" && !InStr(lastActiveWindow, "WSL") && !InStr(lastActiveWindow, "Ubuntu") && !InStr(lastActiveWindow, "Emacs")) {
        ; Activate the window that had focus
        WinActivate, %lastActiveWindow%
        ; Wait for window to fully activate
        Sleep, waitActivate
        ; Select all existing content first with visual feedback - repeat 3 times
        Loop, 3 {
            SendInput, ^a
            Sleep, waitAfterSelect
            SendInput, {Home}
            Sleep, 100
        }
        ; Final selection to paste into
        SendInput, ^a
        Sleep, waitAfterSelect
        ; Show window list selection dialog
        windowList := "Current: " . lastActiveWindow
        if (lastTwoWindows[1] != "") {
            windowList .= "`nPrevious: " . lastTwoWindows[1]
        }
        if (lastTwoWindows[2] != "") {
            windowList .= "`nOlder: " . lastTwoWindows[2]
        }
        MsgBox, 4, Select Target Window, %windowList%`n`nSelected area will be replaced with content from sync file. Continue?
        IfMsgBox, No
        {
            ; If "No" is clicked or X is pressed, activate the terminal window again
            if (terminalWindowTitle != "") {
                ; Release any potentially held modifier keys
                Send {Ctrl up}{Shift up}{Alt up}
                Sleep, waitAfterKeyRelease
                WinActivate, %terminalWindowTitle%
                Sleep, waitAfterTerminalActivate
            }
            ; Update the last modified time to avoid reprocessing
            lastModified := currentModified
            return
        }
        ; Copy content to clipboard and use paste instead of typing
        clipboard := fileContent
        ClipWait, 2  ; Wait for clipboard to contain data (timeout 2 seconds)
        SendInput, ^v
        Sleep, waitAfterPaste
        ; Give extra time to ensure paste is processed
        Sleep, waitBeforeReturn
        ; Activate the terminal window again if we have its title
        if (terminalWindowTitle != "") {
            ; Release any potentially held modifier keys
            Send {Ctrl up}{Shift up}{Alt up}
            Sleep, waitAfterKeyRelease
            WinActivate, %terminalWindowTitle%
            Sleep, waitAfterTerminalActivate
        }
    }
    ; Update the last modified time
    lastModified := currentModified
}
return
