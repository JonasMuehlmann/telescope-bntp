-- https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#guide-to-your-first-picker

local documents = require('documents')

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
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

-- our picker function: colors
local colors = function(opts)
  pickers.new(opts, {
    prompt_title = "bntp documents",
    finder = finders.new_table {
      results = documents.get_tags()
    },
    sorter = conf.generic_sorter(opts),
  }):find()
end

-- to execute the function
colors()