;==========================================================
;
;
;   ██████╗  ██████╗ ██╗  ██╗   ██╗██████╗  █████╗ ██████╗
;   ██╔══██╗██╔═══██╗██║  ╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗
;   ██████╔╝██║   ██║██║   ╚████╔╝ ██████╔╝███████║██████╔╝
;   ██╔═══╝ ██║   ██║██║    ╚██╔╝  ██╔══██╗██╔══██║██╔══██╗
;   ██║     ╚██████╔╝███████╗██║   ██████╔╝██║  ██║██║  ██║
;   ╚═╝      ╚═════╝ ╚══════╝╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
;
;
;   To learn more about how to configure Polybar
;   go to https://github.com/jaagr/polybar
;
;   The README contains alot of information
;
;==========================================================

[colors]
;background = #222
background = #aa
;background-alt = #444
background-alt = #666
foreground = #dfdfdf
foreground-alt = #555
primary = #ffb52a
secondary = #e60053
alert = #bd2c40

[bar/main]
monitor = ${env:MONITOR:LVDS-2}
width = 100%
height = 18
;offset-x = 1%
;offset-y = 1%
radius = 6.0
fixed-center = true
bottom = false

background = ${colors.background}
foreground = ${colors.foreground}

line-size = 3
line-color = #f00

border-size = 4
border-color = #00000000

padding-left = 2
padding-right = 2

module-margin-left = 1
module-margin-right = 2

font-0 = Hack:pixelsize=9;1
font-1 = PowerlineSymbols:pixelsize=12;1
font-2 = siji:pixelsize=12;1
font-3 = Unifont:style=Sans-Serif:size=12;0

modules-left = pulseaudio filesystem mpd 
modules-center = date
modules-right = xkeyboard wlan1 eth ext-ipv4 
tray-position = right
tray-padding = 2
;tray-background = #0063ff

;wm-restack = bspwm
;wm-restack = i3

;override-redirect = true

;scroll-up = bspwm-desknext
;scroll-down = bspwm-deskprev

;scroll-up = i3wm-wsnext
;scroll-down = i3wm-wsprev

cursor-click = pointer
cursor-scroll = ns-resize

[bar/bottom]
monitor = ${env:MONITOR:LVDS-2}
width = 100%
height = 18
;offset-x = 1%
;offset-y = 1%
radius = 6.0
fixed-center = true
bottom = true

background = ${colors.background}
foreground = ${colors.foreground}

line-size = 3
line-color = #f00

border-size = 4
border-color = #00000000

padding-left = 2
padding-right = 2

module-margin-left = 1
module-margin-right = 2

font-0 = Hack:pixelsize=9;1
font-1 = PowerlineSymbols:pixelsize=12;1
font-2 = siji:pixelsize=12;1
font-3 = Unifont:style=Sans-Serif:size=12;0

modules-left = backlight-acpi battery0 battery1
modules-center = i3
modules-right = memory cpu temperature 
tray-position = right
tray-padding = 2
;tray-background = #0063ff

;wm-restack = bspwm
;wm-restack = i3

;override-redirect = true

;scroll-up = bspwm-desknext
;scroll-down = bspwm-deskprev

;scroll-up = i3wm-wsnext
;scroll-down = i3wm-wsprev

cursor-click = pointer
cursor-scroll = ns-resize


[module/ext-ipv4]
type = custom/script
;format-underline = #9f78e1
exec = $HOME/.config/polybar/pub-ipv4.sh
label = %output%
tail = true

[module/xwindow]
type = internal/xwindow
label = %title:0:30:...%

[module/xkeyboard]
type = internal/xkeyboard
blacklist-0 = num lock

;format-prefix = "î¯ "
format-prefix = "keys: "
format-prefix-foreground = ${colors.foreground}
;format-prefix-underline = ${colors.secondary}

label-layout = %layout%
;label-layout-underline = ${colors.secondary}

label-indicator-padding = 2
label-indicator-margin = 1
label-indicator-background = ${colors.secondary}
;label-indicator-underline = ${colors.secondary}

[module/filesystem]
type = internal/fs
interval = 25

mount-0 = /

