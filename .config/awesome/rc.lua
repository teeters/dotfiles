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
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- Bling
local lain = require("lain")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local spotify_widget = require('awesome-wm-widgets.spotify-widget.spotify')

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
local theme_name = "pywal"
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), theme_name)
beautiful.init(theme_path)
beautiful.systray_icon_spacing = 2
beautiful.font = "DejaVu Sans Mono 10"
beautiful.icon_theme = "Arc-X-D"

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "emacs"
editor_cmd = editor
browser = "google-chrome-stable --profile-directory='Profile 4' --password-store=gnome-libsecret --use-gl=desktop"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

lain.layout.cascade.tile.ncol = 2
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
   awful.layout.suit.floating,
   awful.layout.suit.max,
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
	lain.layout.cascade.tile,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
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

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%a %b %d %I:%M %p ")

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
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                          end))

-- Custom: use feh instead of manual wallpaper
local function set_wallpaper(s)
   awful.spawn("/home/steeter/.fehbg")
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Custom widgets
local volume = volume_widget{
   widget_type = 'arc'
}
local spotify = spotify_widget{
   --inversion is intentional; makes buttons more DWIM
   play_icon = "/usr/share/icons/Arc-X-D/actions/24/player_pause.png",
   pause_icon = "/usr/share/icons/Arc-X-D/actions/24/player_play.png",
   font = "DejaVu Sans Mono 10"
}
--Custom buttons for volume:
--Todo: fork the repo and put these changes in the widget file
volume:buttons(
   awful.util.table.join(
	  awful.button({}, 4, function() volume_widget:inc() end),
	  awful.button({}, 5, function() volume_widget:dec() end),
	  awful.button({}, 1, function() awful.spawn("pavucontrol", {
													floating=true,
													placement = awful.placement.top_right}) end),
	  awful.button({}, 3, function() volume_widget:toggle() end)
   )
)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
	local l = awful.layout.suit;
	local layouts = { l.max, l.floating, l.floating,
					  l.floating, l.floating, l.floating, l.floating, l.floating, l.floating }
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, layouts)

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
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
       layout = wibox.layout.align.horizontal,
       expand = "inside",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
	-- Middle widget
	--s.mytasklist,
	{
	   widget = wibox.container.place,
	   halign = "center",
	   s.mytasklist
	},
        { -- Right widgets
		   layout = wibox.layout.fixed.horizontal,
		   spacing=5,
		   spotify,
            wibox.widget.systray(true),
			volume,
			
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
--    awful.button({ }, 5, awful.tag.viewnext),
--    awful.button({ }, 4, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
rofi_cmd = "rofi -modi drun -show drun"
-- if theme_name == "pywal" then
-- rofi_cmd = "rofi -modi drun -show drun -theme ~/.cache/wal/colors-rofi-dark"
-- end
powermenu_cmd = "/home/steeter/.config/rofi/scripts/powermenu_t2"

--focus master/slave
--modified from here https://www.reddit.com/r/awesomewm/comments/j73j99/toggle_master_with_last_focused_slave/
local function toggle_focus_master()
   local c = client.focus
   if c then
	  local master = awful.client.getmaster(awful.screen.focused())
	  local last_focused_window = awful.client.focus.history.get(awful.screen.focused(), 1, nil)
	  if c == master then
		 if not last_focused_window then
            return
		 end
		 client.focus = last_focused_window
	  else
		 client.focus = master
	  end
   end
end

globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
	awful.key({ modkey,           }, "i", toggle_focus_master,
	   {description = "focus master or last focused window", group="client"}),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
       {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,		  }, "F1", function () awful.spawn(browser) end,
       {description = "Launch browser", group="launcher"}),
	awful.key({ modkey, "Shift"   }, "F1", function () awful.spawn(browser.." --incognito") end,
	   {description = "Launch browser in incognito mode", group="launcher"}),
    awful.key({ modkey, 	  }, "F2", function () awful.spawn("emacs") end,
       {description = "Launch editor", group="launcher"}),
	 awful.key({"Control"      }, "Print", function () awful.spawn.with_shell("scrot -s --line mode=edge -e 'xclip -selection clipboard -t image/png -i $f && rm $f'") end,
	   {description = "Screenshot selection to clipboard", group="launcher"}),
	awful.key({               }, "Print", function () awful.spawn.with_shell("scrot ~/Pictures/Screenshots/%Y-%m-%d-%H:%M:%OS.png") end,
	   {description = "Screenshot", group="launcher"}),

    -- Layout
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
       {description = "increase master width factor", group = "layout"}),
       awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
       {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "=", function () awful.client.incwfact(0.05) end,
       {description = "increase slave width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "-", function () awful.client.incwfact(-0.05) end,
       {description = "decrease slave width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    -- awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
    --    {description = "run prompt", group = "launcher"}),
    -- Custom: replace with rofi
    awful.key({ modkey }, "r", function() awful.spawn(rofi_cmd) end,
       {description = "launch rofi", group="launcher"}),
	awful.key({ modkey }, "End", function() awful.spawn(powermenu_cmd) end,
	   {description = "launch power menu", group="launcher"}),
    
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
       {description = "show the menubar", group = "launcher"}),

    -- Media keys
    --HACK: Remap the Pause and Calculator buttons. The keyboard itself should handle this but
    --OpenRGB has borked it in the past.
    awful.key({ }, "Pause", function () awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause", false) end),
    awful.key({ }, "XF86Calculator", function () awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next", false) end),

    -- Principled bindings:
    awful.key({ }, "XF86AudioPlay", function () awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause", false) end),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      awful.key({ }, "XF86AudioNext", function () awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next", false) end),
    awful.key({ }, "XF86AudioPrev", function () awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous", false) end),
    awful.key({}, "XF86AudioRaiseVolume", function() volume_widget:inc(5) end),
    awful.key({}, "XF86AudioLowerVolume", function() volume_widget:dec(5) end),
    awful.key({}, "XF86AudioMute", function() volume_widget:toggle() end)
	  
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
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
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
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
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
		  "Blueman-adapters",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
		  "Nautilus",
		  "nm-connection-editor",
		  "Thunar",
		  "Pavucontrol",
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true, titlebars_enabled=true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "dialog" },
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },

	{ rule = { class = "Slack" },
	  properties = { screen = 1, tag = "3" } }
}
-- }}}

