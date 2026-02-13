# Interleaving Audio Dataset Processing

This repository contains the pipeline for processing the Interleaving Audio Dataset using **WhisperX** on CSCS clusters (Alps/Clariden).

It utilizes the **CSCS Container Engine** with a custom Environment Definition File (EDF) based on the NVIDIA NGC PyTorch 24.05 image.

## Prerequisites

* The  file present in this directory.

## Quick Start

### 1. Setup Environment
First, you must register the environment definition file with the CSCS Container Engine with `ngc-24.05-whisperx.toml` by updating the mounts with the path to the dataset for time stamping. Now, we use uv to create the virtual environment.

```bash
make whisperx
source .venv-whisperx/bin/activate
```

### 2. Modifi
First, you must register the environment definition file with the CSCS Container Engine with ngc-24.05. We use uv to create the virtual environment.


### 3. Usage Examples (test.py)
For a complete Python script example of how to use the whisperx model refer to test.py. You can run this test script inside the container:

```bash
source .venv-whisperx/bin/activate
python test.py
```
