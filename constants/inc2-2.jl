#!/usr/bin/env julia

# searches for the optimal parameters i1-3 and a1-3 to increment two cells with one loop:
# i1 > i2 > il [ << a1 > a2 > al ]

function bf_plus(a, b)
    r = a + b
    if r < 0
        r  = 256 + r
    end

    return r % 256
end

function simulate(i1, i2, il, a1, a2, al)
    r1 = i1
    r2 = i2

    l = il
    l_history = [al]
    while l != 0
        r1 = bf_plus(r1, a1)
        r2 = bf_plus(r2, a2)
        l  = bf_plus(l,  al)

        if l in l_history
            return Nothing, Nothing
        end

        push!(l_history, l)
    end

    return r1, r2
end

function fitness(parms)
    return sum(map(abs, parms))
end


total_iterations = 21 * 21 * 20 * 21 * 21 * 20
println("total:   ", total_iterations)

i = 0
results = Dict()
for i1 in [-10:10;]
    for i2 in [-10:10;]
        for il in [-10:-1;1:10;]
            for a1 in [-10:10;]
                for a2 in [-10:10;]
                    for al in [-10:-1;1:10;]
                        r1, r2 = simulate(i1, i2, il, a1, a2, al)

                        if r1 != Nothing
                            if haskey(results, [r1, r2])
                                if fitness([i1, i2, il, a1, a2, al]) < fitness(results[[r1, r2]])
                                    results[[r1, r2]] = [i1, i2, il, a1, a2, al]
                                end
                            else
                                results[[r1, r2]] = [i1, i2, il, a1, a2, al]
                            end
                        end

                        global i += 1
                        print("\rcurrent: ", i)
                    end
                end
            end
        end
    end
end

f = open("inc2-2.factors", "w")
for r in results
    write(f, string(r[1]) * " " * string(r[2]) * "\n")
end
close(f)
