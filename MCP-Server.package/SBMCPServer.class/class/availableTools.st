tool registry
availableTools
        "Return all concrete tool classes"
        ^ MCPTool allSubclasses reject: [:each | each isAbstract]