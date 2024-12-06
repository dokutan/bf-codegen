#!/usr/bin/env julia

function count_to_color(count::Int)
    if count == 0
        "#ffffff"
    elseif count < 2
        "#ffd7e0"
    elseif count < 10
        "#ffb3bb"
    elseif count < 100
        "#ff8c8e"
    elseif count < 1000
        "#ff5a54"
    else
        "#ff0000"
    end
end

function profile(bf)
    cells::Int = 30000
    cell_size::Int = 256
    memory::Vector{Int} = zeros(Int, cells)
    ptr::Int = 1
    stack::Vector{Int} = []
    ip::Int = 1
    memory_read::Dict{Int, Int} = Dict()
    memory_write::Dict{Int, Int} = Dict()
    instruction_count::Vector{Int} = zeros(Int, length(bf))
    instructions_run::Int = 0
    instructions_total::Int = length(bf)

    while ip < instructions_total
        instruction_count[ip] += 1
        instructions_run += 1

        if bf[ip] == '+'
            memory[ptr] = mod(memory[ptr] + 1, cell_size)
            memory_write[ptr] = get(memory_write, ptr, 0) + 1
        elseif bf[ip] == '-'
            memory[ptr] = mod(memory[ptr] - 1, cell_size)
            memory_write[ptr] = get(memory_write, ptr, 0) + 1
        elseif bf[ip] == '>'
            ptr += 1
            if ptr > cells
                ptr = 1
            end
        elseif bf[ip] == '<'
            ptr -= 1
            if ptr < 1
                ptr = cells
            end
        elseif bf[ip] == '.'
            print(Char(memory[ptr]))
            memory_read[ptr] = get(memory_read, ptr, 0) + 1
        elseif bf[ip] == ','
            if !eof(stdin)
                memory[ptr] = Int(read(stdin, UInt8))
            end
            memory_write[ptr] = get(memory_write, ptr, 0) + 1
        elseif bf[ip] == '['
            memory_read[ptr] = get(memory_read, ptr, 0) + 1
            if memory[ptr] != 0
                push!(stack, ip)
            else
                instruction_count[ip] -= 1
                depth = 1
                while depth > 0
                    ip += 1
                    if bf[ip] == '['
                        depth += 1
                    elseif bf[ip] == ']'
                        depth -= 1
                    end
                end
            end
        elseif bf[ip] == ']'
            ip = pop!(stack) - 1
        end

        ip += 1
    end

    html =
        "<!DOCTYPE html><html>\n" *
        "<h2>program</h2><div style=\"font-family: monospace; font-size: x-large;\">" *
        join(map(i->"""<span title="$(instruction_count[i])" style="background-color: $(count_to_color(instruction_count[i]));">$(bf[i])</span>""", 1:instructions_total)) *
        "</div>\n<h2>statistics</h2>\n" *
        "<p><b>instructions:</b> $instructions_total</p>\n" *
        "<p><b>instructions run:</b> $instructions_run</p>\n" *
        "<h2>memory access</h2><table>\n" *
        "<tr><td><b>ptr</b></td><td><b>read</b></td><td><b>write</b></td></tr>\n" *
        join(map(i->"<tr><td>$i</td><td>$(get(memory_read, i, ""))</td><td>$(get(memory_write, i, ""))</td></tr>\n", union(keys(memory_read), keys(memory_read))|>collect|>sort)) *
        "</table></html>\n"

    # optimize the program by removing instructions that were never executed
    optimized = ""
    for i in 1:instructions_total
        if instruction_count[i] > 0
            optimized *= bf[i]
        end
    end
    optimized *= "\n"

    return html, optimized
end

if length(ARGS) < 2
    println("usage: bf-profiler.jl program.bf profile.html [optimized.bf]")
else
    html, optimized = profile(Char.(read(ARGS[1])))

    outfile = open(ARGS[2]; write=true)
    write(outfile, html)
    close(outfile)

    if length(ARGS) > 2
        outfile = open(ARGS[3]; write=true)
        write(outfile, optimized)
        close(outfile)
    end
end
