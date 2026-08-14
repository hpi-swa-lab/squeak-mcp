# AGENTS.md

Instructions for AI agents working with the SqueakMCP Server.

## Quick Reference

```smalltalk
"Find errors"
World submorphs select: [:m | (m isKindOf: SystemWindow) and: [m model isKindOf: Debugger]]

"Get stack trace from error window"
errorWindow model interruptedContext stackOfSize: 20 collect: [:ctx | ctx selector]

"Find implementors/senders"
SystemNavigation default allImplementorsOf: #selector
SystemNavigation default allCallsOn: #selector

"Find classes by pattern"
Smalltalk allClasses select: [:c | c name asString includesSubstring: 'Pattern']
```

## Principles

1. **Minimize tool calls** - Combine operations where possible
2. **Explain briefly** - State intent before and result after each tool use
3. **Work in Squeak context** - Unless specified otherwise, all work targets the Squeak image

## Source Code Dump (Read-Only Reference)

A dump of the Squeak image source code can be exported for fast text-based searching.

### Exporting the Dump
```
mcp__squeak__source_dump path: '/path/to/src-dump'
```

This creates `.st` files per category in standard chunk format.

### Structure
- `src-dump/*.st` - Category-based exports (one file per category)

### Important Rules
- **Read-only** - For search/reference only
- **Never modify dump files** - All code changes must be made in the live Squeak image via MCP tools
- **May be outdated** - The dump can be out of sync; the **image is always the source of truth**
- **Re-export after changes** - Use `source_dump` tool to refresh after significant image changes

### Usage
Use standard file tools (Grep, Glob, Read) to search the dump quickly:
```
Grep pattern: 'handlePost' path: '/path/to/src-dump'
Read file_path: '/path/to/src-dump/MCP-Server.st'
```

Then verify and modify code through MCP tools in the live image.

## Code Navigation

### Via MCP Tools
```
mcp__squeak__list_classes category: 'MCP-Server'
mcp__squeak__list_methods class: 'ClassName'
mcp__squeak__get_source_code class: 'ClassName' method: 'selector'
mcp__squeak__get_source_code class: 'ClassName class' method: 'classMethod'
```

### Via Evaluate
```smalltalk
"Implementors and senders (most efficient for exploration)"
SystemNavigation default allImplementorsOf: #methodName
SystemNavigation default allCallsOn: #methodName
SystemNavigation default allReferencesTo: ClassName

"Class hierarchy"
SomeClass allSubclasses
SomeClass allSuperclasses

"Find by pattern"
Smalltalk allClasses select: [:c | c name asString beginsWith: 'SBMCP']
```

## Error Handling

### Finding Errors
```smalltalk
"List all debugger windows"
World submorphs select: [:m | (m isKindOf: SystemWindow) and: [m model isKindOf: Debugger]]

"Get error window by label pattern"
World submorphs detect: [:m |
    (m isKindOf: SystemWindow) and: [
        (m model isKindOf: Debugger) and: [
            m label includesSubstring: 'MessageNotUnderstood']]] ifNone: [nil]
```

### Analyzing Errors
```smalltalk
"Get stack trace"
errorWindow model interruptedContext stackOfSize: 20 collect: [:ctx | ctx selector]

"Find specific context"
(errorWindow model interruptedContext stackOfSize: 20)
    detect: [:ctx | ctx selector = #targetMethod] ifNone: [nil]

"Inspect context"
ctx sourceCode.     "method source"
ctx receiver.       "self"
ctx arguments.      "args"
ctx temporaries.    "temps"
```

## Working with Results

The evaluate tool stores results in temporary variables (returned in `variable` field). Use these to chain operations:

```smalltalk
"First call returns variable: 'abc123'"
SomeClass allSubclasses

"Second call can reference it"
abc123 collect: [:c | c name]
```

## Transcript Access

```smalltalk
"When window is open"
| tw |
tw := World submorphs detect: [:m |
    (m isKindOf: SystemWindow) and: [m label includesSubstring: 'Transcript']] ifNone: [nil].
tw ifNotNil: [(tw allMorphs detect: [:m | m isKindOf: PluggableTextMorph]) text asString]

"When window is closed"
Transcript instVarNamed: #collection
```

## Session Maintenance

### Cleanup
```smalltalk
"Close windows by pattern"
(World submorphs select: [:m |
    (m isKindOf: SystemWindow) and: [m label includesSubstring: 'Browser']])
    do: [:w | w delete]

"Clear temp variables"
SBMCPEvaluateTool sessionResults removeAll

"Garbage collect"
Smalltalk garbageCollect
```

## UI Manipulation

### Deferred Execution
For operations that must run after current UI cycle:
```smalltalk
WorldState addDeferredUIMessage: [self doSomething]
```

### Finding Morphs
```smalltalk
"All windows"
World submorphs select: [:m | m isKindOf: SystemWindow]

"Window by label"
World submorphs detect: [:m |
    (m isKindOf: SystemWindow) and: [m label = 'Workspace']] ifNone: [nil]

"Morphs at position"
World morphsAt: 100@100
```

