#Requires AutoHotkey v2.0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; US101 keyboard driver mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GroupAddCondition("US101",      OPTS_US101)
GroupAddCondition("US101_ESC1", OPTS_US101 and OPTS_ESCAPE == 1)
GroupAddCondition("US101_ESC2", OPTS_US101 and OPTS_ESCAPE == 2)
GroupAddCondition("US101_ESC3", OPTS_US101 and OPTS_ESCAPE == 3)
GroupAddCondition("US101_CAPS", OPTS_US101 and OPTS_CAPS)

; JP106              / US101
; vkF4sc029 半角全角 / vkC0sc029 `~
; vkDDsc02B ]}       / vkDCsc02B \|
; vkDCsc07D \|       / vkFFsc07D (none)
; vkE2sc073 \_       / vkC1sc073 (none)

#HotIf !WinActive("ahk_group US101")

 sc07D::Send "{\}"	; \ -> \
+sc07D::Send "{|}"	; | -> |
 sc073::Send "{\}"	; \ -> \
+sc073::Send "{_}"	; _ -> _

;;; Escape 1: No changes
#HotIf !WinActive("ahk_group US101_ESC1")
 ~sc029::Return		; 半角全角 -> `
+~sc029::Return		; 半角全角 -> ~

;;; Escape 2: swap ESC and `~ only
#HotIf !WinActive("ahk_group US101_ESC2")
*sc029::Send "{Blind}{Esc}"	; 半角全角 -> Escape
 Esc::Send "{``}"		; Escape -> `
+Esc::Send "{~}"		; Escape -> ~

;;; Escape 3: `~ type4 style for jp106
#HotIf !WinActive("ahk_group US101_ESC3")
\::Send "{``}"			; ] -> `
|::Send "{~}"			; } -> ~
*sc029::Send "{Blind}{Esc}"	; 半角全角 -> Escape


;; CAPS to Ctrl
;; for US101 kbd driver only - do not use with regular JP106 kbd driver
#HotIf !WinActive("ahk_group US101_CAPS")
*sc03A::Ctrl

#HotIf