;label-mounted = %{F#0a81f5}%mountpoint%%{F-}: %percentage_used%%
label-mounted = root: %percentage_used%%
label-unmounted = root: not mounted
;label-unmounted-foreground = ${colors.foreground-alt}

[module/homesystem]
type = internal/fs
interval = 25

mount-0 = /home

;label-mounted = %{F#0a81f5}%mountpoint%%{F-}: %percentage_used%%
label-mounted = home: %percentage_used%%
label-unmounted = home: not mounted
;label-unmounted-foreground = ${colors.foreground-alt}

[module/bspwm]
type = internal/bspwm

label-focused = %index%
label-focused-background = ${colors.background-alt}
;label-focused-underline= ${colors.primary}
label-focused-padding = 2

label-occupied = %index%
label-occupied-padding = 2

label-urgent = %index%!
label-urgent-background = ${colors.alert}
label-urgent-padding = 2

label-empty = %index%
label-empty-foreground = ${colors.foreground-alt}
label-empty-padding = 2

; Separator in between workspaces
; label-separator = |

[module/i3]
type = internal/i3
format = <label-state> <label-mode>
index-sort = true
wrapping-scroll = false

; Only show workspaces on the same output as the bar
;pin-workspaces = true

label-mode-padding = 2
label-mode-foreground = #000
label-mode-background = ${colors.primary}

; focused = Active workspace on focused monitor
label-focused = %index%
label-focused-background = ${module/bspwm.label-focused-background}
;label-focused-underline = ${module/bspwm.label-focused-underline}
;label-focused-underline = #0a6cf5
label-focused-padding = ${module/bspwm.label-focused-padding}

; unfocused = Inactive workspace on any monitor
label-unfocused = %index%
label-unfocused-padding = ${module/bspwm.label-occupied-padding}

; visible = Active workspace on unfocused monitor
label-visible = %index%
label-visible-background = ${self.label-focused-background}
;label-visible-underline = ${self.label-focused-underline}
label-visible-padding = ${self.label-focused-padding}

; urgent = Workspace with urgency hint set
label-urgent = %index%
label-urgent-background = ${module/bspwm.label-urgent-background}
label-urgent-padding = ${module/bspwm.label-urgent-padding}

; Separator in between workspaces
; label-separator = |


[module/mpd]
type = internal/mpd
format-online = <label-song>  <icon-prev> <icon-stop> <toggle> <icon-next>

;icon-prev = î
;icon-stop = î
;icon-play = î
;icon-pause = î
;icon-next = î

icon-prev = <<
icon-stop = !
icon-play = |>
icon-pause = ||
icon-next = >>

label-song-maxlen = 25
label-song-ellipsis = true

[module/xbacklight]
type = internal/xbacklight

format = <label> <bar>
label = BL: %percentage%%

bar-width = 10
bar-indicator = |
bar-indicator-foreground = #fff
bar-indicator-font = 2
;bar-fill = â
bar-fill = -
bar-fill-font = 2
bar-fill-foreground = #9f78e1
;bar-empty = â
bar-empty = -
bar-empty-font = 2
bar-empty-foreground = ${colors.foreground-alt}

[module/backlight-acpi]
inherit = module/xbacklight
type = internal/backlight
card = intel_backlight

[module/cpu]
type = internal/cpu
interval = 2
;format-prefix = "î¦ "
format-prefix = "cpu: "
format-prefix-foreground = ${colors.foreground}
;format-underline = #f90000
label = %percentage:2%%

[module/memory]
type = internal/memory
interval = 2
;format-prefix = "¨ "
format-prefix = "mem: "
format-prefix-foreground = ${colors.foreground}
;format-underline = #4bffdc
label = %percentage_used%%

[module/wlan]
type = internal/network
interface = wlp3s0
interval = 3.0

format-connected = <label-connected>
;format-connected-underline = #9f78e1
label-connected = %essid% 

format-disconnected = <label-disconnected>
;format-disconnected-underline = ${self.format-connected-underline}
label-disconnected = %ifname% disconnected
label-disconnected-foreground = ${colors.foreground-alt}

;ramp-signal-0 = +
;ramp-signal-1 = +
;ramp-signal-2 = +
;ramp-signal-3 = +
;ramp-signal-4 = +
;ramp-signal-0 = î
;ramp-signal-1 = î
;ramp-signal-2 = î
;ramp-signal-3 = î
;ramp-signal-4 = î
;ramp-signal-foreground = ${colors.foreground-alt}

[module/eth]
type = internal/network
;interface = net0
interface = wlp3s0
interval = 3.0

;format-connected-underline = #55aa55
;format-connected-prefix = "î "
;format-connected-prefix-foreground = ${colors.foreground-alt}
label-connected = %local_ip%

format-disconnected = <label-disconnected>
;format-disconnected-underline = ${self.format-connected-underline}
label-disconnected = %ifname% disconnected
label-disconnected-foreground = ${colors.foreground-alt}

[module/date]
type = internal/date
interval = 5

date = "%Y-%m-%d"
date-alt = "%Y-%m-%d"

time = %H:%M:%S
time-alt = %H:%M:%S

;format-prefix = î
;format-prefix-foreground = ${colors.foreground}
;format-underline = #0a6cf5

label = %time% - %date%

[module/pulseaudio]
type = internal/pulseaudio

format-volume = <label-volume> <bar-volume>
label-volume = Pulse: %percentage%%
label-volume-foreground = ${root.foreground}

;label-muted = ð mute
label-muted = muted
label-muted-foreground = #666

bar-volume-width = 10
bar-volume-foreground-0 = #55aa55
bar-volume-foreground-1 = #55aa55
bar-volume-foreground-2 = #55aa55
bar-volume-foreground-3 = #55aa55
bar-volume-foreground-4 = #55aa55
bar-volume-foreground-5 = #f5a70a
bar-volume-foreground-6 = #ff5555
bar-volume-gradient = false
bar-volume-indicator = |
bar-volume-indicator-font = 2
;bar-volume-fill = â
bar-volume-fill = -
bar-volume-fill-font = 2
;bar-volume-empty = â
bar-volume-empty = -
bar-volume-empty-font = 2
bar-volume-empty-foreground = ${colors.foreground-alt}
;bar-volume-empty-foreground = ${colors.foreground}

[module/alsa]
type = internal/alsa

format-volume = <label-volume> <bar-volume>
label-volume = ALSA VOL: %percentage%%
label-volume-foreground = ${root.foreground}

;format-muted-prefix = "î "
;format-muted-foreground = ${colors.foreground-alt}
label-muted = sound muted

bar-volume-width = 10
bar-volume-foreground-0 = #55aa55
bar-volume-foreground-1 = #55aa55
bar-volume-foreground-2 = #55aa55
bar-volume-foreground-3 = #55aa55
bar-volume-foreground-4 = #55aa55
bar-volume-foreground-5 = #f5a70a
bar-volume-foreground-6 = #ff5555
bar-volume-gradient = false
bar-volume-indicator = |
bar-volume-indicator-font = 2
;bar-volume-fill = â
bar-volume-fill = +
bar-volume-fill-font = 2
;bar-volume-empty = â
bar-volume-empty = =
bar-volume-empty-font = 2
;bar-volume-empty-foreground = ${colors.foreground-alt}
bar-volume-empty-foreground = ${colors.foreground}

[module/battery]
type = internal/battery
;battery = BAT1
adapter = ADP1
full-at = 98

format-charging-prefix = "(chr) batt: " 
format-charging = <label-charging>
;format-charging-underline = #55aa55

format-discharging-prefix = "batt: " 
format-discharging = <label-discharging>
;format-discharging-underline = #ffb52a

format-full-prefix = ${self.format-discharging-prefix} 
format-full = <label-full>
;format-full-prefix-foreground = ${colors.foreground-alt}
;format-full-underline = #55aa55

;ramp-capacity-0 = î¶
;ramp-capacity-1 = î·
;ramp-capacity-2 = î¸
;ramp-capacity-foreground = ${colors.foreground-alt}

animation-charging-0 = î¶
animation-charging-1 = î·
animation-charging-2 = î¸
;animation-charging-foreground = ${colors.foreground-alt};
animation-charging-framerate = 750

animation-discharging-0 = î¸
animation-discharging-1 = î·
animation-discharging-2 = î¶
;animation-discharging-foreground = ${colors.foreground-alt}
animation-discharging-framerate = 750

[module/battery0]
inherit = module/battery
battery = BAT0
format-charging-prefix = "(chr) batt0: "
format-discharging-prefix = "batt0: "

[module/battery1]
inherit = module/battery
battery = BAT1
format-charging-prefix = "(chr) batt1: "
format-discharging-prefix = "batt1: "

[module/temperature]
type = internal/temperature
thermal-zone = 0
warn-temperature = 60

format-prefix = "temp: "
format = <label>
;format-underline = #f50a4d
format-warn = <label-warn>
;format-warn-underline = ${self.format-underline}

label = %temperature-c%
label-warn = %temperature-c%
label-warn-foreground = ${colors.secondary}

;ramp-0 = î
;ramp-1 = î
;ramp-2 = î
;ramp-0 = -
;ramp-1 = +
;ramp-2 = =
;ramp-foreground = ${colors.foreground-alt}

[module/powermenu]
type = custom/menu

expand-right = true

format-spacing = 1

label-open = î
label-open-foreground = ${colors.secondary}
label-close = î¥ cancel
label-close-foreground = ${colors.secondary}
label-separator = |
label-separator-foreground = ${colors.foreground-alt}

menu-0-0 = reboot
menu-0-0-exec = menu-open-1
menu-0-1 = power off
menu-0-1-exec = menu-open-2

menu-1-0 = cancel
menu-1-0-exec = menu-open-0
menu-1-1 = reboot
menu-1-1-exec = sudo reboot

menu-2-0 = power off
menu-2-0-exec = sudo poweroff
menu-2-1 = cancel
menu-2-1-exec = menu-open-0

[settings]
screenchange-reload = true
;compositing-background = xor
;compositing-foreground = source
;compositing-border = over
;pseudo-transparency = true

[global/wm]
margin-top = 5
margin-bottom = 5

; vim:ft=dosini