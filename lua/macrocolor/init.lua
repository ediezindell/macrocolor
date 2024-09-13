local M = {}

---Debounce a function
---@param func function
---@param wait number
---@see https://zenn.dev/vim_jp/articles/68eb77d2f2a37a
local function debounce(func, wait)
  local timer_id
  ---@vararg any
  return function()
    if timer_id ~= nil then
      vim.uv.timer_stop(timer_id)
    end
    timer_id = assert(vim.uv.new_timer())
    vim.uv.timer_start(timer_id, wait, 0, function()
      func()
      timer_id = nil
    end)
  end
end

M.opts = {
  default = "monokai",
  macro = "monokai_ristretto",
  check_interval = 200,
}

M.setup = function(user_opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, user_opts or {})

  local changeColorScheme = debounce(
    vim.schedule_wrap(function()
      local reg = vim.fn.reg_recording()
      if reg ~= "" then
        vim.cmd.colorscheme(M.opts.macro)
      else
        vim.cmd.colorscheme(M.opts.default)
      end
    end),
    M.opts.check_interval
  )

  vim.on_key(changeColorScheme)
end

return M
