executing
execute: arguments
	| categories |
	categories := SystemOrganization categories sorted.
	^ self successResult: categories asArray