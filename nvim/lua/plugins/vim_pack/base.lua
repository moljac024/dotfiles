-- ############################################################################
-- ## Lib
-- ############################################################################

-- Neovim plugin standard library
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim"
})

-- ############################################################################
-- ## Theme
-- ############################################################################

vim.pack.add({
  "https://github.com/catppuccin/nvim"
})

require("catppuccin").setup({
  flavour = "frappe",
  float = {
    solid = false,
    transparent = true,
  },
  transparent_background = not vim.g.neovide,
})

vim.cmd.colorscheme("catppuccin")

-- ############################################################################
-- ## UI
-- ############################################################################

vim.pack.add({
  "https://github.com/folke/snacks.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/lewis6991/hover.nvim",
})

require("snacks").setup({
  rename = {},
  input = {},
  git = {},
  image = {},
})

-- Which key
vim.o.timeout = true
vim.o.timeoutlen = 350
require("which-key").setup({
  preset = "helix" -- classic | modern | helix
})

-- Lualine
local lualine_theme = "auto"

require("lualine").setup({
  options = {
    theme = lualine_theme,
    -- No fancy powerline separators
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
    globalstatus = true, -- Always show one global status line
  },
  sections = {
    lualine_c = {
      {
        function()
          local has_hbac, hbac_state = pcall(require, "hbac.state")
          if not has_hbac then
            return ""
          end

          local cur_buf = vim.api.nvim_get_current_buf()
          return hbac_state.is_pinned(cur_buf) and "󰐃" or ""
          -- tip: nerd fonts have pinned/unpinned icons!
        end,
        color = { fg = "#ef5f6b", gui = "bold" },
      },
      "filename",
    },
    lualine_x = { "copilot", "encoding", "fileformat", "filetype" },
  },
})

-- Notifications
local fidget = require("fidget")
fidget.setup({
  notification = {
    window = {
      -- border: "none"|"single"|"double"|"rounded"|"solid"|"shadow"|string[]
      border = "double",
      -- Make sure window is transparent
      winblend = 0,
      -- Make sure notifications are high enough (the default 45 doesn't
      -- cover telescope, for example)
      zindex = 250,
    },
  },
})

-- Make this the default notify fn
local function notify(msg, level, opts)
  -- Fidget uses key where some other implementations use id. Standardize
  -- and make both behave the same
  if opts and opts.id ~= nil then
    opts.key = opts.id
  elseif opts and opts.key ~= nil then
    opts.id = opts.key
  end
  return fidget.notify(msg, level, opts)
end
vim.notify = notify

local has_telescope, telescope = pcall(require, "telescope")
if has_telescope then
  telescope.load_extension("fidget")
end

-- Hover
local hover = require("hover")

hover.config({
  providers = {
    'hover.providers.lsp',
    'hover.providers.diagnostic',
    'hover.providers.dap',
    'hover.providers.man',
    'hover.providers.dictionary',
    -- Optional, disabled by default:
    -- 'hover.providers.gh',
    -- 'hover.providers.gh_user',
    -- 'hover.providers.jira',
    'hover.providers.fold_preview',
    -- 'hover.providers.highlight',
  },
  preview_opts = {
    border = "single",
  },
  -- Whether the contents of a currently open hover window should be moved
  -- to a :h preview-window when pressing the hover keymap.
  preview_window = false,
  title = true,
  mouse_providers = {
    "hover.providers.lsp",
  },
  mouse_delay = 1000,
})

-- Setup keymaps
vim.keymap.set("n", "K", function()
  if vim.bo.filetype ~= 'help' then
    hover.open()
  else
    vim.api.nvim_feedkeys("K", 'ni', true)
  end
end, { desc = "Hover (open)" })
vim.keymap.set("n", "<leader>k", hover.open, { desc = "Hover (open)" })
vim.keymap.set("n", "gK", hover.enter, { desc = "Hover (enter)" })

-- ############################################################################
-- ## Mini
-- ############################################################################

vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim"
})

require('mini.extra').setup()
require('mini.ai').setup()
require('mini.comment').setup()
require('mini.icons').setup()
require('mini.diff').setup()
require('mini.pick').setup({
  mappings = {
    move_down = '<C-j>',
    move_up   = '<C-k>',
  }
})

