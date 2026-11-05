inspecting
fieldsOf: anObject
	"The fields as Squeak's inspector for anObject shows them, without self and all inst vars, which repeat the object."
	^ (anObject inspectorClass on: anObject) fields
		reject: [:each | #(#self #all) includes: each type]