--
-- Misc mappings
--

local function map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	---@cast keys LazyKeysHandler
	-- do not create the keymap if a lazy keys handler exists
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

-- moving up and down work as you would expect
-- Remap for dealing with word wrap
map(
	{ "n", "x" },
	"j",
	[[v:count == 0 ? 'gj' : 'j']],
	{ expr = true, silent = true }
)
map(
	{ "n", "x" },
	"k",
	[[v:count == 0 ? 'gk' : 'k']],
	{ expr = true, silent = true }
)

-- quitting mapping
map({ "n", "x" }, "q", ":BufDel<CR>", { silent = true })
map({ "n", "x" }, "Q", ":qa<CR>", { silent = true })

-- expand_region
map({ "x" }, "v", "<Plug>(expand_region_expand)", { silent = true })
map({ "x" }, "V", "<Plug>(expand_region_shrink)", { silent = true })

map({ "n", "i" }, "<UP>", "<Nop>", { silent = true })
map({ "n", "i" }, "<Down>", "<Nop>", { silent = true })
map({ "n", "i" }, "<Left>", "<Nop>", { silent = true })
map({ "n", "i" }, "<Right>", "<Nop>", { silent = true })

-- Visual shifting (does not exit Visual mode)
map({ "v" }, "<", "<gv", { silent = true })
map({ "v" }, ">", ">gv", { silent = true })
map({ "n" }, "<", "<<_", { silent = true })
map({ "n" }, ">", ">>_", { silent = true })

-- vimp lacks of unmap() feature
map({ "n", "v" }, "+", "<Plug>(dial-increment)")
map({ "n", "v" }, "-", "<Plug>(dial-increment)")

-- formatter
map(
	{ "n" },
	"<leader>f",
	"<cmd>lua vim.lsp.buf.format()<CR>",
	{ silent = true }
)

-- Comments
-- Ctrl-/ as VSCode and Jetbrain
map({ "n", "v" }, "<c-_>", "<Plug>NERDCommenterToggle", { silent = true })

--
-- bufferline
--
map({ "n" }, "<leader>1", ":BufferLineGoToBuffer 1<CR>", { silent = true })
map({ "n" }, "<leader>2", ":BufferLineGoToBuffer 2<CR>", { silent = true })
map({ "n" }, "<leader>3", ":BufferLineGoToBuffer 3<CR>", { silent = true })
map({ "n" }, "<leader>4", ":BufferLineGoToBuffer 4<CR>", { silent = true })
map({ "n" }, "<leader>5", ":BufferLineGoToBuffer 5<CR>", { silent = true })
map({ "n" }, "<leader>6", ":BufferLineGoToBuffer 6<CR>", { silent = true })
map({ "n" }, "<leader>7", ":BufferLineGoToBuffer 7<CR>", { silent = true })
map({ "n" }, "<leader>8", ":BufferLineGoToBuffer 8<CR>", { silent = true })
map({ "n" }, "<leader>9", ":BufferLineGoToBuffer 9<CR>", { silent = true })

--
-- Ctrl <C-> Mappings
--
--  Helper for saving file
map({ "n" }, "<C-s>", ":update<CR>", { silent = true })
map({ "v" }, "<C-s>", "<C-c>:update<CR>", { silent = true })
map({ "i" }, "<C-s>", "<C-o>:update<CR>", { silent = true })

-- CtrlP compatibility
-- fzf.vim is quicker than fzf.preview
-- Telescope is async
local ok, telescope = pcall(require, "telescope")
if not ok then
	error("Loading telescope")
	return
end

map(
	{ "n" },
	"<C-p>",
	telescope.extensions.menufacture.find_files,
	{ silent = true }
)

map(
	{ "n" },
	"<leader>g",
	telescope.extensions.menufacture.add_menu_with_default_mapping(
		require("telescope.builtin").grep_string,
		vim.tbl_extend("force", telescope.extensions.menufacture.grep_string_menu, {
			["change cwd to parent"] = function(opts, callback)
				local cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
				opts.cwd = vim.fn.fnamemodify(cwd, ":p:h:h")
				callback(opts)
			end,
		})
	),
	{ silent = true }
)

-- map( { "n" }, "<leader>lg",
--   telescope.extensions.menufacture.live_grep,
--   { silent = true }
-- )

--
-- <F1>..<F12> Mappings
--
-- NvimTree
map({ "n" }, "<F2>", ":NvimTreeToggle<CR>", { silent = true })

-- Shift + <F2>
map({ "n" }, "<S-F2>", ":NvimTreeFindFile<CR>", { silent = true })

map(
	{ "n" },
	"<F3>",
	':<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>',
	{ silent = true }
)
-- Shift + <F3>
map({ "n" }, "<F15>", ":<C-U>Leaderf! rg --recall<CR>", { silent = true })

-- F5 shows a diagnostics
map({ "n" }, "<F5>", ":TroubleToggle<CR>", { silent = true })

-- Search for words
map({ "n", "x", "o" }, "s", "<Cmd>Svart<CR>", { silent = true })
