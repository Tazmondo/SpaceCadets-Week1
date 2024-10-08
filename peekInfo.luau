local process = require("@lune/process")
local fs = require("@lune/fs")
local task = require("@lune/task")

local extractUser = require("extractUser")

local TEMP_FILE_NAME = "tempopen.html"
local FILE_CONTENTS_TEMPLATE = "<script>location.href='https://www.ecs.soton.ac.uk/people/%s'</script>"

local args = process.args
local email = args[1]

if not email then
	error("Must provide an email")
end

local name = extractUser(email)

-- create an html file to open
-- the script in the file will automatically redirect to our web page
-- doing it this way makes it browser-agnostic
fs.writeFile(TEMP_FILE_NAME, string.format(FILE_CONTENTS_TEMPLATE, name))

-- found invoke item from microsoft docs
process.spawn("powershell", { "Invoke-Item ./tempopen.html" })

-- allow time for the browser to read the file data, and then clean it up
task.wait(1)
fs.removeFile(TEMP_FILE_NAME)
