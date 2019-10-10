#pragma once
#include "ap_int.h"
void processA(ap_uint<2> bx, ap_uint<2>& bx_o,
              int inmem1[2][16], int inmem2[2][16],
              int outmem1[2][16], int outmem2[4][16],
              int nent_i[4], int nent_o[4]);