local diff = require("mini.diff")
diff.setup({
  -- Disabled by default
  source = diff.gen_source.none(),
})

local function override_select()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(items, opts, on_choice)
    local start_opts = { window = { config = { width = vim.o.columns } } }
    ---@diagnostic disable-next-line: undefined-global
    return MiniPick.ui_select(items, opts, on_choice, start_opts)
  end
end

override_select()

vim.keymap.set('n', '<leader>f', function()
  MiniPick.builtin.files()
end, { desc = 'Open file picker', commander = {} })

vim.keymap.set('n', '<leader>b', function()
  MiniPick.builtin.buffers()
end, { desc = 'Open buffer picker', commander = {} })

vim.keymap.set('n', '<leader>/', function()
  MiniPick.builtin.grep_live()
end, { desc = 'Open global search picker', commander = {} })

vim.keymap.set('n', '<leader>h', function()
  MiniPick.builtin.help()
end, { desc = 'Open help picker', commander = {} })

vim.keymap.set('n', "<leader>'", function()
  MiniPick.builtin.resume()
end, { desc = 'Open last picker', commander = {} })

-- ############################################################################
-- ## Autocomplete
-- ############################################################################

vim.pack.add({
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-cmdline",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/onsails/lspkind.nvim",
})

vim.opt.completeopt = { "menu", "menuone", "preview", "noselect", "noinsert" }
vim.opt.shortmess:append("c")

local lspkind = require("lspkind")
lspkind.init({})

local cmp = require("cmp")

---@diagnostic disable-next-line: unused-local
local down_mapping = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
  else
    cmp.complete()
  end
end, { "i", "c" })

local up_mapping = cmp.mapping(function(fallback)
  local function select_prev()
    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
  end

  if cmp.visible() then
    select_prev()
  else
    fallback()
  end
end, { "i", "c" })

local accept_mapping = cmp.mapping(function(fallback)
  if cmp.visible() then
    local selected = cmp.get_selected_entry()
    if selected ~= nil then
      return cmp.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      })
    end
  end
  -- If we got here, fallback
  fallback()
end, { "i", "c" })

cmp.setup({
  completion = {
    -- autocomplete = false, -- Only trigger completion when explicitly called
  },
  ---@diagnostic disable-next-line: missing-fields
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      menu = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
      },
    }),
  },
  sources = {
    -- { name = "copilot",  group_index = 1 },
    { name = "nvim_lsp", group_index = 1 },
    { name = "buffer",   group_index = 1 },
    { name = "path",     group_index = 1 },
  },
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-n>"] = down_mapping,
    ["<C-p>"] = up_mapping,
    ["<C-j>"] = down_mapping,
    ["<C-k>"] = up_mapping,
    ["<CR>"] = accept_mapping,
    ["<C-CR>"] = accept_mapping,
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "s" }),
    ["<Tab>"] = down_mapping,
    ["<S-Tab>"] = up_mapping,
  },
})

-- Command line completions
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    {
      { name = 'path' }
    },
    {
      {
        name = 'cmdline',
        option = {
          ignore_cmds = { 'Man', '!' }
        }
      }
    }
  )
})

-- ############################################################################
-- ## Util
-- ############################################################################

vim.pack.add({
  "https://github.com/axkirillov/hbac.nvim",
})

local hbac = require("hbac")
hbac.setup({
  -- set autoclose to false if you want to close manually
  autoclose = true,
  -- hbac will start closing unedited buffers once that number is reached
  threshold = 10,
  close_command = function(bufnr)
    vim.api.nvim_buf_delete(bufnr, {})
  end,
  -- hbac will close buffers with associated windows if this option is `true`
  close_buffers_with_windows = false,
})

-- ############################################################################
-- ## Obsidian
-- ############################################################################

local vault_path = os.getenv("NOTEBOOK_PATH")
if vault_path then
  vim.pack.add({
    "https://github.com/obsidian-nvim/obsidian.nvim",
  })

  require("obsidian").setup({
    legacy_commands = false, -- this will be removed in the next major release
    daily_notes = {
      folder = "Journal",
      date_format = "%Y-%m-%d",
    },
    workspaces = {
      {
        name = "personal",
        path = vault_path,
      },
    },
  })
end
