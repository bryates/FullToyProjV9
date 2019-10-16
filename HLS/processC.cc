#include "processC.hh"
void processC(ap_uint<2> bx, ap_uint<2>& bx_o,
              int inmem1[2][16], int inmem2[4][16],
              int outmem[2][16],
              ap_uint<5> nent_i1[4], ap_uint<5> nent_i2[4], ap_uint<5> nent_o[4])
{
#pragma HLS inline off
#pragma HLS interface register port=bx_o
#pragma HLS resource variable=inmem1 latency=2
#pragma HLS resource variable=inmem2 latency=2
#pragma HLS ARRAY_PARTITION variable=nent_i1 complete dim=0
#pragma HLS ARRAY_PARTITION variable=nent_i2 complete dim=0
#pragma HLS ARRAY_PARTITION variable=nent_o complete dim=0

  int count[4] = {0,0,0,0};

  for (int i = 0; i < 16; ++i) {
#pragma HLS pipeline II=1 rewind
    if (i==15) bx_o = bx;

    if(count[bx] > nent_i1[bx]) continue;

    // read input memories
    int indata1 = inmem1[bx(0,0)][i];
    int indata2 = inmem2[bx][i];

    // compare data and store the larger one
    bool islarger = indata1 > indata2;
    int outdata = islarger ? indata1 : indata2;

    // write to output memory
    outmem[bx(0,0)][i] = outdata;

    count[bx]++;
  }
}
