dependencies
weightOf: aDependency
	"Load-time dependencies first, then by number of references"
	^ ((aDependency at: 'superclasses') size + (aDependency at: 'extends') size) * 100000
		+ (aDependency at: 'references')