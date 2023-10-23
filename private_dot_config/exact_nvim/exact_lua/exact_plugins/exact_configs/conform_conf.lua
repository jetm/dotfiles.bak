return function(_, _)
  require("conform").setup({
    -- Everything in opts will be passed to setup()
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt", "shellharden" },
      zsh = { "shfmt", "shellharden" },
      bats = { "shfmt", "shellharden" },
    },
    format_on_save = false,
    -- Customize formatters
    formatters = {
      stylua = {
        prepend_args = {
          "--indent-type=Spaces",
          "--quote-style=ForceDouble",
          "--sort-requires",
          "--column-width=80",
          "--indent-width=2",
          "--call-parentheses=Always",
        },
      },
      shfmt = {
        prepend_args = function(_)
          local extra_args = {
            "-sr",
            "-ci",
            "-s",
          }

          if not vim.bo.expandtab then
            -- Default indent with Tabs
            table.insert(extra_args, "--indent")
            table.insert(extra_args, 0)
          else
            -- Indent with Spaces
            table.insert(extra_args, "--indent")
            table.insert(extra_args, vim.bo.tabstop)
          end

          return extra_args
        end,
      },
    },
  })
end