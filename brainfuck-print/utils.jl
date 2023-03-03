"Finds the integer factorization of x with the smallest sum."
function factorize(x::Int)
    
    divisors = filter(i -> x%i==0 , 2:x-1 )
    
    min_sum = x
    f1 = nothing
    f2 = nothing

    # find f1, f2 with the smallest sum
    if length(divisors) > 0
        f1 = x÷divisors[1]
        f2 = divisors[1]
    end
    for d in divisors
        if x÷d + d < min_sum
            f1 = x÷d
            f2 = d
            min_sum = f1 + f2
        end
    end

    @assert( f1 === nothing || f2 === nothing || f1*f2 == x )
    return f1, f2
end

"Finds the combination of f1*f2+f3==x for the smallest f1+f2+f3."
function factorize_sum(x::Int)

    min_sum = x
    f1 = nothing
    f2 = nothing
    f3 = nothing

    if x ∈ [0:5;]
        f1 = f2 = 0
        f3 = x
    end

    for i=0:x-1
        g1, g2 = factorize(x-i)

        if g1 !== nothing && g2 !== nothing && g1+g2+i < min_sum
            f1 = g1
            f2 = g2
            f3 = i
            min_sum = f1+f2+f3
        end
    end

    @assert( f1 === nothing || f2 === nothing || f1*f2+f3 == x )
    return f1, f2, f3
end

"Memoized version of factorize_sum()"
cache = Dict()
function factorize_sum_c(x::Int)
    
    if !haskey(cache, x)
        cache[x] = factorize_sum(x)
    end

    return cache[x]
end

"""
Given an array of integers n, finds the following:
x * y[m] + z[m] = n[m], for all m and x+sum(y)+sum(z) = minimal
"""
function factorize_n(n)

    # for all possible x, calculate y[] and z[]
    xyz = []
    for x in 1:maximum(n)
        y = n.÷x
        z = n.%x
        append!(xyz, [[x, y, z]])
    end

    # find the minimum
    x_min = xyz[1][1]
    y_min = xyz[1][2]
    z_min = xyz[1][3]
    for x_y_z in xyz
        if x_y_z[1] + sum(x_y_z[2]) + sum(x_y_z[3]) < x_min + sum(y_min) + sum(z_min)
            x_min = x_y_z[1]
            y_min = x_y_z[2]
            z_min = x_y_z[3] 
        end
    end

    return x_min, y_min, z_min

end

"Removes useless combinations of brainfuck commands like '<>' or '+-'"
function clean_brainfuck(str::String)
    length_old = length(str)
    length_new = 0
    while length_old != length_new
        str=replace(str,"<>"=>"")
        str=replace(str,"><"=>"")
        str=replace(str,"-+"=>"")
        str=replace(str,"+-"=>"")
        str=replace(str,"[]"=>"")
        length_old = length_new
        length_new = length(str)
    end
    return str
end

"Recursively replaces large consecutive commands with a loop"
function h3(command, times, cost)
    f1, f2, f3 = factorize_sum_c(times)

    if f1 === nothing || f2 === nothing || f1+f2+f3+cost >= times
        return command^times
    else
        return ">" * h3("+",f1,cost) * "[<" * h3(command,f2,cost) * ">-]<" * h3(command,f3,cost)
    end
end

# str::String → unique codeunits in some order
"Returns the unique bytes(codeunits) in str in the order they appear in str."
function unique_codeunits_appearance(str::String)
    return unique(codeunits(str))
end

"Returns the unique bytes(codeunits) in str in the reverse order they appear in str."
function unique_codeunits_rev_appearance(str::String)
    return reverse(unique_codeunits_appearance(str))
end

"Returns the even, unique bytes(codeunits) in str in the order they appear in str."
function unique_codeunits_appearance_even(str::String)
    even_codeunits = filter(c -> iseven(c), unique(codeunits(str)))
    return length(even_codeunits) > 0 ? even_codeunits : unique(codeunits(str))
end

"Returns the even, unique bytes(codeunits) in str in the reverse order they appear in str."
function unique_codeunits_rev_appearance_even(str::String)
    even_codeunits = filter(c -> iseven(c), reverse(unique_codeunits_appearance(str)))
    return length(even_codeunits) > 0 ? even_codeunits : reverse(unique_codeunits_appearance(str))
end

"Returns the unique bytes(codeunits) in str sorted."
function unique_codeunits_sorted(str::String)
    return sort(unique(codeunits(str)))
end

"Returns the unique bytes(codeunits) in str sorted and reversed."
function unique_codeunits_rev_sorted(str::String)
    return reverse(unique_codeunits_sorted(str))
end

"Returns the even, unique bytes(codeunits) in str sorted."
function unique_codeunits_sorted_even(str::String)
    even_codeunits = filter(c -> iseven(c), sort(unique(codeunits(str))))
    return length(even_codeunits) > 0 ? even_codeunits : sort(unique(codeunits(str)))
end

"Returns the even, unique bytes(codeunits) in str sorted and reversed."
function unique_codeunits_rev_sorted_even(str::String)
    even_codeunits = filter(c -> iseven(c), reverse(unique_codeunits_sorted(str)))
    return length(even_codeunits) > 0 ? even_codeunits : reverse(unique_codeunits_sorted(str))
end

"Returns the unique bytes(codeunits) in str sorted by their frequency."
function unique_codeunits_frequency(str::String)
    
    bytes = codeunits(str)
    unique_bytes = unique(bytes)
    amounts = Dict()

    # build Dict codepoint → number of frequency
    for c in unique(bytes)
        amounts[c] = length(findall((==)(c),bytes))

    end

    # create sorted list of tuples (amount, codepoint)
    sorted_amounts = sort(map(c -> (amounts[c], c), unique_bytes))

    return map(t -> t[2], sorted_amounts)
