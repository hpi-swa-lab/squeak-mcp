private
categoriesForExport
	"Return all categories except Kernel-related ones"
	^ SystemOrganization categories reject: [:cat |
		(cat beginsWith: 'Kernel') or: [
		(cat beginsWith: '60Deprecated')]]