actions
buildWith: builder
    | windowSpec classListSpec methodListSpec detailSpec trackingBtn revertLastBtn revertAllBtn acceptBtn revertAllChangesBtn acceptAllBtn |
    windowSpec := builder pluggableWindowSpec new.
    windowSpec 
        model: self;
        label: 'Code Diff Tool';
        extent: 900 @ 550.
    
    classListSpec := builder pluggableListSpec new.
    classListSpec 
        model: self;
        list: #classList;
        getIndex: #selectedIndex;
        setIndex: #selectedIndex:;
        frame: (0 @ 0 corner: 0.2 @ 0.95).
    
    methodListSpec := builder pluggableListSpec new.
    methodListSpec 
        model: self;
        list: #methodList;
        getIndex: #selectedMethodIndex;
        setIndex: #selectedMethodIndex:;
        frame: (0.2 @ 0 corner: 0.45 @ 0.95).
    
    detailSpec := builder pluggableTextSpec new.
    detailSpec 
        model: self;
        getText: #detailText;
        frame: (0.45 @ 0 corner: 1 @ 0.9).
    
    "Buttons under detail text"
    revertLastBtn := builder pluggableButtonSpec new.
    revertLastBtn 
        model: self;
        label: 'Revert Last';
        action: #revertLast;
        frame: (0.45 @ 0.9 corner: 0.6333 @ 0.95).
    
    revertAllBtn := builder pluggableButtonSpec new.
    revertAllBtn 
        model: self;
        label: 'Revert All';
        action: #revertAll;
        frame: (0.6333 @ 0.9 corner: 0.8166 @ 0.95).
    
    acceptBtn := builder pluggableButtonSpec new.
    acceptBtn 
        model: self;
        label: 'Accept';
        action: #acceptChanges;
        frame: (0.8166 @ 0.9 corner: 1 @ 0.95).
    
    "Bottom row - tracking and global actions"
    trackingBtn := builder pluggableButtonSpec new.
    trackingBtn 
        model: self;
        label: #trackingStatus;
        action: #toggleTracking;
        frame: (0 @ 0.95 corner: 0.3333 @ 1).
    
    revertAllChangesBtn := builder pluggableButtonSpec new.
    revertAllChangesBtn 
        model: self;
        label: 'Revert All Changes';
        action: #revertAllChanges;
        frame: (0.3333 @ 0.95 corner: 0.6666 @ 1).
    
    acceptAllBtn := builder pluggableButtonSpec new.
    acceptAllBtn 
        model: self;
        label: 'Accept All Changes';
        action: #acceptAllChanges;
        frame: (0.6666 @ 0.95 corner: 1 @ 1).
    
    windowSpec children: {classListSpec. methodListSpec. detailSpec. 
        revertLastBtn. revertAllBtn. acceptBtn. 
        trackingBtn. revertAllChangesBtn. acceptAllBtn}.
    ^ builder build: windowSpec