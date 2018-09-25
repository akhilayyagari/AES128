# SDAccel RTL Kernel using custom RTL code

This tutorial explains the procedure for integrating an exsisting RTL with the SDAccel flow. This tutorial is divided into the following steps:

	1. AES128 Design Overview.
	2. Launch SDAccel.
	3. RTL Kernel.
	4. Generate the XO.
	5. SDAccel Host Code
	6. Binary Container.
	7. Hardware Emulation.
	8. System Run.
	9. Conclusion.

## AES128 Design Overview
This tutorial uses a AES128 public IP core available at https://opencores.org/project,systemcaes. The open core repository contains the design, testbench files for the AES128, AES192 Low area core. The Hirearchy of the design files is as shown below.

![](https://user-images.githubusercontent.com/32319498/38529264-abcea81c-3c18-11e8-9500-ca1cdc150b91.png)

This AES128 IP core has dual functionality, as an encrypter and as a decrypter. So, we are going to use this functionality  by integrating the AES core twice back to back. This way we will leverage the full functionality of the IP core. The figure below shows the block diagram of the design.

![](https://user-images.githubusercontent.com/32319498/31142684-e1b2e09c-a82f-11e7-9741-ce0f1c4ce054.png)
## RTL KERNEL

In order to generate a RTL Kernel you need two mandatory items:
1. RTL IP (packaged by the Vivado IP Packager) - XO file
2. Kernel description XML file

In this tutorial, we are using the AES128 core as an encrypter and decrypter. In the github repository,you will find the following files/folders:

	VIVADO files- contains the RTL files generated by wizard.
	HOST - the host code used in this tutorial
 	AES128 IP CORE - This folder contains a tar file of the IP core.

### RTL Kernel Wizard

1. Launch the SDx Development Environment
2. Create Sdx Project.
3. Run the RTL kernel Wizard, by selecting the "RTL Kernel Wizard" from the Xilinx Menu

	1. The RTL kernel starts with a Welcome page, containg an abbreviated version of the workflow and the steps for following the wizard. Go to the next page, by pressing Next.
       
      2. In the "General Settings" dialog box specify the kernel name - sdx_kernel_wizard_0, select the kernel type to be RTL, select the reset options to be 1 and let the remaining to be default. Then press Next
	
	3. In the "Scalars" dialog box you ed to specify the scalar arguments a RTL Kernel has. FOr this tutorial, the AES128 uses '1' scalar argument. Then press Next
	
	4. In the "Global memory" diablog box the user needs to define how a RTL kernel will access Global Memory(off-chip memory such as DDR4). For this tutorial, the AES128 core uses '1' AXI Master Interface with argument name - axi00_ptr0.
    	
	5. The final dialog box("Summary") provide a summary of the generated RTL kernel includign a function prototype (The function prototype conveys what a kernel call would look like if it was a C function): Then Press OK to launch Vivado.

The wizard automatically generates a kernel.xml file to match the software function prototype and behaviour specified in the wizard.

Once the vivdao launches, make the below changes 

> A set of pregerated Vivado files are available in the repository under the vivado directory. Copy these files from the repository and replace in the "project_name"/vivado_rtl_kernel/"kernel_name"/import directory.
> After copying the vivado files, select the add files option and load the AES128 IP Core files into the project.

The block diagram of the design looks like as shown below,

![image](https://user-images.githubusercontent.com/32319498/45783287-376f1b00-bc1a-11e8-8dd6-61fbfd385ba1.png)

The RTL kerenel wizard also provides a bult-in testbench, where you can validate the functionality of the core. The testbench has a golden model which checks for funcitonal correctness.The transactions can be viewed in the XSIM window as shown in the below figure. 

> Read Data

 Data from DDR to Kernel
    
![rdata](https://user-images.githubusercontent.com/32319498/45983952-b6e25d00-c013-11e8-9fab-ffac64225421.PNG)

> Write Data
  Data from Kernel to DDR

![wdata](https://user-images.githubusercontent.com/32319498/45984003-f4df8100-c013-11e8-82d8-63e7089f2d21.PNG)

Once the simulation is finished, it will print out a message as shown in the below figure.

![done](https://user-images.githubusercontent.com/32319498/45984105-5dc6f900-c014-11e8-8479-fc01a159fc97.PNG)

## Generate the XO

The behaviour of the RTL design is validated and now you can generate the XO file to be integrated into the OpenCL(SDAccel) application. In the Vivado project manager press "Generate RTL Kernel". A dialog box opens up, Select Sources-only option for Packaging options. Then Press ok. This generates an .XO file. 

On the following prompt, Press Yes to continue.Vivado will be closed and you return back to the SDAccel environment.

## SDAccel Host Code

In the Project Explorer tab of the SDAccel GUI expand the src directory. You will see that the project will automatically populate and contains two sources, generated by RTL Wizard:

	main.c: Host Code
	sdx_kernel_wizard.xo : AES128 RTL Kerenl

> A precompiled Host code is provided in the repository host directory, replace this file with the automatically generated host code. This Host code fetches the input vector and compares it with the golden out.

The host program is run on the Host Processor and its main responsibility is to an entire work to accomplish various
acceleration tasks. This includes:
  General book keeping and task launch duties associated with the execution of parallel OpenCL applications
  set up all global memory buffers and manage data transfer between the Host and the OpenCL device
  Monitor the status of the compute units (Note: a compute unit is an element in the OpenCL device onto which a kernel is executed) etc.

   Acceleration tasks (computations) themselves are performed by one or multiple OpenCL Devices (can be FPGA, CPU, GPU, etc. based). Each acceleration task is executed by a single or multiple Compute Units (hardware accelerators) implemented and located in OpenCL devices. The algorithmic description of the accelerations tasks done using Kernel description language (OpenCL, C/C++ or RTL). So, one of the main SDAccel tasks is to process a kernel code and implement it as a Compute Unit targeting a specified Acceleration Platform.

## Binary Container

Before you can compile the application you need to go through additional steps:
   1. You need to create a Binary Container where SDAccel will compile the RTL kernel
   2. Add the kernel to the Binary container

In the “HW Function” section of the “SDx Project Settings” click on the thunderbolt icon. By doing this, SDx environment scans all your source files and automatically identifies the kernels. In our case, there is only one. Select it and presss OK. A binary container with the default "binary_contianer_1" name is created.

![binary](https://user-images.githubusercontent.com/32319498/45984347-8bf90880-c015-11e8-80eb-4bef03ebba9f.PNG)


## Hardware emulation (HW Emulation)

The Hardware Emulation flow enables checking of the correctness of the generated logic. This emulation flow invokes the hardware simulator in the SDAccel environment to test the logic functionality. As a consequence, the runtime in the Hardware Emulation flow is longer.So the host code uuses a reduced data set. If neeeded we can run the full data set by change the input/ouput buffer size and the location to the input file.

Select the Emulation-HW Mode . Press on the play icon to start the compilation and execution of process. Once the application is successfully completed and you should see the following message in the console window.

![host_done](https://user-images.githubusercontent.com/32319498/45984752-653bd180-c017-11e8-9da0-e7c5e905fe3e.PNG)


## System Run
 In the system run it will take about 4-5 hours to compile the application for a System Run. Once the run finishes, the tool reports resource, timing reports. These are eaily accesible from the Assistant window on the left hand side.

## Conclusion
In this tutorial you started to familiarize yourself with SDAccel flow by creating a first SDAccel project and using RTL Kernel Wizard.

