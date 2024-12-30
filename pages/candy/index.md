
## 🍬 What is a PnPWls2 Candy?
\
A "Candy" is simply a bash script to be applied on a WSL\Linux environment .
It can be use to install applications, configure settings or even populate linux environments  (yeah , #sky is the limit !) .

## Candy Pot ...

PnP Wsl2 Candy Pot has around **24** items which can help setting up, configuring and maintaining the linux environments inside our WSL instances. Each of the cmdlets is documented to aid in learning how to use it . Hey ... you can even add your [own](index.html#myscripts) !

### Azure
- #### 🍭ub-az-AzureCli
  Installs Azure Cli . 

     [Azure Cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) is a Microsoft Azure command-line tool used to create and manage Azure resources
 ```powershell
   Add-PnPWsl2Candy -Candy ub-az-AzureCli -Instance myinstance
 ```


- #### 🍭ub-az-AzureCli+CreatePAT
  Installs Azure Cli and CreatePAT candy 

     A personal access token contains your security credentials for Azure DevOps.
 ```powershell
   Add-PnPWsl2Candy -Candy ub-az-AzureCli+CreatePAT -Instance myinstance
 ```


- #### 🍭ub-az-CreatePAT
  Creates a AzureDevOps Personal Access Token that is valid for 1 year
 ```powershell
   Add-PnPWsl2Candy -Candy ub-az-CreatePAT -Instance myinstance
 ```


- #### 🍭ub-az-SSHKeyAddToAzDevops
  This script is used to add a WSL SSH key to an Azure DevOps organization 

  1) It prompts the user to enter the Azure DevOps organization and the SSH key name
  2) Gets the SSH key from the .ssh directory 
  3) Adds the SSH key to the Azure DevOps organization
 ```powershell
   Add-PnPWsl2Candy -Candy ub-az-SSHKeyAddToAzDevops -Instance myinstance
 ```


### M365
- #### 🍭ub-m365-PnPCliMicrosoft365
  Installs @pnp/cli-microsoft365.

  [pnp/cli-microsoft365](https://pnp.github.io/cli-microsoft365/) is a command-line interface (CLI) that allows users to manage 
  their Microsoft 365 tenant and SharePoint Framework projects on any platform
 ```powershell
   Add-PnPWsl2Candy -Candy ub-m365-PnPCliMicrosoft365 -Instance myinstance
 ```


- #### 🍭ub-m365-PnPPowerShell
  Installs PnP.PowerShell.

  [PnP.PowerShell](https://pnp.github.io/powershell/) is a cross-platform PowerShell Module that provides over 650 cmdlets to work with Microsoft 365 environments
 ```powershell
   Add-PnPWsl2Candy -Candy ub-m365-PnPPowerShell -Instance myinstance
 ```


- #### 🍭ub-m365-PSCore+PnPPowerShell
  This script will install PowerShell Core and PnP.PowerShell
 ```powershell
   Add-PnPWsl2Candy -Candy ub-m365-PSCore+PnPPowerShell -Instance myinstance
 ```








### Node
- #### 🍭ub-node-Install
  Installs a specified version of [Node.js](https://nodejs.org/en) using the Node Version Manager (NVM).

  1) It first checks if the requested version is already installed.
  2) If the requested version is not installed, the script installs it using NVM
  3) Sets installed version as the current version
 ```powershell
   Add-PnPWsl2Candy -Candy ub-node-Install -Instance myinstance
 ```


