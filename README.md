# Pluto for SG-t-SNE

Pluto for SG-t-SNE is a Pluto notebook that runs [SG-t-SNE algorithm](https://github.com/fcdimitr/sgtsnepi) from Julia giving different cases of data as inputs. It is based on the webpage [How to Use t-SNE Effectively](https://distill.pub/2016/misread-tsne/). You can visit the webpage of Pluto for SG-t-SNE notebook here: [Pluto for SG-t-SNE](https://dimitravrs.github.io/Pluto-for-SG-t-SNE/simple-examples.html). It contains the notebook content without the capability of interactivity. Interactivity requires running the notebook with PlutoSliderServer as described [below](https://github.com/dimitraVrs/Pluto-for-SG-t-SNE#instructions-to-run-the-pluto-notebook-using-plutosliderserver).

### the Pluto notebook:
The Pluto notebook simple-examples.jl runs SG-t-SNE algorithm from Julia giving different cases of data as inputs and plots output points. The notebook uses [SGtSNEpi.jl](https://fcdimitr.github.io/SGtSNEpi.jl/stable/) to run SG-t-SNE. [SGtSNEpi.jl](https://fcdimitr.github.io/SGtSNEpi.jl/stable/) is a Julia interface to SG-t-SNE.
The process of creation of the initial input points (before the graph creation) is based on the corresponding process of the webpage [How to Use t-SNE Effectively](https://distill.pub/2016/misread-tsne/). [SGtSNEpi.jl](https://fcdimitr.github.io/SGtSNEpi.jl/stable/) is also used for the similarity graph creation.

### Instructions to run the Pluto notebook from Pluto:

#### Prerequisites
- [Julia](https://julialang.org/downloads/)
- [Pluto.jl](https://github.com/fonsp/Pluto.jl#lets-do-it)

1. Clone Pluto-for-SG-t-SNE repository:<br>

```
git clone https://github.com/dimitraVrs/Pluto-for-SG-t-SNE
```
2. Build SG-t-SNE according to the steps descrided in [SG-t-SNE repository](https://github.com/fcdimitr/sgtsnepi#building-sg-t-sne-%CF%80).
3. From Julia REPL run:<br>

```
import Pluto
```

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
git clone https://github.com/dimitraVrs/Pluto-for-SG-t-SNE
```

2. Build SG-t-SNE according to the steps descrided in [SG-t-SNE repository](https://github.com/fcdimitr/sgtsnepi#building-sg-t-sne-%CF%80).
3. From Julia REPL run:<br>

```
using PlutoSliderServer
```

```
PlutoSliderServer.run_notebook(path_to_notebook,Export_offer_binder=false)
```

#### Versions used for Pluto for SG-t-SNE
- [Julia](https://julialang.org/downloads/) 1.8.5 (stable release)
- [Pluto.jl](https://github.com/fonsp/Pluto.jl#lets-do-it) v0.19.22
- [PlutoSliderServer.jl](https://github.com/JuliaPluto/PlutoSliderServer.jl) v0.3.22
