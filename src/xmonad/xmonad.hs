import XMonad                         -- xmonad core
import XMonad.Config.Desktop          -- suitable for modern desktop
import XMonad.Util.EZConfig           -- key/mouse bindings in emacs style
import XMonad.Util.Run                -- run external applications
import XMonad.Util.Replace            -- replace compliant window manager
import XMonad.Layout.NoBorders        -- smart borders
import XMonad.Layout.LayoutHints      -- support window size hints
import XMonad.Layout.Maximize         -- maximize window functionality
import XMonad.Layout.Minimize         -- allow minimization of windows
import XMonad.Layout.Fullscreen       -- fullscreen windows in layout
import XMonad.Layout.Grid             -- windows in grid layout
import XMonad.Layout.Reflect          -- reflect a layout horizontally or vertically
import XMonad.Layout.PerWorkspace     -- different layouts per workspace
import XMonad.Hooks.ManageHelpers     -- window matching helpers
import XMonad.Hooks.UrgencyHook       -- react to urgent window hints
import XMonad.Hooks.DynamicLog        -- support external statusbar
import XMonad.Hooks.FloatNext         -- automatically float next created window
import XMonad.Actions.WithAll         -- actions on all windows on a workspace
import XMonad.Actions.Promote         -- alternate promote function
import XMonad.Actions.CycleWindows    -- flexible window switching
import XMonad.Actions.CycleWS         -- extra workspace actions
import XMonad.Actions.WindowBringer   -- bring window menu
import XMonad.Actions.WindowMenu      -- window operations menu
import XMonad.Actions.GridSelect      -- fancy 2d grid to select from
import XMonad.Actions.PhysicalScreens --  Manipulate screens ordered by physical location instead of ID

import Data.Monoid
import System.IO
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

main = do
  replace
  -- din <- spawnPipe myStatusBar
  xmonad defaults

defaults =  desktopConfig {
  modMask            = myModMask,
  terminal           = myTerminal,
  borderWidth        = myBorderWidth,
  normalBorderColor  = myNormalBorderColor,
  focusedBorderColor = myFocusedBorderColor,
  focusFollowsMouse  = False,
  clickJustFocuses   = False,
  workspaces         = myWorkspaces,
  layoutHook         = myLayout,
  logHook            = myLogHook,
  handleEventHook    = myHandleEventHook,
  manageHook         = myManageHook
  }
  `removeKeysP` myRemovedKeys
  `additionalKeysP` myKeys

-- Window border width
myBorderWidth = 3

-- Normal window border color
myNormalBorderColor = "#cecece"

-- Focused window border color
-- myFocusedBorderColor = "#DC322F"
myFocusedBorderColor = "#CB4B16"

-- Modifier key
myModMask = mod4Mask

-- Text Editor
myTextEditor = "emacs"

-- Terminal emulator
{-myTerminal = "xterm"-}
-- myTerminal = "uxterm"
-- myTerminal = "urxvt"
myTerminal = "xfce4-terminal --hide-menubar"

-- Workspaces
myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

-- Startup hook
myStartupHook = do
  startupHook desktopConfig
  -- adjustEventInput

-- Event hook
myHandleEventHook = mconcat [
  hintsEventHook,
  handleEventHook desktopConfig
  ]

-- Manage hook
myManageHook = mconcat [
  floatNextHook,
  myWindowRules,
  manageHook desktopConfig
  ]

-- Log hook
myLogHook = do
  -- myDynamicLogHook din
  -- dynamicLog
  logHook desktopConfig

myDynamicLogHook h = dynamicLogWithPP $ defaultPP {
  ppWsSep = "",
  ppSep = " ",
  ppCurrent = dzenColor "#222222" "white" . pad,
  ppVisible = dzenColor "white" "black" . pad,
  ppHidden = dzenColor "lightblue" "#222222" . pad,
  -- ppHiddenNoWindows = dzenColor "#777777" "#222222" . pad,
  ppUrgent = dzenColor "red" "yellow",
  -- ppExtras = willFloatAllNewPP "float",
  ppOutput = hPutStrLn h
  }

-- Statusbar shell command
myStatusBar = "dzen2 -bg '#494949' -fg '#ffffff' -h 32 -w 600 -e ''"

-- Dmenu color theme - solarized
myDmenuColorsSolarized = ["-nb","#fdf6e3","-nf","#657b83","-sb","#eee8d5","-sf","#657b83"]

-- X larger font
myFontLarge = ["-fn", "-*-*-*-r-*-*-20-*-*-*-*-*-*-*"]

-- Dzen window operation menus
myDmenuGoto = ["-i","-p","Go to window:"] ++ myDmenuColorsSolarized ++ myFontLarge
myDmenuBring = ["-i","-p","Bring window:"] ++ myDmenuColorsSolarized ++ myFontLarge

-- Remove unused default keybindings
myRemovedKeys = [
  -- "M-j",   -- was focusUp
  -- "M-k",   -- was focusDown
  -- "M-S-j", -- was swapDown
  -- "M-S-k", -- was swapUp
  "M-b",   -- was toggle struts
  "M-p",   -- was dmenu run
  "M-S-p", -- was spawn gmrun
  "M-S-q"  -- was quit XMonad
  ]

