all: inc2_3_factors.so inc2_n.so optimize.so

clean:
	rm inc2_3_factors.so inc2_n.so optimize.so

inc2_3_factors.so:
	c++ inc2_3_factors.cpp -o inc2_3_factors.so -shared -llua -fPIC -Wall -Ofast -march=native

inc2_n.so:
	c++ inc2_n.cpp -o inc2_n.so -shared -llua -fPIC -Wall -Ofast -march=native

optimize.so:
	c++ optimize.cpp -o optimize.so -shared -llua -fPIC -Wall -Ofast -march=native
