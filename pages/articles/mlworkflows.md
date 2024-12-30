# Build a machine learning development environment, with WSL2 using DirectML and TensorFlow
 
\
According to Microsoft [link](https://learn.microsoft.com/en-gb/windows/ai/directml/gpu-tensorflow-wsl), to create a machine learning development environment with WSL2 on Windows using DirectML and TensorFlow, we need to follow these steps:

 1. Install the Latest GPU Driver: Download and install the latest GPU driver for our hardware
 2. Enable WSL and Install a glibc-based Distribution
 3. Install Miniconda inside our WSL instance and set up a virtual Python environment using Miniconda
 4. Create a Conda Environment: Create an environment using Python and activate it
 5. Install the TensorFlow with DirectML package through pip

Lot of steps right?

No worries, there's a 🍭Candy for that: [ub-python-miniconda-tensorflow-directml](/candy/index.html#ub-python-miniconda-tensorflow-directml) 

This time-saving Candy "package" simplifies the entire process, combining Miniconda, TensorFlow, and DirectML in a convenient package.

We only need to install and start using it.

 ```powershell
   Add-PnPWsl2Candy -Candy ub-python-Miniconda-TensorFlow-DirectML -Instance mywslinstance
 ```

The "package" will install the following components:

[Miniconda](https://docs.anaconda.com/free/miniconda/index.html) is a small bootstrap version of Anaconda: includes  conda, Python, usefull pkgs

[TensorFlow](https://www.tensorflow.org/) is a popular open-source machine learning framework. Its is a symbolic math library based on dataflow and differentiable programming, used for machine learning applications such as neural networks.

[Direct Machine Learning (DirectML)](https://learn.microsoft.com/en-gb/windows/ai/directml/dml) is a low-level API for machine learning (ML). Hardware-accelerated machine learning primitives (called operators) are the building blocks of DirectML. From those building blocks, we can develop such machine learning techniques as upscaling, anti-aliasing, and style transfer, to name but a few.  

> [!NOTE]
> Keep in mind that before installing Candy with the TensorFlow with DirectML package inside WSL, **you do need to install the latest drivers**
> from your GPU hardware vendor. 
> .. it's just a Candy, not a miracle worker 🤠
> 
> These drivers enable the Windows GPU to work with WSL.  
> 
> [AMD](https://learn.microsoft.com/en-gb/windows/ai/directml/>gpu-tensorflow-wsl?utm_source=pocket_saves#amd) | [Intel](https://learn.microsoft.com/en-gb/windows/ai/directml/gpu-tensorflow-wsl?>utm_source=pocket_saves#intel) | [NVIDIA](https://learn.microsoft.com/en-gb/windows/ai/directml/gpu-tensorflow-wsl?utm_source=pocket_saves#nvidia)