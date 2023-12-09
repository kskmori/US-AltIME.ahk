#Requires AutoHotkey v2.0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Options
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Default options values
OPTS_ENABLE := True
OPTS_REMOTE := False
OPTS_ESCAPE := 1
OPTS_US101 := False
OPTS_CAPS  := False
OPTS_DEBUG := !A_IsCompiled


Parse_OPTS() {
    global
    for arg in A_Args {
        switch arg {
          case "/N":  OPTS_ENABLE := False
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
    opts .= OPTS_ENABLE ? "" : " /N"
    opts .= OPTS_REMOTE ? " /R" : ""
    opts .= (OPTS_ESCAPE >=2 && OPTS_ESCAPE <= 3) ? " /E" OPTS_ESCAPE : ""
    opts .= OPTS_US101  ? " /U" : ""
    opts .= OPTS_CAPS   ? " /C" : ""
    opts .= OPTS_DEBUG  ? " /D" : ""
    return opts
}

Reload_OPTS() {
    new_args := Get_OPTS_args()
;    if (OPTS_DEBUG) {
;        MsgBox "Reload_OPTS : new_args = " new_args
;    }

   if (A_IsCompiled) {
        Run Format('"{1}" /force /restart {2}', A_ScriptFullPath, new_args)
    } else {
        Run Format('"{1}" /force /restart "{2}" {3}', A_AhkPath, A_ScriptFullPath, new_args)
    }
    ExitApp
}

Parse_OPTS()

#HotIf OPTS_DEBUG
 F12::KeyHistory
^F12::Reload_OPTS()
#HotIf


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if (!OPTS_US101) {
  MENU_MODE := "JIS2US mode"
} else {
  MENU_MODE := "US101 mode"
}

SubMenuEsc := Menu()
SubMenuEsc.Add("No changes", HandlerEscape)
SubMenuEsc.Add("swap ESC and ``", HandlerEscape)
SubMenuEsc.Add("change `` to ESC , ] to ``", HandlerEscape)

A_TrayMenu.Delete()
A_TrayMenu.Add(MENU_MODE, HandlerEnable)
A_TrayMenu.Add("Escape Key", SubMenuEsc)
A_TrayMenu.Add("Enable on Remote", HandlerRemote)
if (OPTS_DEBUG) {
  A_TrayMenu.Add("Toggle US101", HandlerUS101)
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

AdjustCheckStatus(A_TrayMenu, MENU_MODE, OPTS_ENABLE)
AdjustCheckStatus(A_TrayMenu, "Enable on Remote", OPTS_REMOTE)
AdjustCheckStatus(SubMenuEsc, OPTS_ESCAPE . "&", True)
if (OPTS_DEBUG) {
  AdjustCheckStatus(A_TrayMenu, "Toggle US101", OPTS_US101)
  AdjustCheckStatus(A_TrayMenu, "CAPS to Ctrl", OPTS_CAPS)
}

HandlerEnable(ItemName, ItemPos, MyMenu) {
    global OPTS_ENABLE
    OPTS_ENABLE := ! OPTS_ENABLE
    AdjustCheckStatus(MyMenu, ItemName, OPTS_ENABLE)
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
    Reload_OPTS()
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
    if (OPTS_CAPS and !OPTS_US101)
        MsgBox "WARN: Do not enable this on Japanese keyboard `n Try to hit Ctrl key again to release if Ctrl keeps pressed"
    Reload_OPTS()
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Remote Desktop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GroupAdd "Remote", "ahk_class TscShellContainerClass"
GroupAdd "Remote", "ahk_class Transparent Windows Client" ; ahk_exe wfica32.exe
GroupAdd "Remote", "ahk_class MC_MSTSC"

GroupAdd "AllWindows"

;;; create Group for HotIf conditions
;;; note that Group is *exlucde* window lists for conversion
GroupAddCondition(group, condition) {
    if (condition and OPTS_ENABLE) { ; i.e. if the conversion should be enabled
        if (!OPTS_REMOTE) {
            GroupAdd group, "ahk_group Remote"
        }
        ; empty group means the conversion is always enabled
    } else {
        ; adding all windows means to disable the conversion
        GroupAdd group, "ahk_group AllWindows"
    }
}

;;; Workaround to activate hotkeys in the RDP full screen mode
;;;   https://www.autohotkey.com/boards/viewtopic.php?p=547610#p547610
;;;   https://www.autohotkey.com/boards/viewtopic.php?p=93693#p93693
#HotIf WinActive("ahk_class TscShellContainerClass")
~vkFF:: {
    if (A_TimeIdlePhysical > A_TimeSinceThisHotkey)
        InstallKeybdHook(True, True)
}
#HotIf
