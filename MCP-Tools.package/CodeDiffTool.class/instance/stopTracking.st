tracking
stopTracking
	isTracking := false.
	SystemChangeNotifier uniqueInstance noMoreNotificationsFor: self.
	self changed: #trackingStatus