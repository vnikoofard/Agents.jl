using BenchmarkTools
include("boid.jl")


# ## Running the model
function boidbenchmark(;sizes, nsteps=10)
    results = []
    for N in sizes
        b = @benchmarkable step!(model, agent_step!, $nsteps) setup=(model = 
        initialize_model(n_birds=$N, 
        speed=1.0,
        cohere_factor=.25,
        separation=4.0,
        seperate_factor=.25,
        match_factor=.01,
        visual_distance=5.0,
        dims=(100,100)))
        
        tune!(b)
        j = run(b, samples=20)
        push!(results, minimum(j.times)/1e9)
    end
    return results
end

function movebenchmark(;sizes)
    results = []
    for N in sizes
        b = @benchmarkable move_agent!(agent, model, agent.speed) setup=(model = 
        initialize_model(n_birds=$N, 
        speed=1.0,
        cohere_factor=.25,
        separation=4.0,
        seperate_factor=.25,
        match_factor=.01,
        visual_distance=5.0,
        dims=(100,100)); agent=model.agents[70])
        
        tune!(b)
        j = run(b, samples=20)
        push!(results, minimum(j.times)/1e9)
    end
    return results
end

function neighborbenchmark(; sizes)
    results = []
    for N in sizes
        b = @benchmarkable space_neighbors(agent, model, agent.visual_distance) setup=(model = 
        initialize_model(n_birds=$N, 
        speed=1.0,
        cohere_factor=.25,
        separation=4.0,
        seperate_factor=.25,
        match_factor=.01,
        visual_distance=5.0,
        dims=(100,100)); agent=model.agents[70])
        
        tune!(b)
        j = run(b, samples=20)
        push!(results, minimum(j.times)/1e9)
    end
    return results
end

function killbenchmark(; sizes)
    results = []
    for N in sizes
        b = @benchmarkable kill_agent!(agent, model) setup=(model = 
        initialize_model(n_birds=$N, 
        speed=1.0,
        cohere_factor=.25,
        separation=4.0,
        seperate_factor=.25,
        match_factor=.01,
        visual_distance=5.0,
        dims=(100,100)); agent=model.agents[70])
        
        tune!(b)
        j = run(b, samples=20)
        push!(results, minimum(j.times)/1e9)
    end
    return results
end

# sizes = (100, 1000, 10000, 100000)
# println("\nBoid benchmark")
# # print(boidbenchmark(sizes=sizes[1:3], nsteps=10))

# println("\nMove agent benchmark")
# print(movebenchmark(sizes=sizes))

# println("\nfinding neighbors benchmark")
# print(neighborbenchmark(sizes=sizes))

# println("\nKill agent benchmark")
# print(killbenchmark(sizes=sizes))