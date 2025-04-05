#Persistent ; Keep the script running
SetTimer, HideTaskbar, 100 ; Check every 100 milliseconds
return

HideTaskbar:
WinHide, ahk_class Shell_TrayWnd ; Hide the taskbar
return
