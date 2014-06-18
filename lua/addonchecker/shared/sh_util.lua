function addonchecker:Print(msg, ...)
	msg = tostring(msg)
	msg = msg:format(...)

	print(("[%s] %s"):format(self.name, msg))
end