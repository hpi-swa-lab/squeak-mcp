I take a PNG screenshot of the Squeak display, or of one morph as it draws itself (also when covered or off-screen), and answer it as MCP image content.

Drawing happens in the UI process, so that it cannot interfere with the UI's own drawing and layout. If the UI process does not get to it in time (busy or blocked), I draw in the request process instead.