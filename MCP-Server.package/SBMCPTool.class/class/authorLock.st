author initials
authorLock
	^ AuthorLock ifNil: [AuthorLock := Mutex new]