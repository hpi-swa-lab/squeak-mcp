capturing
stopCapturing
	isCapturing ifFalse: [^ self].
	isCapturing := false.
	SystemChangeNotifier uniqueInstance noMoreNotificationsFor: self.
	self unregisterMouseCapture.
	self stopErrorTracking
	