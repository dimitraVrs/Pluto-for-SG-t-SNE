# Pluto for SG-t-SNE

Pluto for SG-t-SNE is a Pluto notebook that runs SG-t-SNE algorithm from Julia giving different cases of data as inputs. It is based on the webpage [How to Use t-SNE Effectively](https://distill.pub/2016/misread-tsne/).

### Pluto-for-SG-t-SNE repository consists of 3 parts:

### sgtsnepi_mirror repository:
This repository is a mirror of [SG-t-SNE repository](https://github.com/fcdimitr/sgtsnepi). Some modifications to the original repository have been made so as the points of every iteration are written and then read from the Pluto notebook. The Pluto notebook plots the points for all iterations of the algorithm.

### a Pluto notebook:
The Pluto notebook alg_execution.jl runs SG-t-SNE algorithm from Julia giving different cases of data as inputs and plots output points for all iterations of the algorithm.

### pluto data folder:
It contains input data. Output data as well as their plots' files are written here.
Input data are created using MATLAB. Matlab files are also included in folder matlabScripts. The process of creation of the initial input points (before the sparse matrix creation) is based on the corresponding process of the webpage [How to Use t-SNE Effectively](https://distill.pub/2016/misread-tsne/).

### Instructions to run the Pluto notebook from Pluto

#### Prerequisites
- [Julia](https://julialang.org/downloads/)
- [Pluto.jl](https://github.com/fonsp/Pluto.jl)

1. Clone Pluto-for-SG-t-SNE repository: `git clone --recursive https://github.com/dimitraVrs/Pluto-for-SG-t-SNE`
2. Build SG-t-SNE according to the steps descrided in [SG-t-SNE repository](https://github.com/fcdimitr/sgtsnepi).
3. From Julia REPL run:
`import Pluto`
`Pluto.run()`
4. In section "Open a notebook" choose the notebook.

### Instructions to run the Pluto notebook using PlutoSliderServer

#### Prerequisites
- [Julia](https://julialang.org/downloads/)
- [PlutoSliderServer.jl](https://github.com/JuliaPluto/PlutoSliderServer.jl)

1. Clone Pluto-for-SG-t-SNE repository: `git clone --recursive https://github.com/dimitraVrs/Pluto-for-SG-t-SNE`
2. Build SG-t-SNE according to the steps descrided in [SG-t-SNE repository](https://github.com/fcdimitr/sgtsnepi).
3. From Julia REPL run:
`using PlutoSliderServer`
`PlutoSliderServer.run_notebook(path_to_notebook,Export_offer_binder=false)` 
