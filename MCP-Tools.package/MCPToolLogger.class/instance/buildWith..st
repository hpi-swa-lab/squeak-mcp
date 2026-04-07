ui
buildWith: builder
	| windowSpec listSpec detailSpec statsSpec clearBtn trackingBtn |
	windowSpec := builder pluggableWindowSpec new.
	windowSpec
		model: self;
		label: 'MCP Tool Logger';
		extent: 800 @ 500.

	listSpec := builder pluggableListSpec new.
	listSpec
		model: self;
		list: #toolList;
		getIndex: #selectedIndex;
		setIndex: #selectedIndex:;
		frame: (0 @ 0 corner: 0.3 @ 0.9).

	detailSpec := builder pluggableTextSpec new.
	detailSpec
		model: self;
		getText: #detailText;
		frame: (0.3 @ 0 corner: 0.75 @ 0.9).

	statsSpec := builder pluggableTextSpec new.
	statsSpec
		model: self;
		getText: #statsText;
		frame: (0.75 @ 0 corner: 1 @ 0.9).

	trackingBtn := builder pluggableButtonSpec new.
	trackingBtn
		model: self;
		label: #trackingStatus;
		action: #toggleTracking;
		frame: (0 @ 0.9 corner: 0.5 @ 1).

	clearBtn := builder pluggableButtonSpec new.
	clearBtn
		model: self;
		label: 'Clear Log';
		action: #clear;
		frame: (0.5 @ 0.9 corner: 1 @ 1).

	windowSpec children: {listSpec. detailSpec. statsSpec. trackingBtn. clearBtn}.
	^ builder build: windowSpec