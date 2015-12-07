function reloadConfig(files)
   doReload = false
   for _,file in pairs(files) do
      if file:sub(-4) == ".lua" then
         doReload = true
      end
   end
   if doReload then
      hs.reload()
   end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")


local tiling = require "hs.tiling"
local mash = {"ctrl", "alt"}

hs.hotkey.bind(mash, "c", function() tiling.cyclelayout() end)
hs.hotkey.bind(mash, "j", function() tiling.cycle(1) end)
hs.hotkey.bind(mash, "k", function() tiling.cycle(-1) end)
hs.hotkey.bind(mash, "space", function() tiling.promote() end)

local move_window = function(axis, point_from_origin)
   local win = hs.window.focusedWindow()
   local f = win:frame()
   local screen = win:screen()
   local max = screen:frame()

   f.x = max.x
   f.y = max.y
   if axis == "horizontal" then
      f.w = max.w / 2
      f.h = max.h
   else
      f.h = max.h / 2
      f.w = max.w
   end
   win:setFrame(f)
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "b", function()
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()

      f.x = max.x
      f.y = max.y
      f.w = max.w / 2
      f.h = max.h
      win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "p", function()
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()

      f.x = max.x
      f.y = max.y
      f.w = max.w
      f.h = max.h / 2
      win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "n", function()
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()

      f.x = max.x
      f.y = max.y + (max.h / 2)
      f.w = max.w
      f.h = max.h / 2
      win:setFrame(f)
end)


hs.hotkey.bind({"cmd", "alt", "ctrl"}, "f", function()
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()

      f.x = max.x + (max.w / 2)
      f.y = max.y
      f.w = max.w / 2
      f.h = max.h
      win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Return", function()
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()

      f.x = max.x
      f.y = max.y
      f.w = max.w
      f.h = max.h
      win:setFrame(f)
end)

local updateICal = function()
   hs.execute("ping -t 1 google.com && /Users/steggy/bin/sync_gcal.rb", "steggy")
end

updateICalTimer = hs.timer.new(120, updateICal)
updateICalTimer:start()
