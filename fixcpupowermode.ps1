# Function to get the average CPU usage over a period of time
function Get-CPUUsage {
    $cpu = Get-Counter '\Processor(_Total)\% Processor Time'
    return [math]::Round($cpu.CounterSamples.CookedValue, 2)
}

# Variables
$threshold = 100 # CPU usage threshold in percentage
$duration = 300 # Duration in seconds (5 minutes = 300 seconds)
$checkInterval = 5 # Check interval in seconds
$cpu100Time = 0 # Time CPU has been at 100%

# Monitoring loop
while ($true) {
    $cpuUsage = Get-CPUUsage

    if ($cpuUsage -ge $threshold) {
        $cpu100Time += $checkInterval
    } else {
        $cpu100Time = 0 # Reset if CPU drops below 100%
    }

    # If CPU is at 100% for the specified duration, run the task
    if ($cpu100Time -ge $duration) {
        Write-Host "CPU at 100% for 5 minutes. Running task..."
        
        # Run your commands to disable CPU power saving mode
        Start-Process "cmd.exe" -ArgumentList "/c PowerCfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 000"
        Start-Process "cmd.exe" -ArgumentList "/c PowerCfg /SETACTIVE SCHEME_CURRENT"
        
        # Exit the loop after running the task
        break
    }

    # Wait before checking again
    Start-Sleep -Seconds $checkInterval
}
