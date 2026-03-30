require("colorful-menu").setup({})

require("blink.cmp").setup({
  cmdline = {
    keymap = {
      preset = "none",
    },
  },
  keymap = (function()
    local km = { preset = "default" }
    for i = 1, 10 do
      km["<A-" .. (i % 10) .. ">"] = {
        function(cmp)
          cmp.accept({ index = i })
        end,
      }
    end
    return km
  end)(),
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
  },
  sources = {
    default = function(ctx)
      local success, node = pcall(vim.treesitter.get_node)
      if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
        return { "buffer" }
      else
        return { "lsp", "path", "snippets", "buffer" }
      end
    end,
  },
  completion = {
    list = {
      selection = {
        preselect = function(ctx)
          return ctx.mode ~= "cmdline"
        end,
        auto_insert = false,
      },
    },
    menu = {
      border = nil,
      scrolloff = 1,
      auto_show = function(ctx)
        return ctx.mode ~= "cmdline"
      end,
      draw = {
        columns = { { "item_idx" }, { "label", gap = 1 }, { "kind" } },
        components = {
          item_idx = {
            text = function(ctx)
              return ctx.idx == 10 and "0" or ctx.idx >= 10 and " " or tostring(ctx.idx)
            end,
            highlight = "BlinkCmpItemIdx",
          },
          label = {
            width = { fill = true, max = 60 },
            text = function(ctx)
              local highlights_info = require("colorful-menu").blink_highlights(ctx)
              if highlights_info ~= nil then
                return highlights_info.label
              else
                return ctx.label
              end
            end,
            highlight = function(ctx)
              local highlights = {}
              local highlights_info = require("colorful-menu").blink_highlights(ctx)
              if highlights_info ~= nil then
                highlights = highlights_info.highlights
              end
              for _, idx in ipairs(ctx.label_matched_indices) do
                table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
              end
              return highlights
            end,
          },
        },
      },
    },
  },
  signature = {
    enabled = true,
  },
})
