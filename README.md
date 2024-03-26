# Fall Detection Project

## Overview

This Fall Detection Project is designed to identify and alert when a fall incident occurs, utilizing MATLAB for algorithm development and data processing. Developed approximately 7 years ago, this project leverages sensor data and video analysis to accurately detect fall events, aiming to provide timely assistance to individuals, especially the elderly and those with conditions that increase their fall risk.

## Features

- **Fall Detection Algorithm**: Implements sophisticated algorithms to process sensor and/or video data to detect fall incidents.
- **MATLAB Integration**: Fully developed in MATLAB, taking advantage of its powerful matrix calculations and visualization tools.
- **Real-Time Alerts**: Configured to send alerts or notifications upon detecting a fall, facilitating immediate response.

## Prerequisites

- MATLAB (version used during development, e.g., R2016b)
- Signal Processing Toolbox (if applicable)
- Image Processing Toolbox (if applicable)
- Computer Vision Toolbox (if applicable)

## Installation

1. Clone the repository to your local machine:
  ```
  git clone https://github.com/msarisapim/Fall-detection-Project.git
  ```

2. Open MATLAB and navigate to the project directory.
3. Run the main script (e.g., `FallDt_Proj.m`) to start the fall detection system.

## Dataset
Le2i Fall dataset


## Key Functions and Concepts
-  **Background Subtraction**: Central to the script, using a GMM approach to differentiate between the foreground (moving objects/people) and the static background. Parameters like the number of mixtures, learning rate, and thresholds are crucial for accurate detection.
-  **Gaussian Mixture Models (GMMs)**: Used for modeling each pixel's value distribution to separate background and foreground.
-  **PCA for Fall Detection**: a technique for distinguish falls from other movements. PCA identifies major and minor axes, aiding in the visualization of object orientation and shape. This analytical depth is vital for refining detection accuracy and understanding the dynamics of falls, offering insights through visualization of results and temporal data analysis on aspect ratios and orientations.
-  **Video and Image Processing**: The script demonstrates extensive use of MATLAB's video and image processing capabilities, including reading, writing, and manipulating frames. 

