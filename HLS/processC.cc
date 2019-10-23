#include "processC.hh"
void processC(ap_uint<2> bx, ap_uint<2>& bx_o,
              int inmem1[16], int inmem2[16],
              int outmem[16],
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
  bool isbigger = nent_i1[bx] > nent_i2[bx];
  nent_o[bx] = (isbigger ? nent_i1[bx] : nent_i2[bx]);
  //nent_o[bx] = nent_i1[bx];

  for (int i = 0; i < 16; ++i) {
#pragma HLS pipeline II=1 rewind
    if (i==15) bx_o = bx;

    //if(count[bx] >= nent_o[bx]) continue;

    // read input memories
    int indata1 = inmem1[i];
    int indata2 = inmem2[i];

    // compare data and store the larger one
    bool islarger = indata1 > indata2;
    //islarger &= nent_i1[bx(0,0)] > count[bx(0,0)];
    int outdata = islarger ? indata1 : indata2;
    //std::cout << indata1 << "\t" << indata2 << "\t" << islarger << "\t" << nent_i1[bx(0,0)] << "\t" << count[bx(0,0)] << std::endl;

    // write to output memory
    outmem[i] = outdata;

    count[bx]++;
  }
}
