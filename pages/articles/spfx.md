# SharePoint Framework Development environment

\
To set up a SharePoint development environment, we usually follow these general steps:

1. Install **Node.js**: Download and install a Node.js LTS Version.

2. Install the **development toolchain prerequisites** (Git,Yeoman, Gulp and Microsoft\SharePoint Yeoman Generator)

3. Install **Visual Studio Code**

4. Trusting the self-signed developer certificate

5. Install other optional tools 

These steps provide a basic setup for a SharePoint development environment under Windows 11\WSL, but there are a few more steps that we need to do to have a complete ready to go  development environment.

As reference, the official documentation is [here](https://docs.microsoft.com/en-us/sharepoint/dev/spfx/set-up-your-development-environment)

After that we always need to execute a couple of operations like configure git, create a sshkey to be shared between wsl and windows , upload it to our AzureDevops\GitHub, and so on...

## The "problem"

The "problem" with this process is that it is not streamlined\automated: we have to download\install each one of the components, and configure them all manually, align with what we need. #timeconsuming #pronetoerrors

## The solution

The PnP.Wsl2 module comes with a bundle of tools that can help us to automate the process of setting up a SharePoint development environment from scratch, and also applying those tools in an existing SPFX development.

To create a completely new SPFX development with all steps mentioned before, use the [🍭ub-spfx-FullDevEnvironment](/candy/index.html#ub-spfx-fulldevenvironment) candy available through the [Add-PnPWsl2Candy](/cmdlets/Add-PnPWsl2Candy.html) cmdlet.  

The candy will :

1. Install build essentials (packages needs for compiling software inside linux)
2. Install Nvm, Node (where you can select the version)
3. Install gulp, yeoman ,microsoft yeoman generator
4. Install spfxfastserve (a command-line utility that is used to improve the SPFX flow by speeding up the "serve" command)
5. Prompts for your global git configuration
6. Creates a SSHKey in Wsl, Copy that key to you windows host and upload the sshkey to a Azure DevOps instance

Kinda ... cool no? (automation rules! 🤠)

The candy is a bash script that executes all of those steps one by one.

Plus ...

... each one of the steps is a candy itself, so they are available for us to execute them !
