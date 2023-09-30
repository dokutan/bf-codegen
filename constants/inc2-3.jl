#!/usr/bin/env julia

# searches for the optimal parameters i1-3,l and a1-3,l to increment three cells with one loop:
# i1 > i2 > i3 > il [ <<< a1 > a2 > a3 > al ]

#using StatProfilerHTML
using StaticArrays

const CInt = Int16

function Base.:(==)(a::SVector{3,CInt}, b::SVector{3,CInt})
    return @inbounds (a[1] == b[1]) && @inbounds (a[2] == b[2]) && @inbounds (a[3] == b[3])
end

function Base.isequal(a::SVector{3,CInt}, b::SVector{3,CInt})
    return @inbounds (a[1] == b[1]) && @inbounds (a[2] == b[2]) && @inbounds (a[3] == b[3])
end

function bf_plus(a::CInt, b::CInt)::CInt
    r::CInt = a + b
    if r < 0
        r += 256
    end

    return r % 256
end

function generate_simulation_cache()::MMatrix{41,41,CInt}
    "Generate an MMatrix describing for how many iterations a brainfuck loop `0[al]` runs."
    simulation_cache = zeros(MMatrix{41,41,CInt})

    for il::CInt in [-20:-1; 1:20]
        for al::CInt in [-20:-1; 1:20]
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

            simulation_cache[il+21, al+21] = iterations
        end
    end

    return simulation_cache
end

function simulate(simulation_cache::MMatrix{41,41,CInt}, i1::CInt, i2::CInt, i3::CInt, il::CInt, a1::CInt, a2::CInt, a3::CInt, al::CInt)::Tuple{Bool,CInt,CInt,CInt}

    iterations::CInt = simulation_cache[il+21, al+21]

    if iterations < 0
        return false, 0, 0, 0
    else
        r1::CInt = (i1 + iterations * a1) % 256
        if r1 < 0
            r1 += 256
        end

        r2::CInt = (i2 + iterations * a2) % 256
        if r2 < 0
            r2 += 256
        end

        r3::CInt = (i3 + iterations * a3) % 256
        if r3 < 0
            r3 += 256
        end

        return true, r1, r2, r3
    end
end

function cost(parms::SVector{8,CInt})::CInt
    return sum(map(abs, parms))
end

function inc2_3()
    println("generating simulation cache ...")
    simulation_cache = generate_simulation_cache()

    total_iterations = 25 * 25 * 25 * 24 * 25 * 25 * 25 * 24
    println("total:   ", total_iterations)

    max_cost::Int = 60 # don't simulate solutions that are longer than this
    i::Int = 0

    results = Array{SVector{8,CInt},3}(undef, 256, 256, 256)
    fill!(results, SVector{8,CInt}(100, 100, 100, 100, 100, 100, 100, 100))

    parameter_range = CInt[-12:12;]
    parameter_range_no_0 = CInt[-12:-1; 1:12]

    for i1::CInt in parameter_range
        for i2::CInt in parameter_range
            for i3::CInt in parameter_range
                for il::CInt in parameter_range_no_0
                    for a1::CInt in parameter_range
                        for a2::CInt in parameter_range
                            for a3::CInt in parameter_range
                                for al::CInt in parameter_range_no_0
                                    has_result::Bool, r1::CInt, r2::CInt, r3::CInt = simulate(simulation_cache, i1, i2, i3, il, a1, a2, a3, al)

                                    # update progress
                                    i += 1
                                    if i % 10000 == 0
                                        print("\rcurrent: ", i)
                                    end

                                    if !(a1 <= a2 <= a3)
                                        continue
                                    end

                                    parameter_array_123 = SVector{8,CInt}(i1, i2, i3, il, a1, a2, a3, al)
                                    current_cost::CInt = cost(parameter_array_123)
                                    if current_cost > max_cost
                                        continue
                                    end

                                    if has_result && r1 >= 0 && r2 >= 0 && r3 >= 0 && current_cost < cost(results[r1+1, r2+1, r3+1])
                                        results[r1+1, r2+1, r3+1] = parameter_array_123
                                        results[r1+1, r3+1, r2+1] = SVector{8,CInt}(i1, i3, i2, il, a1, a3, a2, al)
                                        results[r2+1, r1+1, r3+1] = SVector{8,CInt}(i2, i1, i3, il, a2, a1, a3, al)
                                        results[r2+1, r3+1, r1+1] = SVector{8,CInt}(i2, i3, i1, il, a2, a3, a1, al)
                                        results[r3+1, r1+1, r2+1] = SVector{8,CInt}(i3, i1, i2, il, a3, a1, a2, al)
                                        results[r3+1, r2+1, r1+1] = SVector{8,CInt}(i3, i2, i1, il, a3, a2, a1, al)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    println()

    println("writing results to inc2-3.csv ...")
    f = open("inc2-3.csv", "w")
    for r1 in [0:255;]
        for r2 in [0:255;]
            for r3 in [0:255;]
                write(f, string(r1) * "," * string(r2) * "," * string(r3) * "," * join(map(string, results[r1+1, r2+1, r3+1]), ',') * "\n")
            end
        end
    end
    close(f)
end

inc2_3()
#@profilehtml inc2_3()
