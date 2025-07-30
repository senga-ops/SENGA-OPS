# 🔥 SENGA+ 1D Hydrogen Flame Simulation (OPS-Enabled)

This repository provides instructions to build and run a version of **SENGA+** combined with OPS (Oxford Parallel library for Structured meshes) use Domain Specific Language for reactive flow solvers.

It uses the following repository for OPS which is already included in the code:

- 🔗 [OPS (feature branch)](https://github.com/OP-DSL/OPS) — Multi-backend framework (CPU, GPU)

---

## 📦 Prerequisites

Make sure the following dependencies are available:

- CMake
- GNU Make
- MPI compiler (e.g., `mpicc`, `mpif90`)
- HDF5 development libraries
- CUDA or HIP toolkit (for GPU targets)

---

## 🛠️ Setup Instructions

### 1. Clone and Set Up Repositories

#### Clone SENGA2 and Checkout Correct Branch

```bash
git clone --recurse-submodules https://github.com/senga-ops/SENGA-OPS.git
```
---

### 2. Build OPS

Navigate into the OPS source directory and build the C backend:

```bash
cd SENGA-OPS/OPS/ops
pwd
```
Copy the directory to modify the setup file based on the system and desired backend or make your own setup file in for ```OPS_INSTALL_PATH=```:
```
SENGA-OPS/OPS/source_files
```
source the setup file:
```
source <setup_file>
```
then go the ```SENGA-OPS/OPS/ops_translator``` directory and source the virtural enviornment:
```
source setup_venv.sh
```
note that: ```python_requires=">=3.8"```

For installing the OPS on GPU backends, you need to go to the GPU nodes in an HPC center. You'll need to allocate and run the resource. Here is an example for requesting and going to the GPU node:
```
srun -A <Budget Account>  --nodes=1  --time=01:00:00  --partition=gpu  --gres=gpu:1   --pty /bin/bash
```
Then you'll need to source the setup environment file from ```SENGA-OPS/OPS/source_files``` in compute nodes.
After sourcing the setup file, go to the ```SENGA-OPS/OPS/ops/fortran``` and make the fortran OPS.

```
make <target>
```
Which ```<target>``` can have different options like:

> mpi_cuda if cuda fortran available, say: ```make -f Makefile.codegen senga2_mpi_cuda```

> f2c_mpi_cuda if cuda fortran is not available

> f2c_mpi_hip for AMD GPUs

> 💡 You can also build other backends (`cuda`, `openmp`, etc.) depending on your target hardware. 

When the build is successful, you can see the the build files in the ```SENGA-OPS/OPS/ops/fortran/lib``` path.

---

### 3. Build SENGA+

Navigate back to the SENGA directory and buikd the source code with the target backend. Make sure the `OPS_INSTALL_PATH` is correctly set (edit `Makefile.codgen` or your shell as needed).

```bash
cd SENGA-OPS/src
./Allmake
 make -f Makefile.codegen senga2_<target>
```

Which ```<target>``` can have different options which explained in previouse section.

---

## 🚀 Running the Simulation

(Coming soon...)

Here you will describe how to:

- Run the binary
- Set runtime parameters
- Use `mpirun` if running in parallel
- Handle outputs (e.g., HDF5 files)

Example placeholder:

```bash
mpirun -np 4 ./senga_exec input_file.inp
```

---

## 📁 Directory Structure (Optional)

```
.
├── SENGA2/                 # SENGA+ source code
├── OPS/                    # OPS backend source
├── output/                 # Simulation results (after run)
├── Make.codgen             # Build configuration file
└── README.md               # This file
```

---

## 📄 License

This project inherits the licenses of [SENGA2](https://github.com/vishnu-ncl/SENGA2) and [OPS](https://github.com/OP-DSL/OPS).
