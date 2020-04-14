# Run the benchmarks for Julia (run.jl, and boid/run.jl) and Python (run.py and boid/run.py). Copy the results below and plot

using VegaLite
using DataFrames

## Agents.jl benchmark results 

# forest fire
jlresults = [0.0639249, 0.142405601, 0.257741999, 0.371782101]

# boid
jlboid = [0.101076999, 0.270401899, 0.5469489, 0.8079563]

jlmovecontinuous = [3.5201e-5, 3.2199e-5, 3.6301e-5, 5.3201e-5]
jlneighborcontinuous = [0.0375496, 0.003957999, 0.001798301, 0.0026353]
jlkillcontinuous = [3.9601e-5, 4.41e-5, 2.6e-5, 3.63e-5]

# Mesa benchmark results

#forest fire
pyresults = [0.8553307999998196, 2.0069307999999637, 3.3087123000000247, 4.781681599999956]

# boid
pyboid = [0.8770560000000387, 2.4145003999999517, 4.189664500000049, 6.677871200000027]

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
    fill("Boid flocking", 4),
    fill("Move (continuous space)", 4),
    fill("Neighbors (continuous space)", 4),
    fill("Kill (continuous space)", 4),
  ),
  size = vcat(
    1:4,
    1:4,
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
