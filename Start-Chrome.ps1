<#
	.Synopsis
	This function is an easy way to start Google Chrome from the command line.
	It includes Incognito, Restore-Session and options to open one or multiple tabs with addresses or searches.
	
	.Parameter Help | H
	Open the Help Page for this function
	
	.Parameter Incognito | I
	Open Chrome in Incognito Mode
	
	.Parameter Restore | R
	Open Chrome and restore tabs of previous Chrome session

	.Parameter Maximized | M
    	Open Chrome in a maximized window

    	.Parameter Fullscreen | F
    	Open Chrome in fullscreen, as if the user pressed F11 right after startup.
	
	.Parameter Search | S
	Open Chrome and start a given search
	
	.Parameter SearchMultiple | SM
	Open Chrome and start multiple given searches
	
	.Parameter Browse | B
	Open Chrome and navigate to given address
	
	.Parameter BrowseMultiple | BM
	Open Chrome and navigate to multiple given addresses
	
	.Example
	Start-Chrome
	
	.Example
	Start-Chrome -Incognito -Maximized -Browse 'www.google.com' -BrowseMultiple @('127.0.0.1','www.microsoft.com') -S 'search keywords' -SearchMultiple @('search 1','search')	
#>

# Setting Alias for Google Chrome. Worked better then just using the path when invoking an expression
New-Alias Chrome "$ENV:ProgramFiles (x86)\Google\Chrome\Application\chrome.exe"

function Start-Chrome {
    param
    (
        [Alias("H")][switch]$Help,
        [Alias("I")][switch]$Incognito,
        [Alias("R")][switch]$Restore,
	
	[Alias("M")][switch]$Maximized,
	[Alias("F")][switch]$Fullscreen,

        [Alias("S")][string][ValidateNotNullOrEmpty()]$Search,
        [Alias("B")][string][ValidateNotNullOrEmpty()]$Browse,

        [Alias("SM")][string[]][ValidateNotNullOrEmpty()]$SearchMultiple,
        [Alias("BM")][string[]][ValidateNotNullOrEmpty()]$BrowseMultiple
    )

    if($Help -and ($Incognito -or $Restore -or $Search -or $SearchMultiple -or $Browse -or $BrowseMultiple)) { 
	Write-Host "
	By declaring the -Help parameter all your other parameters are being ignored. 
	Below you will find the requested Help Page. To excecute the other parameters enter a new command without -Help.
		
	"
    }

    if($Help) {
        Write-Host "Help page

        Syntaxis: Start-Chrome [Option] [Parameters]
        
        Invoking this function without options will start Chrome in a normal manner
        
        Start Options:
        -Help: Open this help page.
        -Incognito: Start Chrome in Incognito mode.
        -Restore: Start Chrome and open tabs from last session.
        
	Window Options:
	-Maximized: Start Chrome in a maximized screen.
	-Fullscreen: Start Chrome in fullscreen, as if the user pressed F11 right after startup.

        Paramaters:
        -Search [string]: Enter a string of text to search for it in Google in a new tab in Chrome.
        -Browse [string]: Enter an address to open a new tab and navigate to it in Chrome.
        -SearchMultiple [string[]]: Enter a collection of text to start multiple searches ing Google at once.
        -BrowseMultiple [string[]]: Enter a collection of addresses to open new tabs in Chrome navigating to the addresses.
        
        NOTE: You can only use one Start Option and one Window Option, but you can use multiple parameterss.

        EXAMPLE: Start-Chrome -Incognito -Fullscreen -Browse 'www.google.com' -SearchMultiple @('search1','search2')
	"
	return
    }

    if($Incognito -and $Restore) {
        Write-Error -Message "Chrome cannot be started with both the -Incognito and the -Restore option." -RecommendedAction "Start Chrome with one of these options."
        return
    }

    if($Maximized -and $Fullscreen) {
    	Write-Error -Message "Chrome cannot be started with both the -Maximezed and the -Fullscreen option." -RecommendedAction "Start Chrome with one of these options."
	return
    }
	
    # Declaring default variables
    $_command = ""
    
    $_incognito = "--incognito"
    $_restore = "--restore-last-session"

    $_maximized = "--start-maximized"
    $_fullscreen = "--start-fullscreen"

    $_searchUrl = "https://www.google.com/search?q="

    $_option = ""

    # Chrome Starting Options

    if($Fullscreen -and ($SearchMultiple -or $BrowseMultiple)) {
    	$_option = $_maximized
	Write-Error -Message "Fullscreen mode does not work when opening multiple tabs. Starting Chrome in Maximized mode instead" -RecommendedAction "Next time, when using -BrowseMultiple or -SearchMultiple start Chrome with -Maximized or no Window option."
    }
    elseif($Fullscreen) { $_option = $_fullscreen }
    
    if($Maximized) { $_option = $_maximized }

    if($Restore) { $_option += " " + $_restore }
    if($Incognito) { $_option += " " + $_incognito }
    
    if(!$Search -and !$SearchMultiple -and !$Browse -and !$BrowseMultiple) {
	$_expr = "Chrome $_option"
        Invoke-Expression $_expr
    }
	
    # Setting and excecuting Search and Browse commands
    if($Browse) { 
	$_command = "`"" + (($Browse + "`"") -replace ' ','%20')
        $_expr = "Chrome $_option $_command"
	Invoke-Expression $_expr
    }
        
    if($BrowseMultiple) {
        foreach($b in $BrowseMultiple) {
            $_command = "`"" + (($b + "`"") -replace ' ','%20')
	    $_expr = "Chrome $_option $_command"
	    Invoke-Expression $_expr		      
        }
    }

    if($Search) { 
	$_command = "`""  + (($_searchUrl + $Search + "`"") -replace ' ','%20') 
        $_expr = "Chrome $_option $_command"
	Invoke-Expression $_expr	
    }

    if($SearchMultiple) {
        foreach($s in $SearchMultiple) {
            $_command = "`""  + (($_searchUrl + $s + "`"") -replace ' ','%20') 
	    $_expr = "Chrome $_option $_command"
	    Invoke-Expression $_expr
        }
    }
}