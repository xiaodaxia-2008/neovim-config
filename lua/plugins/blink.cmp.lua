return {
  "saghen/blink.cmp",
  dependencies = { "milanglacier/minuet-ai.nvim" }, -- 确保依赖关系
  opts = {
    sources = {
      default = { "lsp", "path", "buffer", "snippets", "minuet" },
      providers = {
        snippets = {
          opts = {
            search_paths = { vim.fn.stdpath("config") .. "/snippets" },
          },
        },
        minuet = {
          name = "minuet",
          module = "minuet.blink",
          async = true,
          -- Should match minuet.config.request_timeout * 1000,
          -- since minuet.config.request_timeout is in seconds
          timeout_ms = 3000,
          score_offset = 50, -- Gives minuet higher priority among suggestions
        },
      },
    },
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<A-y>"] = {
        function()
          require("minuet").make_blink_map()()
        end,
      },
    },
  },
}
