# Give the window a title so double-clicking doesn't close it immediately
$Host.UI.RawUI.WindowTitle = "UpdatePaths Runner"

# Get all .txt files tracked by Git, sorted by last commit timestamp
$files = git ls-files *.txt | ForEach-Object {
    $file = $_
    $timestamp = git log -1 --format="%ct" -- "$file"
    [PSCustomObject]@{
        File      = $file
        Timestamp = [int]$timestamp
    }
} | Sort-Object Timestamp

$total = $files.Count
$index = 0

foreach ($item in $files) {
    $index++
    $percent = [math]::Round(($index / $total) * 100)

    Write-Progress `
        -Activity "Processing files..." `
        -Status "Running Update Paths on $($item.File) ($index of $total)" `
        -PercentComplete $percent

    # Build safe cmd.exe command
    # >nul 2>&1 silences ALL output so the progress bar stays clean
    $cmdArgs = "/c echo.| "".\Update Paths.bat"" ""$($item.File)"" >nul 2>&1"

    # Run the batch file and wait for it to finish
    $process = Start-Process -FilePath "cmd.exe" `
        -ArgumentList $cmdArgs `
        -NoNewWindow `
        -PassThru

    $process.WaitForExit()
}

Write-Progress -Activity "Processing files..." -Completed
Read-Host "Done. Press Enter to exit."
