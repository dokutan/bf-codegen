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

function generate_simulation_cache()::Dict{SVector{2, Int}, Int}
    simulation_cache = Dict{SVector{2, Int}, Int}()

    for L::Int in [0:255;]
        for al::Int in [-10:10;]
            l::Int = L
            l_history = BitSet(l)
            iterations::Int = 0

            while l != 0
                l = bf_plus(l, al)
                iterations += 1

                if l in l_history
                    iterations = -1
                    break
                end

                push!(l_history, l)
            end

            simulation_cache[SA[L, al]] = iterations
        end
    end

    return simulation_cache
end

function simulate(
    simulation_cache::Dict{SVector{2, Int}, Int},
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

function cost(parms)::Int
    "Calculates the cost of the brainfuck program described by `parms`"
    return sum(map(abs, parms))
end

function inc2()
    println("generating simulation cache ...")
    simulation_cache = generate_simulation_cache()

    total_iterations = 21 * 256 * 21 * 21 * 20
    println("total:   ", total_iterations)

    max_cost::Int = 20 # don't simulate solutions that are longer than this
    i::Int = 0
    results = Dict{SVector{2, Int}, SVector{4, Int}}()
    for i1::Int in [-10:10;]
        for L::Int in [0:255;]
            for il::Int in [-10:10;]
                for a1::Int in [-10:10;]
                    for al::Int in [-10:-1; 1:10]
                        has_result::Bool, r::Int =
                            simulate(simulation_cache, i1, L, il, a1, al)

                        # update progress
                        i += 1
                        if i % 1000 == 0
                            print("\rcurrent: ", i)
                        end

                        parameter_array = SA[i1, il, a1, al]
                        if cost(parameter_array) > max_cost
                            continue
                        end

                        # store result
                        if has_result && r >= 0
                            result_array = SA[r, L]
                            if haskey(results, result_array)
                                if cost(parameter_array) < cost(results[result_array])
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
