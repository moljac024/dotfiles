-- ############################################################################
-- Keybindings
-- ############################################################################

local c = require("lib.command")

-- Basic movement keybinds, these make navigating splits easy for me
vim.keymap.set({ "n", "i" }, "<A-j>", "<c-c><c-w><c-j>", { desc = "Focus window down" })
vim.keymap.set({ "n", "i" }, "<A-k>", "<c-c><c-w><c-k>", { desc = "Focus window up" })
vim.keymap.set({ "n", "i" }, "<A-l>", "<c-c><c-w><c-l>", { desc = "Focus window right" })
vim.keymap.set({ "n", "i" }, "<A-h>", "<c-c><c-w><c-h>", { desc = "Focus window left" })

vim.keymap.set("n", "<BS>", "<c-^>", { desc = "Go to alternate file", commander = {} })

-- Some heresy (emacs/readline keybinds)
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { noremap = true })
vim.keymap.set({ "i", "c" }, "<C-e>", "<End>", { noremap = true })
vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { noremap = true })
vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", { noremap = true })
vim.keymap.set({ "i", "c" }, "<C-k>", "<C-o>D", { noremap = true }) -- Kill to end of line

-- Y will yank from the cursor to the end of the line, to be consistent with C and D.
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Visual shifting (does not exit Visual mode)
vim.keymap.set({ "v", "x" }, "<", "<gv", { desc = "Shift selection left" })
vim.keymap.set({ "v", "x" }, ">", ">gv", { desc = "Shift selection right" })

vim.keymap.set("v", "Q", "gw", { desc = "Format selected text", commander = {} })
vim.keymap.set("n", "<C-c>", "<CMD>noh<CR>", { desc = "Clear search highlight", commander = {} })

-- Window splits
vim.keymap.set({ "n" }, { "<leader>2", "<A-2>" }, "<CMD>sp<CR>", { desc = "Split window horizontally", commander = {} })
vim.keymap.set({ "n" }, { "<leader>3", "<A-3>" }, "<CMD>vsp<CR>", { desc = "Split window vertically", commander = {} })
vim.keymap.set({ "n" }, { "<leader>4", "<A-4>" }, "<c-w>c", { desc = "Close current window", commander = {} })
vim.keymap.set({ "n" }, { "<leader>1", "<A-1>" }, "<c-w>o", { desc = "Close other windows", commander = {} })

-- Map "U" to additional redo, like in helix
vim.keymap.set({ "n" }, "U", "<C-r>")

-- Buffers
c.add_command({
  {
    desc = "Kill current buffer",
    -- cmd = "<CMD>bw<CR>",
    cmd = function()
      Snacks.bufdelete()
    end,
  },
  {
    desc = "Kill current buffer (force)",
    -- cmd = "<CMD>bw!<CR>",
    cmd = function()
      Snacks.bufdelete({ force = true })
    end,
  },
  {
    desc = "Save current buffer",
    cmd = "<CMD>w<CR>"
  },
  {
    desc = "Save all buffers",
    cmd = "<CMD>wa<CR>"
  },
  {
    desc = "Refresh current buffer",
    cmd = "<CMD>e<CR>"
  },
  {
    desc = "Refresh current buffer (force)",
    cmd = "<CMD>e!<CR>"
  },
})

-- Tabs
vim.keymap.set("n", "<leader>tk", "<CMD>tabclose<CR>", { desc = "Close tab", commander = {} })
vim.keymap.set("n", "<leader>tK", "<CMD>tabonly<CR>", { desc = "Close other tabs", commander = {} })
vim.keymap.set("n", "<leader>tn", "<CMD>tabnew<CR>", { desc = "New tab", commander = {} })
vim.keymap.set({ "n" }, "<leader>t<", "<CMD>tabprevious<CR>", { desc = "Previous tab", })
vim.keymap.set({ "n" }, "<leader>t>", "<CMD>tabnext<CR>", { desc = "Next tab", })