-- Key bindings
myKeys = [
  -- ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- -q"),
  -- ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ -q"),
  -- ("<XF86AudioMute>", spawn "amixer set Master toggle -q"),
  -- ("<XF86AudioPlayPause>", spawn "mpc toggle"),
  -- ("<XF86TouchpadToggle>", spawn "touchpad-toggle"),
  -- ("<Print>", spawn "scrot-screenshot"),
  -- ("M1-<F2>", spawn "dmenu-run"),
  ("M1-<Tab>", windows W.focusDown),
  -- ("M1-<Tab>", cycleRecentWindows [xK_Alt_L] xK_Tab xK_Tab), -- alt-tab like in most other wms
  ("M1-S-<Tab>", windows W.focusUp),
  ("M1-<Escape>", withFocused (sendMessage . maximizeRestore)),
  ("M-<Escape>", floatAllNew True),
  ("M1-<F4>", kill),
  ("M-q", kill),
  ("M1-S-<F4>", killAll),
  ("M-C-<F4>", spawn "xkill"),
  ("M-S-t", floatAllNew False >> sinkAll),
  ("M-<Tab>", toggleWS),
  ("M-<Left>", prevWS),
  ("M-<Right>", nextWS),
  ("M-S-<Left>", shiftToPrev),
  ("M-S-<Right>", shiftToNext),
  -- ("M-o", windows W.focusDown),
  -- ("M-n", windows W.focusDown),
  -- ("M-p", windows W.focusUp),
  -- ("M-S-n", windows W.swapDown),
  -- ("M-S-p", windows W.swapUp),
  -- ("M-k", kill),
  -- ("M-z", sendMessage NextLayout >> (dynamicLogString defaultPP >>= \d->spawn $ "dzen-msg '" ++ d ++ "'")),
  ("M1-<F3>", gotoMenuArgs myDmenuGoto),
  ("M-g", gotoMenuArgs myDmenuGoto),
  ("M-b", bringMenuArgs myDmenuBring),
  -- ("M-g", goToSelected defaultGSConfig),
  -- ("M-b", bringSelected defaultGSConfig),
  -- ("M-p", spawn "system-setup-xorg"),
  -- ("M-s", spawn "bashwall -sr"),
  ("M-a", windowMenu),
  -- ("M-f", spawn "thunar"),
  -- ("M-f", spawn "pcmanfm"),
  -- ("M-q", promote),
  -- ("M-f", spawn "sensible-file-manager"),
  -- ("M-v", spawn "gvim"),
  -- ("M-t", spawn "emacs"),
  ("M-<Return>", spawn $ XMonad.terminal defaults),
  ("M-S-<Return>", windows W.swapMaster),
  ("M-<Backspace>", spawn "xmonad --recompile; xmonad --restart"),
  -- TODO: Make these bindings programatically, like the workspace switching ones
  ("M-w", viewScreen 0),
  ("M-e", viewScreen 1),
  ("M-r", viewScreen 2),
  ("M-S-w", sendToScreen 0),
  ("M-S-e", sendToScreen 1),
  ("M-S-r", sendToScreen 2),
  ("M-S-<Backspace>", io (exitWith ExitSuccess))
  ]
  ++
  [ (otherModMasks ++ "M-" ++ [key], action tag)
    | (tag, key)  <- zip myWorkspaces "123456789"
    , (otherModMasks, action) <- [ ("", windows . W.greedyView) -- W.greedyView or W.view
                                    , ("S-", windows . W.shift)]
  ]

-- Layouts
myLayoutFull = (desktopLayoutModifiers
               -- $ fullscreenFull
               $ lessBorders OnlyFloat -- remove borders from fullscreen floats
               $ layoutHintsWithPlacement (0.5, 0.5) Full)
               ||| noBorders (fullscreenFull Full)

myLayoutMain = desktopLayoutModifiers
               $ maximize
               $ lessBorders OnlyFloat -- remove borders from fullscreen floats
               $ layoutHintsWithPlacement (0.5, 0.5)
               (tiled ||| Mirror tiled ||| Grid)
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    -- Percent of screen to increment by when resizing panes
    delta   = 5/100

myLayout = onWorkspaces ["1", "2"] myLayoutFull $ -- full screen layout
           myLayoutMain -- tiling layout

myWindowRules = composeAll [
  -- resource     =? "desktop_window"          --> doIgnore,
  -- title        =? "ediff"                   --> doFloat,
  -- title        =? "xfce4-notifyd"           --> doIgnore,
  title        =? "File Operation Progress" --> doCenterFloat,
  title        =? "Copying files"           --> doCenterFloat,
  title        =? "Moving files"            --> doCenterFloat,
  title        =? "Deleting files"          --> doCenterFloat,
  className    =? "Xmessage"                --> doCenterFloat,
  -- className    =? "Orage"                   --> doFloat,
  -- className    =? "Galculator"              --> doFloat,
  className    =? "Gimp"                    --> doFloat,
  className    =? "Gimp-2.8"                --> doFloat,
  className    =? "Wine"                    --> doFloat,
  className    =? "VirtualBox"              --> doFloat,

  -- Hackish way to support fullscreen windows:
  isFullscreen                              --> doFullFloat
  -- Allow focusing other monitors without killing fullscreen:
   -- isFullscreen -?> (doF W.focusDown <+> doFullFloat)
  ]
