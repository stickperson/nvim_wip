-- n, v, i, t = mode names

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local M = {}

M.general = {
  i = {
    -- go to  beginning and end
    ["<C-b>"] = { "<ESC>^i", "beginning of line" },
    ["<C-e>"] = { "<End>", "end of line" },

    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "move left" },
    ["<C-l>"] = { "<Right>", "move right" },
    ["<C-j>"] = { "<Down>", "move down" },
    ["<C-k>"] = { "<Up>", "move up" },
  },

  n = {
    ["<ESC>"] = { "<cmd> noh <CR>", "no highlight" },

    -- switch between windows
    ["<C-h>"] = { "<C-w>h", "window left" },
    ["<C-l>"] = { "<C-w>l", "window right" },
    ["<C-j>"] = { "<C-w>j", "window down" },
    ["<C-k>"] = { "<C-w>k", "window up" },

    -- save
    ["<C-s>"] = { "<cmd> w <CR>", "save file" },

    -- Copy all
    ["<C-c>"] = { "<cmd> %y+ <CR>", "copy whole file" },

    -- line numbers
    ["<leader>n"] = { "<cmd> set nu! <CR>", "toggle line number" },
    ["<leader>rn"] = { "<cmd> set rnu! <CR>", "toggle relative number" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },

    -- new buffer
    ["<leader>b"] = { "<cmd> enew <CR>", "new buffer" },
  },

  t = { ["<C-x>"] = { termcodes("<C-\\><C-N>"), "escape terminal mode" } },

  v = {
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
  },

  x = {
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', opts = { silent = true } },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "toggle comment",
    },
  },

  v = {
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "toggle comment",
    },
  },
}

M.lspconfig = {
  plugin = true,

  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

  n = {
    ["lD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      "lsp declaration",
    },

    ["ld"] = {
      function()
        vim.lsp.buf.definition()
      end,
      "lsp definition",
    },

    ["lh"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "lsp hover",
    },

    ["li"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "lsp implementation",
    },

    ["ls"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "lsp signature_help",
    },

    ["llD"] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      "lsp definition type",
    },

    ["lca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "lsp code_action",
    },

    ["lr"] = {
      function()
        vim.lsp.buf.references()
      end,
      "lsp references",
    },
    ["<leader>rn"] = {
      function()
        vim.lsp.buf.rename()
      end,
      "[R]e[n]ame",
    },

    ["df"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "floating diagnostic",
    },

    ["d["] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "goto prev",
    },

    ["d]"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "goto_next",
    },

    ["dq"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "diagnostic setloclist",
    },

    ["lf"] = {
      function()
        vim.lsp.buf.format({ async = true })
      end,
      "lsp formatting",
    },

    ["lwa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "add workspace folder",
    },

    ["lwr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "remove workspace folder",
    },

    ["lwl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "list workspace folders",
    },
  },
}

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },

    -- focus
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
  },
}

M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader>zz"] = { "<cmd> Telescope find_files <CR>", "find files" },
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "find all" },
    ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "live grep" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "find oldfiles" },
    ["<leader>tk"] = { "<cmd> Telescope keymaps <CR>", "show keys" },
    ["<leader>gs"] = { "<cmd> Telescope grep_string <CR>", "grep string" },

    -- git
    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "git status" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "pick hidden term" },

    ["<leader>tf"] = {
      function()
        if not require("nvim-tree.view").is_visible() then
          return
        end
        local node = require("nvim-tree.lib").get_node_at_cursor()

        require("telescope.builtin").find_files({
          shorten_path = true,
          cwd = node.absolute_path,
          prompt_title = "~ Find files in directory ~",
          hidden = true,
        })
      end,
      "Find files in directory selected in nvim-tree",
    },
    ["<leader>tw"] = {
      function()
        if not require("nvim-tree.view").is_visible() then
          return
        end
        local node = require("nvim-tree.lib").get_node_at_cursor()

        require("telescope.builtin").live_grep({
          shorten_path = true,
          cwd = node.absolute_path,
          prompt_title = "~ Live grep in directory ~",
          hidden = true,
        })
      end,
      "Live grep in directory selected in nvim-tree",
    },
    ["<leader>ld"] = { "<cmd> Telescope diagnostics <CR>", "lsp diagnostics" },
    ["<leader>tm"] = { "<cmd> Telescope marks <CR>", "list marks" },
    ["<leader>tr"] = { "<cmd> Telescope registers <CR>", "list registers" },
  },
}

