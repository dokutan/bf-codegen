using Random
include("utils.jl")

######################################### 
# Type 1: increment/decrement and print #
#########################################

"""
The most primitive approach, uses a single memory cell. Used commands: ``+``, ``-``, ``.``
The memory cell has to be initialized with a known value (default 0).
"""
function encode1(str::String; init::Int=0)

    ret = ""
    previous_char = init

    for c in codeunits(str)
        this_char = Int(c)
        
        if this_char == previous_char
            ret *= "."
        elseif this_char > previous_char
            ret *= "+"^(this_char-previous_char) * "."
        elseif this_char < previous_char
            ret *= "-"^(previous_char-this_char) * "."
        end
    
        previous_char = this_char
    end

    return ret
end

"""
Uses loops for incrementing/decrementing. Makes use of two memory cells.
The initial memory cell and the next memory cell have to be initialized with 0.
After printing the instruction pointer will be at the initial memory cell.
"""
function encode2(str::String)

    cost = 5 # the cost of using a loop in brainfuck

    ret = ""
    previous_char = 0

    for c in codeunits(str)
        this_char = Int(c)
        
        if this_char == previous_char
            ret *= "."
        else
        
            diff = abs(this_char-previous_char)
            command = previous_char > this_char ? "-" : "+"
            f1, f2, f3 = factorize_sum_c(diff)

            if f1 === nothing || f2 === nothing || f1+f2+f3+cost >= diff
                ret *= command^diff * "."
            else
                ret *= ">" * "+"^f1 * "[<" * command^f2 * ">-]<" * command^f3 * "." 
            end

        end
    
        previous_char = this_char
    end

    return ret
end

"""
Uses nested loops for incrementing/decrementing. Has no upper limit on the number of memory cells used.
The used memory cells have to be initialized with 0.
TODO! sometimes generates an infinite loop
"""
function encode3(str::String)

    cost = 5 # the cost of using a loop in brainfuck

    ret = ""
    previous_char = 0

    for c in codeunits(str)
        this_char = Int(c)
        
        if this_char == previous_char
            ret *= "."
        else
        
            diff = abs(this_char-previous_char)
            command = previous_char > this_char ? "-" : "+"
            ret *= h3(command, diff, cost) * "."

        end
    
        previous_char = this_char
    end

    return ret
end

