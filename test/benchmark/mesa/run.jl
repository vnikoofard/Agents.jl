using BenchmarkTools
include("forest_fire.jl")

function counter(model::ABM)
  on_fire = 0
  green = 0
  burned = 0
  for tree in values(model.agents)
    if tree.status == 1
      green += 1
    elseif tree.status == 2
      on_fire += 1
    else
      burned += 1
    end
  end
  return green, on_fire, burned
end

function forestfirebenchmark()
  height=100
  d=0.6
  nsteps = 100
  when = 1:nsteps
  size_range = 100:100:400
  mdata = [counter]
  results = Float64[]
  for width in size_range
    b = @benchmarkable data=run!(forest, tree_step!, $nsteps,
    mdata=$mdata, when=$when) setup=(forest=model_initiation(d=$d,
    griddims=($width, $height), seed=2))

    tune!(b)
    j = run(b, samples=20)
    push!(results, minimum(j.times)/1e9)  # convert them to seconds
  end
  results
end
