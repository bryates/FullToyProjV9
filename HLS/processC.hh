#pragma once
#include "ap_int.h"
void processC(ap_uint<2> bx, ap_uint<2>& bx_o,
              int inmem1[16], int inmem2[16],
              int outmem[16],
              ap_uint<5> nent_i1[4], ap_uint<5> nent_i2[4], ap_uint<5> nent_o[4]);
