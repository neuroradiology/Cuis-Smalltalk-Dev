'From Cuis6.3 [latest update: #6364] on 13 May 2024 at 10:17:21 am'!

!DirectoryEntry class methodsFor: 'base directories' stamp: 'jmv 5/13/2024 10:16:57'!
userBaseDirectory
	"The top directory for files generated by the system on behalf of the user
		userBaseDirectory/SavedChangeSets 									Default folder for saving new ChangeSets
		userBaseDirectory/Packages: 									Default folder for new code packages
		userBaseDirectory/UserChanges: 									Folder to store user changes files
		userBaseDirectory/FileOuts: 									Default folder for filed out code
		userBaseDirectory/Logs: 									Default folder for error logs and other logs
	DirectoryEntry userBaseDirectory
	See #cuisBaseDirectory. See #currentDirectory."

	UserBaseDirectory notNil ifTrue: [
		^ UserBaseDirectory ].

	Smalltalk getCurrentWorkingDirectory ifNotNil: [ :wd |
		UserBaseDirectory := self withAbsolutePathName: wd ].

	"If no OS current directory, use a sibling of #cuisBaseDirectory
	If OS current directory is same as #cuisBaseDirectory, take a sibling too"
	(UserBaseDirectory isNil or: [ UserBaseDirectory = self cuisBaseDirectory ]) ifTrue: [
		UserBaseDirectory := self cuisBaseDirectory parent / (self cuisBaseDirectory name, '-UserFiles').
		UserBaseDirectory assureExistence ].

	^ UserBaseDirectory! !

