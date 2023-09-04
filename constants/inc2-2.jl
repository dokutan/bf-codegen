#!/usr/bin/env julia

# searches for the optimal parameters i1-3 and a1-3 to increment two cells with one loop:
# i1 > i2 > il [ << a1 > a2 > al ]

#using StatProfilerHTML
using StaticArrays

const CInt = Int16

function bf_plus(a::CInt, b::CInt)::CInt
    r::CInt = a + b
    if r < 0
        r += 256
    end

    return r % 256
end

function generate_simulation_cache()::MMatrix{21,21,CInt}
    "Generate an MMatrix describing for how many iterations a brainfuck loop `0[al]` runs."
    simulation_cache = zeros(MMatrix{21,21,CInt})

    for il::CInt in [-10:-1; 1:10]
        for al::CInt in [-10:-1; 1:10]
            l::CInt = il
            l_history::BitSet = BitSet(l)
            iterations::CInt = 0

            while l != 0
                l = bf_plus(l, al)
                iterations += 1

                if l in l_history
                    iterations = -1
                    break
                end

                push!(l_history, l)
            end

            simulation_cache[il+11, al+11] = iterations
        end
    end

    return simulation_cache
end

function simulate(simulation_cache::MMatrix{21,21,CInt}, i1::CInt, i2::CInt, il::CInt, a1::CInt, a2::CInt, al::CInt)::Tuple{Bool,CInt,CInt}

    iterations::CInt = simulation_cache[il+11, al+11]

    if iterations < 0
        return false, 0, 0
    else
        r1 = (i1 + iterations * a1) % 256
        if r1 < 0
            r1 += 256
        end

        r2 = (i2 + iterations * a2) % 256
        if r2 < 0
            r2 += 256
        end

        return true, r1, r2
    end
end

function cost(parms::SVector{6,CInt})::CInt
    return sum(map(abs, parms))
end

function inc2_2()
    println("generating simulation cache ...")
    simulation_cache = generate_simulation_cache()

    total_iterations = 21 * 21 * 20 * 21 * 21 * 20
    println("total:   ", total_iterations)

    max_cost::Int = 40 # don't simulate solutions that are longer than this
    i::Int = 0

    results = Array{SVector{6,CInt},2}(undef, 256, 256)
    fill!(results, SVector{6,CInt}(100, 100, 100, 100, 100, 100))

    for i1::CInt in [-10:10;]
        for i2::CInt in [-10:10;]
            for il::CInt in [-10:-1; 1:10]
                for a1::CInt in [-10:10;]
                    for a2::CInt in [-10:10;]
                        for al::CInt in [-10:-1; 1:10]
                            has_result::Bool, r1::CInt, r2::CInt = simulate(simulation_cache, i1, i2, il, a1, a2, al)

                            # update progress
                            i += 1
                            if i % 10000 == 0
                                print("\rcurrent: ", i)
                            end

                            if a2 > a1
                                continue
                            end

                            parameter_array = SVector{6,CInt}(i1, i2, il, a1, a2, al)
                            current_cost::CInt = cost(parameter_array)
                            if current_cost > max_cost
                                continue
                            end

                            if has_result && r1 >= 0 && r2 >= 0 && current_cost < cost(results[r1+1, r2+1])
                                parameter_array_swapped = SVector{6,CInt}(i2, i1, il, a2, a1, al)
                                results[r1+1, r2+1] = parameter_array
                                results[r2+1, r1+1] = parameter_array_swapped
                            end
                        end
                    end
                end
            end
        end
    end
    println()

    println("writing results to inc2-2.csv ...")
    f = open("inc2-2.csv", "w")
    for r1 in [0:255;]
        for r2 in [0:255;]
            write(f, string(r1) * "," * string(r2) * "," * join(map(string, results[r1+1, r2+1]), ',') * "\n")
        end
    end
    close(f)
end

inc2_2()
#@profilehtml inc2_2()
