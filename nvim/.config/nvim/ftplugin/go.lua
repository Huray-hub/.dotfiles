local which_key_ok, which_key = pcall(require, 'which-key')
if not which_key_ok then
    return
end

local my_utils_ok, my_utils = pcall(require, 'huray.my-utils')
if not my_utils_ok then
    return
end

local command = my_utils.command

local opts = {
    mode = 'n', -- NORMAL mode
    prefix = '<leader>',
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
    G = {
        name = 'Go',
        r = {
            function()
                command('GoGenReturn')
            end,
            'Generate return',
        },
        l = {
            function()
                command('GoLint')
            end,
            'Lint',
        },
        --[[ i = { ]]
        --[[     function() ]]
        --[[         command('GoImpl') ]]
        --[[     end, ]]
        --[[     '', ]]
        --[[ }, ]]

        I = { '<cmd>GoInstallDeps<Cr>', 'Install Go Dependencies' },
        f = { '<cmd>GoMod tidy<cr>', 'Tidy' },
        a = { '<cmd>GoTestAdd<Cr>', 'Add Test' },
        A = { '<cmd>GoTestsAll<Cr>', 'Add All Tests' },
        e = { '<cmd>GoTestsExp<Cr>', 'Add Exported Tests' },
        g = { '<cmd>GoGenerate<Cr>', 'Go Generate' },
        G = { '<cmd>GoGenerate %<Cr>', 'Go Generate File' },
        c = { '<cmd>GoCmt<Cr>', 'Generate Comment' },
        t = { "<cmd>lua require('dap-go').debug_test()<cr>", 'Debug Test' },
    },
    i = {
        function()
            if vim.bo.filetype == 'go' then
                command('GoIfErr')
            end
        end,
        'which_key_ignore',
    },
    r = {
        function()
            if vim.bo.filetype == 'go' then
                command('GoRename')
            else
                vim.lsp.buf.rename()
            end
        end,
        'Rename',
    },
}

which_key.register(mappings, opts)
