#Requires AutoHotkey v2.0
InstallKeybdHook
;#UseHook


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Options
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Default options values
OPTS_JIS2US := True
OPTS_REMOTE := False
OPTS_ESCAPE := 1
OPTS_US101 := False
OPTS_CAPS  := False
OPTS_DEBUG := !A_IsCompiled


Parse_OPTS() {
    global
    for arg in A_Args {
        switch arg {
          case "/N":  OPTS_JIS2US := False
          case "/R":  OPTS_REMOTE := True
          case "/E1": OPTS_ESCAPE := 1
          case "/E2": OPTS_ESCAPE := 2
          case "/E3": OPTS_ESCAPE := 3
          case "/U":  OPTS_US101  := True
          case "/C":  OPTS_CAPS   := True
          case "/D":  OPTS_DEBUG  := True
        }
    }
}

Get_OPTS_args() {
    global
    opts := ""
    opts .= OPTS_JIS2US ? "" : " /N"
    opts .= OPTS_REMOTE ? " /R" : ""
    opts .= (OPTS_ESCAPE >=2 && OPTS_ESCAPE <= 3) ? " /E" OPTS_ESCAPE : ""
    opts .= OPTS_US101  ? " /U" : ""
    opts .= OPTS_CAPS   ? " /C" : ""
    opts .= OPTS_DEBUG  ? " /D" : ""
    return opts
}

Reload_OPTS() {
    new_args := Get_OPTS_args()
    if (OPTS_DEBUG) {
        MsgBox "Reload_OPTS : new_args = " new_args
    }

   if (A_IsCompiled) {
        Run Format('"{1}" /force /restart {2}', A_ScriptFullPath, new_args)
    } else {
        Run Format('"{1}" /force /restart "{2}" {3}', A_AhkPath, A_ScriptFullPath, new_args)
    }
    ExitApp
}

Parse_OPTS()

#HotIf OPTS_DEBUG
F12::Reload_OPTS()
F11::KeyHistory
#HotIf


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SubMenuEsc := Menu()
SubMenuEsc.Add("No changes", HandlerEscape)
SubMenuEsc.Add("swap ESC and ``", HandlerEscape)
SubMenuEsc.Add("change `` to ESC , ] to ``", HandlerEscape)

A_TrayMenu.Delete()
A_TrayMenu.Add("JIS2US mode", HandlerJIS2US)
A_TrayMenu.Add("Escape Key", SubMenuEsc)
A_TrayMenu.Add("Enable on Remote", HandlerRemote)
if (OPTS_DEBUG) {
  A_TrayMenu.Add("US101 mode", HandlerUS101)
  A_TrayMenu.Add("CAPS to Ctrl", HandlerCaps)
}
A_TrayMenu.Add()
A_TrayMenu.AddStandard()

AdjustCheckStatus(menu, item, status) {
  if (status) {
    menu.Check(item)
  } else {
    menu.Uncheck(item)
  }
}

AdjustCheckStatus(A_TrayMenu, "JIS2US mode", OPTS_JIS2US)
AdjustCheckStatus(A_TrayMenu, "Enable on Remote", OPTS_REMOTE)
AdjustCheckStatus(SubMenuEsc, OPTS_ESCAPE . "&", True)
if (OPTS_DEBUG) {
  AdjustCheckStatus(A_TrayMenu, "US101 mode", OPTS_US101)
  AdjustCheckStatus(A_TrayMenu, "CAPS to Ctrl", OPTS_CAPS)
}

HandlerJIS2US(ItemName, ItemPos, MyMenu) {
    global OPTS_JIS2US
    OPTS_JIS2US := ! OPTS_JIS2US
    AdjustCheckStatus(MyMenu, ItemName, OPTS_JIS2US)
    Reload_OPTS()
}

HandlerRemote(ItemName, ItemPos, MyMenu) {
    global OPTS_REMOTE
    OPTS_REMOTE := ! OPTS_REMOTE
    AdjustCheckStatus(MyMenu, ItemName, OPTS_REMOTE)
    Reload_OPTS()
}

HandlerEscape(ItemName, ItemPos, MyMenu) {
    global OPTS_ESCAPE
    if (ItemPos >= 1 & ItemPos <= 3) {
        OPTS_ESCAPE := ItemPos
        AdjustCheckStatus(MyMenu, "1&", OPTS_ESCAPE == 1)
        AdjustCheckStatus(MyMenu, "2&", OPTS_ESCAPE == 2)
        AdjustCheckStatus(MyMenu, "3&", OPTS_ESCAPE == 3)
    }
}

