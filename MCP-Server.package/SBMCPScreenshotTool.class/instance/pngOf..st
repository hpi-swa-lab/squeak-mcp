private
pngOf: aForm
	^ ByteArray streamContents: [:stream | PNGReadWriter putForm: aForm onStream: stream]