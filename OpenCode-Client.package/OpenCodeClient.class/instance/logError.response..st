logging
logError: aMessage response: aResponse
	Transcript
		show: 'OpenCodeClient: ', aMessage;
		show: ' (', aResponse code asString, ')';
		cr.