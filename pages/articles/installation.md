# Installing PnP Wsl2

\
You need PowerShell 7.2 or later to use PnP Wsl2. It is available for Windows and can be [installed through here](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4).

You can run the following commands to install the latest PowerShell cmdlets for the current user:

```powershell
Install-Module PnP.Wsl2 -Scope CurrentUser
```

Upon first use, you'll be prompted to set the root folder for the module's assets.  

```powershell
PnPWsl2 assets are not present in the system
Input PnP.Wsl2 Rootfolder [default [C:\Users\<CurrentUser>]]
```

The module creates a folder named PnPWsl2, containing two subfolders:

* **instances**: All running Wsl2 instances created by this module.
* **mods**: Bash scripts for execution in your WSL instances, covering a range of functionalities.

## Updating PnP Wsl2

If you already have PnP Wsl2 installed and just want to update to the latest version you can follow these steps.  

You need PowerShell 7.2 or later to use PnP WSL2. It is available for Windows and can be [installed through here](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4).

You can run the following commands to update to the latest stable PowerShell cmdlets for the current user:

```powershell
Update-Module PnP.Wls2 -Scope CurrentUser
```

## Uninstalling PnP Wsl2

\
In case you would like to remove PnP Wsl2, you can run:

```powershell
Uninstall-Module PnP.Wls2 -AllVersions
```  

> [!NOTE]
>Importing or updating the Pnp WSL2 module will **not remove any existing wsl instances** .
>
>However, out of the box [Candy](/candy/index.html) assets will be updated, the system will detect the changes and will prompt you to overwrite or overwrite and backup.  
>
>
>[Candy](/candy/index.html) assets under the [MyScripts](/candy/index.html#myscripts) will **not** be overwritten.
