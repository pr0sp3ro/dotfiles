-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
-- local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Collision
require("collision")()
-- require("collision") {
--     --        Normal    Xephyr       Vim      G510
--     up    = { "k" },
--     down  = { "j" },
--     left  = { "h" },
--     right = { "l" },
-- }

-- Scratchpad
local scratch = require("scratch")
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}


-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

terminal = os.getenv("TERMINAL") or "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Enable gaps
    -- beautiful.useless_gap = 10
    -- beautiful.gap_single_client = true

    -- local names = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    -- local l = awful.layout.suit
    -- local layouts = { l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile  }
    -- awful.tag(names, s, layouts)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 21 })

    -- Create a separator or blank space
    blankspace = wibox.widget{ markup = ' ', widget = wibox.widget.textbox }

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            -- layout = wibox.layout.fixed.horizontal,
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        -- blankspace, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            blankspace,
            awful.widget.watch('bar-disk', 3600), blankspace,
            awful.widget.watch('bar-router', 600), blankspace,
            awful.widget.watch('bar-battery', 120), blankspace,
            awful.widget.watch('bar-memory', 120), blankspace,
            awful.widget.watch('bar-volume', 5),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 5, awful.tag.viewnext),
    awful.button({ }, 4, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey          }, "n",      awful.tag.viewnext),
    awful.key({ modkey          }, "p",      awful.tag.viewprev),
    -- -- Move client to prev tag and switch to it
    -- awful.key({ modkey, "Shift" }, "p",
    --     function ()
    --         -- get current tag
    --         local t = client.focus and client.focus.first_tag or nil
    --         if t == nil then
    --             return
    --         end
    --         -- get previous tag (modulo 9 excluding 0 to wrap from 1 to 9)
    --         local tag = client.focus.screen.tags[(t.name - 2) % 9 + 1]
    --         awful.client.movetotag(tag)
    --         awful.tag.viewprev()
    --     end),
    -- awful.key({ modkey, "Shift" }, "n",
    --     function ()
    --         -- get current tag
    --         local t = client.focus and client.focus.first_tag or nil
    --         if t == nil then
    --             return
    --         end
    --         -- get next tag (modulo 9 excluding 0 to wrap from 9 to 1)
    --         local tag = client.focus.screen.tags[(t.name % 9) + 1]
    --         awful.client.movetotag(tag)
    --         awful.tag.viewnext()
    --     end),
    awful.key({ modkey,         }, "h",      function () awful.tag.incmwfact(-0.05)                     end),
    awful.key({ modkey, "Shift" }, "h",      function () awful.screen.focus_relative( 1)                end),
    awful.key({ modkey,         }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end
    ),
    awful.key({ modkey, "Shift" }, "j",      function () awful.client.swap.byidx(1)                     end),
    awful.key({ modkey,         }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end
    ),
    awful.key({ modkey, "Shift" }, "k",      function () awful.client.swap.byidx(-1)                    end),
    awful.key({ modkey,         }, "l",      function () awful.tag.incmwfact(0.05)                      end),
    awful.key({ modkey, "Shift" }, "l",      function () awful.screen.focus_relative(-1)                end),
    awful.key({ modkey          }, "F1",     function () awful.util.spawn("remaps dmenu")                     end),
    awful.key({ modkey          }, "F2",     function () awful.util.spawn("displayselect")              end),
    awful.key({                 }, "Print",  function () awful.util.spawn("dmenumaim")                  end),
    awful.key({ modkey,         }, "Delete", function () awful.util.spawn("dmenukill")                  end),
    awful.key({ modkey          }, "`",      function () awful.util.spawn("dunstctl close")             end),
    awful.key({ modkey          }, "0",      function () awful.util.spawn("clipclear")                  end),
    awful.key({ modkey          }, "-",      function () awful.layout.inc(-1)                           end),
    awful.key({ modkey          }, "=",      function () awful.layout.inc( 1)                           end),
    awful.key({ modkey,         }, "Return", function () awful.spawn(terminal)                          end),
    awful.key({ modkey, "Shift" }, "e",      function () awful.util.spawn("dmenusys")                   end),
    awful.key({ modkey, "Shift" }, "r",      awesome.restart                                               ),
    awful.key({ modkey          }, "i",      function () awful.util.spawn("dmenunet")                   end),
    -- Scratchpad
    awful.key({ modkey          }, "o",
      function ()
        scratch.toggle("st -n scratch", { instance = "scratch" })
      end),
    awful.key({ modkey,         }, "[",      function () awful.util.spawn("xbacklight -dec 5")          end),
    awful.key({ modkey,         }, "]",      function () awful.util.spawn("xbacklight -inc 5")          end),
    awful.key({ modkey          }, "d",      function () awful.util.spawn("dmenu_run")                  end),
    awful.key({ modkey, "Shift" }, "d",      function () awful.util.spawn("keepmenu")                   end),
    awful.key({ modkey, "Shift" }, "w",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end),
    awful.key({ modkey          }, ";",      function () awful.util.spawn("memhogs")                    end),
    awful.key({ modkey          }, "'",      function () awful.util.spawn("cpuhogs")                    end),
    awful.key({ modkey          }, "c",      awful.placement.centered                                      ),
    awful.key({ modkey          }, "v",      function () awful.util.spawn("pamixer --allow-boost -d 5") end),
    awful.key({ modkey, "Shift" }, "v",      function () awful.util.spawn("pamixer --allow-boost -i 5") end),
    -- Show/Hide Wibox
    awful.key({ modkey          }, "b",
      function ()
        for s in screen do
          s.mywibox.visible = not s.mywibox.visible
          if s.mybottomwibox then
            s.mybottomwibox.visible = not s.mybottomwibox.visible
          end
        end
      end),
    awful.key({ modkey, "Shift" }, "b",      function () awful.util.spawn("dmenubluetooth")             end),
    awful.key({ modkey          }, "m",      function () awful.util.spawn("pamixer -t")                 end),
    awful.key({ modkey, "Shift" }, "m",      function () awful.util.spawn("pavucontrol -t 3")           end)
)

