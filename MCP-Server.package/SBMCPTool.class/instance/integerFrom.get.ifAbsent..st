accessing
integerFrom: arguments get: key ifAbsent: defaultValue
	"Clients may send integer parameters as strings, e.g. 2 as '2'."
	^ (arguments at: key ifAbsent: [^ defaultValue value]) asString asInteger ifNil: [defaultValue value]