end

"Returns the unique bytes(codeunits) in str reversely sorted by their frequency."
function unique_codeunits_rev_frequency(str::String)
    return reverse(unique_codeunits_frequency(str))
end

"Returns the concatenation of unique_codeunits_frequency() and unique_codeunits_rev_frequency()."
function unique_codeunits_frequency_repeated(str::String)
    return vcat(unique_codeunits_frequency(str), unique_codeunits_rev_frequency(str))
end

"Returns the unique, even codeunits in str, sorted by their frequency."
function unique_codeunits_frequency_even(str::String)
    even_codeunits = filter(c -> iseven(c), unique_codeunits_frequency(str))
    return length(even_codeunits) > 0 ? even_codeunits : unique_codeunits_frequency(str)
end

"Returns the unique, even codeunits in str, reversely sorted by their number of frequency."
function unique_codeunits_rev_frequency_even(str::String)
    even_codeunits = filter(c -> iseven(c), unique_codeunits_rev_frequency(str))
    return length(even_codeunits) > 0 ? even_codeunits : unique_codeunits_rev_frequency(str)
end

# old and new value of a brainfuck memory cell → brainfuck code
"Generates brainfuck code using '+' or '-' to assign the value new to the current memory cell containing the value old."
function bf_assign_primitive(new::Int, old::Int=0)
    ret = ""

    if new > old
        ret = "+"^(new-old)
    elseif new < old
        ret *= "-"^(old-new)
    end

    return ret
end

"Generates brainfuck code using a loop to assign the value new to the current memory cell containing the value old."
function bf_assign_loop(new::Int, old::Int=0; loop_cost::Int=5)
    ret = ""

    if new != old
        
        diff = abs(new-old)
        command = old > new ? "-" : "+"
        f1, f2, f3 = factorize_sum_c(diff)

        if f1 === nothing || f2 === nothing || f1+f2+f3+loop_cost >= diff
            ret = command^diff
        else
            ret = command^f3 * ">" * "+"^f1 * "[<" * command^f2 * ">-]<"
        end

    end

    return ret
end

"Generates brainfuck code using nested loops to assign the value new to the current memory cell containing the value old."
function bf_assign_loop_nested(new::Int, old::Int=0; loop_cost::Int=5)
    ret = ""

    if new != old
        
        diff = abs(new-old)
        command = old > new ? "-" : "+"
        f1, f2, f3 = factorize_sum_c(diff)

        if f1 === nothing || f2 === nothing || f1+f2+f3+loop_cost >= diff
            ret = command^diff
        else
            ret = bf_assign_loop_nested(f3,old) * ">" * bf_assign_loop_nested(f1,old) * "[<" * command^f2 * ">-]<"
        end

    end

    return ret
end

"""
Calculates brainfuck commands required to move the data pointer from ptr to target.
"""
function bf_move(memory, ptr, target)
    
    options = [] # vector of (commands, next_ptr)

    if ptr == target
        
        append!(options, [("", target)])

    elseif target > ptr

        # move directly, repeated '>'
        append!(options, [( ">" ^ (target - ptr), target )])
        
        # make use of gaps, this allows '[>]'
        gaps = 0 # the number of memory cells containing 0 encountered
        for i=ptr:length(memory)+1
            if i > length(memory) || memory[i] == 0
                gaps += 1
                command = ("[>]" ^ gaps) * (i > target ? "<" : ">")^abs(target-i)
                append!(options, [(command, target)])
            end
        end

    elseif target < ptr

        # move directly, repeated '<'
        append!(options, [( "<" ^ (ptr - target), target )])

        # make use of gaps, this allows '[<]'
        gaps = 0 # the number of memory cells containing 0 encountered
        for i=ptr:-1:0
            if i == 0 || memory[i] == 0
                gaps += 1
                command = ("[<]" ^ gaps) * (i > target ? "<" : ">")^abs(target-i)
                append!(options, [(command, target)])
            end
        end

    end

    # return the shortest option
    o_min = options[1]
    for o in options
        if length(o[1]) < length(o_min[1])
            o_min = o
        end
    end
    return o_min
end

"""
Calculates brainfuck commands required to move the data pointer from ptr to an address containing value.
"""
function bf_move_value(memory, ptr, value)
    
    # failsafe, if value does not appear in memory
    if findall((==)(value), memory) == []
        return []
    end

    options = [] # vector of (commands, next_ptr)

    for target in findall((==)(value), memory)    
        append!(options, [bf_move(memory, ptr, target)])
    end

    # return the shortest option
    o_min = options[1]
    for o in options
        if length(o[1]) < length(o_min[1])
            o_min = o
        end
    end
    return o_min
end

"""
Print value for a given data pointer ptr and memory.
Calls overwrite with an address to check if that memory cell can be permanently changed.
"""
function bf_print(memory, ptr, value, overwrite::Function=(x -> false))
    
    options = []

    # value might exist in memory, move and print
    move = bf_move_value(memory, ptr, value)
    if move != []
        append!(options, [(move[1] * ".", move[2])])
    end

    # for each memory position, move, change the value, print, restore value
    for target=1:length(memory)
        
        move = bf_move(memory, ptr, target)
        commands = move[1]
        commands *= (memory[target] > value ? "-" : "+")^abs(memory[target]-value) * "."
        #if !overwrite(target) # doesn't always work
        #    println("overwrite")
            commands *= (value > memory[target] ? "-" : "+")^abs(memory[target]-value)
        #end

        append!(options, [(commands, move[2])])

        if length(commands) < 4
            break
        end

    end

    # return the shortest option
    o_min = options[1]
    for o in options
        if length(o[1]) < length(o_min[1])
            o_min = o
        end
    end
    return o_min

end
