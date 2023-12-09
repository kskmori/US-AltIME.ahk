#Requires AutoHotkey v2.0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; IME controls
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; IME Library
;;; https://github.com/kdr-s/ime.ahk-v2
#Include "IME.ahk"

;;; IME controls works only on the local machine
#HotIf !WinActive("ahk_group Remote")

;;; note:
;;; {vkE8} is sent to prevent the menu bar from activating when Alt is hit.
;;; {vk07} was used in alt-ime-ahk.ahk for this purpose,
;;;   but now vk07 can be used by Windows according to the AutoHotKey doc:
;;;   https://www.autohotkey.com/docs/v2/lib/A_MenuMaskKey.htm#Remarks

;;; Alt -> IME On/Off
*~RAlt::Send "{Blind}{vkE8}"
RAlt up::
{
    if (A_PriorHotkey == "*~RAlt" && (A_PriorKey == "RAlt" || A_PriorKey == "")) {
        IME_SET(1)
    }
    Return
}

*~LAlt::Send "{Blind}{vkE8}"
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

*sc079::Send "{Blind}{RAlt down}{vkE8}"
*sc079 up::
{
    Send "{Blind}{RAlt up}"
    if (A_PriorHotkey == "*sc079" && (A_PriorKey == "sc079" || A_PriorKey == "")) {
        IME_SET(1)
    }
    Return
}

*sc07B::Send "{Blind}{LAlt down}{vkE8}"
*sc07B up::
{
    Send "{Blind}{LAlt up}"
    if (A_PriorHotkey == "*sc07B" && (A_PriorKey == "sc07B" || A_PriorKey == "")) {
        IME_SET(0)
    }
    Return
}

#HotIf
