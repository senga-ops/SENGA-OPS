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
mkdir senga_ops
git clone https://github.com/vishnu-ncl/SENGA2.git
cd SENGA2
git checkout OPS/SENGA_1D_H2
cd ..
```

#### Clone OPS and Checkout Correct Branch

```bash
git clone https://github.com/OP-DSL/OPS.git
cd OPS
git checkout origin/feature/ops_cg-f2c
cd ..
```

---

### 2. Build OPS

Navigate into the OPS source directory and build the C backend:

```bash
cd OPS/ops/c
make
```

> 💡 You can also build other backends (`cuda`, `openmp`, etc.) depending on your target hardware. For example:
>
> ```bash
> cd ../cuda
> make
> ```

---

### 3. Build SENGA+

Navigate back to the SENGA2 directory and compile the simulation code. Make sure the `OPS_INSTALL_PATH` is correctly set (edit `Make.codgen` or your shell as needed).

```bash
cd SENGA2
make                # or ./makenek or your build system
```

> ⚠️ **Important:** Ensure `OPS_INSTALL_PATH` in your `Make.codgen` points to the correct OPS location.

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
