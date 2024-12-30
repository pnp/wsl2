# CheckPoints
  
\
PnP WSL2 checkpoints is a feature that allow us to capture the state of the WSL Instance at a particular point in time. 
This captured state includes the current WSL instance content, and it is saved as an export .vhdx file under the WSL  instance folder.  
  
Whenever a checkpoint is created, a timestamped vhdx file is created in the WSL instance folder. This  file can be used to restore the WSL instance to the state it was in when the checkpoint was created.

Checkpoints can be used for creating backups of WSL linux system, testing software, scripts, and reverting a WSL Instance to a previous state if needed.

When you add a new WSL instance, the module will automatically create a checkpoint for you making this is a good practice to have a clean state of the WSL instance.
  
## Available cmdlets to manage CheckPoints

* [CheckPoint-PnPWsl2Instance](/cmdlets/CheckPoint-PnPWsl2Instance.html) : creates a new checkpoint of a WSL2 instance.  
* [Get-PnPWsl2CheckPoint](/cmdlets/Get-PnPWsl2CheckPoint.html) : retrieves a list of checkpoints of a WSL2 instance.
* [Restore-PnPWsl2Instance](/cmdlets/Restore-PnPWsl2Instance.html) restores a PnP WSL2 instance from a checkpoint.  
  
> [!NOTE]
>Keep in mind that the checkpoints are stored in the WSL instance folder (under checkpoints folder)
>
> If you **remove** the WSL instance with [Remove-PnPWsl2Instance](/cmdlets/Remove-PnPWsl2Instance.html), the **checkpoints will not be deleted**.
>
  