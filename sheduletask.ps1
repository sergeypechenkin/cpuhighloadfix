# Define the path to your script
$scriptPath = "D:\OneDrive - Microsoft\Github_repo\cpuhighloadfix\fixcpupowermode.ps1"

# Create an action to run the PowerShell script
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File $scriptPath"

# Create a trigger to run at system startup (change to your preferred trigger)
$trigger = New-ScheduledTaskTrigger -AtStartup

# Optionally, specify user account (e.g., SYSTEM account) and highest privileges
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Register the task in Task Scheduler
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -TaskName "Monitor CPU 100% Task" -Description "Run script when CPU reaches 100% for 5 minutes."
