-- ############################################################################
-- Neovide specific config
-- ############################################################################

-- Font
-- vim.opt.guifont = "FiraCode Nerd Font:h16"
vim.opt.guifont = "ZedMono NF:h16"

-- Floating window blur
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

-- Use windowed fullscreen
vim.g.neovide_fullscreen = true
-- Window transparency
vim.g.neovide_transparency = 0.9
-- Animate cursor in insert mode
vim.g.neovide_cursor_animate_in_insert_mode = true
-- Particles on cursor animation
vim.g.neovide_cursor_vfx_mode = "sonicboom"

-- Sane copy/paste
vim.keymap.set("v", "<SC-C>", '"+y', { noremap = true })
vim.keymap.set("n", "<SC-V>", '"+P', { noremap = true })
vim.keymap.set("v", "<SC-V>", '"+P', { noremap = true })
vim.keymap.set("c", "<SC-V>", '<C-o>"+<C-o>P', { noremap = true })
vim.keymap.set("i", "<SC-V>", '<ESC>"+Pi', { noremap = true })
vim.keymap.set("t", "<SC-V>", '<C-\\><C-n>"+Pi', { noremap = true })
