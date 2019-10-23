#include "processB.hh"
#include <algorithm>

int main()
{
  using namespace std;

  // error count
  int err = 0;

  // input array;
  int memoryAB[2][16] = {{2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53},
                            {3,4,6,8,12,14,18,20,24,30,32,38,42,44,48,54}};
  // output array
  int memoryBC[2][16];

  // reference array
  int refarray1[2][16] = {{4,6,10,14,22,26,34,38,46,58,62,74,82,86,94,106},
                            {6,8,12,16,24,28,36,40,48,60,64,76,84,88,96,108}};
  ap_uint<5> nent_i[2] = {16,16};
  ap_uint<5> nent_o[2] = {0,0};

  ap_uint<2> bx_o;

  cout << "Start event loop" << endl;
  for (unsigned int ievt = 0; ievt < 5; ++ievt) {
    cout << "Event: " << ievt << endl;

    // call top function
    processB(ievt, bx_o, memoryAB[ievt%2], memoryBC[ievt%2], nent_i, nent_o);
    //topfunction(ievt, bx_o, inarray1[ievt%2], inarray2[ievt%2], outarray[ievt%2]);

    // verify output
    for (int i = 0; i<16; ++i) {
      if (memoryBC[ievt%2][i] != refarray1[ievt%2][i])
      {
        err++;
        cout << "memoryBC[ievt%2][i]: " << memoryBC[ievt%2][i] << "\t";
        cout << "refarray1[ievt%2][i]: " << refarray1[ievt%2][i] << endl;
      }
    }
    for (int i = 0; i < bx_o; i++) {
      if (nent_i[i%2] != nent_o[i%2]) err++;
      std::cout << nent_i[i] << "\t" << nent_o[i] << std::endl;
    }
  }

  return err;
}

