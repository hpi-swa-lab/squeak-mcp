running
isTestFrame: aContext of: aTestCase
	"Traces end at the test method, setUp or tearDown; the SUnit frames below them are the same for every test."
	^ aContext receiver == aTestCase
		and: [aContext closure isNil
		and: [{aTestCase selector. #setUp. #tearDown} includes: aContext method selector]]