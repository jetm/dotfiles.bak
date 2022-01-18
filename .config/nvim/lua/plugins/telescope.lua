local ok, telescope = pcall(require, "telescope")
if not ok then
	error("Loading telescope")
	return
end

local ok2, telescope_actions = pcall(require, "telescope.actions")
if not ok2 then
	error("Loading telescope.actions")
	return
end

local ok3, telescope_sorters = pcall(require, "telescope.sorters")
if not ok3 then
	error("Loading telescope.sorters")
	return
end

local ok4, telescope_previewers = pcall(require, "telescope.previewers")
if not ok4 then
	error("Loading telescope.previewers")
	return
end

telescope.setup({
	defaults = {
		mappings = { i = { ["<esc>"] = telescope_actions.close } },
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"--glob=!.git/",
		},
		hidden = true,
		prompt_prefix = "🔍 ",
		selection_caret = " ",
		entry_prefix = " ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "descending",
		layout_strategy = "horizontal",
		file_sorter = telescope_sorters.get_generic_sorter,
		file_ignore_patterns = {},
		path_display = { shorten = 5 },
		generic_sorter = telescope_sorters.get_generic_fuzzy_sorter,
		winblend = 0,
		border = {},
		borderchars = {
			"─",
			"│",
			"─",
			"│",
			"╭",
			"╮",
			"╯",
			"╰",
		},
		color_devicons = true,
		use_less = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
		file_previewer = telescope_previewers.vim_buffer_cat.new,
		grep_previewer = telescope_previewers.vim_buffer_vimgrep.new,
		qflist_previewer = telescope_previewers.vim_buffer_qflist.new,
		-- Developer configurations: Not meant for general override
		buffer_previewer_maker = telescope_previewers.buffer_previewer_maker,
	},
	extensions = {
		fzf = {
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
		},
	},
})

telescope.load_extension("fzf")