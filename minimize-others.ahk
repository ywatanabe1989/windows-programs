; minimize-others.ahk
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

^!m::
WinGet, activeWindow, ID, A
WinGetClass, activeClass, ahk_id %activeWindow%
WinMinimizeAll
WinActivate, ahk_class %activeClass%
return
