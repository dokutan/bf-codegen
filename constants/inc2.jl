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

function simulate(i1::Int, L::Int, il::Int, a1::Int, al::Int)::Tuple{Bool,Int}
    r = i1
    l = bf_plus(L, il)

    l_history = BitSet(l)
    while l != 0
        r = bf_plus(r, a1)
        l = bf_plus(l, al)

        if l in l_history
            return false, 0
        end

        push!(l_history, l)
    end

    return true, r
end

function fitness(parms)
    return sum(map(abs, parms))
end

function inc2()
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
                        has_result::Bool, r::Int = simulate(i1, L, il, a1, al)

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
