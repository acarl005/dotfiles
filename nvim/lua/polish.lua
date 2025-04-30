vim.api.nvim_create_user_command(
  "Trim",
  ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s",
  { desc = "Trim the trailing whitespace off each line" }
)

vim.api.nvim_create_user_command(
  "Camel",
  "%s/\\([a-z0-9]\\)_\\([a-z0-9]\\)/\\1\\u\\2/g",
  { desc = "Convert snake case to camel case" }
)

vim.api.nvim_create_user_command("F", ":echo expand('%:p')", { desc = "Echo absolute path of current buffer" })

vim.api.nvim_create_user_command("Unescape", function()
  vim.cmd "%s/\\\\n/\\r/g"
  vim.cmd '%s/\\\\"/"/g'
end, { desc = "Unescape quotes and newlines" })

-- shows how the current buffer differs from the file on disk
vim.cmd [[
	function! s:DiffWithSaved()
		let filetype=&ft
		diffthis
		vnew | r # | normal! 1Gdd
		diffthis
		exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
		endfunc
	com! DiffSaved call s:DiffWithSaved()
]]

vim.keymap.set("n", "<leader>lc", function()
  require("snacks").picker.pick {
    title = "LSP Incoming Calls",
    finder = function(opts, ctx)
      local lsp = require "snacks.picker.source.lsp"
      local Async = require "snacks.picker.util.async"
      local win = ctx.filter.current_win
      local buf = ctx.filter.current_buf
      local bufmap = lsp.bufmap()

      ---@async
      ---@param cb async fun(item: snacks.picker.finder.Item)
      return function(cb)
        local async = Async.running()
        local cancel = {} ---@type fun()[]

        async:on(
          "abort",
          vim.schedule_wrap(function()
            vim.tbl_map(pcall, cancel)
            cancel = {}
          end)
        )

        vim.schedule(function()
          -- First prepare the call hierarchy
          local clients = lsp.get_clients(buf, "textDocument/prepareCallHierarchy")
          if vim.tbl_isempty(clients) then return async:resume() end

          local remaining = #clients
          for _, client in ipairs(clients) do
            local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
            local status, request_id = client:request("textDocument/prepareCallHierarchy", params, function(_, result)
              if result and not vim.tbl_isempty(result) then
                -- Then get incoming calls for each item
                local call_remaining = #result
                if call_remaining == 0 then
                  remaining = remaining - 1
                  if remaining == 0 then async:resume() end
                  return
                end

                for _, item in ipairs(result) do
                  local call_params = { item = item }
                  local call_status, call_request_id = client:request(
                    "callHierarchy/incomingCalls",
                    call_params,
                    function(_, calls)
                      if calls then
                        for _, call in ipairs(calls) do
                          local detail = call.from.detail or call.from.name or ""
                          ---@type snacks.picker.finder.Item
                          local item = {
                            text = detail,
                            kind = lsp.symbol_kind(call.from.kind),
                            line = "    " .. detail,
                          }
                          local loc = {
                            uri = call.from.uri,
                            range = call.from.range,
                          }
                          lsp.add_loc(item, loc, client)
                          item.buf = bufmap[item.file]
                          item.text = item.file .. "    " .. detail
                          ---@diagnostic disable-next-line: await-in-sync
                          cb(item)
                        end
                      end
                      call_remaining = call_remaining - 1
                      if call_remaining == 0 then
                        remaining = remaining - 1
                        if remaining == 0 then async:resume() end
                      end
                    end
                  )
                  if call_status and call_request_id then
                    table.insert(cancel, function() client:cancel_request(call_request_id) end)
                  end
                end
              else
                remaining = remaining - 1
                if remaining == 0 then async:resume() end
              end
            end)
            if status and request_id then table.insert(cancel, function() client:cancel_request(request_id) end) end
          end
        end)

        async:suspend()
        cancel = {}
        async = Async.nop()
      end
    end,
  }
end, { desc = "LSP incoming function calls" })
