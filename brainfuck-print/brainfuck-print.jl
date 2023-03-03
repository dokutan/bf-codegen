# Generate brainfuck code to print a given string

include("encode.jl")

function benchmark(funcs, str)
    l_min = nothing
    f_min = nothing
    r_min = nothing

    for fn in funcs
        show(fn)
        @time r = fn(str)
        l = length(r)
        println("  bytes: " , l)
        println()
        
        if l_min === nothing || l < l_min
            l_min = l
            f_min = fn
            r_min = r
        end
    end

    println("best: ", repr(f_min), " (", length(r_min), " bytes)")
    return r_min
end

functions = [
    encode1
    encode2
    #encode3
    encode4pu
    encode4pU
    encode4ps
    encode4pS
    encode4po
    encode4pO
    encode4lu
    encode4lU
    encode4ls
    encode4lS
    encode4lo
    encode4lO
    #encode5p
    #encode5l
    #encode5n
    encode6pu
    encode6pU
    encode6ps
    encode6pS
    encode6po
    encode6pO
    encode6lu
    encode6lU
    encode6ls
    encode6lS
    encode6lo
    encode6lO
    encode7pu
    encode7pU
    encode7ps
    encode7pS
    encode7po
    encode7poe
    encode7pO
    encode7pOe
    encode7pr
    encode7lu
    encode7lue
    encode7lU
    encode7lUe
    encode7ls
    encode7lS
    encode7lo
    encode7loe
    encode7lO
    encode7lOe
    encode7lr
    encode7nu
    encode7nU
    encode7ns
    encode7nS
    encode7no
    encode7noe
    encode7nO
    encode7nOe
    encode7nr
    encode10pu
    encode10pU
    encode10ps
    encode10pS
    encode10po
    encode10poe
    encode10pO
    encode10pOe
    encode10pr
    encode10lu
    encode10lue
    encode10lU
    encode10lUe
    encode10ls
    encode10lS
    encode10lo
    encode10loe
    encode10lO
    encode10lOe
    encode10lr
    encode10nu
    encode10nU
    encode10ns
    encode10nS
    encode10no
    encode10noe
    encode10nO
    encode10nOe
    encode10nr
]

str = "Hello world!"

# println(encode9(str, bf_assign_loop_nested; steps=5000))
# println(encode5_generic(str, bf_assign_loop_nested; steps=5000))
# println(encode10_generic(str, unique_codeunits_rev_appearance, bf_assign_loop_nested))

println(benchmark(functions, str))