clientkeys = gears.table.join(
    awful.key({ modkey          }, "q",
      function (c)
        c:kill()
      end),
    awful.key({ modkey,         }, "f",
      function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
      end),
    awful.key({ modkey, "Shift" }, "f",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end),
    awful.key({ modkey          }, "space",  function (c) c:swap(awful.client.getmaster())              end),
    awful.key({ modkey, "Shift" }, "space",  awful.client.floating.toggle                                  ),
    awful.key({ modkey          }, "z",      function () awful.tag.incgap(1)                            end),
    awful.key({ modkey          }, "x",      function () awful.tag.incgap(-1)                           end),
    awful.key({ modkey          }, "s",      function (c) c.ontop = not c.ontop                         end),
    awful.key({ modkey          }, "w",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen+awful.placement.centered
     }
    },

    -- Scratchpads
    { rule_any = {
            instance = { "scratch" },
            class = { "scratch" },
        },
        properties = {
            skip_taskbar = false,
            floating = true,
            ontop = false,
            minimized = true,
            sticky = false,
            width = screen_width - 900,
            height = screen_height - 250
            -- width = screen_width - 650,
            -- height = screen_height - 200
            -- titlebars_enabled = false
        },
        callback = function (c)
            -- awful.placement.centered(c,{honor_padding = true, honor_workarea=true})
            awful.placement.centered(c, { offset = { y = 50, x = 250 } })
            gears.timer.delayed_call(function()
                c.urgent = false
            end)
        end
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA", -- Firefox addon DownThemAll.
          "copyq", -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          -- "Tor Browser",
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
          "Nsxiv",
          "mpv",
          "stacer",
          "opensnitch-ui"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester", -- xev.
        },
        role = {
          "AlarmWindow",   -- Thunderbird's calendar.
          "ConfigManager", -- Thunderbird's about:config.
          "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
          "toolbox",       -- Tor Browser Developer Tools.
        }
      },
      properties = {
        floating = true,
        placement = awful.placement.centered
      }
    },

    -- { rule = { class = "Pavucontrol"              }, properties = {
    --     placement = awful.placement.centered,
    --     floating = true,
    --     width = screen_width - 800,
    --     height = screen_height - 300
    --     }
    -- },
    -- { rule = { class = "System-config-printer.py" }, properties = {
    --     placement = awful.placement.centered,
    --     floating = true,
    --     -- width = screen_width - 500,
    --     -- height = screen_height - 700
    --     }
    -- },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("request::manage", function(client, context)
    if client.floating and context == "new" then
        client.placement = awful.placement.centered
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),

        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            -- awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },

        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },

        { -- Right
            -- awful.titlebar.widget.floatingbutton (c),
            -- awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.stickybutton   (c),
            -- awful.titlebar.widget.ontopbutton    (c),
            -- awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },

        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Disable window border for not tiled windows.
-- screen.connect_signal("arrange", function (s)
--     local max = s.selected_tag.layout.name == "max"
--     local only_one = #s.tiled_clients == 1 -- use tiled_clients so that other floating windows don't affect the count
--     -- but iterate over clients instead of tiled_clients as tiled_clients doesn't include maximized windows
--     for _, c in pairs(s.clients) do
--         -- Attempt to fix AwesomeWM freezing when entering fullscreen.
--         -- if (max or only_one) and not c.floating or c.maximized then
--         if (max or only_one) and not c.floating or c.maximized or c.fullscreen then
--             c.border_width = 0
--         else
--             c.border_width = beautiful.border_width
--         end
--     end
-- end)
-- }}}