function should_display_titlebar(c)
   if c.floating and not c.maximized then
      return true
   end
   -- local tag = c.screen.selected_tag
   -- if tag.layout.name == "floating" then
   --    return true
   -- end
   return false
end

function update_titlebar_visibility(c)
   if should_display_titlebar(c) then
      awful.titlebar.show(c)
   else
      awful.titlebar.hide(c)
   end
   return
end

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    update_titlebar_visibility(c)
end)

-- Toggle titlebar visibility when a tag changes layout
tag.connect_signal("property::layout", function (t)
		      for k,c in pairs(t:clients()) do
			 update_titlebar_visibility(c)
		      end
end)

-- And when the screen changes tags
screen.connect_signal("tag::history::update", function(s)
			 for k,c in pairs(s.clients) do
			    update_titlebar_visibility(c)
			 end
end)

-- And finally, when the floating property is toggled
client.connect_signal("property::floating", function(c)
			 update_titlebar_visibility(c)
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
            awful.titlebar.widget.iconwidget(c),
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
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            --awful.titlebar.widget.stickybutton   (c),
            --awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
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
-- }}}

-- Autostarts

-- network manager in systray
awful.spawn("nm-applet")
awful.spawn("blueman-applet")

-- picom
awful.spawn("picom -b --config /home/steeter/.config/picom.conf")

-- Cycorp work setup
function cycorp_init()
   -- todo: redefine this if I ever get a second screen
   -- todo: fix bug with placing electron apps (chrome, slack, spotify) described here: https://github.com/awesomeWM/awesome/issues/2859
   local t1 = awful.tag.find_by_name(awful.screen.focused(), "1")
   local t2 = awful.tag.find_by_name(awful.screen.focused(), "2")
   local t3 = awful.tag.find_by_name(awful.screen.focused(), "3")
   local l = awful.layout.suit
   --tag 1: chromium and terminal
   --awful.spawn("nmcli con up steeter_worldwide", { floating=false, tag=t1 })
   --awful.spawn(terminal.."-e sshfs steeter@draco:/ ~/cycorp/fs")
   awful.layout.set(l.max, t1)
   awful.spawn("google-chrome-stable --profile-directory='Profile 3' --password-store=gnome-libsecret --use-gl=desktop", { floating=false, tag=t1 })
   --tag 2: emacs and terminal
   awful.layout.set(l.tile.top, t2)
   t2.master_width_factor = .15
   awful.spawn(terminal.." --directory=~/cycorp/", { floating=false, tag=t2 })
    awful.spawn([[emacs --eval='(progn
    								(cd "~/cycorp/")
    							   )']], { floating=false, tag=t2 })
	-- 								(split-window-right)
	-- 								(magit-status)

   --tag 3: slack
   awful.spawn("slack", { tag=t3, placement=awful.placement.centered })
end

-- setup current tag for dev work
function codespace(path)
   if path==nil then
	  path = "~/"
   end
   local t = awful.screen.focused().selected_tag --assumption: one tag only
   local l = awful.layout.suit
   awful.layout.set(l.tile.top, t)
   t.master_width_factor = .15
   awful.spawn(terminal.." --directory="..path, { floating=false, tag=t })
   awful.spawn([[emacs --eval='(progn
    								(cd "]]..path..[[")
    							   )']], { floating=false, tag=t })
end

local blacklisted_snid = setmetatable({}, {__mode = "v" })
