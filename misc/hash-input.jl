#!/usr/bin/env julia

# Reading and handling multiple allowed input strings of possibly diferrent lengths can be inefficient in brainfuck.
# One solution is to hash the input, this script helps to construct a suitable hash function.

# These are the possible inputs to the brainfuck program:
possibe_inputs = [
    "Alabama", "Alaska", "Arizona",
    "Arkansas", "California", "Colorado",
    "Connecticut", "Delaware", "District of Columbia",
    "Florida", "Georgia", "Hawaii",
    "Idaho", "Illinois", "Indiana",
    "Iowa", "Kansas", "Kentucky",
    "Louisiana", "Maine", "Maryland",
    "Massachusetts", "Michigan", "Minnesota",
    "Mississippi", "Missouri", "Montana",
    "Nebraska", "Nevada", "New Hampshire",
    "New Jersey", "New Mexico", "New York",
    "North Carolina", "North Dakota", "Ohio",
    "Oklahoma", "Oregon", "Pennsylvania",
    "Rhode Island", "South Carolina", "South Dakota",
    "Tennessee", "Texas", "Utah",
    "Vermont", "Virginia", "Washington",
    "West Virginia", "Wisconsin", "Wyoming"
]

# Search for parameters a,b of the hash function that produce no collisions for the possible inputs
println("a\tb")
for a in [1:255;]
    for b in [0:255;]
        function hash(str)
            x = 0
            for c in collect(str)
                x = ((a * x) + Int(c) + b) % 256
            end
            return x
        end

        l = length(unique(map(hash, possibe_inputs)))
        if l == length(possibe_inputs)
            println(a, "\t", b)
        end
    end
end
println()

# Choose a, b:
a = 1
b = 7


function hash(str)
    x = 0
    for c in collect(str)
        x = ((a * x) + Int(c) + b) % 256
    end
    return x
end

for i in possibe_inputs
    println(hash(i), "\t", i)
end

# brainfuck version of the hash function:
bf_hash = """
>[-]<
,
[
    >
    [
        <$('+' ^ a)
        >-
    ]
    <
    $('+' ^ b)
    [>+<-]
    ,
]
"""

println()
println(bf_hash)
