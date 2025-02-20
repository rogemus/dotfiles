local function preview_location_callback(_, result, method, _)
	if result == nil or vim.tbl_isempty(result) then
		vim.lsp.log.info(method, "No location found")
		return nil
	end
	if vim.tbl_islist(result) then
		vim.lsp.util.preview_location(result[1])
	else
		vim.lsp.util.preview_location(result)
	end
end

local function peek_definition()
	local params = vim.lsp.util.make_position_params()
	return vim.lsp.buf_request(0, "textDocument/definition", params, preview_location_callback)
end

return {
	"williamboman/mason.nvim",
	event = "VeryLazy",
	dependencies = {
		"neovim/nvim-lspconfig",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				size = { width = 0.9, height = 0.4 },
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		local servers = {
			ts_ls = {},
			html = {
				filetypes = { "html", "htmldjango", "gotmpl" },
			},
			cssls = {},
			bashls = {},
			dotls = {},
			jsonls = {},
			lua_ls = {},
			-- svelte = {},
			-- pyright = {},
			-- ruff = {},
			-- yamlls = {},
			sqlls = {},
			gopls = {
				experimentalPostfixCompletions = true,
				analyses = {
					unusedparams = true,
					shadow = true,
				},
				staticcheck = true,
			},
		}

		local formatters_linters = {
			"prettier",
			"stylua",
			-- "biome",
			-- LINTERS
			"golangci-lint",
		}

		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = true,
		})

		mason_tool_installer.setup({
			ensure_installed = formatters_linters,
		})

		local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "rounded"
			return orig_util_open_floating_preview(contents, syntax, opts, ...)
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local on_attach = function(client, bufnr)
			local function buf_set_option(...)
				vim.api.nvim_buf_set_option(bufnr, ...)
			end

			buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

			if client.name == "svelte" then
				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.js", "*.ts" },
					group = vim.api.nvim_create_augroup("svelte_ondidchangetsorjsfile", { clear = true }),
					callback = function(ctx)
						-- Here use ctx.match instead of ctx.file
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
					end,
				})
			end

			local nmap = function(keys, func, desc)
				if desc then
					desc = "LSP: " .. desc
				end

				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
			end

			nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
			nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

			nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
			nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
			nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
			nmap("<leader>D", function()
				require("telescope.builtin").lsp_document_symbols({
					symbols = { "method", "function", "struct", "constant" },
					symbol_width = 50,
				})
			end, "[D]ocument [S]ymbols")
			nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

			nmap("K", vim.lsp.buf.hover, "Hover Documentation")
			-- nmap("K", peek_definition, "Hover Documentation")
			nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
			nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		end

		mason_lspconfig.setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
					filetypes = (servers[server_name] or {}).filetypes,
				})
			end,
		})
	end,
}
