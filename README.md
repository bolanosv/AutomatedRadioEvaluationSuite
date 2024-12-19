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

- Download the latest release of the Automated Radio Evaluation Suite from the [latest release](/releases)
  - For MATLAB App: To install the app in MATLAB, follow the instructions in the [Packaging and Installing MATLAB Apps
    ](https://www.mathworks.com/videos/packaging-and-installing-matlab-apps-70404.html)
  - For Standalone Desktop Application: Download the appropriate version for your system and follow the included installation instructions.

### Requirements

- [MATLAB](https://www.mathworks.com/products/matlab.html) to run the app
- [MATLAB Instrument Control Toolbox](https://www.mathworks.com/products/instrument.html) for the VISA control functions
- [Keysight Connection Expert](https://www.keysight.com/us/en/lib/software-detail/computer-software/io-libraries-suite-downloads-2175637.html) for the VISA drivers
- [NI VISA Driver](https://www.ni.com/en/support/downloads/drivers/download.ni-visa.html#548367)

### Connections

- Connect to the lab WiFi or a Virtual LAN-enabled ethernet port.
- Ensure your IP address matches the following settings to connect to instruments by LAN
  - IPV4 address starts with 192.168.0.XXX (Where XXX is a number between
  - Gateway is router IP 192.168.1.1
  - Subnet Mask is 255.255.0.0
  - DNS Server is 128.210.11.5 and alternate 128.210.11.57

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

The instrument control code can be used for reference in custom scripts. It can be found in the [src/main](src/main) and [src/support](src/support) folders.

Sample data can be found in the [data](./data) folder to plot sample measurements.

## Compatibility

The app is compatible with the following instruments:

- Keysight PNA-L N5235B 4-Port Network Analyzer
- Agilent E3634A DC Power Supply
- ETS Lindgren EMCenter Position Controller
- ETS Lindgren Linear Slide
- Coming Next: Keysight E3634A Dual Output DC Power Supply
- Coming Next: Keysight PNA-X 4-Power Network Analyzer
- Coming Next: Keysight CXA/PXA Signal Analyzer

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
