return {
  "yetone/avante.nvim",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = function()
    -- conditionally use the correct build system for the current OS
    if vim.fn.has("win32") == 1 then
      return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    else
      return "make"
    end
  end,
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- provider = "qwen25",
    provider = "openai_o4_mini",
    auto_suggestions_provider = "openai_o4_mini",

    mappings = {
      --- @class AvanteConflictMappings
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
    },
    vim.keymap.set({ "n", "v" }, "<leader>aa", ":AvanteChat<CR>", { desc = "[A]vante: [A]sk" }),
    vim.keymap.set({ "n", "v" }, "<leader>an", ":AvanteChatNew<CR>", { desc = "[A]vante: [N]ew chat" }),
    vim.keymap.set({ "n", "v" }, "<leader>ae", ":AvanteEdit<CR>", { desc = "[A]vante: [E]dit" }),
    -- vim.keymap.set({ "n", "v" }, "<leader>ae", ":AvanteEdit<CR>", { desc = "[A]vante: [E]dit" }),

    prompt_logger = { -- logs prompts to disk (timestamped, for replay/debugging)
      enabled = true, -- toggle logging entirely
      log_dir = "avante_prompts", -- directory where logs are saved
      fortune_cookie_on_success = false, -- shows a random fortune after each logged prompt (requires `fortune` installed)
      next_prompt = {
        normal = "<C-n>", -- load the next (newer) prompt log in normal mode
        insert = "<C-n>",
      },
      prev_prompt = {
        normal = "<C-p>", -- load the previous (older) prompt log in normal mode
        insert = "<C-p>",
      },
    },
    -- set TAVILY_API_KEY for web search.
    providers = {
      qwen25 = {
        endpoint = "http://localhost:11434",
        model = "qwen2.5-coder:7b",
      },
      ollama_qwen3_8b = {
        endpoint = "http://localhost:11434",
        model = "qwen3:8b",
      },
      -- AVANTE_OPENAI_API_KEY
      openai_o4_mini = {
        __inherited_from = "openai",
        endpoint = "https://api.openai.com/v1",
        model = "o4-mini",
      },
      openai_o3 = {
        __inherited_from = "openai",
        endpoint = "https://api.openai.com/v1",
        model = "o3",
      },
      -- AVANTE_ANTHROPIC_API_KEY
      -- claude = {
      --   endpoint = "https://api.anthropic.com",
      --   model = "claude-sonnet-4",
      --   timeout = 30000,
      --   disable_tools = true,
      --   extra_request_body = {
      --     temperature = 0,
      --     max_tokens = 4096,
      --   }
      -- }
    }
    -- provider = "claude",
    -- providers = {
    --   claude = {
    --     endpoint = "https://api.anthropic.com",
    --     model = "claude-sonnet-4-20250514",
    --     timeout = 30000, -- Timeout in milliseconds
    --       extra_request_body = {
    --         temperature = 0.75,
    --         max_tokens = 20480,
    --       },
    --   },
    -- },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "stevearc/dressing.nvim", -- for input provider dressing
    "folke/snacks.nvim", -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
