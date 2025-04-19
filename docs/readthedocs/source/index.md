# Automated Radio Evaluation Suite Documentation

<!-- File Tree -->
```{toctree}
:hidden:
:maxdepth: 2
:caption: Contents

getting_started.md
tutorial_ant.md
tutorial_PA.md
code_reference.md
gallery.md
GitHub Repository <https://github.com/AlexDCode/AutomatedRadioEvaluationSuite>
```

[![Star on GitHub](https://img.shields.io/github/stars/AlexDCode/AutomatedRadioEvaluationSuite?style=social)](https://github.com/AlexDCode/AutomatedRadioEvaluationSuite/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/AlexDCode/AutomatedRadioEvaluationSuite?style=social)](https://github.com/AlexDCode/AutomatedRadioEvaluationSuite/network/members)
[![GitHub Issues](https://img.shields.io/github/issues/AlexDCode/AutomatedRadioEvaluationSuite)](https://github.com/AlexDCode/AutomatedRadioEvaluationSuite/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/AlexDCode/AutomatedRadioEvaluationSuite)](https://github.com/AlexDCode/AutomatedRadioEvaluationSuite/pulls)
[![License](https://img.shields.io/github/license/AlexDCode/AutomatedRadioEvaluationSuite)](https://github.com/AlexDCode/AutomatedRadioEvaluationSuite/blob/main/LICENSE)

The **Automated Radio Evaluation Suite (ARES)** enables automated RF measurements for power amplifiers and antennas. Unlike commercial software, this app is open-source, customizable, and free. Download the [latest release](https://github.com/AlexDCode/AutomatedRadioEvaluationSuite/releases) and follow the getting started guide to learn how to use it. Please note that the app is still in development, and some features may not be available in this release.

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
- **Stop button**: for PA tests.
- **3D Radiation Pattern**: Include 3D patterns if more than two cuts are included.
- **Create Tutorials**: Add more tutorials for different app functionalities (one tutorial available for now).
- **Error Handling**: Error handling is in place for the PA side, including error messages displayed in the GUI. An error log function is still needed.
- **Export Plots**: Save images in standard formats and in tikz for publication.
- **How It Works**: Provide an overview of the app's inner workings, explaining how it communicates with instruments, processes measurements, and the general workflow.
- **Advanced Features**: Save and load test parameters with custom configurations and unique app settings with JSON file. Add MATLAB style toolbar and resizable pannels. 
- **Troubleshooting**: Add a section for common issues users might encounter, such as connection issues or instrument compatibility, with suggested solutions.
- **FAQ**: Add a Frequently Asked Questions (FAQ) section to address common user inquiries and difficulties.