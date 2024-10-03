local process = require("@lune/process")
local net = require("@lune/net")
local regex = require("@lune/regex")

local extractUser = require("extractUser")

local function generateUrl(name: string)
	return `https://www.ecs.soton.ac.uk/people/{name}`
end

local function extractNameFromHTML(html: string): string?
	local re = regex.new('<meta property="og:title" content="(David Edward Millard)" />')
	local caps = re:captures(html)
	if not caps then
		return nil
	end

	local name = caps:get(1)
	if not name then
		return nil
	end

	return name.text
end

local args = process.args
local email = args[1]

if not email then
	error("Must provide an email")
end

local user = extractUser(email)
local url = generateUrl(user)

local response = net.request(url)

if response.statusCode ~= 200 then
	error(`Response was not OK. Status code: {response.statusCode} {response.statusMessage}`)
end

local body = response.body
local name = extractNameFromHTML(body)
if name then
	print(`Found name: {name}`)
else
	print("Could not find name, the given user might not have a page...")
end
