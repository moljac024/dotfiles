local M = {}

M.ensure_installed = function(url, opts) -- ref = branch **or** tag
  opts             = opts or {}
  local ref        = opts.ref or "default"
  local user, repo = url:match("(.+)/(.+)")
  local repo_path  = vim.fn.stdpath("data") .. "/lazy/" .. repo

  ---------------------------------------------------------------------------
  -- helpers ---------------------------------------------------------------
  local function git(args, git_opts)
    git_opts = git_opts or {}
    local cmd = { "git", "-C", repo_path }; vim.list_extend(cmd, args)

    local out = vim.fn.system(cmd)
    local code = vim.v.shell_error

    if code ~= 0 and not git_opts.allow_fail then
      error(("git failed (%s):\n%s"):format(table.concat(cmd, " "), out))
    end

    return out, code
  end

  local function clone_repo()
    vim.notify(("Installing %s (%s)…"):format(url, ref or "default"))
    local out = vim.fn.system({
      "git", "clone", "--filter=blob:none",
      ("https://github.com/%s.git"):format(url),
      repo_path,
    })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone " .. url .. ":\n", "ErrorMsg" },
        { out,                                "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end

  -- ----------------------------------------------------------------------

  -- 1. Clone if missing
  local exists = (vim.uv or vim.loop).fs_stat(repo_path) ~= nil
  if not exists then
    clone_repo()               -- brand-new clone
  elseif not opts.refresh then -- cloned *and* caller said “don’t touch”
    return repo_path
  end

  -- 2. Make sure the tree is clean & up-to-date
  if git { "status", "--porcelain" } ~= "" then
    vim.notify("Resetting dirty working tree for " .. repo)
    git { "reset", "--hard" }                   -- blow away local changes
    git { "clean", "-fd" }                      -- delete untracked files
  end
  git { "fetch", "--all", "--tags", "--prune" } -- refresh refs

  -- 3. Pick branch first, tag second
  if ref and ref ~= "" then
    local function ref_exists(kind)
      -- heads | tags
      local _, code = git(
        { "show-ref", "--verify", "--quiet", ("refs/%s/%s"):format(kind, ref) },
        { allow_fail = true })
      return code == 0
    end

    if ref_exists("heads") then
      git { "checkout", ref }
      git { "pull", "--ff-only", "origin", ref }
    elseif ref_exists("tags") then
      git { "checkout", ("tags/%s"):format(ref) }
    else
      vim.notify(("Neither branch nor tag '%s' found in %s"):format(ref, repo),
        vim.log.levels.WARN)
    end
  end

  return repo_path
end

return M
