'From Cuis6.3 [latest update: #6242] on 23 February 2024 at 10:15:07 am'!

!DirectoryEntry class methodsFor: 'base directories' stamp: 'jmv 2/23/2024 10:12:04'!
cuisBaseDirectory
	"The main folder with the directory structure where the files provided with Cuis reside.
	Usually will not contain user files, that belong to the project using Cuis and not to Cuis itself.
	Could be made read-only.
		cuisBaseDirectory/CoreUpdates: 								Default folder to look for updates to Cuis
		cuisBaseDirectory/Packages: 								Folder for code packages included with Cuis
		cuisBaseDirectory/TrueTypeFonts: 								Default folder to look for TrueType Fonts
	DirectoryEntry cuisBaseDirectory
	See #currentDirectory. See #userBaseDirectory."

	| imageDirectory |
	CuisBaseDirectory notNil ifTrue: [
		^ CuisBaseDirectory ].

	imageDirectory := self withAbsolutePathName: Smalltalk imagePath.

	"If the directory containing the image has siblings named CoreUpdates or Packages,
	it means that the parent is the Cuis Base Directory. This is the case for the directory
	structure provided in the Cuis repo."
	imageDirectory parent ifNotNil: [ :parentDirectory |
		(parentDirectory / 'CoreUpdates') exists | (parentDirectory / 'Packages') exists ifTrue: [
			^ CuisBaseDirectory := parentDirectory ]].

	"Otherwise, hopefully the required folders shold be inside the image folder.
	But if not, at least fail while looking for them in a reasonable place."
	^ CuisBaseDirectory := imageDirectory.! !

!DirectoryEntry class methodsFor: 'base directories' stamp: 'jmv 2/23/2024 10:00:30'!
currentDirectory
	"The current directory.
	
	It is used, for unqualified names: `'stuff.txt' asFileEntry`, `'subfldr' asDirectoryEntry`. It is also used for relative paths if the full path is not specified: `'../sibling/data.txt'`.

	In Linux and MacOS, it is the current directory in the OS shell that started us.

	Same in Windows if Cuis is started from a command line. But, for instance, if the image is dropped on the VM in a Windows explorer, and no OS current directory is available, it defaults to #userBaseDirectory.

	DirectoryEntry currentDirectory
	See #cuisBaseDirectory. See #userBaseDirectory.
	See #getCurrentWorkingDirectory"

	CurrentDirectory notNil ifTrue: [
		^ CurrentDirectory ].

	Smalltalk getCurrentWorkingDirectory ifNotNil: [ :wd |
		^ CurrentDirectory := self withAbsolutePathName: wd ].

	^ CurrentDirectory := self userBaseDirectory.! !

!DirectoryEntry class methodsFor: 'base directories' stamp: 'jmv 2/23/2024 10:04:27'!
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
		UserBaseDirectory := self cuisBaseDirectory parent / (self cuisBaseDirectory name, '-UserFiles') ].

	^ UserBaseDirectory! !


!DirectoryEntry class reorganize!
('base directories' cuisBaseDirectory currentDirectory projectBaseDirectory userBaseDirectory)
('default directories' coreUpdatesDirectory packagesDirectory trueTypeFontsDirectory)
('user default directories' fileOutsDirectory logsDirectory newPackagesDirectory savedChangeSetsDirectory userChangesDirectory)
('system directories' roots smalltalkImageDirectory vmDirectory)
('cached state access' releaseClassCachedState)
('initialization' setUserBaseDirectory: setUserBaseDirectoryAsCuisBase)
!

"Postscript:
Leave the line above, and replace the rest of this comment by a useful one.
Executable statements should follow this comment, and should
be separated by periods, with no exclamation points (!!).
Be sure to put any further comments in double-quotes, like this one."
DirectoryEntry classPool at: #CurrentDirectory put: nil.
DirectoryEntry classPool at: #UserBaseDirectory put: nil.
DirectoryEntry classPool at: #CuisBaseDirectory put: nil.
DirectoryEntry classPool at: #ProjectBaseDirectory put: nil.!