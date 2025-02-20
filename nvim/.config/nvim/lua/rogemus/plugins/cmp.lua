return {
	"hrsh7th/nvim-cmp",
	event = "VeryLazy",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",

		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		local cmp = require("cmp")
		local types = require("luasnip.util.types")
		local luasnip = require("luasnip")
		luasnip.config.setup({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { "●", "#f5c2e7" } },
					},
					[types.insertNode] = {
						active = {
							virt_text = { { "●", "#f9e2af" } },
						},
					},
				},
			},
		})

		require("luasnip.loaders.from_snipmate").lazy_load()

		local select_next = false
		vim.keymap.set({ "i" }, "<c-s>", function()
			local ok, _ = pcall(luasnip.activate_node, {
				strict = true,
				select = select_next,
			})

			if not ok then
				print("No node.")
				return
			end

			if select_next then
				return
			end

			local curbuf = vim.api.nvim_get_current_buf()
			local hl_duration_ms = 100

			local node = luasnip.session.current_nodes[curbuf]
			local from, to = node:get_buf_position({ raw = true })

			local id = vim.api.nvim_buf_set_extmark(curbuf, luasnip.session.ns_id, from[1], from[2], {
				end_row = to[1],
				end_col = to[2],
				hl_group = "Visual",
			})
			vim.defer_fn(function()
				vim.api.nvim_buf_del_extmark(curbuf, luasnip.session.ns_id, id)
			end, hl_duration_ms)

			select_next = true
			vim.uv.new_timer():start(1000, 0, function()
				select_next = false
			end)
		end)

		cmp.setup({
			window = {
				completion = {
					border = "rounded",
					winhighlight = "Normal:CmpNormal",
				},
				documentation = {
					border = "rounded",
					winhighlight = "Normal:CmpNormal",
				},
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			preselect = cmp.PreselectMode.Item,
			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sorting = {
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.locality,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "buffer", keyword_length = 3 },
			},
		})

		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
				},
			}),
		})
	end,
}
