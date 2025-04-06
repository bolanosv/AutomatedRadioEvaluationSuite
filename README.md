<p align="center">
  <img src="/docs/assets/ARES%20logo.jpg" width="240"/>
<p \>
<h1 align="center">Automated Radio Evaluation Suite
</h1>

The **Automated Radio Evaluation Suite** enables automated RF measurements for power amplifiers and antennas. Unlike commercial software, this app is open-source, customizable, and free. Please note that the app is still in development, and some features may not be available in this release.

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

- **Faster Antenna Scanning**: Improve scanning by measuring positive angles first and returning to the origin at the end of the measurement.
- **Create Tutorials**: Add more tutorials for different app functionalities (one tutorial available for now).
- **Error Handling**: Error handling is in place for the PA side, including error messages displayed in the GUI. An error log function is still needed.
- **Callback for Automatic Plotting**: Implement automatic plotting when changing parameters (missing).
- **Measurement Progress Bars**: Progress bars for PA measurements have been implemented.
- **App Personalization Settings**: Add personalization settings for the app.
- **How It Works**: Provide an overview of the app's inner workings, explaining how it communicates with instruments, processes measurements, and the general workflow.
- **Advanced Features**: Highlight advanced options or features that may not be immediately obvious to users, such as custom configurations or unique settings.
- **Troubleshooting**: Add a section for common issues users might run into, such as connection issues or instrument compatibility, with suggested solutions.
- **FAQ**: Add a Frequently Asked Questions (FAQ) section to address common user inquiries and difficulties.

## Install

### Download

- Download the latest release of the Automated Radio Evaluation Suite from the [releases page](/release).
  - **For the MATLAB App**: Follow the instructions in the [Packaging and Installing MATLAB Apps Guide](https://www.mathworks.com/videos/packaging-and-installing-matlab-apps-70404.html).
  - **For the Standalone Desktop Application**: Download the executable files, run the installer, and follow the provided installation instructions.

### Requirements

To run the app, you will need:

- [MATLAB](https://www.mathworks.com/products/matlab.html)
- [MATLAB Instrument Control Toolbox](https://www.mathworks.com/products/instrument.html) (for VISA control functions)
- [Keysight Connection Expert](https://www.keysight.com/us/en/lib/software-detail/computer-software/io-libraries-suite-downloads-2175637.html) (for VISA drivers)
- [NI VISA Driver](https://www.ni.com/en/support/downloads/drivers/download.ni-visa.html#548367)

### Network Connections

1. **WiFi or Ethernet**: Connect to the lab WiFi or an Ethernet port with Virtual LAN (VLAN) access.
2. **IP Configuration**: Ensure your device’s IP address is set up with the following network settings to connect to the instruments:
   - **IPV4 Address**: 192.168.0.XXX (where XXX is between 1 and 254).
   - **Gateway**: 192.168.1.1
   - **Subnet Mask**: 255.255.0.0
   - **DNS Servers**: Primary: 128.210.11.5, Alternate: 128.210.11.57.

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
- **instrument_address_history.txt**: This text file stores the names of instruments and their corresponding IP addresses (or other connection details, like USB addresses). The app reads this file each time it is loaded to display available instruments and their addresses in the instrument blocks. Users can add, modify, or remove instrument addresses either through the app interface or by directly editing the **instrument_address_history.txt** file. The app handles the `visadev` connections internally and requires only the correct addresses to connect to the instruments.

In the **[src/support](src/support)** directory, you'll find three subdirectories, each containing functions relevant to specific parts of the app:

- **[AntennaFunctions](src/support/AntennaFunctions)**: This directory contains functions related to antenna measurements, including the calculation of antenna gain using methods like gain comparison and gain transfer, S-parameters, and setting up necessary hardware like linear sliders. 

- **[PAFunctions](src/support/PAFunctions)**: This directory contains functions specific to power amplifier (PA) testing. It includes functions for measuring RF output, Gain, and DC Power, controlling power supply units (PSUs), deembedding PA characteristics, and validating and configuring PSU channels.

- **[SupportFunctions](src/support/SupportFunctions)**: This directory contains utility functions that are used across both antenna and PA modules. These include functions for data conversion, saving/loading measurement data, improving plot appearance, and ensuring smooth instrument communication, and other app-wide utilities that facilitate interaction with the system.

Additionally, sample measurement data for plotting is available in the **[data](./data)** directory, organized into two subdirectories:
- **[Antenna](./data/Antenna)**: Contains sample data specific to antenna measurements.
- **[PA](./data/PA)**: Contains sample data related to power amplifier measurements.

You can reference these files and directories to build custom scripts or adapt the existing functionality to suit your specific needs.

## Compatibility

The app is compatible with the following instruments:

- **Keysight PNA-L N5235B** 4-Port Network Analyzer
- **Keysight E36233A/E36234A** Dual Output DC Power Supply
- **Agilent E3634A** DC Power Supply
- **Rohde & Schwarz SMW200A** Signal Generator
- **Keysight CXA/PXA** Signal Analyzer
- **ETS Lindgren EMCenter** Position Controller
- **ETS Lindgren Linear Slider**
- **Coming Soon**: **Keysight PNA-X** 4-Port Network Analyzer

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
