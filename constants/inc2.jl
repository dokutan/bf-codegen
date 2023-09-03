#!/usr/bin/env julia

# searches for the optimal parameters to increment a cell with one loop:
# i1 (?) > il (L) [ < a1 > al ]

#using StatProfilerHTML
using StaticArrays

function bf_plus(a::Int, b::Int)::Int
    r = a + b
    if r < 0
        r = 256 + r
    end

    return r % 256
end

function generate_simulation_cache()
    simulation_cache = Dict()

    for L::Int in [0:255;]
        for al::Int in [-10:10;]
            l = L
            l_history = BitSet(l)
            iterations = 0

            while l != 0
                l = bf_plus(l, al)
                iterations += 1

                if l in l_history
                    iterations = -1
                    break
                end

                push!(l_history, l)
            end

            global simulation_cache[SA[L, al]] = iterations
        end
    end

    return simulation_cache
end

function simulate(
    simulation_cache::Dict,
    i1::Int,
    L::Int,
    il::Int,
    a1::Int,
    al::Int,
)::Tuple{Bool,Int}

    l = bf_plus(L, il)
    iterations = simulation_cache[SA[l, al]]

    if iterations < 0
        return false, 0
    else
        r = (i1 + iterations * a1) % 256
        if r < 0
            r += 256
        end
        return true, r
    end
end

function fitness(parms)
    return sum(map(abs, parms))
end

function inc2()
    println("generating simulation cache ...")
    simulation_cache = generate_simulation_cache()

    total_iterations = 21 * 256 * 21 * 21 * 20
    println("total:   ", total_iterations)

    max_fitness::Int = 20 # don't simulate solutions that are longer than this
    i::Int = 0
    results = Dict()
    for i1::Int in [-10:10;]
        for L::Int in [0:255;]
            for il::Int in [-10:10;]
                for a1::Int in [-10:10;]
                    for al::Int in [-10:-1; 1:10]
                        has_result::Bool, r::Int =
                            simulate(simulation_cache, i1, L, il, a1, al)

                        i += 1
                        if i % 1000 == 0
                            print("\rcurrent: ", i)
                        end

                        parameter_array = SA[i1, il, a1, al]
                        if fitness(parameter_array) > max_fitness
                            continue
                        end
                        result_array = SA[r, L]

                        if has_result && r >= 0
                            if haskey(results, result_array)
                                if fitness(parameter_array) < fitness(results[result_array])
                                    results[result_array] = parameter_array
                                end
                            else
                                results[result_array] = parameter_array
                            end
                        end
                    end
                end
            end
        end
    end
    println()

    println("writing results to inc2.csv ...")
    result_keys = collect(keys(results))
    sort!(result_keys)
    f = open("inc2.csv", "w")
    for r_key in result_keys
        write(
            f,
            join(map(string, r_key), ',') *
            "," *
            join(map(string, results[r_key]), ',') *
            "\n",
        )
    end
    close(f)
end

#@profilehtml inc2()
inc2()
