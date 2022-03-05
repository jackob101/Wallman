local status_ok, collorizer = pcall(require, "colorizer")
if not status_ok then
	return
end

collorizer.setup()

