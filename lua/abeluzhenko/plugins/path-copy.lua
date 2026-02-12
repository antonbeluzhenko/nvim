return {
  dir = vim.fn.stdpath("config") .. "/lua/path-copy",
  name = "path-copy",
  event = "VeryLazy",
  config = function()
    require("path-copy").setup()
  end,
}
