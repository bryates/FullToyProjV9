#include "processA.hh"
#define WIDHT1 32
#define WIDTH2 64
void processA(ap_uint<2> bx, ap_uint<2>& bx_o,
              int inmem1[16], int inmem2[16],
              int outmem1[16], int outmem2[16],
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

  nent_o1[bx] = nent_i1[bx];
  nent_o2[bx] = nent_i2[bx];
  int count1[4] = {0,0,0,0};
  int count2[4] = {0,0,0,0};

  ap_uint<5> bx_i = bx;
  
  for (int i = 0; i < 16; ++i) {
      nent_o1[bx] = nent_i1[bx];
      nent_o2[bx] = nent_i2[bx];
#pragma HLS pipeline II=1 rewind
    //if(count1[bx_i] >= nent_o1[bx_i] && count2[bx_i] >= nent_o2[bx_i]) continue;
    // read input memories
    int indata1 = inmem1[i]; //address with paging
    int indata2 = inmem2[i]; //address with paging

    // copy data
    int outdataA = indata1;

    int outdataB = indata2 * 2;

    // write to output
    outmem1[i] = outdataA;
    outmem2[i] = outdataB;

    if (i==15) bx_o = bx;
    if(count1[bx_i] < nent_i1[bx_i])
    count1[bx_i]++;
    if(count2[bx_i] < nent_i2[bx_i])
    count2[bx_i]++;
  }
  /*
  nent_o1[bx_i] = count1[bx_i];
  nent_o2[bx_i] = count2[bx_i];
  */
}
