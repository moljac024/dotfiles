-- Load proper config
if vim.g.vscode then
  require("config/vscode")
else
  require("config/main")
end
