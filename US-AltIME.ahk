#Requires AutoHotkey v2.0
InstallKeybdHook
;#UseHook


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Common definitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; options, menus and other definitions
#Include "include/common.ahk"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; define all hotkeys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Include "include/all-hotkeys.ahk"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; JIS to US keyboard conversion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; enabled when JIS2US mode (default)
#Include "include/jis2us.ahk"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; US101 keyboard driver mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; enabled when US101 mode (/U option)
#Include "include/us101.ahk"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; IME controls
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Include "include/ime-controls.ahk"
