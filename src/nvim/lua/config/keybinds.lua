-- ############################################################################
-- Keybindings
-- ############################################################################

vim.keymap.set({ "i", "c" }, "jj", "<C-c><Esc>", {
  silent = true,
  noremap = true,
})

-- Basic movement keybinds, these make navigating splits easy for me
vim.keymap.set("n", "<A-j>", "<c-w><c-j>")
vim.keymap.set("n", "<A-k>", "<c-w><c-k>")
vim.keymap.set("n", "<A-l>", "<c-w><c-l>")
vim.keymap.set("n", "<A-h>", "<c-w><c-h>")
vim.keymap.set("i", "<A-j>", "<esc><c-w><c-j>")
vim.keymap.set("i", "<A-k>", "<esc><c-w><c-k>")
vim.keymap.set("i", "<A-l>", "<esc><c-w><c-l>")
vim.keymap.set("i", "<A-h>", "<esc><c-w><c-h>")

vim.keymap.set("n", "<leader><leader>", "<c-^>", { desc = "Go to alternate file", commander = {} })
vim.keymap.set("n", "g;", "<c-o>", { desc = "Go back", commander = {} }) -- Go back

-- Some heresy (emacs/readline keybinds)
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { noremap = true })
vim.keymap.set({ "i", "c" }, "<C-e>", "<End>", { noremap = true })
vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { noremap = true })
vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", { noremap = true })
vim.keymap.set({ "i", "c" }, "<C-k>", "<C-o>D", { noremap = true }) -- Kill to end of line

-- Y will yank from the cursor to the end of the line, to be consistent with C and D.
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Visual shifting (does not exit Visual mode)
vim.keymap.set({ "v", "x" }, "<", "<gv")
vim.keymap.set({ "v", "x" }, ">", ">gv")

vim.keymap.set("v", "Q", "gw", { desc = "Format selected text", commander = {} })
vim.keymap.set("n", "<Esc>", "<CMD>noh<CR>", { desc = "Clear search highlight", commander = {} })

-- Window splits
vim.keymap.set({ "n" }, "<leader>2", ":sp<cr>", { desc = "Split window horizontally" })
vim.keymap.set({ "n" }, "<leader>3", ":vsp<cr>", { desc = "Split window vertically" })
vim.keymap.set({ "n" }, "<leader>1", "<c-w>o", { desc = "Close other windows" })
vim.keymap.set({ "n" }, "<leader>4", "<c-w>c", { desc = "Close current window" })
vim.keymap.set({ "n" }, "<leader>0", "<c-w>c", { desc = "Close current window" })
--
vim.keymap.set({ "n" }, "<A-2>", ":sp<cr>", { desc = "Split window horizontally", commander = {} })
vim.keymap.set({ "n" }, "<A-3>", ":vsp<cr>", { desc = "Split window vertically", commander = {} })
vim.keymap.set({ "n" }, "<A-1>", "<c-w>o", { desc = "Close other windows", commander = {} })
vim.keymap.set({ "n" }, "<A-4>", "<c-w>c", { desc = "Close current window", commander = {} })
vim.keymap.set({ "n" }, "<A-0>", "<c-w>c", { desc = "Close current window", commander = {} })

vim.keymap.set({ "n" }, "<A-left>", "<CMD>bprev<CR>", { desc = "Previous buffer", commander = {} })
vim.keymap.set({ "n" }, "<A-right>", "<CMD>bnext<CR>", { desc = "Next buffer", commander = {} })
vim.keymap.set({ "n" }, "<A-,>", "<CMD>bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set({ "n" }, "<A-.>", "<CMD>bnext<CR>", { desc = "Next buffer" })

-- Buffers
vim.keymap.set("n", "<leader><Backspace>", ":bw<cr>", { desc = "Kill current buffer", commander = {} })

-- Initiate search
vim.keymap.set("n", "<leader>s", "<CMD>%s@", { desc = "Search in buffer", commander = {} })
