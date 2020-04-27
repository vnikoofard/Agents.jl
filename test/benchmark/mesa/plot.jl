# Run the benchmarks for Julia (run.jl, and boid/run.jl) and Python (run.py and boid/run.py). Copy the results below and plot

using VegaLite
using DataFrames
include("run.jl")
include("./boid/run.jl")

## Agents.jl benchmark results 

### forest fire
# jlresults = forestfirebenchmark()
jlresults = [0.0639249, 0.142405601, 0.257741999, 0.371782101]

### boid
sizes = (100, 1000, 10000, 100000)

# jlboid = boidbenchmark(sizes=sizes, nsteps=10)
jlboid = [0.010007899, 0.3411312, 34.4437326]

# jlmovecontinuous = movebenchmark(sizes=sizes)
jlmovecontinuous = [4.937375e-6, 6.128571428571428e-6, 3.06e-5, 5.4e-5]
# jlneighborcontinuous = neighborbenchmark(sizes=sizes)
jlneighborcontinuous = [6.049875e-6, 4.63e-5, 0.000145901, 0.003253799]
# jlkillcontinuous = killbenchmark(sizes=sizes)
jlkillcontinuous = [8.315864661654135e-7, 9.115894736842105e-7, 2.875125e-6, 3.3501e-5]

## Mesa benchmark results

### forest fire
pyresults = [0.8553307999998196, 2.0069307999999637, 3.3087123000000247, 4.781681599999956]

### boid
pyboid = [0.0720559999999999, 2.430720799999996, 215.62135829999988]
pymovecontinuous = [7.100000402715523e-06, 1.0200000360782724e-05, 1.2399999832268804e-05, 2.2899999748915434e-05]
pyneighborcontinuous = [4.059999992023222e-05, 7.399999958579428e-05, 0.000301999999464897, 0.0036306000001786742]
pykillcontinuous = [3.0299999707494862e-05, 0.00023239999973156955, 0.0022923999995327904, 0.02695990000029269]

dd = DataFrame(
  runtime = vcat(
    pyresults./jlresults,
    pyboid./jlboid,
    pymovecontinuous ./ jlmovecontinuous,
    pyneighborcontinuous ./ jlneighborcontinuous,
    pykillcontinuous ./ jlkillcontinuous
  ),
  model = vcat(
    fill("Forest fire", 4),
    fill("Boid flocking", 3),
    fill("Move (continuous space)", 4),
    fill("Neighbors (continuous space)", 4),
    fill("Kill (continuous space)", 4),
  ),
  size = vcat(
    1:4,
    1:3,
    1:4,
    1:4,
    1:4
  )
)

p = @vlplot(
  width=300, height=100,
  data = dd,
  mark = :circle,
  y = {"model:n", axis={title=""}},
  x = {:runtime, axis={title="Mesa/Agents run time"}, scale={type="log"}},
  color = {"size:o", legend={title="Space/pop size"}}
)
save("benchmark_mesa.svg", p)
