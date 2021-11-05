M = {}
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        "git", "clone", "https://github.com/wbthomason/packer.nvim",
        install_path
    })
    execute("packadd packer.nvim")
end

function M.reload_config()
    vim.cmd("source ~/.config/nvim/init.lua")
    vim.cmd("source ~/.config/nvim/lua/plugins.lua")
    vim.cmd(":PackerCompile")
    vim.cmd(":PackerClean")
    vim.cmd(":PackerInstall")
end

-- Need to replace this once lua api has vim modes
vim.api.nvim_exec([[
  augroup PackerReload
    autocmd!
    autocmd BufWritePost plugins.lua lua require'plugins'.reload_config()
  augroup end
]], false)

local packer = require("packer")
local use = packer.use

packer.reset()
packer.init({
    max_jobs = 16,
    luarocks = {
        -- Set the python command to use for running hererocks
        python_cmd = 'python3'
    }
})

packer.startup({
    function()
        -- Need to be at the beginning
        use {
            "lewis6991/impatient.nvim",
            config = function() require('impatient') end
        }

        -- A faster version of filetype.vim
        -- Still missing colors in some files
        -- use {"nathom/filetype.nvim"}

        -- Packer can manage itself
        use {'wbthomason/packer.nvim'}

        -- Neovim plugin that allows you to easily write your .vimrc in lua or any lua based language
        use {'svermeulen/vimpeccable', requires = {'tpope/vim-repeat'}}

        -- We recommend updating the parsers on update
        use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
            requires = {
                {'kyazdani42/nvim-web-devicons'},
                {'nvim-treesitter/nvim-treesitter-refactor'},
                {'nvim-treesitter/nvim-treesitter-textobjects'},
                {'romgrk/nvim-treesitter-context'}, {'p00f/nvim-ts-rainbow'}
            },
            config = function() require('plugins.nvim-treesitter') end
        }

        --
        -- Navigation/Movement
        --
        -- fuzzy finder
        -- Replace fzf
        use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}

        use {
            'nvim-telescope/telescope.nvim',
            requires = {
                'nvim-telescope/telescope-fzf-native.nvim',
                'yamatsum/nvim-nonicons', 'nvim-lua/popup.nvim',
                'nvim-lua/plenary.nvim'
            },
            config = function() require('plugins.telescope') end
        }

        -- fast grep using ripgrep. It allows to change grepping directory
        use {
            'Yggdroot/LeaderF',
            run = ':LeaderfInstallCExtension',
            config = function() require('plugins.leaderf') end
        }

        -- Better quickfix window in Neovim, polish old quickfix window
        use {'kevinhwang91/nvim-bqf'}

        -- use {'camspiers/snap',
        -- config = function() require('plugins.snap')
        -- end}

        -- Smooth scroll
        use {
            'karb94/neoscroll.nvim',
            config = function()
                require('neoscroll').setup({mappings = {}})
            end
        }

        -- even better % navigate and highlight matchin words
        use {
            'andymass/vim-matchup',
            config = function() require('plugins.vim-matchup') end,
            event = 'CursorMoved',
            opt = true
        }

        use {
            'Jorengarenar/vim-MvVis',
            config = function() require('plugins.vim-MvVis') end
        }

        --
        -- UI
        --
        -- Vim version
        -- use 'joshdick/onedark.vim'
        -- Coping joshdick
        -- use {'ii14/onedark.nvim'}
        -- More complete
        use {
            'navarasu/onedark.nvim',
            config = function() require('onedark').setup() end
        }

        -- Icon set using nonicons for neovim plugins and settings
        use {
            'yamatsum/nvim-nonicons',
            requires = {'kyazdani42/nvim-web-devicons'}
        }

        -- Apply fast colors
        use {
            'norcalli/nvim-colorizer.lua',
            config = function() require('plugins.nvim-colorizer') end
        }

        -- Neovim tabline plugin
        use {
            'romgrk/barbar.nvim',
            config = function() require('plugins.barbar') end
        }

        -- Indent guides on blank lines for Neovim
        use {
            'lukas-reineke/indent-blankline.nvim',
            config = function() require('plugins.indent-blankline') end
        }

        -- spaceline is slower
        -- Galaxyline lacks of nice configurations, like feline has
        -- lualine has better structure and theme, it's more like spaceline
        use {
            'nvim-lualine/lualine.nvim',
            config = function() require('plugins.lualine') end
        }

        --
        -- Motions
        --
        -- Next-generation motion plugin for incredibly fast on-screen navigation
        -- Replace hop.nvim and quick-scope
        use {
            'ggandor/lightspeed.nvim',
            config = function() require('plugins.lightspeed') end
            -- after = 'coq_nvim',
            -- after = 'nvim-cmp'
        }

        -- Enable opening a file in a given line
        use {'wsdjeg/vim-fetch'}

        -- Go to the last edited place
        use {
            'ethanholz/nvim-lastplace',
            config = function() require('plugins.nvim-lastplace') end
        }

        --
        -- Search/Replace
        --
        use {'mg979/vim-visual-multi'}

        -- Substitute preview
        use {'osyo-manga/vim-over'}

        --
        -- Copy/Paste
        --
        -- Dynamically show content of vim registers
        use {
            'gennaro-tedesco/nvim-peekup',
            config = function() require('plugins.nvim-peekup') end
        }

        -- Handles bracketed-paste-mode in vim (aka. automatic `:set paste`)
        use {'ConradIrwin/vim-bracketed-paste'}

        -- seamless integration for vim and tmux's clipboard
        -- Allows to copy between multiple neovim instances
        -- tmux.nvim needs a lot configuration
        use {'roxma/vim-tmux-clipboard'}

        -- Pasting in Vim with indentation adjusted to destination context
        -- It breaks vim-repeat
        -- use {'sickill/vim-pasta'}

        --
        -- Diff/Git
        --
        -- Weapon to fight against conflicts in Vim
        -- [x and ]x mappings are defined as default
        use {'rhysd/conflict-marker.vim'}

        -- Git features and provider for feline
        -- like gitgutter shows hunks etc on sign column
        use {
            'lewis6991/gitsigns.nvim',
            requires = {'nvim-lua/plenary.nvim'},
            config = function() require('plugins.gitsigns') end
        }

        -- Disable because crashes nvim
        -- -- magit for neovim
        -- use {
        --     'TimUntersberger/neogit',
        --     requires = {'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim'},
        --     config = function() require('plugins.neogit') end
        -- }
        --
        -- single tabpage interface for easily cycling through diffs for all
        -- modified files for any git rev
        use {
            'sindrets/diffview.nvim',
            config = function() require('plugins.diffview') end
        }

        --
        -- Text manipulation
        --
        -- Expand selection
        use {
            'terryma/vim-expand-region',
            requires = {
                {'kana/vim-textobj-user'}, {'kana/vim-textobj-line'},
                {'machakann/vim-textobj-functioncall'},
                {'sgur/vim-textobj-parameter'}
            }
        }

        -- Vim plugin, insert or delete brackets, parens, quotes in pair
        use {
            "windwp/nvim-autopairs",
            requires = {'nvim-treesitter/nvim-treesitter'},
            config = function() require('plugins.nvim-autopairs') end
        }

        -- Quoting/parenthesizing made simple
        use {'machakann/vim-sandwich'}

        -- Enable repeating supported plugin maps with '.'
        use {'tpope/vim-repeat'}

        -- Vim plugin for intensely nerdy commenting powers
        use {
            'preservim/nerdcommenter',
            config = function() require('plugins.nerd-commenter') end
        }

        -- enhanced increment/decrement plugin for Neovim
        use {'monaqa/dial.nvim'}

        -- Nvim-plugin for doing the opposite of join-line (J) of arguments
        -- example: use ,<leader>j
        -- Not working, produces many errors
        -- use {
        --     'AckslD/nvim-revJ.lua',
        --     requires = {'kana/vim-textobj-user', 'sgur/vim-textobj-parameter'},
        --     config = function()
        --         require("revj").setup({
        --             keymaps = {
        --                 operator = "<Leader>J", -- for operator (+motion)
        --                 line = "<Leader>j", -- for formatting current line
        --                 visual = "<Leader>j" -- for formatting visual selection
        --             }
        --         })
        --     end
        -- }

        --
        -- Completion
        --
        use {
            'ms-jpq/coq_nvim',
            branch = 'coq',
            run = ':COQdeps',
            config = function() require('plugins.coq') end
        }

        -- coq_nvim snippets
        use {'ms-jpq/coq.artifacts', branch = 'artifacts'}

        -- nvim-cmp is slower than coq_nvim. Test it more later
        -- {"rafamadriz/friendly-snippets"},
        --         { "hrsh7th/cmp-vsnip", after = "nvim-cmp" },
        --         { "hrsh7th/vim-vsnip", after = "nvim-cmp" },
        --         { "lukas-reineke/cmp-rg", after = "nvim-cmp" },
        -- use {
        --     'hrsh7th/nvim-cmp',
        --     requires = {
        --         {"hrsh7th/cmp-nvim-lsp"}, {"onsails/lspkind-nvim"},
        --         {"nvim-treesitter/nvim-treesitter"},
        --         {"hrsh7th/cmp-nvim-lua", after = "nvim-cmp"},
        --         {"hrsh7th/cmp-buffer", after = "nvim-cmp"},
        --         {"hrsh7th/cmp-path", after = "nvim-cmp"},
        --         {'quangnguyen30192/cmp-nvim-ultisnips', after = "nvim-cmp"}
        --     },
        --     config = function() require('plugins.nvim-cmp') end
        -- }


        -- use {
        --     'tzachar/cmp-tabnine',
        --     run = './install.sh',
        --     requires = 'hrsh7th/nvim-cmp',
        --     config = function() require('plugins.cmp-tabnine') end
        -- }

        -- It's not ready yet
        -- use({
        --     'jameshiew/nvim-magic',
        --     config = function() require('nvim-magic').setup() end,
        --     requires = {'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim'}
        -- })

        --
        -- LSP
        --
        use {
            'neovim/nvim-lspconfig',
            requires = {
                {
                    -- Signature hint when typing
                    'ray-x/lsp_signature.nvim'
                }, {
                    -- Generate statusline components from the built-in LSP client
                    'nvim-lua/lsp-status.nvim'
                }, {
                    -- Pictograms for LSP completion system
                    'onsails/lspkind-nvim'
                }, {
                    -- Better diagnostic list
                    'folke/lsp-trouble.nvim'
                }

            },
            config = function() require('plugins.lsp') end
        }

        -- replace lsp-saga
        -- Use Neovim as a language server to inject LSP diagnostics, code
        -- actions, and more via Lua
        use {
            "jose-elias-alvarez/null-ls.nvim",
            requires = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"}
        }

        -- use {'github/copilot.vim' }

        -- window for showing LSP detected issues in code
        use {
            'folke/lsp-trouble.nvim',
            config = function() require('plugins.lsp-trouble') end
        }

        -- lsp status
        use {
            "nvim-lua/lsp-status.nvim",
            config = function() require('plugins.lsp-status') end
        }

        -- Replacing ale, as it's big for just removing whitespaces and do formatting
        use {
            'ntpeters/vim-better-whitespace',
            config = function()
                require('plugins.vim-better-whitespace')
            end
        }

        use {
            'mhartington/formatter.nvim',
            config = function() require('plugins.formatter') end
        }

        --
        -- Languages support
        --
        use {'sheerun/vim-polyglot'}

        -- Wisely add if/fi, for/end in several languages
        use {'tpope/vim-endwise'}

        -- bitbake support
        use {'kergoth/vim-bitbake'}

        -- Markdown support
        -- Generate table of contents for Markdown files
        use {'mzlogin/vim-markdown-toc', opt = true}

        --
        -- File modifications
        --
        -- An alternative sudo.vim
        use {
            'lambdalisue/suda.vim',
            config = function() require('plugins.suda') end
        }

        -- New files created with a shebang line are automatically made executable
        use {'tpope/vim-eunuch'}

        -- File manager
        use {
            'kyazdani42/nvim-tree.lua',
            requires = 'kyazdani42/nvim-web-devicons',
            config = function() require('plugins.nvim-tree') end
        }

        -- A neovim lua plugin to help easily manage multiple terminal windows
        use {
            'akinsho/nvim-toggleterm.lua',
            config = function() require('plugins.nvim-toggleterm') end
        }

        -- todo searcher
        -- No longer needed
        -- use {
        --     'folke/todo-comments.nvim',
        --     requires = 'nvim-lua/plenary.nvim',
        --     config = function() require('plugins.todo-comments') end
        -- }

        -- Have not found an use
        -- Create key bindings that stick. Displays a popup with possible
        -- keybindings of the command you started typing
        -- use {
        --     'folke/which-key.nvim',
        --     config = function()
        --         require('which-key').setup {
        --             -- your configuration comes here
        --             -- or leave it empty to use the default settings
        --         }
        --     end
        -- }

    end,
    config = {display = {open_fn = require('packer.util').float}}
})

return M
