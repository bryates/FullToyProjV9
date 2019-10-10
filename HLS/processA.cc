#include "processA.hh"
void processA(ap_uint<2> bx, ap_uint<2>& bx_o,
              int inmem1[2][16], int inmem2[2][16],
              int outmem1[2][16], int outmem2[4][16],
              int nent_i[4], int nent_o[4])
{
#pragma HLS inline off
#pragma HLS interface register port=bx_o
#pragma HLS resource variable=inmem1 latency=2
#pragma HLS resource variable=inmem2 latency=2
#pragma HLS ARRAY_PARTITION variable=nent_i complete dim=0
#pragma HLS ARRAY_PARTITION variable=nent_o complete dim=0

  int countA[4] = {0,0,0,0};

  for (int i = 0; i < 16; ++i) {
#pragma HLS pipeline II=1 rewind
    if(countA[bx] > nent_i[bx]) continue;
    // read input memories
    int indata1 = inmem1[bx(0,0)][i];
    int indata2 = inmem2[bx(0,0)][i];

    // copy data
    int outdataA = indata1;

    int outdataB = indata2 * 2;

    // write to output
    outmem1[bx(0,0)][i] = outdataA;
    outmem2[bx][i] = outdataB;

    countA[bx]++;

    if (i==15) bx_o = bx;

    nent_o[bx] = countA[bx];
  }
}
