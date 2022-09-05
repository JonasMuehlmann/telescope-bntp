-- https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#guide-to-your-first-picker

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values

local insert_link = function(prompt_bufnr)
    local linkDestionation = action_state.get_selected_entry().value
    local insertedText = "["..linkDestionation.."]".."("..linkDestionation..")"

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
        finder = finders.new_oneshot_job(vim.tbl_flatten{"bntp.go", "document","list", "--path-format"}, opts),
        sorter = conf.file_sorter(opts),
        previewer = conf.file_previewer(opts),
        attach_mappings = function(_, map)
            map('i', '<c-l>', insert_link)
            map('n', '<c-l>', insert_link)

            return true
        end,
    }):find()
end

-- TODO:This all is pretty messy, but I want to get it done ASAP
local  links = function(opts)
    opts.entry_maker = make_entry.gen_from_file(opts)

    local filterCurrentDocument = [[
    {
        "path": {
            "operand": {
                "operand": "]]..vim.fn.expand('%:p')..[["
            },
            "operator": "FilterEqual"
        }
    }
    ]]


        local createLinkedDocumentIDsFragment = function()
        local getCurrentDocumentCommandHandle = io.popen("bntp.go document find-first --filter '" .. filterCurrentDocument.."'")
        local currentDocumentSerialized = getCurrentDocumentCommandHandle:read("*a")
        getCurrentDocumentCommandHandle:close()

        -- if currentDocumentSerialized == "null" then
        --    -- TODO: Empty return
        -- end

        local currentDocument = vim.json.decode(currentDocumentSerialized)
        local documentIDs = currentDocument["linked_documentIDs"]

        return table.concat(documentIDs, ",")
    end


    local makeFilterLinkedDocuments = function(linkedDocumentIDsFragment)
        return [[
    {
        "id": {
            "operand": {
                "operands": []]..linkedDocumentIDsFragment..[[]
            },
            "operator": "FilterIn"
        }
    }
    ]]
end
    pickers.new(opts, {
        prompt_title = "bntp document links",
        finder = finders.new_oneshot_job(vim.tbl_flatten{
            "bntp.go",
            "document",
            "list",
            "--path-format",
            "--filter",
            makeFilterLinkedDocuments(createLinkedDocumentIDsFragment())
        }, opts),

        sorter = conf.file_sorter(opts),
        previewer = conf.file_previewer(opts),
    }):find()
end

local  backlinks = function(opts)
    opts.entry_maker = make_entry.gen_from_file(opts)

    local filterCurrentDocument = [[
    {
        "path": {
            "operand": {
                "operand": "]]..vim.fn.expand('%:p')..[["
            },
            "operator": "FilterEqual"
        }
    }
    ]]


        local createBacklinkedDocumentIDsFragment = function()
        local getCurrentDocumentCommandHandle = io.popen("bntp.go document find-first --filter '" .. filterCurrentDocument.."'")
        local currentDocumentSerialized = getCurrentDocumentCommandHandle:read("*a")
        getCurrentDocumentCommandHandle:close()

        -- if currentDocumentSerialized == "null" then
        --    -- TODO: Empty return
        -- end

        local currentDocument = vim.json.decode(currentDocumentSerialized)
        local documentIDs = currentDocument["backlinked_documentIDs"]

        return table.concat(documentIDs, ",")
    end


    local makeFilterBacklinkedDocuments = function(linkedDocumentIDsFragment)
        return [[
    {
        "id": {
            "operand": {
                "operands": []]..linkedDocumentIDsFragment..[[]
            },
            "operator": "FilterIn"
        }
    }
    ]]
end
    pickers.new(opts, {
        prompt_title = "bntp document links",
        finder = finders.new_oneshot_job(vim.tbl_flatten{
            "bntp.go",
            "document",
            "list",
            "--path-format",
            "--filter",
            makeFilterBacklinkedDocuments(createBacklinkedDocumentIDsFragment())
        }, opts),

        sorter = conf.file_sorter(opts),
        previewer = conf.file_previewer(opts),
    }):find()
end


-- local  related_pages = function(opts)
--     opts.entry_maker = make_entry.gen_from_file(opts)

--     pickers.new(opts, {
--         prompt_title = "bntp document references",
--         finder = finders.new_oneshot_job(vim.tbl_flatten{"documentmanager","--related_pages", vim.fn.expand('%:p')}, opts),
--         sorter = conf.file_sorter(opts),
--         previewer = conf.file_previewer(opts),
--     }):find()
-- end

-- local  sources = function(opts)
--     opts.entry_maker = make_entry.gen_from_file(opts)

--     pickers.new(opts, {
--         prompt_title = "bntp document references",
--         finder = finders.new_oneshot_job(vim.tbl_flatten{"documentmanager","--sources", vim.fn.expand('%:p')}, opts),
--         sorter = conf.file_sorter(opts),
--         previewer = conf.file_previewer(opts),
--     }):find()
-- end


return require("telescope").register_extension({
	exports = {
		documents = documents,
        links = links,
        backlinks = backlinks,
        -- related_pages = related_pages,
        -- sources =sources,
	},
})
