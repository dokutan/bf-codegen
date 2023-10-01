#!/usr/bin/env sh
# Convert inc2.csv to inc2-factors.lua and inc2-2.csv to inc2-2-factors.lua for use with fnl2bf.

# for files with 65k lines
convert1(){
    sed -E 's/^([^,]+,[^,]+),(.+)/t\["\1"\]={\2}/g' "$1" > "$2" #inc2.csv > inc2-factors.lua
    cat << EOF | ed "$2"
0a
t={}
function f1()
.

20000a
end function f2()
.

40000a
end function f3()
.

60000a
end function f4()
.

\$a
end
f1() f2() f3() f4()
return t
.

w
q
EOF
}

# for inc2-n
convert2(){
    sed -E 's/^([^,]+,[^,]+),(.+)/t\["\1"\]={\2}/g' "$1" > "$2" #inc2.csv > inc2-factors.lua
    cat << EOF | ed "$2"
0a
t={}
function f1()
.

20000a
end function f2()
.

40000a
end function f3()
.

60000a
end function f4()
.

80000a
end function f5()
.

100000a
end function f6()
.

120000a
end function f7()
.

140000a
end function f8()
.

160000a
end function f9()
.

180000a
end function f10()
.

200000a
end function f11()
.

220000a
end function f12()
.

240000a
end function f13()
.

\$a
end
f1() f2() f3() f4() f5() f6() f7() f8() f9() f10() f11() f12() f13()
return t
.

w
q
EOF
}

convert1 "inc2.csv" "inc2-factors.lua"
convert1 "inc2-2.csv" "inc2-2-factors.lua"
convert2 "inc2-n.csv" "inc2-n-factors.lua"
