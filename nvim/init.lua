--
-- VM settings
--
local vim = vim

vim.g.python3_host_prog = os.getenv("HOME") ..
                              "/.asdf/installs/python/3.9.6/bin/python3.9"

-- Disable some unused built-in Neovim plugins
vim.g.loaded_man = false
vim.g.loaded_gzip = false
vim.g.loaded_netrwPlugin = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_zipPlugin = false
vim.g.loaded_2html_plugin = false
vim.g.loaded_remote_plugins = false

require('plugins')
require('global')
require('autocmds')
require('backup')
require('mappings')
require('colors-ui')

-- For debugging purpose
-- :lua dump(...)
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

vim.notify = function(msg, log_level, _)
    if msg:match("exit code") then return end
    if log_level == vim.log.levels.ERROR then
        vim.api.nvim_err_writeln(msg)
    else
        vim.api.nvim_echo({{msg}}, true, {})
    end
end