HandlerUS101(ItemName, ItemPos, MyMenu) {
    global OPTS_US101
    OPTS_US101 := ! OPTS_US101
    AdjustCheckStatus(MyMenu, ItemName, OPTS_US101)
    Reload_OPTS()
}
HandlerCaps(ItemName, ItemPos, MyMenu) {
    global OPTS_CAPS
    OPTS_CAPS := ! OPTS_CAPS
    AdjustCheckStatus(MyMenu, ItemName, OPTS_CAPS)
    if (OPTS_CAPS)
        MsgBox "WARN: Do not enable this on Japanese keyboard `n Try to hit Ctrl key to release if Ctrl keeps enabled"
    Reload_OPTS()
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Remote Desktop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GroupAdd "Remote", "ahk_class TscShellContainerClass"
GroupAdd "Remote", "ahk_class Transparent Windows Client" ; ahk_exe wfica32.exe
GroupAdd "Remote", "ahk_class MC_MSTSC"

GroupAdd "AllWindows"

if (OPTS_US101) {
  GroupAdd "DisableJIS2US", "ahk_group AllWindows"
  if (!OPTS_JIS2US) {
      GroupAdd "DisableUS101", "ahk_group AllWindows"
  }
  if (!OPTS_REMOTE) {
      GroupAdd "DisableUS101", "ahk_group Remote"
  }
} else {
  GroupAdd "DisableUS101", "ahk_group AllWindows"
  if (!OPTS_JIS2US) {
      GroupAdd "DisableJIS2US", "ahk_group AllWindows"
  }
  if (!OPTS_REMOTE) {
      GroupAdd "DisableJIS2US", "ahk_group Remote"
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; JIS to US keyboard conversion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#HotIf !WinActive("ahk_group DisableJIS2US")

;;; 1st row
+2::Send "{@}"		; " -> @
+6::Send "{^}"		; & -> ^
+7::Send "{&}"		; ' -> &
+8::Send "{*}"		; ( -> *
+9::Send "{(}"		; ) -> (
+0::Send "{)}"		;   -> )
+-::Send "{_}"		; = -> _n
 ^::Send "{=}"		; ^ -> =
+^::Send "{+}"		; ~ -> +

;;; 2nd row
 @::Send "{[}"		; @ -> [
+@::Send "{{}"		; ` -> {
 [::Send "{]}"		; [ -> ]
+[::Send "{}}"		; { -> }

;;; 3rd row
+;::Send "{:}"		; + -> :
 :::Send "{'}"		; : -> '
 *::Send "{`"}"		; * -> "



#HotIf !WinActive("ahk_group DisableJIS2US") and OPTS_ESCAPE == 1
;;; for US external keyboard - match to the US keytops
 ]::Send "{\}"		; ] -> \
+]::Send "{|}"		; } -> |
 sc029::Send "{``}"	; 漢字 -> `
+sc029::Send "{~}"	; 漢字 -> ~

#HotIf !WinActive("ahk_group DisableJIS2US") and OPTS_ESCAPE == 2
;;; swap ESC and `~ only
 ]::Send "{\}"		; ] -> \
+]::Send "{|}"		; } -> |
*sc029::Send "{Blind}{Esc}"	; 漢字 -> Escape
 Esc::Send "{``}"
+Esc::Send "{~}"

#HotIf !WinActive("ahk_group DisableJIS2US") and OPTS_ESCAPE == 3
;;; for jp106
 ]::Send "{``}"		; ] -> `
+]::Send "{~}"		; } -> ~
*sc029::Send "{Blind}{Esc}"	; 漢字 -> Escape

#HotIf

;;; Disable ひらがな/カタカナ
;vkF2sc070	ひらがな/カタカナ
*sc070::Return

;;; Disable 英数 / CapsLock
;vkF0sc03A	英数（CapsLock）
;vk14sc03A      CapsLock
*sc03A::Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; US101 keyboard driver mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#HotIf !WinActive("ahk_group DisableUS101")
; JP106              / US101
; vkF4sc029 半角全角 / vkC0sc029 `~
; vkDDsc02B ]}       / vkDCsc02B \|
; vkDCsc07D \|       / vkFFsc07D (none)
; vkE2sc073 \_       / vkC1sc073 (none)

 sc07D::Send "{\}"	; \ -> \
+sc07D::Send "{|}"	; | -> |
 sc073::Send "{\}"	; \ -> \
+sc073::Send "{_}"	; _ -> |

#HotIf !WinActive("ahk_group DisableUS101") and OPTS_ESCAPE == 1
;;; No changes
 ~sc02B::Return		; ] -> \
+~sc02B::Return		; } -> |
 ~sc029::Return		; 漢字 -> `
+~sc029::Return		; 漢字 -> ~

#HotIf !WinActive("ahk_group DisableUS101") and OPTS_ESCAPE == 2
;;; swap ESC and `~ only
 ~sc02B::Return		; ] -> \
+~sc02B::Return		; } -> |
*sc029::Send "{Blind}{Esc}"	; 漢字 -> Escape
 Esc::Send "{``}"
+Esc::Send "{~}"

#HotIf !WinActive("ahk_group DisableUS101") and OPTS_ESCAPE == 3
;;; for jp106
 sc02B::Send "{``}"		; ] -> `
+sc02B::Send "{~}"		; } -> ~
*sc029::Send "{Blind}{Esc}"	; 漢字 -> Escape

#HotIf

;; CAPS to Ctrl
;; for US101 kbd driver only - do not use with regular JP106 kbd driver
#HotIf OPTS_CAPS
*sc03A::Ctrl
#HotIf


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
