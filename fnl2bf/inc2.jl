#!/usr/bin/env julia

# searches for the optimal parameters to increment a cell with one loop:
# i1 (?) > il (L) [ < a1 > al ]

function bf_plus(a, b)
    r = a + b
    if r < 0
        r  = 256 + r
    end

    return r % 256
end

function simulate(i1, L, il, a1, al)
    r = i1
    l = bf_plus(L, il)

    l_history = [l]
    while l != 0
        r = bf_plus(r, a1)
        l  = bf_plus(l,  al)

        if l in l_history
            return Nothing
        end

        push!(l_history, l)
    end

    return r
end

function fitness(parms)
    return sum(map(abs, parms))
end


total_iterations = 21 * 256 * 21 * 21 * 20
println("total:   ", total_iterations)

i = 0
results = Dict()
for i1 in [-10:10;]
    for L in [0:255;]
        for il in [-10:10;]
            for a1 in [-10:10;]
                for al in [-10:-1;1:10;]
                    r = simulate(i1, L, il, a1, al)
                    global i += 1

                    if r != Nothing
                        if haskey(results, [r, L])
                            if fitness([i1, il, a1, al]) < fitness(results[[r, L]])
                                results[[r, L]] = [i1, il, a1, al]
                            end
                        else
                            results[[r, L]] = [i1, il, a1, al]
                        end
                    end

                    print("\rcurrent: ", i)
                end
            end
        end
    end
end

f = open("inc2.factors", "w")
for r in results
    write(f, string(r[1]) * " " * string(r[2]) * "\n")
end
close(f)
