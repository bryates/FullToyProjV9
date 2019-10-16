#pragma once
#include "ap_int.h"
void processA(ap_uint<2> bx, ap_uint<2>& bx_o,
              int inmem1[2][16], int inmem2[2][16],
              int outmem1[2][16], int outmem2[4][16],
              ap_uint<5> nent_i1[4], ap_uint<5> nent_o1[4],
              ap_uint<5> nent_i2[4], ap_uint<5> nent_o2[4]);
