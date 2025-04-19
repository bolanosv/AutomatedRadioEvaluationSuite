<p align="center">
  <img src="./src/support/ARES%20Icon.png" width="480"/>
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
- [Usage](#usage)
  - [PA Measurement Tutorial](#pa-measurement-tutorial)
  - [Antenna Measurement Tutorial](#antenna-measurement-tutorial)
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

[Getting Started Guide](https://aresio.readthedocs.io/en/latest/getting_started.html) available in the documentation.

### Download

- Download the latest release of the Automated Radio Evaluation Suite from [releases](https://github.com/bolanosv/AutomatedRadioEvaluationSuite/releases).
  - **For the MATLAB App**: Follow the instructions in the [Packaging and Installing MATLAB Apps Guide](https://www.mathworks.com/videos/packaging-and-installing-matlab-apps-70404.html).

### Requirements

To run the app, you will need:

- [MATLAB](https://www.mathworks.com/products/matlab.html)
- [MATLAB Instrument Control Toolbox](https://www.mathworks.com/products/instrument.html) (for VISA control functions)
- [MATLAB RF Toolbox](https://www.mathworks.com/products/rftoolbox.html) (to read and analyze S-parameter data)
- [Keysight Connection Expert](https://www.keysight.com/us/en/lib/software-detail/computer-software/io-libraries-suite-downloads-2175637.html) (for VISA drivers; Install the pre-requisite first, then the main installer)

## Usage

### [PA Measurement Tutorial](https://aresio.readthedocs.io/en/latest/tutorial_PA.html)

### [Antenna Measurement Tutorial](https://aresio.readthedocs.io/en/latest/tutorial_ant.html)

You can find the detailed tutorial for performing antenna measurements using ARES [here](docs/assets/Tutorials/Antenna Tutorial.pdf).

## Contributions

<p align="center">
  <img src="./docs/assets/ARES_logo.jpg" width="240"/>
<p \>
  
- Author: José Abraham Bolaños Vargas (@bolanosv)
- Mentor: Alex David Santiago Vargas (@AlexDCode)
- PI: Dimitrios Peroulis
- Adaptive Radio Electronics and Sensors Group
- Purdue University
