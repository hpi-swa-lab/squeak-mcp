accessing
from: arguments get: key ifAbsent: defaultValue
	"Safely extract a parameter from arguments"
	^ arguments at: key ifAbsent: defaultValue