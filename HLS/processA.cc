#include "processA.hh"
void processA(ap_uint<2> bx, ap_uint<2>& bx_o,
              int inmem1[2][16], int inmem2[2][16],
              int outmem1[2][16], int outmem2[4][16],
              ap_uint<5> nent_i1[4], ap_uint<5> nent_o1[4],
              ap_uint<5> nent_i2[4], ap_uint<5> nent_o2[4])
{
#pragma HLS inline off
#pragma HLS interface register port=bx_o
#pragma HLS resource variable=inmem1 latency=2
#pragma HLS resource variable=inmem2 latency=2
#pragma HLS ARRAY_PARTITION variable=nent_i1 complete dim=0
#pragma HLS ARRAY_PARTITION variable=nent_o1 complete dim=0
#pragma HLS ARRAY_PARTITION variable=nent_i2 complete dim=0
#pragma HLS ARRAY_PARTITION variable=nent_o2 complete dim=0

  int count[4] = {0,0,0,0};

  nent_o1[bx] = nent_i1[bx];
  nent_o2[bx] = nent_i2[bx];

  for (int i = 0; i < 16; ++i) {
#pragma HLS pipeline II=1 rewind

    if (i==15) bx_o = bx;

    if(count[bx] > nent_i1[bx] && count[bx] > nent_i2[bx]) continue;

    // read input memories
    if(count[bx] <= nent_i1[bx]) {
      int indata1 = inmem1[bx(0,0)][i];
      // copy data
      int outdataA = indata1;
      // write to output
      outmem1[bx(0,0)][i] = outdataA;
    }
    if(count[bx] <= nent_i2[bx]) {
      int indata2 = inmem2[bx(0,0)][i];
      // copy data
      int outdataB = indata2 * 2;
      // write to output
      outmem2[bx][i] = outdataB;
    }

    count[bx]++;
  }
}