M.whichkey = {
  plugin = true,

  n = {
    ["<leader>wK"] = {
      function()
        vim.cmd("WhichKey")
      end,
      "which-key all keymaps",
    },
    ["<leader>wk"] = {
      function()
        local input = vim.fn.input("WhichKey: ")
        vim.cmd("WhichKey " .. input)
      end,
      "which-key query lookup",
    },
  },
}

M.blankline = {
  plugin = true,

  n = {
    ["<leader>cc"] = {
      function()
        local ok, start = require("indent_blankline.utils").get_current_context(
          vim.g.indent_blankline_context_patterns,
          vim.g.indent_blankline_use_treesitter_scope
        )

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd([[normal! _]])
        end
      end,

      "Jump to current_context",
    },
  },
}

M.gitsigns = {
  plugin = true,

  n = {
    -- Navigation through hunks
    ["]c"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to next hunk",
      opts = { expr = true },
    },

    ["[c"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to prev hunk",
      opts = { expr = true },
    },

    -- Actions
    ["<leader>rh"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },

    ["<leader>ph"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview hunk",
    },

    ["<leader>gb"] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      "Blame line",
    },

    ["<leader>td"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "Toggle deleted",
    },
  },
}

M.bufferline = {
  plugin = true,

  n = {
    -- cycle through buffers
    ["<TAB>"] = { "<cmd> BufferLineCycleNext <CR>", "goto next buffer" },

    ["<S-Tab>"] = { "<cmd> BufferLineCyclePrev <CR>", "goto prev buffer" },

    -- pick buffers via numbers
    ["<Bslash>"] = { "<cmd> BufferLinePick <CR>", "Pick buffer" },
    ["<leader>x"] = { "<cmd> Bdelete!<CR>", "Close buffer" },
  },
}

M.dap = {
  n = {
    ["<leader>dc"] = { "<cmd> DapContinue <CR>", "dap continue" },
    ["<leader>do"] = { "<cmd> DapStepOver <CR>", "dap step over" },
    -- ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>", "dap toggle breakpoint"},
    ["<leader>db"] = {
      function()
        require("dap").toggle_breakpoint()
      end,
      "dap toggle breakpoint",
    },
  },
}

M.dap_python = {
  n = {
    ["<leader>dm"] = {
      function()
        require("dap-python").test_method()
      end,
      "test method",
    },
  },
}

M.harpoon = {
  plugin = true,
  n = {
    ["<leader>hc"] = {
      function()
        require("harpoon.mark").clear_all()
      end,
      "harpoon clear all marks",
    },
    ["<leader>hd"] = {
      function()
        require("harpoon.mark").rm_file()
      end,
      "harpoon remove file",
    },
    ["<leader>hm"] = {
      function()
        require("harpoon.mark").add_file()
      end,
      "harpoon add file",
    },
    ["<leader>hv"] = { "<cmd> Telescope harpoon marks <CR>", "harpoon toggle quick menu" },
  },
}

M.luasnip = {
  i = {
    ["<C-k>"] = {
      function()
        local luasnip = require("luasnip")
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end,
      "luasnip jump or expand",
    },
    ["<C-j>"] = {
      function()
        local luasnip = require("luasnip")
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end,
      "luasnip jump backwards",
    },
    ["<C-l>"] = {
      function()
        local luasnip = require("luasnip")
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end,
      "luasnip select list of options",
    },
  },
  s = {
    ["<C-k>"] = {
      function()
        local luasnip = require("luasnip")
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end,
      "luasnip jump or expand",
    },
    ["<C-j>"] = {
      function()
        local luasnip = require("luasnip")
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end,
      "luasnip jump backwards",
    },
  },
}

M.undotree = {
  n = {
    ["<leader>u"] = { "<cmd>UndotreeToggle<CR>", "[U]ndotree toggle" },
  },
}

return M
