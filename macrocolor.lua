local M = {}

M.opts = {
  default = "monokai",
  macro = "monokai_ristretto",
  check_interval = 200,
}

M.setup = function(opts)
  local changeColorScheme = Debounce(
    vim.schedule_wrap(function()
      local reg = vim.fn.reg_recording()
      if reg ~= "" then
        vim.cmd.colorscheme(opts.macro)
      else
        vim.cmd.colorscheme(opts.default)
      end
    end),
    opts.check_interval
  )
  vim.on_key(changeColorScheme)
end

return M
