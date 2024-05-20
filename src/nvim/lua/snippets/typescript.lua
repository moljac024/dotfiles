require("luasnip.session.snippet_collection").clear_snippets("typescript")
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("typescript", {
  -- Snippets here
})
