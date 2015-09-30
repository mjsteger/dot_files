tell application "System Preferences"
    activate
    set current pane to pane "com.apple.preference.keyboard"
end tell


-- tell application "System Events"
--     tell process "System Preferences"
--     click button "Modifier Keys…" of tab group 1 of window "Keyboard"

--     # The Option Key pop up
--     click pop up button 4 of sheet 1 of window "Keyboard"
--     # Change it to Command, the 4th choice
--     click menu item 2 of menu 1 of pop up button 4 of sheet 1 of window "Keyboard"

--     click button "OK" of sheet 1 of window "Keyboard"

--     end tell
-- end tell


-- tell application "System Events"
--     tell process "System Preferences"
--         click menu bar item 1 of tab group 1 of window "Keyboard"
--     -- click button "Input Sources" of tab group 1 of window "Keyboard"

--     end tell
-- end tell


tell application "System Preferences"
	activate
	set current pane to pane "com.apple.preference.keyboard"
	reveal anchor "InputSources" of current pane
end tell

tell application "System Events"
	tell process "System Preferences"
		activate
		click button 1 of group 1 of tab group 1 of window "Keyboard"
		delay 1
		keystroke "Workman-p"
                delay 1
		keystroke return
	end tell
end tell

-- set keyboard layout to workman
delay 1
set layoutName to "Workman-P"
tell application "System Events" to tell process "SystemUIServer"
tell (1st menu bar item of menu bar 1 whose description is "text input") to {click, click (menu 1's menu item layoutName)}
end tell