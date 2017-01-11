# Start-Chrome.ps1
A PowerShell Script to start Google Chrome in various ways from the command line.

## Synopsis
This function is an easy way to start Google Chrome from the command line.
It includes Incognito, Restore-Session and options to open one or multiple tabs with addresses or searches.

## Installation
### Option 1 (One session use only)
To temporary use this function one can simply copy and paste the script in PowerShell <br>(starting from: `New-Alias Chrome ...`) and hit enter. This way you can use the function just for one PowerShell session.
When you exit PowerShell, the function will not work when opening PowerShell the next time. To use the fucntion again you will have to manually enter the function again or take a look at the other installation option for a more permanent option.

### Option 2 (Add directly to profile)
To be able to use the function automatically when starting PowerShell the use of a PowerShell Profile is required.
To create a profile that only affects PowerShell for the current user, create a file `Microsoft.Profile_profile.ps1` in `[UserProfile]/Documents/WindowsPowershell`.
To add the function to PowerShell the entire content of Start-Chrome.ps1 can be copied to the profile file. the next time PowerShell is started, the function will be available to the user.

### Option 3 (RECOMMENDED: Add script file to profile)
A cleaner option to Option 2 is by not copying the function directly into your profile file. When using multiple functions, the profile file can get quite messy and unreadable. So I advise to seperate each function into its own script file and then include those files to PowerShell by using the profile file.

If you haven't yet created a profile file, create one now: `[UserProfile]/Documents/WindowsPowershell/Microsoft.Profile_profile.ps1`. If the directory WindowsPowershell doesn't exist, create it.

Next inside the WindowsPowerShell directory create a new directory 'Scripts'. This directory will contain all the scripts that will be executed when starting PowerShell. Download Start-Chrome.ps1 and put it in this directory.

Now to load all scripts the profile file needs to be edited. Open the (just created) profile file with your favourite text editor and add the following lines:
```sh
# Directory containing scripts that will be included
$psdir="$Env:USERPROFILE\Documents\WindowsPowershell\Scripts"

# Load all scripts
Get-ChildItem "${psdir}\*.ps1" | %{.$_}
```

Make sure that the path after $psdir is correct for your system.

Now when starting PowerShell you should be able to use the new function.

NOTE: Due to script execution permissions in PowerShell it can happen that the profile or script is rejected by PowerShell. To override this, Start PowerShell as Adminstartor and set the Execution Policy to at least Remote Signed. 
(PS: `Set-ExecutionPolicy RemoteSigned`).

## Function
### Options
Parameter Help | H<br>
Open the Help Page for this function<br>
	
Parameter Incognito | I<br>
Open Chrome in Incognito Mode<br>
	
Parameter Restore | R<br>
Open Chrome and restore tabs of previous Chrome session<br>

Parameter Maximized | M<br>
Open Chrome in a maximized window<br>

Parameter Fullscreen | F<br>
Open Chrome in fullscreen, as if the user pressed F11 right after startup.<br>
	
Parameter Search | S<br>
Open Chrome and start a given search<br>
	
Parameter SearchMultiple | SM<br>
Open Chrome and start multiple given searches<br>
	
Parameter Browse | B<br>
Open Chrome and navigate to given address<br>
	
Parameter BrowseMultiple | BM<br>
Open Chrome and navigate to multiple given addresses<br>

### Examples
No options:<br>
`Start-Chrome`<br>
Will just start Google Chrome, nothing special.<br>

Window Option:<br>
`Start-Chrome -Fullscreen`<br>
Will start Google Chrome in fullscreen mode.<br>

Start Option:<br>
`Start-Chrome -Restore`<br>
Will start Google Chrome and restore the tabs of the previous session.<br>

Window and Start Option combined:<br>
`Start-Chrome -Maximized -Incognito`<br>
Will start Google Chrome maximized and in incgonito mode.<br>

Search Command: <br>
`Start-Chrome -Search 'some words'`<br>
Will start Google Chrome and open a tab with a search for 'some words'.<br>

Browse Command:<br>
`Start-Chrome -Browse 'www.example.com'`<br>
Will start Google Chrome and open a tab navigating to www.example.com.<br>

SearchMultiple Command:<br>
`Start-Chrome -SearchMultiple @('key','word')`<br>
Will start Google Chrome and open two tabs searching for 'key' and 'word'. You can enter as many searches as required, all seperated by a `,`.<br>

BrowseMultiple Command:<br>
`Start-Chrome -BrowseMultiple @('www.example.com','127.0.0.1')`<br>
Will start Google Chrome and open two tabs navigating to www.example.com and 127.0.0.1. You can enter as many addresses as required, all seperated by a `,`.<br>

Everything Combined (Including Aliases):<br>
`Start-Chrome -Incognito -Maximized -Browse 'www.google.com' -BrowseMultiple @('127.0.0.1','www.microsoft.com') -S 'search keywords' -SearchMultiple @('search 1','search')`<br>
Will start Google Chrome maximized and in incognito mode with six tabs open: www.google.com, 127.0.0.1, www.microsoft.com and searches for 'search keywords', 'search 1' and 'search'.

## Exceptions
Parameter **Help**:<br>
When used with other parameters, only the help parameter will be executed. All other parameters will be ignored.<br>

Parameter Combination **Restore - Incognito**:<br>
Chrome cannot be started in incognito mode and then restore the last session. When these parameters are combined, it will generate an error. Recommened action is to start the command again and leave one of the two parameters.<br>

Parameter Combination **Maximized - Fullscreen**:<br>
Chrome cannot be started in both maximized and fullscreen mode. Again this wil generate an error. Recommended action: Execute command again with one of the two parameters.<br>

Parameter Combination **Fullscreen - SearchMultiple | BrowseMultiple**<br>
Because of how opening multiple tabs works, starting Google Chrome in fullscreen mode has no effect. Therefore when combining these parameters a warning will show. Chrome will be started in Maximized mode. For future use, use -Maximized instead of -Fullscreen.
