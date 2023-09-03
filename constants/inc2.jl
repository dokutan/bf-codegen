#!/usr/bin/env julia

# searches for the optimal parameters to increment a cell with one loop:
# i1 (?) > il (L) [ < a1 > al ]

#using StatProfilerHTML
using StaticArrays

const CInt = Int32

function bf_plus(a::CInt, b::CInt)::CInt
    r::CInt = a + b
    if r < 0
        r = 256 + r
    end

    return r % 256
end

function generate_simulation_cache()::MMatrix{256, 21, CInt}
    "Generate an MMatrix describing for how many iterations a brainfuck loop `L[al]` runs."
    simulation_cache = zeros(MMatrix{256, 21, CInt})

    for L::CInt in [0:255;]
        for al::CInt in [-10:10;]
            l::CInt = L
            l_history::BitSet = BitSet(l)
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

            simulation_cache[L+1, al+11] = iterations
        end
    end

    return simulation_cache
end

function simulate(
    simulation_cache::MMatrix{256, 21, CInt},
    i1::CInt,
    L::CInt,
    il::CInt,
    a1::CInt,
    al::CInt,
)::Tuple{Bool,CInt}

    l::CInt = bf_plus(L, il)
    iterations::CInt = simulation_cache[l+1, al+11]

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

function cost(parms::SVector{4, CInt})::CInt
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
    results = Dict{SVector{2, CInt}, SVector{4, CInt}}()
    for i1::CInt in [-10:10;]
        for L::CInt in [0:255;]
            for il::CInt in [-10:10;]
                for a1::CInt in [-10:10;]
                    for al::CInt in [-10:-1; 1:10]
                        has_result::Bool, r::Int =
                            simulate(simulation_cache, i1, L, il, a1, al)

                        # update progress
                        i += 1
                        if i % 10000 == 0
                            print("\rcurrent: ", i)
                        end

                        parameter_array = SVector{4, CInt}(i1, il, a1, al)
                        current_cost::CInt = cost(parameter_array)
                        if current_cost > max_cost
                            continue
                        end

                        # store result
                        if has_result && r >= 0
                            result_array = SVector{2, CInt}(r, L)
                            if haskey(results, result_array)
                                if current_cost < cost(results[result_array])
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
    result_keys::Vector{SVector{2, CInt}} = collect(keys(results))
    sort!(result_keys)
    f = open("inc2.csv", "w")
    for r_key::SVector{2, CInt} in result_keys
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
