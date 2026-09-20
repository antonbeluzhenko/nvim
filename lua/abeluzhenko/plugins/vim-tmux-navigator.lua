return {
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    -- default ctrl+hjkl bindings
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate pane left" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate pane down" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate pane up" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate pane right" },
    -- same, for the plain arrow keys Karabiner sends
    { "<Left>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate pane left" },
    { "<Down>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate pane down" },
    { "<Up>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate pane up" },
    { "<Right>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate pane right" },
  },
  init = function()
    -- define the mappings above ourselves instead of the plugin's defaults
    vim.g.tmux_navigator_no_mappings = 1
  end,
}
