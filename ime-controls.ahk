#Requires AutoHotkey v2.0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; IME controls
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; IME Library
;;; https://github.com/kdr-s/ime.ahk-v2
#Include "IME.ahk"

;;; IME controls works only on the local machine
#HotIf !WinActive("ahk_group Remote")

;;; Alt -> IME On/Off
*~RAlt::Send "{Blind}{vk07}"
RAlt up::
{
    if (A_PriorHotkey == "*~RAlt" && (A_PriorKey == "RAlt" || A_PriorKey == "")) {
        IME_SET(1)
    }
    Return
}

*~LAlt::Send "{Blind}{vk07}"
LAlt up::
{
    if (A_PriorHotkey == "*~LAlt" && (A_PriorKey == "LAlt" || A_PriorKey == "")) {
        IME_SET(0)
    }
    Return
}

;;; 変換/無変換 -> Alt + IME On/OFF
;vk1Csc079	変換
;vk1Dsc07B	無変換

*sc079::Send "{Blind}{RAlt down}{vk07}"
*sc079 up::
{
    Send "{Blind}{RAlt up}"
    if (A_PriorHotkey == "*sc079" && (A_PriorKey == "sc079" || A_PriorKey == "")) {
        IME_SET(1)
    }
    Return
}

*sc07B::Send "{Blind}{LAlt down}{vk07}"
*sc07B up::
{
    Send "{Blind}{LAlt up}"
    if (A_PriorHotkey == "*sc07B" && (A_PriorKey == "sc07B" || A_PriorKey == "")) {
        IME_SET(0)
    }
    Return
}

#HotIf
