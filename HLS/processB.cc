#include "processB.hh"
void processB(ap_uint<2> bx, ap_uint<2>& bx_o,
              int inmem[16], int outmem[16],
              ap_uint<5> nent_i[4], ap_uint<5> nent_o[4])
{
#pragma HLS inline off
#pragma HLS interface register port=bx_o
#pragma HLS resource variable=inmem latency=2
#pragma HLS ARRAY_PARTITION variable=nent_i complete dim=0
#pragma HLS ARRAY_PARTITION variable=nent_o complete dim=0

  int count = 4;
  ap_uint<5> bx_i = bx;

  for (int i = 0; i < 16; ++i) {
#pragma HLS pipeline II=1 rewind
    if (i==15) bx_o = bx;

    nent_o[bx_i] = nent_i[bx_i];

    //if(count >= nent_o[bx]) continue;

    // read input memories
    int indata = inmem[i];

    // multiple by 2
    int outdata = indata * 2;

    // write to output
    outmem[i] = outdata;

    count++;
  }
}
