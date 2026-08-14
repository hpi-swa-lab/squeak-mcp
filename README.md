# SqueakMCP

An MCP (Model Context Protocol) server implementation for Squeak/Smalltalk, enabling AI assistants like Claude to interact with a live Squeak image.

## Overview

SqueakMCP bridges AI coding assistants with the Squeak programming environment. The MCP server runs inside the Squeak image and exposes tools for code navigation, evaluation, and modification.

## Usage

### Prerequisites

- [Squeak](https://squeak.org/) (tested with Squeak 6.0)
- [OpenCode CLI](https://opencode.ai/de/download) or another MCP-compatible client

### Setup

**Load the MCP Server in Squeak**  
*TODO*

**Start the MCP Server**  
```smalltalk
server := SBMCPServer new port: 8081.
server start.
```

**Configure OpenCode**  
Add to your OpenCode MCP configuration (`~/.config/opencode/opencode.json`):

```json 
  {
    "mcp": {
      "squeak_system": {
        "type": "remote",
        "url": "http://localhost:8081/mcp/message",
        "enabled": true
    }
  }
}

``` 
  
   

**Connect**  
Start OpenCode in your project directory. The Squeak MCP tools will be available automatically.

## MCP Tools

The server exposes the following tools to AI assistants:

| Tool | Description |
|------|-------------|
| `evaluate` | Evaluate a Smalltalk expression and return the result |
| `list_categories` | List all class categories in the system |
| `list_classes` | List classes filtered by category prefix |
| `list_methods` | List all methods of a class |
| `get_source_code` | Get source code for a specific method |
| `write_class_code` | Manage classes: create, modify, rename, or delete |
| `write_method_code` | Manage methods: add, modify, or delete |
| `source_dump` | Export source code to files for text-based searching |

## Server Management

### Starting and Stopping

```smalltalk
"Start server on port 8081"
server := SBMCPServer new port: 8081.
server start.

"Stop server"
server stop.
```

## MCP-Tools

Additional utilities for working with the MCP server.

### CodeDiffTool

A visual diff tool that tracks code changes made during an MCP session. Useful for reviewing AI-made modifications before accepting them.

```smalltalk
"Open the diff tool"
CodeDiffTool open.
```

**Features:**
- View changes grouped by class and method
- Colored diff display (additions/removals)
- Revert individual or all changes
- Accept changes to clear tracking

### MCPToolLogger

Logs all MCP tool calls with their arguments and results. Useful for debugging and understanding AI interactions.

```smalltalk
"Open the logger UI"
MCPToolLogger open.
```

**Features:**
- Records tool name, arguments, and results
- Browse individual tool calls
- Clear log history

## Alternative Setup: OpenCode-Client UI

For a fully integrated experience within Squeak, use the **OpenCode-Client** UI instead of the CLI.

### Components

| Class | Description |
|-------|-------------|
| `OpenCodeClient` | HTTP client for communicating with OpenAI-compatible APIs |
| `PromptUI` | Morphic-based chat interface |
| `ChatMessage` | Message model for conversations |

### Setup

**Start OpenCode in server mode**

  ```bash
  opencode serve --port 33955 --hostname 127.0.0.1
  ```

  This runs OpenCode as an HTTP server that the Squeak client can connect to.

**Open the chat UI in Squeak**

  ```smalltalk
  PromptUI open.
  ```

The flow is:
```
PromptUI (Squeak) → HTTP → OpenCode Server (:33955) → AI API
```

This provides a native Squeak interface for conversing with AI, with the ability to execute suggested code directly in the image.
