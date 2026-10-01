; =============================================================================
; gdocs.ahk - code-editor line keys for Google Docs (AutoHotkey v2)
; =============================================================================
;
; WHAT IT DOES
;   Adds line keys like in a code editor to Google Docs. The keys work only
;   when the active window title has "Google Docs" in it (the browser tab of
;   a doc). In every other window the keys keep their normal action.
;
; KEYS
;   Ctrl+D            Delete the current line
;   Ctrl+Alt+Down     Duplicate the current line below
;   Ctrl+Alt+Up       Duplicate the current line above
;   Ctrl+Shift+Down   Move the current line (paragraph) down
;   Ctrl+Shift+Up     Move the current line (paragraph) up
;
; NOTES
;   - Inside Google Docs these keys replace their normal action. For example
;     Ctrl+Shift+Up no longer selects up to the paragraph start.
;   - Delete and duplicate act on the visible line. For a long paragraph that
;     wraps, this is only one part of it. Move acts on the whole paragraph.
;   - Duplicate uses the clipboard for a moment, then puts the old clipboard
;     content back.
;   - Move sends Alt+Shift+Up/Down, the Google Docs "move paragraph" keys.
;     If the keyboard language changes instead, Windows uses Alt+Shift to
;     switch languages. Turn that off in: Settings > Time & language >
;     Typing > Advanced keyboard settings > Input language hot keys.
;
; SET UP ON A NEW MACHINE
;   1. Install AutoHotkey v2 from https://www.autohotkey.com (the v2
;      download). AutoHotkey v1 cannot run this file.
;   2. Copy gdocs.ahk to any folder, for example the Desktop.
;   3. Double-click gdocs.ahk to start it. A green "H" icon shows in the
;      system tray (bottom right of the taskbar).
;   4. Optional - start it with Windows:
;      - Press Win+R, type  shell:startup  and press Enter.
;      - Right-drag gdocs.ahk into the folder that opens and choose
;        "Create shortcuts here".
;
; DAILY USE
;   - After you change this file: right-click the tray icon > Reload Script.
;   - To pause the keys: right-click the tray icon > Suspend Hotkeys.
;   - To stop the script: right-click the tray icon > Exit.
; =============================================================================

#Requires AutoHotkey v2.0
SetTitleMatchMode 2

#HotIf WinActive("Google Docs")

; Ctrl+D — delete current line
$^d:: SendEvent "{Home}{Shift down}{Down}{Shift up}{Delete}"

; Ctrl+Alt+Down — duplicate line down
$^!Down:: DuplicateLine("down")

; Ctrl+Alt+Up — duplicate line up
$^!Up::   DuplicateLine("up")

; Ctrl+Shift+Down — move line down (sends the Docs move-paragraph keys)
$^+Down:: SendEvent "!+{Down}"

; Ctrl+Shift+Up — move line up
$^+Up::   SendEvent "!+{Up}"

#HotIf

DuplicateLine(dir) {
    saved := ClipboardAll()
    A_Clipboard := ""

    SendEvent "{Home}{Shift down}{End}{Shift up}"
    SendEvent "^c"
    if !ClipWait(1) {              ; empty line — nothing to copy
        A_Clipboard := saved
        return
    }
    Sleep 80

    if (dir = "down") {
        SendEvent "{End}{Enter}"
        Sleep 80
        SendEvent "^v"
    } else {
        SendEvent "{Home}"
        Sleep 60
        SendEvent "^v"
        Sleep 120
        SendEvent "{Enter}{Up}{End}"
    }

    Sleep 250                       ; let Docs finish the paste
    A_Clipboard := saved
}