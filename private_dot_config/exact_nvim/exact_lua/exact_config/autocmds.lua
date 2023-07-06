local function augroup(name)
  return vim.api.nvim_create_augroup("jetm_" .. name, { clear = true })
end

local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- General settings:
--------------------

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("YankHighlight"),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = "500" })
  end,
})

-- Don't auto commenting new lines
autocmd("BufEnter", {
  pattern = "",
  command = "set fo-=c fo-=r fo-=o",
})

-- close some filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query", -- :InspectTree
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "floaterm",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set(
      "n",
      "q",
      "<cmd>close<CR>",
      { buffer = event.buf, silent = true }
    )
  end,
})

--
-- Settings for filetypes:
--

-- Set indentation to 2 spaces
autocmd("Filetype", {
  group = augroup("setIndent"),
  pattern = { "yaml", "lua" },
  command = "setlocal shiftwidth=2 tabstop=2 sts=2 expandtab",
})

-- Show by default 4 spaces for a tab
autocmd("Filetype", {
  group = augroup("setIndent"),
  pattern = { "go" },
  command = "setlocal shiftwidth=4 tabstop=4 sts=4 noexpandtab",
})

-- Enable wrap
autocmd("Filetype", {
  group = augroup("wrap"),
  pattern = { "markdown", "gitcommit" },
  command = "setlocal wrap",
})

-- Apply changes in chezmoi managed files
autocmd("BufWritePost", {
  pattern = os.getenv 'HOME' .. '/.local/share/chezmoi/*',
  command = "silent !chezmoi apply --source-path %",
})

-- Terminal settings:
---------------------

-- Open a Terminal on the right tab
autocmd("CmdlineEnter", {
  command = "command! Term :botright vsplit term://$SHELL",
})

-- Enter insert mode when switching to terminal
autocmd("TermOpen", {
  command = "setlocal listchars= nonumber norelativenumber nocursorline",
})

autocmd("TermOpen", {
  pattern = "",
  command = "startinsert",
})

-- Close terminal buffer on process exit
autocmd("BufLeave", {
  pattern = "term://*",
  command = "stopinsert",
})
