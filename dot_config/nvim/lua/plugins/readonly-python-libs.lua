return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    autocmds = {
      readonly_python_libs = {
        {
          event = { "BufReadPost", "BufEnter" },
          desc = "Open installed Python library files as read-only",
          callback = function(args)
            local bufnr = args.buf
            local path = vim.api.nvim_buf_get_name(bufnr)
            if path == "" then return end

            local normalized = vim.fs.normalize(path):gsub("\\", "/")
            local is_installed_python_lib = normalized:find("/site-packages/", 1, true)
              or normalized:find("/dist-packages/", 1, true)

            if is_installed_python_lib then
              vim.bo[bufnr].readonly = true
              vim.bo[bufnr].modifiable = false
            end
          end,
        },
      },
    },
  },
}
