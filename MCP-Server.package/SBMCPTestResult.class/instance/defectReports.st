accessing
defectReports
	^ defectReports ifNil: [defectReports := IdentityDictionary new]