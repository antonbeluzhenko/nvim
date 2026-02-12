local M = {}

-- Helper function to get current file path and cursor line number
local function get_file_and_line()
  local filepath = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  return filepath, line
end

-- Helper function to copy text to clipboard and notify user
local function copy_to_clipboard(text)
  vim.fn.setreg("+", text)
  vim.notify(text, vim.log.levels.INFO)
end

-- Command 1: Copy absolute path with line number
local function copy_absolute_path()
  local filepath, line = get_file_and_line()

  if filepath == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  local result = string.format("%s:%d", filepath, line)
  copy_to_clipboard(result)
end

-- Command 2: Copy git-relative path with line number
local function copy_repo_path()
  local filepath, line = get_file_and_line()

  if filepath == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  -- Find git root
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(vim.fn.expand("%:p:h")) .. " rev-parse --show-toplevel")[1]

  if vim.v.shell_error ~= 0 then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return
  end

  -- Calculate relative path from git root
  local relative_path = filepath:sub(#git_root + 2) -- +2 to remove leading slash
  local result = string.format("%s:%d", relative_path, line)
  copy_to_clipboard(result)
end

-- Command 3: Copy GitHub URL with line anchor
local function copy_github_path()
  local filepath, line = get_file_and_line()

  if filepath == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  -- Find git root
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(vim.fn.expand("%:p:h")) .. " rev-parse --show-toplevel")[1]

  if vim.v.shell_error ~= 0 then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return
  end

  -- Get remote URL
  local remote_url = vim.fn.systemlist("git -C " .. vim.fn.shellescape(git_root) .. " remote get-url origin")[1]

  if vim.v.shell_error ~= 0 or remote_url == "" then
    vim.notify("No git remote 'origin' found", vim.log.levels.WARN)
    return
  end

  -- Parse GitHub repository from remote URL
  local repo
  -- Handle SSH format: git@github.com:user/repo.git
  repo = remote_url:match("git@github%.com:(.+)%.git$")
  if not repo then
    -- Handle HTTPS format: https://github.com/user/repo.git
    repo = remote_url:match("https://github%.com/(.+)%.git$")
  end
  if not repo then
    -- Handle URLs without .git suffix
    repo = remote_url:match("git@github%.com:(.+)$")
  end
  if not repo then
    repo = remote_url:match("https://github%.com/(.+)$")
  end

  if not repo then
    vim.notify("Remote is not a GitHub repository", vim.log.levels.WARN)
    return
  end

  -- Get current branch
  local branch = vim.fn.systemlist("git -C " .. vim.fn.shellescape(git_root) .. " branch --show-current")[1]

  if vim.v.shell_error ~= 0 or branch == "" then
    -- Fallback to HEAD for detached HEAD state
    branch = "HEAD"
  end

  -- Calculate relative path from git root
  local relative_path = filepath:sub(#git_root + 2) -- +2 to remove leading slash

  -- Format GitHub URL
  local result = string.format("https://github.com/%s/blob/%s/%s#L%d", repo, branch, relative_path, line)
  copy_to_clipboard(result)
end

-- Setup function to register commands
function M.setup()
  vim.api.nvim_create_user_command("CopyPath", copy_absolute_path, {
    desc = "Copy absolute path with line number to clipboard",
  })

  vim.api.nvim_create_user_command("CopyRepoPath", copy_repo_path, {
    desc = "Copy git-relative path with line number to clipboard",
  })

  vim.api.nvim_create_user_command("CopyGithubPath", copy_github_path, {
    desc = "Copy GitHub URL with line anchor to clipboard",
  })
end

return M
