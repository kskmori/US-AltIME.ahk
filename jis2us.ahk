#Requires AutoHotkey v2.0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; JIS to US keyboard conversion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GroupAddCondition("JIS2US",      !OPTS_US101)
GroupAddCondition("JIS2US_ESC1", !OPTS_US101 and OPTS_ESCAPE == 1)
GroupAddCondition("JIS2US_ESC2", !OPTS_US101 and OPTS_ESCAPE == 2)
GroupAddCondition("JIS2US_ESC3", !OPTS_US101 and OPTS_ESCAPE == 3)

#HotIf !WinActive("ahk_group JIS2US")

+2::Send "{@}"		; " -> @
+6::Send "{^}"		; & -> ^
+7::Send "{&}"		; ' -> &
+8::Send "{*}"		; ( -> *
+9::Send "{(}"		; ) -> (
+0::Send "{)}"		;   -> )
+-::Send "{_}"		; = -> _n
 ^::Send "{=}"		; ^ -> =
+^::Send "{+}"		; ~ -> +

 @::Send "{[}"		; @ -> [
+@::Send "{{}"		; ` -> {
 [::Send "{]}"		; [ -> ]
+[::Send "{}}"		; { -> }

+;::Send "{:}"		; + -> :
 :::Send "{'}"		; : -> '
 *::Send "{`"}"		; * -> "


;;; Escape 1: No changes
#HotIf !WinActive("ahk_group JIS2US_ESC1")
 ]::Send "{\}"		; ] -> \
+]::Send "{|}"		; } -> |
 sc029::Send "{``}"	; 半角全角 -> `
+sc029::Send "{~}"	; 半角全角 -> ~
 ~sc073::Return		; \
+~sc073::Return		; _

;;; Escape 2: swap ESC and `~ only
#HotIf !WinActive("ahk_group JIS2US_ESC2")
 ]::Send "{\}"			; ] -> \
+]::Send "{|}"			; } -> |
*sc029::Send "{Blind}{Esc}"	; 半角全角 -> Escape
 Esc::Send "{``}"		; Escape -> `
+Esc::Send "{~}"		; Escape -> ~
 ~sc073::Return			; \
+~sc073::Return			; _

;;; Escape 3: change \_ to `~, ]} to Enter
#HotIf !WinActive("ahk_group JIS2US_ESC3")
 ]::Send "{Enter}"		; ] -> Enter
+]::Send "{Enter}"		; ] -> Enter
*sc029::Send "{Blind}{Esc}"	; 半角全角 -> Escape
 sc073::Send "{``}"		; \ -> `
+sc073::Send "{~}"		; _ -> ~

#HotIf

;;; Disable keys
;vkF2sc070	ひらがな/カタカナ
;vkF0sc03A	英数（CapsLock）
;vk14sc03A      CapsLock
*sc070::Return		; disable ひらがな/カタカナ
*sc03A::Return		; disable 英数/CapsLock

