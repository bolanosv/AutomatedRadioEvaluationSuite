<p align="center">
  <img src="/docs/assets/ARES%20logo.jpg" width="240"/>
<p \>
<h1 align="center">Automated Radio Evaluation Suite
</h1>

Automated Radio Evaluation Suite Toolbox enables automated RF measurements of power amplifiers and antennas. Although commercial software exists, this app is open-source, customizable, and free. This app is still in development, some features might be unavailable at this release.

## Features

- VISA Instrument Control for multiple Keysight and ETS-Lindgren instruments by GPIB and LAN
- Measure RF power amplifier Figures of Merit (FoM)
  - Gain
  - Output Power
  - Drain Efficiency
  - Power Added Efficiency
- Multi-frequency PA measurements
- Measure antenna gain characteristics by Gain Comparison Method (i.e., Two-Antenna Method) and Gain Transfer Method (i.e., Comparison Antenna Method) using a reference gain file
- Measure antenna return loss
- Save and recall measurements in standardized file formats
- Plot measurement results

## TODO

- Faster antenna scanning by measuring the positive angles first and returning to the origin at the end of the measurement.
- Extend the PA DC supplies to enable 1 to 4 supplies with sweeps
- Create tutorials
- Error handling, printing out error messages
- Callback for automatic plotting when changing parameters
- Measurement progress bars
- App personalization settings

## Install

### Download

- Download the latest release of the Automated Radio Evaluation Suite from the [releases page](/release)
  - For the MATLAB App: Follow the instructions in the [Packaging and Installing MATLAB Apps Guide
    ](https://www.mathworks.com/videos/packaging-and-installing-matlab-apps-70404.html)
  - For the Standalone Desktop Application: Download the attached files to your system, run the executable, and follow the included installation instructions.

### Requirements

- [MATLAB](https://www.mathworks.com/products/matlab.html) to run the app
- [MATLAB Instrument Control Toolbox](https://www.mathworks.com/products/instrument.html) for the VISA control functions
- [Keysight Connection Expert](https://www.keysight.com/us/en/lib/software-detail/computer-software/io-libraries-suite-downloads-2175637.html) for the VISA drivers
- [NI VISA Driver](https://www.ni.com/en/support/downloads/drivers/download.ni-visa.html#548367)

### Connections

- Connect to the lab WiFi or an ethernet port enabled for Virtual LAN (VLAN) access.
- Ensure your device's IP address is configured with the following settings to connect to the instruments:
  - IPV4 address: Starts with 192.168.0.XXX, where XXX is a number between 1 and 254.
  - Gateway: Router IP address 192.168.1.1
  - Subnet Mask: 255.255.0.0
  - DNS Servers: Primary 128.210.11.5 and Alternate 128.210.11.57.

## Usage

### PA Measurement Tutorial

<p align="center">
  <img src="/docs/assets/PADemo.PNG" width="720"/>
<p \>

Coming Soon...

### Antenna Measurement Tutorial

<p align="center">
  <img src="/docs/assets/AntennaDemo1.PNG" width="720"/>
<p \>

<p align="center">
  <img src="/docs/assets/AntennaDemo2.PNG" width="720"/>
<p \>
 
You can find the detailed tutorial for performing antenna measurements using ARES [here](docs/Antenna_Measurement_Tutorial.pdf).


### Reference Code

The main application, instrument control code and supporting functions are organized within the **[src](src)** directory. Here’s an overview of the contents:

- **ARES.mlapp**: This is the main application file for ARES, where the graphical user interface (GUI) and core functionality reside.
- **instrument_address_history.txt**: This text file stores the instruments' names and corresponding IP addresses that users can reference when connecting to instruments via `visadev` to establish connections and send SCPI commands. Example line:

In the **[src/support](src/support)** directory, you'll find three subdirectories, each containing functions relevant to specific parts of the app:

- **[AntennaFunctions](src/support/AntennaFunctions)**: This directory contains functions specific to antenna measurements. It includes code for processing and analyzing antenna data using various methods like Gain Comparison and Gain Transfer.

- **[PAFunctions](src/support/PAFunctions)**: This directory contains functions tailored for power amplifier (PA) testing. It includes code for measuring key PA figures of merit such as Gain, Output Power, Drain Efficiency, and Power Added Efficiency.

- **[SupportFunctions](src/support/SupportFunctions)**: This directory contains utility functions shared across both the antenna and PA measurement modules. It includes functions for data saving/loading, troubleshooting, plotting measurement results, and other app-wide utilities that facilitate interaction with the system.

Additionally, sample measurement data for plotting is available in the **[data](./data)** directory, organized into two subdirectories:
- **[Antenna](./data/Antenna)**: Contains sample data specific to antenna measurements.
- **[PA](./data/PA)**: Contains sample data related to power amplifier measurements.

You can reference these files and directories to build custom scripts or adapt the existing functionality to suit your specific needs.




The instrument control code, including support scripts for the main application, can be found in the [src](src) directory for the ARES `.mlapp` file and the [src/support](src/support) folder for supporting `.m` files. These can be referenced for custom scripts.  

Sample data for plotting measurements is available in the [data](./data) directory.

## Compatibility

The app is compatible with the following instruments:

- Keysight PNA-L N5235B 4-Port Network Analyzer
- Keysight E36233A/E36234A Dual Output DC Power Supply
- Agilent E3634A DC Power Supply
- Rohde & Schwarz SMW200A Signal Generator
- Keysight CXA/PXA Signal Analyzer
- ETS Lindgren EMCenter Position Controller
- ETS Lindgren Linear Slide
- Coming Next: Keysight PNA-X 4-Power Network Analyzer

## License

MIT License

Copyright (c) 2024

- Author: Jose Abraham Bolanos Vargas
- Mentor: Alex David Santiago Vargas
- PI: Dimitrios Peroulis
- Adaptive Radio Electronics and Sensors Group
- Purdue University

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
