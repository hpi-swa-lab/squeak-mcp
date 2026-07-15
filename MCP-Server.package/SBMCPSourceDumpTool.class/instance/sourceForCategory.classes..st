private
sourceForCategory: category classes: classNames
	"Generate chunk format source for all classes in a category"
	| stream |
	stream := WriteStream on: (String new: 50000).

	stream nextPutAll: '"Category: ', category, '"'; cr; cr.

	classNames do: [:className |
		| cls |
		cls := Smalltalk at: className ifAbsent: [nil].
		cls ifNotNil: [
			[cls fileOutOn: stream]
				on: Error
				do: [:ex |
					stream cr; nextPutAll: '"Error filing out ';
						nextPutAll: className;
						nextPutAll: ': ';
						nextPutAll: ex messageText;
						nextPutAll: '"'; cr]]].
		
	^ stream contents