- #### 🍭ub-node-Nvm
  Installs the Node Version Manager (nvm).

  [Node Version Manager (NVM)](https://github.com/nvm-sh/nvm) is a tool used to download, install, manage, and upgrade Node.js versions
 ```powershell
   Add-PnPWsl2Candy -Candy ub-node-Nvm -Instance myinstance
 ```


- #### 🍭ub-node-RimRaf
  Installs the RimRaf Node tool.

  [RimRaf](https://github.com/isaacs/rimraf) is a utility for Node.js that provides a faster alternative to the 'rm -rf' shell command.  
  It allows for deep recursive deletion of files and folders
 ```powershell
   Add-PnPWsl2Candy -Candy ub-node-RimRaf -Instance myinstance
 ```


### PowerShell
- #### 🍭ub-pwsh-PowerShellCore
  Installs the latest version of PowerShell Core.

  [PowerShell Core](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/?view=powershell-7.4) is a cross-platform automation and configuration tool/framework that works on Windows, Linux, and macOS. 
  It is based on .NET Core, which allows it to be multiplatform
 ```powershell
   Add-PnPWsl2Candy -Candy ub-pwsh-PowerShellCore -Instance myinstance
 ```


### Python
- #### 🍭ub-python-Miniconda-TensorFlow-DirectML
  Set up TensorFlow with DirectML (run machine learning (ML) training on existing hardware).
  
  Before installing the TensorFlow with DirectML package inside WSL, **you need to install the latest drivers**
  from your GPU hardware vendor. These drivers enable the Windows GPU to work with WSL. [AMD](https://learn.microsoft.com/en-gb/windows/ai/directml/gpu-tensorflow-wsl?utm_source=pocket_saves#amd) [Intel](https://learn.microsoft.com/en-gb/windows/ai/directml/gpu-tensorflow-wsl?utm_source=pocket_saves#intel) [AMD](https://learn.microsoft.com/en-gb/windows/ai/directml/gpu-tensorflow-wsl?utm_source=pocket_saves#nvidia)  
  
  To enable TensorFlow with DirectML in WSL, we are installing Miniconda,Tensorflow and  DirectML.This candy does all the work for you 
  Instructions followed from [Microsoft](https://learn.microsoft.com/en-gb/windows/ai/directml/gpu-tensorflow-wsl)

  [Miniconda](https://docs.anaconda.com/free/miniconda/index.html) is a small bootstrap version of Anaconda: includes  conda, Python, usefull pkgs
  [Tensorflow](https://www.tensorflow.org/) is a open source machine learning platform  
  [DirectML](https://github.com/microsoft/DirectML) is a high-performance, hardware-accelerated DirectX 12 library for machine learning
 ```powershell
   Add-PnPWsl2Candy -Candy ub-python-Miniconda-TensorFlow-DirectML -Instance myinstance
 ```


### SharePoint Framework
- #### 🍭ub-spfx-FullDevEnvironment
  This script will install all needed assets for SharePoint Framework Development environment following Microsoft guidance
  mentioned [here](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/set-up-your-development-environment)

  1) It will install **nvm** , **node** (you can select the version), [gulp-cli](https://github.com/gulpjs/gulp-cli), [yeoman](https://yeoman.io/),
  [microsoft yeoman generator](https://www.npmjs.com/package/@microsoft/generator-sharepoint), and [spfxfastserve](https://github.com/s-KaiNet/spfx-fast-serve) 
  2) **Create the sfpx self-signed developer certificate**
  3) **Import** the certificate to your **windows local computer store**
  4) Will also **create the sshkey in wsl updating it to your windows host**
  5) **Import sshkey** into your Azure Devops instance
 ```powershell
   Add-PnPWsl2Candy -Candy ub-spfx-FullDevEnvironment -Instance myinstance
 ```


- #### 🍭ub-spfx-git-Config
  This script is used to configure git (username;useremail).
 ```powershell
   Add-PnPWsl2Candy -Candy ub-spfx-git-Config -Instance myinstance
 ```


- #### 🍭ub-spfx-gulp-TrustDevCert
  This script is will install the SharePoint Framework Development Certificate.
 ```powershell
   Add-PnPWsl2Candy -Candy ub-spfx-gulp-TrustDevCert -Instance myinstance
 ```


- #### 🍭ub-spfx-gulp-Yo-Mgen-Fs
  This script is used to install gulp-cli yo @microsoft/generator-sharepoint spfx-fast-serve.
 ```powershell
   Add-PnPWsl2Candy -Candy ub-spfx-gulp-Yo-Mgen-Fs -Instance myinstance
 ```


### System
- #### 🍭ub-sys-wsl-Initialize
  Initializes a ubuntu environment
 ```powershell
   Add-PnPWsl2Candy -Candy ub-sys-wsl-Initialize -Instance myinstance
 ```


- #### 🍭ub-sys-wsl-SSHKeyGenerate
  This script is a bash shell script that will create an SSH key in WSL and will update your windows host with the same key
 ```powershell
   Add-PnPWsl2Candy -Candy ub-sys-wsl-SSHKeyGenerate -Instance myinstance
 ```


- #### 🍭ub-sys-wsl-SuperUser
  This script is a bash shell script that sets the default user for a WSL instance
 ```powershell
   Add-PnPWsl2Candy -Candy ub-sys-wsl-SuperUser -Instance myinstance
 ```


- #### 🍭ub-sys-wsl-Updates
  This script is a bash shell script that updates the current Linux distribution packages
 ```powershell
   Add-PnPWsl2Candy -Candy ub-sys-wsl-Updates -Instance myinstance
 ```


- #### 🍭ub-sys-wsl-Utils
  This script is a bash shell script that installs WSL [utilities](https://github.com/wslutilities/wslu)
 ```powershell
   Add-PnPWsl2Candy -Candy ub-sys-wsl-Utils -Instance myinstance
 ```

### MyScripts
- #### 🍭ub-myscripts-eggxample1
  Installs  gedit linux app 

  Eggxample1 is a script that installs a linux app (gedit)  
  After execution take a peek at your Windows Start Menu, you should see a new entry for the app.  

  Purpose : show how to install a package and how to run linux apps in windows.
 ```powershell
   Add-PnPWsl2Candy -Candy ub-myscripts-eggxample1 -Instance myinstance
 ```
- #### 🍭ub-myscripts-eggxample2
  Eggxample2 is a script that runs a RickRool PowerShell script.

  Eggxample2 is a script that runs a PowerShell script that calls a windows process and plays a rickroll.  

  Purpose : show how to run a process in windows within wsl.
 ```powershell
   Add-PnPWsl2Candy -Candy ub-myscripts-eggxample2 -Instance myinstance
 ```
- #### 🍭ub-myscripts-MyFirstScript
  Installs linux x11 apps and shows a clock and a calc 

  Eggxample1 is a script that installs X11 apps (linux), shows a linux clock and a linux calc.
  Purpose is to show how to install a package and running appsin linux.
 ```powershell
   Add-PnPWsl2Candy -Candy ub-myscripts-MyFirstScript -Instance myinstance
 ```


\
**Important Note:**
Updating\Importing the Pnp WSL2 module will **not remove any existing assets**.
However out of the box [Candy](/candy/index.html) assets will be updated ( the system will detect the changes and will prompt you). Candy under the [MyScripts](/candy/index.html#myscripts) will **not** be overwritten.

