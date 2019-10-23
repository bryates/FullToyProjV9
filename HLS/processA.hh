#pragma once
#include "ap_int.h"
#define WIDTH1 32
#define WIDTH2 64
void processA(ap_uint<2> bx, ap_uint<2>& bx_o,
              int inmem1[WIDTH1], int inmem2[WIDTH2],
              int outmem1[WIDTH1], int outmem2[WIDTH2],
              ap_uint<5> nent_i1[4], ap_uint<5> nent_o1[4],
              ap_uint<5> nent_i2[4], ap_uint<5> nent_o2[4]);
