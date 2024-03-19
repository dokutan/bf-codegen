#!/usr/bin/env julia

using CSV
using StaticArrays

"Search for i1,a1 in inc2_n_factors."
function find(inc2_n_factors, r, il, al)
    for row in inc2_n_factors
        if row.Column1 == r && row.Column2 == il && row.Column3 == al
            return row.Column4, row.Column5
        end
    end
    return nothing, nothing
end

"Calculate the cost of the brainfuck program descriped by `il_al` `and all_i1_a1`."
function cost(il_al, all_i1_a1)
    return sum(map(abs, il_al)) + sum(map(x->sum(map(abs,x)), all_i1_a1))
end

"Search for the optimal parameters to add/store `results`."
function get_parameters(results)
    inc2_n_factors = nothing
    try
        inc2_n_factors = CSV.File("inc2-n.csv", header=false)
    catch
        println("Failed to open inc2-n.csv, run inc2-n.jl to generate it.")
        exit(1)
    end

    parameters = Dict()

    for il in [-20:20;]
        for al in [-20:-1; 1:20]
            all_i1_a1 = []
            possible = true
            for r in results
                i1, a1 = find(inc2_n_factors, r, il, al)
                if i1 === nothing || a1 === nothing
                    possible = false
                    break
                end
                push!(all_i1_a1, SA[i1, a1])
            end
            if possible
                parameters[SA[il, al]] = all_i1_a1
            end
        end
    end

    min_il_al = nothing
    min_all_i1_a1 = nothing
    for il_al in keys(parameters)
        if min_il_al === nothing
            min_il_al = il_al
            min_all_i1_a1 = parameters[il_al]
        elseif cost(il_al, parameters[il_al]) < cost(min_il_al, min_all_i1_a1)
            min_il_al = il_al
            min_all_i1_a1 = parameters[il_al]
        end
    end

    return min_il_al, min_all_i1_a1
end

function bf_inc_dec(x)
    if x < 0
        return "-" ^ abs(x)
    else
        return "+" ^ x
    end
end

function build_bf(il_al, all_i1_a1)
    bf = ""
    for i1_a1 in all_i1_a1
        bf *= bf_inc_dec(i1_a1[1]) * ">"
    end
    bf *= bf_inc_dec(il_al[1])
    bf *= "["
    bf *= "<" ^ length(all_i1_a1)
    for i1_a1 in all_i1_a1
        bf *= bf_inc_dec(i1_a1[2]) * ">"
    end
    bf *= bf_inc_dec(il_al[2])
    bf *= "]" * "<" ^ length(all_i1_a1)
end

function  main()
    println("Press Ctrl+C to exit.")
    while true
        println("Enter the values you want to add/store in brainfuck as a comma separated list:")
        print("> ")
        results = parse.(Int, split(readline(), ","))
        il_al, all_i1_a1 = get_parameters(results)
        println(build_bf(il_al, all_i1_a1))
        println()
    end
end

main()
