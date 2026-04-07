tool registry
availableTools
        "Return all concrete tool classes"
        ^ SBMCPTool allSubclasses reject: [:each | each isAbstract]