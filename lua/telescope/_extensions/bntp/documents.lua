local documents = {}

documents.get_tags = function(self)
    local handle = assert(io.popen('documentmanager list', 'r'))

    local output_iter = handle:lines()

    local lines = {}

    for line in output_iter do
      table.insert(lines, line)
    end 

    handle:close()

    return lines
end

return documents 
