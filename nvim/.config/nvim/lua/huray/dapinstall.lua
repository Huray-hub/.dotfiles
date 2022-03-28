local dap_install_status_ok, dap_install = pcall(require, "dap_install")

if not dap_install_status_ok then
	vim.notify("dap_install " .. dap_install .. " not found!")
	return
end

dap_install.setup({
	installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
	verbosely_call_debuggers = false,
})

-- dap_install.config("lldb", {})
