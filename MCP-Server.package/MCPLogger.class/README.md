File-based tracer for the MCP server. Logs every step of request handling to a flat file (default 'squeakmcp.log') so we can see which calls go through and where the VM hangs on headless devices like the Quest 2 (no terminal, no live MCP). Pull the file with adb.exe pull <path>/squeakmcp.log.

Usage:
	MCPLogger default log: 'something happened'.
	MCPLogger default logFileName: '/sdcard/squeakmcp.log'.  "absolute path for Quest"

Each line is opened/closed individually so output is always flushed even if the VM later hangs.