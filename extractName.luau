return function(email: string)
	local atIndex = string.find(email, "@")
	if not atIndex then
		return email
	end

	return string.sub(email, 1, atIndex - 1)
end