##################################### 
# Type 2: store in memory and print #
#####################################

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses at least as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
"""
function encode4_generic(str::String, unique_codeunits::Function, bf_assign::Function; verbose::Bool=false)
    ret = ""
    ret_size = 0 # used to calculate the amount of commands used for initialization/printing

    # build Dict codepoint → memory position
    positions = Dict()
    pos = 0

    if verbose
        printstyled(repr(bf_assign), ", ", repr(unique_codeunits), "\n"; color=:green)
    end

    for c in unique_codeunits(str)

        positions[Int(c)] = pos
        pos += 1

        ret *= bf_assign(Int(c)) * ">"

    end

    # the last '>' is useless
    pos -= 1
    ret = ret[begin:end-1]

    ret_size = length(ret)

    for c in codeunits(str)

        next_pos = positions[Int(c)]

        if next_pos == pos
            ret *= "."
        elseif next_pos > pos
            ret *= ">"^(next_pos-pos) * "."
        elseif next_pos < pos
            ret *= "<"^(pos-next_pos) * "."
        end

        pos = next_pos

    end
    
    if verbose
        printstyled("init: ", ret_size, ", print: ", length(ret)-ret_size, "\n"; color=:green)
    end

    return ret
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- u: Bytes are sorted in memory by their appearance in str.
"""
function encode4pu(str::String)
    return encode4_generic(str, unique_codeunits_appearance, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- U: Bytes are reversely sorted in memory by their appearance in str.
"""
function encode4pU(str::String)
    return encode4_generic(str, unique_codeunits_rev_appearance, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- s: Bytes are sorted in memory.
"""
function encode4ps(str::String)
    return encode4_generic(str, unique_codeunits_sorted, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- S: Bytes are reversely sorted in memory.
"""
function encode4pS(str::String)
    return encode4_generic(str, unique_codeunits_rev_sorted, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
"""
function encode4po(str::String)
    return encode4_generic(str, unique_codeunits_frequency, bf_assign_primitive)
end
"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
"""
function encode4pO(str::String)
    return encode4_generic(str, unique_codeunits_rev_frequency, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- u: Bytes are sorted in memory by their appearance in str.
"""
function encode4lu(str::String)
    return clean_brainfuck(encode4_generic(str, unique_codeunits_appearance, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- U: Bytes are reversely sorted in memory by their appearance in str.
"""
function encode4lU(str::String)
    return clean_brainfuck(encode4_generic(str, unique_codeunits_rev_appearance, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- s: Bytes are sorted in memory.
"""
function encode4ls(str::String)
    return clean_brainfuck(encode4_generic(str, unique_codeunits_sorted, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- S: Bytes are reversely sorted in memory.
"""
function encode4lS(str::String)
    return clean_brainfuck(encode4_generic(str, unique_codeunits_rev_sorted, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
"""
function encode4lo(str::String)
    return clean_brainfuck(encode4_generic(str, unique_codeunits_frequency, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
"""
function encode4lO(str::String)
    return clean_brainfuck(encode4_generic(str, unique_codeunits_rev_frequency, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses at least as many memory cells as there are unique bytes in str.
Uses an evolutionary approach to optimize the memory layout.
All memory cells have to be initialized with 0.
"""
function encode5_generic(str::String, bf_assign::Function; verbose::Bool=true, steps::Int=10)
    ret = ""

    # generates brainfuck code for the given Dict codepoint → memory position
    function build_ret(positions, str)
        ret = ""
        pos = 0

        ordered_positions = []
        for c in positions
            append!(ordered_positions, [(c[2], c[1])])
        end
        sort!(ordered_positions)
        for c in ordered_positions
            pos += 1
            ret *= bf_assign(Int(c[2])) * ">"
        end

        # the last '>' is useless
        pos -= 1
        ret = ret[begin:end-1]

        for c in codeunits(str)

            next_pos = positions[Int(c)]
    
            if next_pos == pos
                ret *= "."
            elseif next_pos > pos
                ret *= ">"^(next_pos-pos) * "."
            elseif next_pos < pos
                ret *= "<"^(pos-next_pos) * "."
            end
    
            pos = next_pos
    
        end

        return clean_brainfuck(ret)
    end

    # build initial Dict codepoint → memory position
    positions = Dict()
    pos = 0

    for c in unique(codeunits(str))
        positions[Int(c)] = pos
        pos += 1
    end

    # try ro find the best layout
    best_positions = positions
    best_ret = build_ret(positions,str)
    for i=1:steps

        positions = best_positions

        #for j=i:steps
        for j=1:100
            # swap the postion of two random codepoints
            c1, c2 = Random.rand(positions,2)
            positions[c1[1]] = c2[2]
            positions[c2[1]] = c1[2]
        end

        ret = build_ret(positions,str)
        if length(ret) < length(best_ret)
            best_positions = positions
            best_ret = ret
        end

        if verbose
            println(i, "/", steps, ", current: ", length(ret), ", best: ", length(best_ret))
        end

    end

    return best_ret
end

function encode5p(str::String)
    return encode5_generic(str, bf_assign_primitive; verbose=false, steps=5000)
end

function encode5l(str::String)
    return encode5_generic(str, bf_assign_loop; verbose=false, steps=5000)
end

function encode5n(str::String)
    return encode5_generic(str, bf_assign_loop_nested; verbose=false, steps=5000)
end


"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses at least as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
Similar to encode4_generic, but has a better instruction pointer movement.
TODO! make movement a function, maybe remove encode4*
"""
function encode6_generic(str::String, unique_codeunits::Function, bf_assign::Function; verbose::Bool=false)
    ret = ""
    ret_size = 0 # used to calculate the amount of commands used for initialization/printing

    # build Dict codepoint → memory position
    positions = Dict()
    pos = 0

    if verbose
        printstyled(repr(bf_assign), ", ", repr(unique_codeunits), "\n"; color=:green)
    end

    for c in unique_codeunits(str)

        positions[Int(c)] = pos
        pos += 1

        ret *= bf_assign(Int(c)) * ">"

    end

    # the last '>' is useless
    pos -= 1
    ret = ret[begin:end-1]

    last_pos = pos
    ret_size = length(ret)

    for c in codeunits(str)

        next_pos = positions[Int(c)]

        if next_pos == pos
            ret *= "."
        elseif next_pos > pos
            
            # the first approach (directly move to the next position)
            move1 = ">"^(next_pos-pos) * "."
            
            # the second approach (move to the end, then back)
            move2 = "[>]" * "<"^(last_pos-pos) * "."
            
            if length(move2) < length(move1)
                print("ok")
            end

            ret *= (length(move1) > length(move2) ? move2 : move1)

        elseif next_pos < pos

            # the first approach (directly move to the next position)
            move1 = "<"^(pos-next_pos) * "."
            
            # the second approach (move to the end, then back)
            move2 = "[<]" * ">"^(next_pos+1) * "."

            ret *= (length(move1) > length(move2) ? move2 : move1)

        end

        pos = next_pos

    end
    
    if verbose
        printstyled("init: ", ret_size, ", print: ", length(ret)-ret_size, "\n"; color=:green)
    end

    return ret
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses at least as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
Similar to encode4_generic, but has a better instruction pointer movement.
This version of encode6_generic attempts to implement movement to the ends while printing with a loop. → failed
"""
function encode6_generic_(str::String, unique_codeunits::Function, bf_assign::Function; verbose::Bool=true)
    ret = ""
    ret_size = 0 # used to calculate the amount of commands used for initialization/printing

    # build Dict codepoint → memory position
    positions = Dict()
    pos = 0

    if verbose
        printstyled(repr(bf_assign), ", ", repr(unique_codeunits), "\n"; color=:green)
    end

    for c in unique_codeunits(str)

        positions[Int(c)] = pos
        pos += 1

        ret *= bf_assign(Int(c)) * ">"

    end

    if verbose
        printstyled(positions, "\n"; color=:green)
    end

    max_pos = length(positions)

    # the last '>' is useless
    pos -= 1
    ret = ret[begin:end-1]

    last_pos = pos
    ret_size = length(ret)


    # iterate over the codeunits in str
    bytes = codeunits(str)
    i = 1
    while i <= length(bytes)

        c = bytes[i]
        next_pos = positions[Int(c)]

        
        if next_pos == pos

            ret *= "."
            pos = next_pos
            i+=1
        
        elseif false #next_pos == pos + 1
            
            loop_possible = true
            j = i+1
            for _ = pos:length(positions)
                this_byte = bytes[j]
                prev_byte = bytes[j-1]
                this_pos = positions[this_byte]
                prev_pos = positions[prev_byte]

                loop_possible = loop_possible && (this_pos == prev_pos+1)
                j += 1
            end

            ret1 = ret[begin:end-1]
            ret2 = ret
            if loop_possible
                
            else

            end

        elseif next_pos == pos - 1

            loop_possible = false

            for j = i:length(bytes)
                if positions[bytes[j]] == max_pos
                    loop_possible = true
                    println("loop ok")
                    break
                elseif positions[bytes[j]] != positions[bytes[i]] - 1
                        break
                end
            end

            # the first approach (directly move to the next position)
            move1 = "<"^(pos-next_pos) * "."
            
            # the second approach (move to the end, then back)
            move2 = "[<]" * ">"^(next_pos+1) * "."

            ret *= (length(move1) > length(move2) ? move2 : move1)
            pos = next_pos
            i+=1

        elseif next_pos > pos
            
            # the first approach (directly move to the next position)
            move1 = ">"^(next_pos-pos) * "."
            
            # the second approach (move to the end, then back)
            move2 = "[>]" * "<"^(last_pos-pos) * "."
            
            if length(move2) < length(move1)
                print("ok")
            end

            ret *= (length(move1) > length(move2) ? move2 : move1)
            pos = next_pos
            i+=1

        elseif next_pos < pos

            # the first approach (directly move to the next position)
            move1 = "<"^(pos-next_pos) * "."
            
            # the second approach (move to the end, then back)
            move2 = "[<]" * ">"^(next_pos+1) * "."

            ret *= (length(move1) > length(move2) ? move2 : move1)
            pos = next_pos
            i+=1

        end

    end
    
    if verbose
        printstyled("init: ", ret_size, ", print: ", length(ret)-ret_size, "\n"; color=:green)
    end

    return ret
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- u: Bytes are sorted in memory by their appearance in str.
"""
function encode6pu(str::String)
    return encode6_generic(str, unique_codeunits_appearance, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- U: Bytes are reversely sorted in memory by their appearance in str.
"""
function encode6pU(str::String)
    return encode6_generic(str, unique_codeunits_rev_appearance, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- s: Bytes are sorted in memory.
"""
function encode6ps(str::String)
    return encode6_generic(str, unique_codeunits_sorted, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- S: Bytes are reversely sorted in memory.
"""
function encode6pS(str::String)
    return encode6_generic(str, unique_codeunits_rev_sorted, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
"""
function encode6po(str::String)
    return encode6_generic(str, unique_codeunits_frequency, bf_assign_primitive)
end
"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
"""
function encode6pO(str::String)
    return encode6_generic(str, unique_codeunits_rev_frequency, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- u: Bytes are sorted in memory by their appearance in str.
"""
function encode6lu(str::String)
    return clean_brainfuck(encode6_generic(str, unique_codeunits_appearance, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- U: Bytes are reversely sorted in memory by their appearance in str.
"""
function encode6lU(str::String)
    return clean_brainfuck(encode6_generic(str, unique_codeunits_rev_appearance, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- s: Bytes are sorted in memory.
"""
function encode6ls(str::String)
    return clean_brainfuck(encode6_generic(str, unique_codeunits_sorted, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- S: Bytes are reversely sorted in memory.
"""
function encode6lS(str::String)
    return clean_brainfuck(encode6_generic(str, unique_codeunits_rev_sorted, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
"""
function encode6lo(str::String)
    return clean_brainfuck(encode6_generic(str, unique_codeunits_frequency, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
"""
function encode6lO(str::String)
    return clean_brainfuck(encode6_generic(str, unique_codeunits_rev_frequency, bf_assign_loop))
end

"""
Similar to encode6, but allows incrementing/decrementing during printing and implements better movement.
"""
function encode7_generic(str::String, unique_codeunits::Function, bf_assign::Function)
    
    memory = [] # the brainfuck memory
    ret = "" # the returned code
    
    str_units = codeunits(str)
    index = 1

    bytes = unique_codeunits(str)
    # x, y, z = factorize_n(bytes)

    # initialize the memory with all required bytes, TODO! combine loops, optimized layout
    ptr = 1
    for b in bytes
        ret *= bf_assign(Int(b))
        append!(memory, b)
        ptr += 1

        # print if possible
        while index <= length(str_units) && str_units[index] == b
            ret *= "."
            index += 1
        end


        ret *= ">"

        # insert gaps, doesn't work
        #=
        if length(memory) % 5 == 0
            ret *= ">"
            append!(memory, 0)
            ptr += 1
        end
        =#


    end

    # the last '>' is useless
    ptr -= 1
    ret = ret[begin:end-1]
    ret = clean_brainfuck(ret)

    # print str
    for i=index:length(str_units)

        #=
        overwrite = function (x)
            return findnext((==)(memory[x]), str_units, i) === nothing
        end
        =#

        p = bf_print(memory, ptr, str_units[i])
        ret *= p[1]
        ptr = p[2]

    end

    return clean_brainfuck(ret)

end

"Attempt at combining loops during memory initialization."
function encode7_generic_m(str::String, unique_codeunits::Function, bf_assign::Function)
    
    memory = [] # the brainfuck memory
    ret = "" # the returned code
    
    str_units = codeunits(str)
    index = 1

    bytes = unique_codeunits(str)
    x, y, z = factorize_n(bytes)

    # initialize the memory with all required bytes, TODO! combine loops, optimized layout
    memory = bytes
    append!(memory, [0])
    ptr = length(memory)
    for i in z
        ret *= "+" ^ i * ">"
    end
    ret *= "+" ^ x * "["
    for i in reverse(y)
        ret *= "<" * "+" ^ i
    end
    ret *= "[>]<-]\n"

    # print str
    for i=index:length(str_units)
        p = bf_print(memory, ptr, str_units[i])
        ret *= p[1]
        ptr = p[2]

    end

    return clean_brainfuck(ret)

end

"Attempt at removing repetitions"
function encode7_generic_r(str::String, unique_codeunits::Function, bf_assign::Function)
    
    memory = [] # the brainfuck memory
    ret = "" # the returned code
    
    str_units = codeunits(str)
    index = 1

    bytes = unique_codeunits(str)
    # x, y, z = factorize_n(bytes)

    # initialize the memory with all required bytes, TODO! combine loops, optimize layout
    ptr = 1
    for b in bytes
        ret *= bf_assign(Int(b))
        append!(memory, b)
        ptr += 1

        # print if possible
        while index <= length(str_units) && str_units[index] == b
            ret *= "."
            index += 1
        end

        ret *= ">"
    end

    append!(memory, [0])

    # the last '>' is useless
    ptr -= 1
    ret = ret[begin:end-1]
    ret = clean_brainfuck(ret)

    # print str
    i=index
    while i <= length(str_units)

        b = str_units[i]
        count = 0
        while i <= length(str_units) && str_units[i] == b
            count += 1
            i += 1
        end

        if count == 1

            p = bf_print(memory, ptr, b)
            ret *= p[1]
            ptr = p[2]

        elseif count > 1

            f1, f2, f3 = factorize_sum(count)

            if f1 == 0 || f2 == 0 || count < 10 # change this

                p = bf_print(memory, ptr, b)
                ret *= p[1]
                ptr = p[2]
                ret *= "." ^ (count-1)

            else

                if f3 !== nothing && f3 > 0
                    p = bf_print(memory, ptr, b)
                    ret *= p[1]
                    ptr = p[2]
                    ret *= "." ^ (f3-1)
                end

                # move to empty cell at the end
                ret *= "[>]" * "+" ^ f2 * "["
                ptr = length(memory)

                # inside the loop, print repeatedly
                p = bf_print(memory, ptr, b)
                ret *= p[1]
                ptr = p[2]
                ret *= "." ^ (f1-1)

                # end the loop
                ret *= "[>]<-]"
                ptr = length(memory)

            end

        else
            throw("count = "*string(count))
        end


        # detect repetitions
        #=
        if i < length(str_units) && str_units[i] == str_units[i+1]
            
            ret *= "\n"

            r = 1
            while i < length(str_units) && str_units[i] == str_units[i+1]
                r += 1
                i += 1
            end
            p = bf_print(memory, ptr, str_units[i-r+1])
            ret *= p[1]
            ptr = p[2]

            ret *= "." ^ (r-2)

            ret *= "\n"

        else
            p = bf_print(memory, ptr, str_units[i])
            ret *= p[1]
            ptr = p[2]
            i += 1
        end
        =#

    end

    return clean_brainfuck(ret)

end

"Attempt at removing a common phrase"
function encode7_generic__(str::String, unique_codeunits::Function, bf_assign::Function)
    
    memory = [] # the brainfuck memory
    ret = "" # the returned code

    phrase = codeunits("ab")
    
    str_units = codeunits(str)
    index = 1

    bytes = unique_codeunits(str)
    # x, y, z = factorize_n(bytes)

    # initialize the memory with all required bytes, TODO! combine loops, optimized layout
    ptr = 1
    for b in bytes
        ret *= bf_assign(Int(b))
        append!(memory, b)
        ptr += 1

        # print if possible
        while index <= length(str_units) && str_units[index] == b
            ret *= "."
            index += 1
        end

        ret *= ">"
    end

    ret *= ">"
    ptr+=1

    for b in phrase
        ret *= bf_assign(Int(b))
        append!(memory, b)
        ptr += 1
        ret *= ">"
    end

    # the last '>' is useless
    ptr -= 1
    ret = ret[begin:end-1]
    ret = clean_brainfuck(ret)

    # print str
    for i=index:length(str_units)

        if findnext(phrase, str_units, i) !== nothing && findnext(phrase, str_units, i)[1] == i

            ret *= [>]>[.>]
            ptr = length(memory)+1

        else

            p = bf_print(memory, ptr, str_units[i])
            ret *= p[1]
            ptr = p[2]

        end

    end

    return clean_brainfuck(ret)

end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- u: Bytes are sorted in memory by their appearance in str.
"""
function encode7pu(str::String)
    return encode7_generic(str, unique_codeunits_appearance, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- U: Bytes are reversely sorted in memory by their appearance in str.
"""
function encode7pU(str::String)
    return encode7_generic(str, unique_codeunits_rev_appearance, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- s: Bytes are sorted in memory.
"""
function encode7ps(str::String)
    return encode7_generic(str, unique_codeunits_sorted, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- S: Bytes are reversely sorted in memory.
"""
function encode7pS(str::String)
    return encode7_generic(str, unique_codeunits_rev_sorted, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
"""
function encode7po(str::String)
    return encode7_generic(str, unique_codeunits_frequency, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
- e: Only even bytes are stored.
"""
function encode7poe(str::String)
    return encode7_generic(str, unique_codeunits_frequency_even, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
"""
function encode7pO(str::String)
    return encode7_generic(str, unique_codeunits_rev_frequency, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
- e: Only even bytes are stored.
"""
function encode7pOe(str::String)
    return encode7_generic(str, unique_codeunits_rev_frequency_even, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- r: Bytes are stored two times: (reversely) sorted in memory by their frequency in str.
"""
function encode7pr(str::String)
    return encode7_generic(str, unique_codeunits_rev_frequency, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- u: Bytes are sorted in memory by their appearance in str.
"""
function encode7lu(str::String)
    return clean_brainfuck(encode7_generic(str, unique_codeunits_appearance, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- u: Bytes are sorted in memory by their appearance in str.
- e: Only even bytes are stored.
"""
function encode7lue(str::String)
    return clean_brainfuck(encode7_generic(str, unique_codeunits_appearance_even, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- U: Bytes are reversely sorted in memory by their appearance in str.
"""
function encode7lU(str::String)
    return clean_brainfuck(encode7_generic(str, unique_codeunits_rev_appearance, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- U: Bytes are reversely sorted in memory by their appearance in str.
- e: Only even bytes are stored.
"""
function encode7lUe(str::String)
    return clean_brainfuck(encode7_generic(str, unique_codeunits_rev_appearance_even, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- s: Bytes are sorted in memory.
"""
function encode7ls(str::String)
    return clean_brainfuck(encode7_generic(str, unique_codeunits_sorted, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- s: Bytes are sorted in memory.
- e: Only even bytes are stored.
"""
function encode7lse(str::String)
    return clean_brainfuck(encode7_generic(str, unique_codeunits_sorted_even, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- S: Bytes are reversely sorted in memory.
"""
function encode7lS(str::String)
    return clean_brainfuck(encode7_generic(str, unique_codeunits_rev_sorted, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- S: Bytes are reversely sorted in memory.
- e: Only even bytes are stored.
"""
function encode7lS(str::String)
    return clean_brainfuck(encode7_generic(str, unique_codeunits_rev_sorted_even, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
"""
function encode7lo(str::String)
    return clean_brainfuck(encode7_generic(str, unique_codeunits_frequency, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
- e: Only even bytes are stored.
"""
function encode7loe(str::String)
    return clean_brainfuck(encode7_generic(str, unique_codeunits_frequency_even, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
"""
function encode7lO(str::String)
    return clean_brainfuck(encode7_generic(str, unique_codeunits_rev_frequency, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
- e: Only even bytes are stored.
"""
function encode7lOe(str::String)
    return clean_brainfuck(encode7_generic(str, unique_codeunits_rev_frequency_even, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- r: Bytes are stored two times: (reversely) sorted in memory by their frequency in str.
"""
function encode7lr(str::String)
    return clean_brainfuck(encode7_generic(str, unique_codeunits_frequency_repeated, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- u: Bytes are sorted in memory by their appearance in str.
"""
function encode7nu(str::String)
    return encode7_generic(str, unique_codeunits_appearance, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- U: Bytes are reversely sorted in memory by their appearance in str.
"""
function encode7nU(str::String)
    return encode7_generic(str, unique_codeunits_rev_appearance, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- s: Bytes are sorted in memory.
"""
function encode7ns(str::String)
    return encode7_generic(str, unique_codeunits_sorted, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- S: Bytes are reversely sorted in memory.
"""
function encode7nS(str::String)
    return encode7_generic(str, unique_codeunits_rev_sorted, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
"""
function encode7no(str::String)
    return encode7_generic(str, unique_codeunits_frequency, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
- e: Only even bytes are stored.
"""
function encode7noe(str::String)
    return encode7_generic(str, unique_codeunits_frequency_even, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
"""
function encode7nO(str::String)
    return encode7_generic(str, unique_codeunits_rev_frequency, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
- e: Only even bytes are stored.
"""
function encode7nOe(str::String)
    return encode7_generic(str, unique_codeunits_rev_frequency_even, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- r: Bytes are stored two times: (reversely) sorted in memory by their frequency in str.
"""
function encode7nr(str::String)
    return encode7_generic(str, unique_codeunits_frequency_repeated, bf_assign_loop_nested)
end

"""
A version of encode7 with an evolutionary approach to the memory layout. performs poorly
"""
function encode8(str::String; steps::Int=10000)

    function build_ret(bytes, str)

        memory = [] # the brainfuck memory
        ret = "" # the returned code
    
        # initialize the memory with all required bytes, TODO! combine loops, recursive loops
        ptr = 1
        for b in bytes
            ret *= bf_assign_loop(Int(b)) * ">"
            append!(memory, b)
            ptr += 1
        end
    
        # the last '>' is useless
        ptr -= 1
        ret = ret[begin:end-1]
        ret = clean_brainfuck(ret)
    
        # print str
        str_units = codeunits(str)
        for i=1:length(str_units)
    
            #=
            overwrite = function (x)
                return findnext((==)(memory[x]), str_units, i) === nothing
            end
            =#
    
            p = bf_print(memory, ptr, str_units[i])
            ret *= p[1]
            ptr = p[2]
    
        end
    
        return clean_brainfuck(ret)
    end

    bytes = shuffle(unique_codeunits_frequency(str)) # use a generally good starting layout
    # x, y, z = factorize_n(bytes)

    bytes_min = bytes
    ret_min = build_ret(bytes, str)
    for i=1:steps
        
        bytes_swapped = bytes_min
        for j=1:3
            i1, i2 = Random.rand([1:length(bytes_min)],2)
            temp = bytes_swapped[i1]
            bytes_swapped[i1] = bytes_swapped[i2]
            bytes_swapped[i2] = temp
        end
        
        bytes_shuffled = shuffle(bytes_min)

        ret_swapped = build_ret(bytes_swapped, str)
        ret_shuffled = build_ret(bytes_shuffled, str)

        if length(ret_swapped) < length(ret_min)
            ret_min = ret_swapped
            bytes_min = bytes_swapped
        end
        if length(ret_shuffled) < length(ret_min)
            ret_min = ret_shuffled
            bytes_min = bytes_shuffled
        end

        println("$i/$steps, ", length(ret_min), ", ", length(ret_swapped), ", ", length(ret_shuffled))

    end

    return ret_min
end

"""
A wrapper around encode7_generic that optimises the memory layout.
"""
function encode9(str::String, bf_assign::Function; steps::Int=1000, remove::Bool=true, verbose=true)

    # build initial Dict codeunit → memory position
    positions = unique(codeunits(str))

    # try ro find the best layout
    best_positions = positions
    best_ret = encode7_generic(str, s -> positions, bf_assign)
    Threads.@threads for i=1:steps

        ret = encode7_generic(str, s -> Random.shuffle(positions), bf_assign)
        if length(ret) < length(best_ret)
            best_positions = positions
            best_ret = ret
        end

        if verbose
            println(i, "/", steps, ", current: ", length(ret), ", best: ", length(best_ret))
        end

    end

    return best_ret
end

"""
A wrapper around encode7_generic that optimises the memory layout, adds redundant values
"""
function encode9_1(str::String, bf_assign::Function; steps::Int=1000, remove::Bool=true, verbose=true)

    # build initial Dict codeunit → memory position
    positions = unique(codeunits(str))

    # try ro find the best layout
    best_positions = positions
    best_ret = encode7_generic(str, s -> positions, bf_assign)
    Threads.@threads for i=1:steps

        ret = encode7_generic(str, s -> vcat(Random.shuffle(positions), Random.shuffle(positions)[1:Random.rand([2:length(positions);])]), bf_assign)
        if length(ret) < length(best_ret)
            best_positions = positions
            best_ret = ret
        end

        if verbose
            println(i, "/", steps, ", current: ", length(ret), ", best: ", length(best_ret))
        end

    end

    return best_ret
end

"""
A wrapper around encode7_generic that optimises the memory layout, removes values
"""
function encode9_2(str::String, bf_assign::Function; steps::Int=1000, remove::Bool=true, verbose=true)

    # build initial Dict codeunit → memory position
    positions = unique(codeunits(str))

    # try ro find the best layout
    best_positions = positions
    best_ret = encode7_generic(str, s -> positions, bf_assign)
    Threads.@threads for i=1:steps

        ret = encode7_generic(str, s -> Random.shuffle(positions[1:length(positions)-1]), bf_assign)
        if length(ret) < length(best_ret)
            best_positions = positions
            best_ret = ret
        end

        if verbose
            println(i, "/", steps, ", current: ", length(ret), ", best: ", length(best_ret))
        end

    end

    return best_ret
end

"""
Similar to encode7, uses loops to print sequences.
"""
function encode10_generic(str::String, unique_codeunits::Function, bf_assign::Function)
    
    memory = [] # the brainfuck memory
    ret = "" # the returned code
    
    str_units = codeunits(str)
    index = 1

    bytes = unique_codeunits(str)

    # initialize the memory with all required bytes
    ptr = 1
    for b in bytes
        ret *= bf_assign(Int(b))
        append!(memory, b)
        ptr += 1

        # print if possible
        while index <= length(str_units) && str_units[index] == b
            ret *= "."
            index += 1
        end

        ret *= ">"
    end

    # the last '>' is useless
    ptr -= 1
    ret = ret[begin:end-1]
    ret = clean_brainfuck(ret)

    # print str
    i = index
    while i <= length(str_units)

        # is printing all bytes until the end of the memory possible ? works
        #=
        if length(memory)-ptr > 1 && i+length(memory)-ptr <= length(str_units) && memory[ptr+1:end] == str_units[i:i+length(memory)-ptr-1]
            ret *= ">[.>]<"
            i = i+ptr+2
            ptr = length(memory)
        =#
        
        # cheap hack
        if i <= length(str_units)-1 && ptr == length(memory)-2 && memory[end-1] == str_units[i] && memory[end] == str_units[i+1]
            ret *= ">[.>]<"
            i += 1
            ptr = length(memory)

        elseif i <= length(str_units)-1 && ptr == 3 && memory[2] == str_units[i] && memory[1] == str_units[i+1]
            ret *= "<[.<]>"
            i += 1
            ptr = 1

        else
            p = bf_print(memory, ptr, str_units[i])
            ret *= p[1]
            ptr = p[2]
        end

        i += 1
    end

    # this function generates code that needs additional cleanup
    l_old = length(ret)
    l_new = 0
    while l_old != l_new
        ret = replace(ret, ".>[.>]" => "[.>]")
        ret = replace(ret, ".<[.<]" => "[.<]")
        l_old = l_new
        l_new = length(ret)
    end

    return clean_brainfuck(ret)

end


"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- u: Bytes are sorted in memory by their appearance in str.
"""
function encode10pu(str::String)
    return encode10_generic(str, unique_codeunits_appearance, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- U: Bytes are reversely sorted in memory by their appearance in str.
"""
function encode10pU(str::String)
    return encode10_generic(str, unique_codeunits_rev_appearance, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- s: Bytes are sorted in memory.
"""
function encode10ps(str::String)
    return encode10_generic(str, unique_codeunits_sorted, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- S: Bytes are reversely sorted in memory.
"""
function encode10pS(str::String)
    return encode10_generic(str, unique_codeunits_rev_sorted, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
"""
function encode10po(str::String)
    return encode10_generic(str, unique_codeunits_frequency, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
- e: Only even bytes are stored.
"""
function encode10poe(str::String)
    return encode10_generic(str, unique_codeunits_frequency_even, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
"""
function encode10pO(str::String)
    return encode10_generic(str, unique_codeunits_rev_frequency, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
- e: Only even bytes are stored.
"""
function encode10pOe(str::String)
    return encode10_generic(str, unique_codeunits_rev_frequency_even, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- p: Doesn't make use of loops for initialization.
- r: Bytes are stored two times: (reversely) sorted in memory by their frequency in str.
"""
function encode10pr(str::String)
    return encode10_generic(str, unique_codeunits_rev_frequency, bf_assign_primitive)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- u: Bytes are sorted in memory by their appearance in str.
"""
function encode10lu(str::String)
    return clean_brainfuck(encode10_generic(str, unique_codeunits_appearance, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- u: Bytes are sorted in memory by their appearance in str.
- e: Only even bytes are stored.
"""
function encode10lue(str::String)
    return clean_brainfuck(encode10_generic(str, unique_codeunits_appearance_even, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- U: Bytes are reversely sorted in memory by their appearance in str.
"""
function encode10lU(str::String)
    return clean_brainfuck(encode10_generic(str, unique_codeunits_rev_appearance, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- U: Bytes are reversely sorted in memory by their appearance in str.
- e: Only even bytes are stored.
"""
function encode10lUe(str::String)
    return clean_brainfuck(encode10_generic(str, unique_codeunits_rev_appearance_even, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- s: Bytes are sorted in memory.
"""
function encode10ls(str::String)
    return clean_brainfuck(encode10_generic(str, unique_codeunits_sorted, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- s: Bytes are sorted in memory.
- e: Only even bytes are stored.
"""
function encode10lse(str::String)
    return clean_brainfuck(encode10_generic(str, unique_codeunits_sorted_even, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- S: Bytes are reversely sorted in memory.
"""
function encode10lS(str::String)
    return clean_brainfuck(encode10_generic(str, unique_codeunits_rev_sorted, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- S: Bytes are reversely sorted in memory.
- e: Only even bytes are stored.
"""
function encode10lS(str::String)
    return clean_brainfuck(encode10_generic(str, unique_codeunits_rev_sorted_even, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
"""
function encode10lo(str::String)
    return clean_brainfuck(encode10_generic(str, unique_codeunits_frequency, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
- e: Only even bytes are stored.
"""
function encode10loe(str::String)
    return clean_brainfuck(encode10_generic(str, unique_codeunits_frequency_even, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
"""
function encode10lO(str::String)
    return clean_brainfuck(encode10_generic(str, unique_codeunits_rev_frequency, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
- e: Only even bytes are stored.
"""
function encode10lOe(str::String)
    return clean_brainfuck(encode10_generic(str, unique_codeunits_rev_frequency_even, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
All memory cells have to be initialized with 0.
- l: Uses loops for initialization.
- r: Bytes are stored two times: (reversely) sorted in memory by their frequency in str.
"""
function encode10lr(str::String)
    return clean_brainfuck(encode10_generic(str, unique_codeunits_frequency_repeated, bf_assign_loop))
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- u: Bytes are sorted in memory by their appearance in str.
"""
function encode10nu(str::String)
    return encode10_generic(str, unique_codeunits_appearance, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- U: Bytes are reversely sorted in memory by their appearance in str.
"""
function encode10nU(str::String)
    return encode10_generic(str, unique_codeunits_rev_appearance, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- s: Bytes are sorted in memory.
"""
function encode10ns(str::String)
    return encode10_generic(str, unique_codeunits_sorted, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- S: Bytes are reversely sorted in memory.
"""
function encode10nS(str::String)
    return encode10_generic(str, unique_codeunits_rev_sorted, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
"""
function encode10no(str::String)
    return encode10_generic(str, unique_codeunits_frequency, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- o: Bytes are sorted in memory by their frequency in str.
- e: Only even bytes are stored.
"""
function encode10noe(str::String)
    return encode10_generic(str, unique_codeunits_frequency_even, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
"""
function encode10nO(str::String)
    return encode10_generic(str, unique_codeunits_rev_frequency, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- O: Bytes are reversely sorted in memory by their frequency in str.
- e: Only even bytes are stored.
"""
function encode10nOe(str::String)
    return encode10_generic(str, unique_codeunits_rev_frequency_even, bf_assign_loop_nested)
end

"""
Stores all required bytes in memory, then accesses and prints them.
Bytes are stored on the right side of the initial memory cell.
Uses as many memory cells as there are unique bytes in str.
All memory cells have to be initialized with 0.
- n: Uses nested loops for initialization.
- r: Bytes are stored two times: (reversely) sorted in memory by their frequency in str.
"""
function encode10nr(str::String)
    return encode10_generic(str, unique_codeunits_frequency_repeated, bf_assign_loop_nested)
end
