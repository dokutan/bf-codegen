#!/usr/bin/env julia

# searches for the optimal parameters i1,a1 for all possible il,al to increment a cell with one loop:
# i1 > il [ < a1 > al ]

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

function generate_simulation_cache()::MMatrix{41, 41, CInt}
    "Generate an MMatrix describing for how many iterations a brainfuck loop `L[al]` runs."
    simulation_cache = zeros(MMatrix{41, 41, CInt})

    for il::CInt in [-20:20;]
        for al::CInt in [-20:20;]
            l::CInt = il
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

            simulation_cache[il+21, al+21] = iterations
        end
    end

    return simulation_cache
end

function cost(parms::SVector{2, CInt})::CInt
    "Calculates the cost of the brainfuck program described by `parms`"
    return sum(map(abs, parms))
end

function simulate(
    simulation_cache::MMatrix{41, 41, CInt},
    i1::CInt,
    il::CInt,
    a1::CInt,
    al::CInt,
)::Tuple{Bool,CInt}

    iterations::CInt = simulation_cache[il+21, al+21]

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

function inc2_n()
    println("generating simulation cache ...")
    simulation_cache = generate_simulation_cache()

    total_iterations = 41 * 41 * 41 * 41
    println("total:   ", total_iterations)

    i::Int = 0
    results = Dict{SVector{3, CInt}, SVector{2, CInt}}()
    for i1::CInt in [-20:20;]
        for il::CInt in [-20:20;]
            for a1::CInt in [-20:20;]
                for al::CInt in [-20:20;]
                    has_result::Bool, r::Int =
                        simulate(simulation_cache, i1, il, a1, al)

                    # update progress
                    i += 1
                    if i % 10000 == 0
                        print("\rcurrent: ", i)
                    end

                    # store result
                    if has_result && r >= 0
                        result_array = SVector{3, CInt}(r, il, al)
                        parameter_array = SVector{2, CInt}(i1, a1)
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
    println()

    println("writing results to inc2-n.csv ...")
    result_keys::Vector{SVector{3, CInt}} = collect(keys(results))
    sort!(result_keys)
    f = open("inc2-n.csv", "w")
    for r_key::SVector{3, CInt} in result_keys
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

#@profilehtml inc2_n()
inc2_n()
