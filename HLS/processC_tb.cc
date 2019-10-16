#include "processC.hh"
#include <algorithm>

int main()
{
  using namespace std;

  // error count
  int err = 0;

  // input array;
  int memoryBC[2][16] = {{2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53},
                            {3,4,6,8,12,14,18,20,24,30,32,38,42,44,48,54}};
  int memoryAC[4][16] = {{1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,61},
                           {2,4,6,8,10,12,14,16,18,20,22,24,26,28,50,32},
                           {1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,61},
                           {2,4,6,8,10,12,14,16,18,20,22,24,26,28,50,32}};
  ap_uint<5> nent_i1[4] = {16,16,16,16};
  ap_uint<5> nent_i2[4] = {16,16,16,16};
  ap_uint<5> nent_o[4] = {0,0,0,0};
  // output array
  int outarray1[2][16];

  // reference array
  int refarray1[2][16] = {{2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,61},
                            {3,4,6,8,12,14,18,20,24,30,32,38,42,44,50,54}};

  ap_uint<2> bx_o;

  cout << "Start event loop" << endl;
  for (unsigned int ievt = 0; ievt < 5; ++ievt) {
    cout << "Event: " << ievt << endl;

    // call top function
    processC(ievt, bx_o, memoryBC, memoryAC, outarray1, nent_i1, nent_i2, nent_o);
    //topfunction(ievt, bx_o, inarray1[ievt%2], inarray2[ievt%2], outarray[ievt%2]);

    // verify output
    for (int i = 0; i<16; ++i) {
      if (outarray1[ievt%2][i] != refarray1[ievt%2][i]) err++;
    }
  }

  return err;
}

