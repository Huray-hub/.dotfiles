local status_ok, headlines = pcall(require, 'headlines')
if not status_ok then
    return
end

-- TODO: setup properly
local markdown_like = {
    query = vim.treesitter.query.parse(
        'markdown',
        [[
                (atx_heading [
                    (atx_h1_marker)
                    (atx_h2_marker)
                    (atx_h3_marker)
                    (atx_h4_marker)
                    (atx_h5_marker)
                    (atx_h6_marker)
                ] @headline)

                (thematic_break) @dash

                (fenced_code_block) @codeblock

                (block_quote_marker) @quote
                (block_quote (paragraph (inline (block_continuation) @quote)))
            ]]
    ),
    treesitter_language = 'markdown',
    headline_highlights = { 'Headline1', 'Headline2', 'Headline3', 'Headline4', 'Headline5', 'Headline6' },
    codeblock_highlight = 'CodeBlock',
    dash_highlight = 'Dash',
    dash_string = '-',
    quote_highlight = 'Quote',
    quote_string = '┃',
    fat_headlines = false,
    fat_headline_upper_string = '▄',
    fat_headline_lower_string = '▀',
}

headlines.setup({
    quarto = markdown_like,
    rmd = markdown_like,
    markdown = markdown_like,
})

vim.cmd([[highlight link Headline1 @variable.builtin ]])
vim.cmd([[highlight link Headline2 MatchParen ]])
vim.cmd([[highlight link Headline3 @string ]])
vim.cmd([[highlight link Headline4 @operator ]])
vim.cmd([[highlight link Headline5 @function ]])
vim.cmd([[highlight link Headline6 @constructor ]])
