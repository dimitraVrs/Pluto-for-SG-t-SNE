# Pluto for SG-t-SNE

Pluto for SG-t-SNE is a Pluto notebook that runs [SG-t-SNE algorithm](https://github.com/fcdimitr/sgtsnepi) from Julia giving different cases of data as inputs. It is based on the webpage [How to Use t-SNE Effectively](https://distill.pub/2016/misread-tsne/).

### Pluto-for-SG-t-SNE repository consists of 2 parts:

### a Pluto notebook:
The Pluto notebook simple-examples.jl runs SG-t-SNE algorithm from Julia giving different cases of data as inputs and plots output points. The notebook uses [SGtSNEpi.jl](https://fcdimitr.github.io/SGtSNEpi.jl/stable/) to run SG-t-SNE. [SGtSNEpi.jl](https://fcdimitr.github.io/SGtSNEpi.jl/stable/) is a Julia interface to SG-t-SNE.
The process of creation of the initial input points (before the graph creation) is based on the corresponding process of the webpage [How to Use t-SNE Effectively](https://distill.pub/2016/misread-tsne/).

### pluto data folder:
This folder can be created from the Pluto notebook so as (png) files of input and output data are be written here.

### Instructions to run the Pluto notebook from Pluto:

#### Prerequisites
- [Julia](https://julialang.org/downloads/)
- [Pluto.jl](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)

1. Clone Pluto-for-SG-t-SNE repository:<br>

```
git clone --recursive https://github.com/dimitraVrs/Pluto-for-SG-t-SNE
```
2. Build SG-t-SNE according to the steps descrided in [SG-t-SNE repository](https://github.com/fcdimitr/sgtsnepi#building-sg-t-sne-%CF%80).
3. From Julia REPL run:<br>

```
import Pluto
```
<br>
```
Pluto.run()
```

4. In section "Open a notebook" choose the notebook.

### Instructions to run the Pluto notebook using PlutoSliderServer:

#### Prerequisites:
- [Julia](https://julialang.org/downloads/)
- [PlutoSliderServer.jl](https://github.com/JuliaPluto/PlutoSliderServer.jl)

1. Clone Pluto-for-SG-t-SNE repository:<br>

```
git clone --recursive https://github.com/dimitraVrs/Pluto-for-SG-t-SNE
```

2. Build SG-t-SNE according to the steps descrided in [SG-t-SNE repository](https://github.com/fcdimitr/sgtsnepi#building-sg-t-sne-%CF%80).
3. From Julia REPL run:<br>

```
using PlutoSliderServer
```

<br>

```
PlutoSliderServer.run_notebook(path_to_notebook,Export_offer_binder=false)
```
