tell application "System Preferences"
    activate
    set current pane to pane "com.apple.preference.keyboard"
end tell


tell application "System Events"
    tell process "System Preferences"
    click button "Modifier Keys…" of tab group 1 of window "Keyboard"

    # The Option Key pop up
    click pop up button 4 of sheet 1 of window "Keyboard"
    # Change it to Command, the 4th choice
    click menu item 2 of menu 1 of pop up button 4 of sheet 1 of window "Keyboard"

    click button "OK" of sheet 1 of window "Keyboard"

    end tell
end tell
