#pragma once
#include "ap_int.h"
void processB(ap_uint<2> bx, ap_uint<2>& bx_o,
              int inmem[2][16], int outmem[2][16],
              ap_uint<5> nent_i[4], ap_uint<5> nent_o[4]);
