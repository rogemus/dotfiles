-- https://github.com/nvim-lua/kickstart.nvim/blob/master/lua/kickstart/plugins/autoformat.lua

local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local bo = vim.bo
local lsp = vim.lsp

local autoformat_enabled = true

api.nvim_create_user_command("AutoFormatToggle", function()
  autoformat_enabled = not autoformat_enabled
  print('Setting autoformatting to: ' .. tostring(autoformat_enabled))
end, {})


local _augroups = {}
local get_augroup = function(client)
  if not _augroups[client.id] then
    local group_name = 'af-lsp-format-' .. client.name
    local id = api.nvim_create_augroup(group_name, { clear = true })
    _augroups[client.id] = id
  end

  return _augroups[client.id]
end


api.nvim_create_autocmd('LspAttach', {
  group = api.nvim_create_augroup('af-lsp-attach-format', { clear = true }),
  callback = function(args)
    local client_id = args.data.client_id
    local client = lsp.get_client_by_id(client_id)
    local bufnr = args.buf

    -- Only attach to clients that support document formatting
    if not client.server_capabilities.documentFormattingProvider then
      return
    end

    -- Tsserver usually works poorly. Sorry you work with bad languages
    -- You can remove this line if you know what you're doing :)
    if client.name == 'tsserver' then
      return
    end

    api.nvim_create_autocmd('BufWritePre', {
      group = get_augroup(client),
      buffer = bufnr,
      callback = function()
        if not autoformat_enabled then
          return
        end

        lsp.buf.format {
          async = false,
          filter = function(c)
            return c.id == client.id
          end,
        }
      end,
    })
  end
})

api.nvim_create_augroup("AutoFormat", {})
api.nvim_create_autocmd(
  { "InsertLeave", "TextChanged" },
  {
    pattern = "*",
    callback = function()
      local buf = buf or api.nvim_get_current_buf()

      if bo.filetype == '' then
        return
      end

      if not api.nvim_buf_get_option(buf, 'modifiable') then
        return
      end

      if not api.nvim_buf_get_option(buf, "modified") then
        return
      end

      local time = os.date("%H:%M:%S")
      local filename = fn.expand('%:t')

      -- local filename = api.nvim_buf_get_name(0)
      local msg = string.format("AutoSave (%s): saved at %s", filename, time)

      api.nvim_echo({ { msg, "MsgArea" } }, true, {})
      api.nvim_buf_call(buf, function()
        cmd("silent! write")
      end)
      fn.timer_start(1500, function()
        cmd([[echon '']])
      end)
    end
  }
)
