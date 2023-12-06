#Requires AutoHotkey v2.0
InstallKeybdHook
;#UseHook


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Options
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Include "options.ahk"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; JIS to US keyboard conversion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; enabled when JIS2US mode (default)
#Include "jis2us.ahk"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; US101 keyboard driver mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; enabled when US101 mode (/U option)
#Include "us101.ahk"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; IME controls
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Include "ime-controls.ahk"