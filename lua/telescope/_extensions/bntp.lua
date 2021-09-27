-- https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#guide-to-your-first-picker

local bntp_documents = require('telescope._extensions.bntp.documents')

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values

local document_paths = {}

-- TODO: Find a good way to gurantee up to date data
-- Reacting to db changes?
-- Checking for new tags every few seconds?
local update_documents = function(self)
    local  documents_ = bntp_documents.get_documents()

    for _, document in ipairs(documents_) do
        table.insert(document_paths, document)
    end
end

local insert_link = function(prompt_bufnr)
    local linkDestionation = action_state.get_selected_entry().value
    local insertedText = "[]".."("..linkDestionation..")"

    actions._close(prompt_bufnr, true)

    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    local nline = line:sub(0, cursor[2]) .. insertedText .. line:sub( cursor[2]+ 1)
    vim.api.nvim_set_current_line(nline)

    vim.schedule(function()
        vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + 1})
    end)
end

local documents = function(opts)
    opts.entry_maker = make_entry.gen_from_file(opts)

    pickers.new(opts, {
        prompt_title = "bntp documents",
        finder = finders.new_oneshot_job(vim.tbl_flatten{"documentmanager","--list"}, opts),
        sorter = conf.file_sorter(opts),
        previewer = conf.file_previewer(opts),
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<c-l>', insert_link)
            map('n', '<c-l>', insert_link)

            return true
        end,
    }):find()
end

local  links = function(opts)
    opts.entry_maker = make_entry.gen_from_file(opts)

    pickers.new(opts, {
        prompt_title = "bntp outgoing links",
        finder = finders.new_oneshot_job(vim.tbl_flatten{"documentmanager","--links", vim.fn.expand('%:p')}, opts),
        sorter = conf.file_sorter(opts),
        previewer = conf.file_previewer(opts),
    }):find()
end

return require("telescope").register_extension({
	exports = {
		documents = documents,
        links = links,
	},
})
