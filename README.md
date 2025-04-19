<p align="center">
  <img src="/src/support/ARES%20Icon.png" width="480"/>
<p \>
<h1 align="center">Automated Radio Evaluation Suite
</h1>

The **Automated Radio Evaluation Suite** enables automated RF measurements for power amplifiers and antennas. Unlike commercial software, this app is open-source, customizable, and free. Please note that the app is still in development, and some features may not be available in this release.

All the documentation is hosted on [Read the Docs](https://aresio.readthedocs.io/).

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Features](#features)
- [TODO](#todo)
- [Install](#install)
  - [Download](#download)
  - [Requirements](#requirements)
  - [Network Connections](#network-connections)
- [Usage](#usage)
  - [PA Measurement Tutorial](#pa-measurement-tutorial)
  - [Antenna Measurement Tutorial](#antenna-measurement-tutorial)
  - [Reference Code](#reference-code)
- [Compatibility](#compatibility)
- [Contributions](#contributions)

## Features

- VISA Instrument Control for multiple Keysight and ETS-Lindgren instruments by GPIB and LAN
- Measure RF power amplifier Figures of Merit (FoM) over one or multiple frequencies
  - Gain
  - Output Power
  - Drain Efficiency
  - Power Added Efficiency
- Measure antenna gain characteristics by the Gain Comparison Method (i.e., Two-Antenna Method) and the Gain Transfer Method (i.e., Comparison Antenna Method) using a reference gain file
- Measure antenna return loss (magnitude and phase)
- Save and recall measurements in standardized file formats for data analysis
- Plot measurement results within the app for quick visualization

## TODO

- **Faster Antenna Scanning**: Improve scanning by measuring positive angles first and returning to the origin at the end of the measurement.
- **3D Radiation Pattern**: Include 3D patterns if more than two cuts are included.
- **Create Tutorials**: Add more tutorials for different app functionalities (one tutorial available for now).
- **Error Handling**: Error handling is in place for the PA side, including error messages displayed in the GUI. An error log function is still needed.
- **Export Plots**: Save images in standard formats and in tikz for publication.
- **How It Works**: Provide an overview of the app's inner workings, explaining how it communicates with instruments, processes measurements, and the general workflow.
- **Advanced Features**: Save and load test parameters with custom configurations and unique app settings with JSON file. Add MATLAB style toolbar and resizable pannels. 
- **Troubleshooting**: Add a section for common issues users might encounter, such as connection issues or instrument compatibility, with suggested solutions.
- **FAQ**: Add a Frequently Asked Questions (FAQ) section to address common user inquiries and difficulties.

## Install

### Download

- Download the latest release of the Automated Radio Evaluation Suite from [releases](https://github.com/bolanosv/AutomatedRadioEvaluationSuite/releases).
  - **For the MATLAB App**: Follow the instructions in the [Packaging and Installing MATLAB Apps Guide](https://www.mathworks.com/videos/packaging-and-installing-matlab-apps-70404.html).

### Requirements

To run the app, you will need:

- [MATLAB](https://www.mathworks.com/products/matlab.html)
- [MATLAB Instrument Control Toolbox](https://www.mathworks.com/products/instrument.html) (for VISA control functions)
- [MATLAB RF Toolbox](https://www.mathworks.com/products/rftoolbox.html) (to read and analyze S-parameter data)
- [Keysight Connection Expert](https://www.keysight.com/us/en/lib/software-detail/computer-software/io-libraries-suite-downloads-2175637.html) (for VISA drivers; Install the pre-requisite first, then the main installer)

### Network Connections

1. **WiFi or Ethernet**: Connect to the lab WiFi or an Ethernet port with Virtual LAN (VLAN) access.
2. **IP Configuration**: Ensure your device’s IP address is set up with the following network settings to connect to the instruments within the ARES Lab:
   - **IPV4 Address**: 192.168.0.XXX (where XXX is between 1 and 254).
   - **Gateway**: 192.168.1.1
   - **Subnet Mask**: 255.255.0.0
   - **DNS Servers**: Primary: 128.210.11.5, Alternate: 128.210.11.57.

## Usage

### PA Measurement Tutorial

Coming Soon...

### Antenna Measurement Tutorial

You can find the detailed tutorial for performing antenna measurements using ARES [here](docs/assets/Tutorials/Antenna Tutorial.pdf).


### Reference Code

The main application, instrument control code, and supporting functions are organized within the **[src](./src)** directory. Here’s an overview of the contents:

- **ARES.mlapp**: This is the main application file for ARES, where the graphical user interface (GUI) and core functionality reside.
- **instrument_address_history.txt**: This text file stores the names of instruments and their corresponding IP addresses (or other connection details, like USB addresses). The app reads this file each time it is loaded to display available instruments and their addresses in the instrument blocks. Users can add, modify, or remove instrument addresses either through the app interface or by directly editing the **instrument_address_history.txt** file. The app handles the `visadev` connections internally and requires only the correct addresses to connect to the instruments.

In the **[src/support](./src/support)** directory, you'll find three subdirectories, each containing functions relevant to specific parts of the app:

- **[AntennaFunctions](./src/support/AntennaFunctions)**: This directory contains functions related to antenna measurements, including the calculation of antenna gain using methods like gain comparison and gain transfer, S-parameters, and setting up necessary hardware like linear sliders. 

- **[PAFunctions](./src/support/PAFunctions)**: This directory contains functions specific to power amplifier (PA) testing. It includes functions for measuring RF output, Gain, and DC Power, controlling power supply units (PSUs), deembedding PA characteristics, and validating and configuring PSU channels.

- **[SupportFunctions](./src/support/SupportFunctions)**: This directory contains utility functions that are used across both antenna and PA modules. These include functions for data conversion, saving/loading measurement data, improving plot appearance, and ensuring smooth instrument communication, and other app-wide utilities that facilitate interaction with the system.

Additionally, sample measurement data for plotting is available in the **[data](./data)** directory, organized into two subdirectories:
- **[Antenna](./data/Antenna)**: Contains sample data specific to antenna measurements.
- **[PA](./data/PA)**: Contains sample data related to power amplifier measurements.

You can reference these files and directories to build custom scripts or adapt the existing functionality to suit your specific needs.

## Compatibility

The app is compatible with the following instruments:

- **Keysight PNA-L N5235B** 4-Port Network Analyzer
- **Keysight E36233A/E36234A** Dual Output DC Power Supply
- **Keysight CXA** Signal Analyzer
- **Keysight PXA** Signal Analyzer
- **Agilent E3634A** DC Power Supply
- **Rohde & Schwarz SMW200A** Signal Generator
- **Hewlett-Packard E4433B** Signal Generator
- **ETS Lindgren EMCenter** Position Controller
- **ETS Lindgren Linear Slider**
- **Coming Soon**: **Keysight PNA-X** 4-Port Network Analyzer

## Contributions

<p align="center">
  <img src="/docs/assets/ARES_logo.jpg" width="240"/>
<p \>
  
- Author: José Abraham Bolaños Vargas (@bolanosv)
- Mentor: Alex David Santiago Vargas (@AlexDCode)
- PI: Dimitrios Peroulis
- Adaptive Radio Electronics and Sensors Group
- Purdue University
