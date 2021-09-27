-- https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#guide-to-your-first-picker

local documents = require('telescope._extensions.bntp.documents')

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local conf = require("telescope.config").values

local items = {}
--
-- TODO: Find a good way to gurantee up to date documents:
-- Reacting to db changes?
-- Checking for new tags every few seconds?
local update_documents = function(self)
    local  documents = documents .get_documents()

    for _, document in ipairs(documents) do
        table.insert(items, tag)
    end
end

local insert_link = function(prompt_bufnr)
    local linkDestionation = actions.get_selected_entry().value[1]
    local insertedText = "[]".."("..linkDestionation..")"

    actions._close(prompt_bufnr, true)

    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_text(0, cursor[1], cursor[2], cursor[1], cursor[2], { insertedText })

    vim.schedule(function()
        vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + 1})
    end)
end

local documents = function(opts)
  pickers.new(opts, {
    prompt_title = "bntp documents",
    finder = finders.new_table {
      results = documents.get_tags()
    },
    sorter = conf.generic_sorter(opts),
    previewer = conf.file_previewer(opts),
  }):find()
end

return require("telescope").register_extension({
	exports = {
		documents = documents,
	},
})
