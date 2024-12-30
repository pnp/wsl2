#!/bin/bash
# Define the module\section name
modName="Python"
modSection="Miniconda+Tensorflow+DirectML"
# Set the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Installs Miniconda (conda subset-python+packages) + Tensorflow + DirectML "
# Set the long help message
HELP_MESSAGE_LONG="Set up TensorFlow with DirectML (run machine learning (ML) training on existing hardware).
  
  Before installing the TensorFlow with DirectML package inside WSL, **you need to install the latest drivers**
  from your GPU hardware vendor. These drivers enable the Windows GPU to work with WSL. [AMD](https://learn.microsoft.com/en-gb/windows/ai/directml/gpu-tensorflow-wsl?utm_source=pocket_saves#amd) [Intel](https://learn.microsoft.com/en-gb/windows/ai/directml/gpu-tensorflow-wsl?utm_source=pocket_saves#intel) [AMD](https://learn.microsoft.com/en-gb/windows/ai/directml/gpu-tensorflow-wsl?utm_source=pocket_saves#nvidia)  
  
  To enable TensorFlow with DirectML in WSL, we are installing Miniconda,Tensorflow and  DirectML.This candy does all the work for you 
  Instructions followed from [Microsoft](https://learn.microsoft.com/en-gb/windows/ai/directml/gpu-tensorflow-wsl)

  [Miniconda](https://docs.anaconda.com/free/miniconda/index.html) is a small bootstrap version of Anaconda: includes  conda, Python, usefull pkgs
  [Tensorflow](https://www.tensorflow.org/) is a open source machine learning platform  
  [DirectML](https://github.com/microsoft/DirectML) is a high-performance, hardware-accelerated DirectX 12 library for machine learning


"



# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core script
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Print a separator with the module name and section
echo-print-separator "$modName"  "$modSection"


# Print the long help message
echo-print "\n $HELP_MESSAGE_LONG"

# Install
echo-print "\n Installing Miniconda ...\n"

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
bash Miniconda3-latest-Linux-x86_64.sh -u -b

conda_init=$(cat << 'EOF'
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/s/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/s/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/s/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/s/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
EOF
)
eval "$conda_init"

conda config --set auto_activate_base true
# source ~/.bashrc	
echo-print " Creating DirectML python environment ...\n"
conda create --name directml python=3.6 
conda activate directml
echo-print " Installing Tensorflow + DirectML ...\n"
pip install tensorflow-directml

echo-print "\n Miniconda installed, DirectML installed, Tensorflow installed ! \n"
# Print two newlines
echo-print "\n\n"