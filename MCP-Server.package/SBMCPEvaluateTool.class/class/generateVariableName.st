private
generateVariableName
	^ (UUID new asString copyReplaceAll: '-' with: '') copyFrom: 1 to: 6