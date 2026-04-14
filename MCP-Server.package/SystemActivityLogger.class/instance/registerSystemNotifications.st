capturing
registerSystemNotifications
	| notifier |
	notifier := SystemChangeNotifier uniqueInstance.
	#((method Added onMethodAdded:)
		(method Modified onMethodModified:)
		(method Removed onMethodRemoved:)
		(class Added onClassAdded:)
		(class Modified onClassModified:)
		(class Removed onClassRemoved:))
			do: [:spec |
				notifier
					notify: self
					ofSystemChangesOfItem: spec first
					change: spec second
					using: spec third]