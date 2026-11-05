I run SUnit tests for an MCP client: in a background process with a time limit, with a stack trace for each unexpected failure and error (see SBMCPTestResult).

If the time limit is reached, I report the test that was running and where it was, then terminate the run; terminating still runs its tearDown.