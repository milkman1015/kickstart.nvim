-- plugin to customize tabline

local theme = {
  fill = 'TabLineFill',
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = 'TabLine',
  current_tab = 'TabLineSel',
  tab = { fg = '#3b4261', bg = '#242430' },
  win = 'TabLine',
  tail = 'TabLine',
}

return {
  'nanozuki/tabby.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('tabby.tabline').set(function(line)
      return {
        {
          { ' ', hl = theme.head },
          line.sep('', theme.head, theme.fill),
        },
        line.tabs().foreach(function(tab)
          local hl = tab.is_current() and theme.current_tab or theme.tab

          local win_count = 0
          local any_modified = false
          local current_buf_name = ''

          -- walk tab.wins()
          tab.wins().foreach(function(win)
            win_count = win_count + 1
            -- get the buffer so we can get stuff from it.
            local buf = win.buf()
            -- get filename (tail only), show "No Name" for empty buffers
            local name = win.buf_name() or ''
            if name == '' then
              name = 'No Name'
            end
            if win.is_current() then
              current_buf_name = vim.fn.fnamemodify(name, ':t')
            end

            if buf and buf.id and vim.bo[buf.id].modified then
              any_modified = true
            end
            return
          end)
          local modified = any_modified and '+' or ''
          local my_stuff = ''
          if win_count > 1 then
            my_stuff = '[' .. win_count .. modified .. ']'
          elseif any_modified then
            my_stuff = '[' .. modified .. ']'
          end

          return {
            line.sep('', hl, theme.fill),
            -- tab.is_current() and '' or '',
            tab.number(),
            -- tab.name(),
            current_buf_name .. my_stuff,
            line.sep('', hl, theme.fill),
            hl = hl,
            margin = ' ',
          }
        end),
        line.spacer(),
        -- shows list of windows in tab
        line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
          local hl = win.is_current() and theme.current_tab or theme.tab
          return {
            line.sep('', hl, theme.fill),
            -- win.is_current() and '' or '',
            ' ',
            win.buf_name(),
            win.buf().is_changed() and '[+]' or '',
            ' ',
            line.sep('', hl, theme.fill),
            hl = hl,
            -- margin = ' ',
          }
        end),
        {
          line.sep('', theme.tail, theme.fill),
          { '  ', hl = theme.tail },
        },
        hl = theme.fill,
      }
    end)
  end,
}
