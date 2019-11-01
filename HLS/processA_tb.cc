#include "processA.hh"
#include <algorithm>
#define WIDTH1 32
#define WIDTH2 64

int main()
{
  using namespace std;

  // error count
  int err = 0;

  // input array;
  int inarray1[2][16] = {{2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53},
                            {3,4,6,8,12,14,18,20,24,30,32,38,42,44,48,54}};
  int inarray2[2][16] = {{1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31},
                           {2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32}};
  // output array
  int memoryAB[2][16];
  int memoryAC[4][16];

  // reference array
  int refarray1[2][16] = {{2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53},
                            {3,4,6,8,12,14,18,20,24,30,32,38,42,44,48,54}};
  int refarray2[2][16] = {{2,6,10,14,18,22,26,30,34,38,42,46,50,54,58,62},
                           {4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64}};
  ap_uint<5> nent_i1[4] = {16,16,16,16};
  ap_uint<5> nent_o1[4] = {0,0,0,0};
  ap_uint<5> nent_i2[4] = {16,16,16,16};
  ap_uint<5> nent_o2[4] = {0,0,0,0};

  ap_uint<2> bx_o;

  cout << "Start event loop" << endl;
  for (unsigned int ievt = 0; ievt < 5; ++ievt) {
    cout << "Event: " << ievt << endl;

    // call top function
    processA(ievt, bx_o, inarray1[ievt%2], inarray2[ievt%2], memoryAB[ievt%2], memoryAC[ievt%4], nent_i1, nent_o1, nent_i2, nent_o2);
    //topfunction(ievt, bx_o, inarray1[ievt%2], inarray2[ievt%2], outarray[ievt%2]);

    // verify output
    for (int i = 0; i<16; ++i) {
      if(ievt%2==0 && i>=nent_i1[0]) continue;
      if (memoryAB[ievt%2][i] != refarray1[ievt%2][i]) { err++;
      std::cout << memoryAB[ievt%2][i] << "\t" << refarray1[ievt%2][i] << std::endl;
      }
      if (memoryAC[ievt%4][i] != refarray2[ievt%2][i]) { err++;
      std::cout << memoryAC[ievt%2][i] << "\t" << refarray2[ievt%2][i] << std::endl;
      }
    }
    for (int i = 0; i < bx_o; i++) {
      if (nent_i1[i] != nent_o1[i]) err++;
      if (nent_i2[i] != nent_o2[i]) err++;
      //std::cout << bx_o << std::endl;
      //std::cout << nent_i2[i] << "\t" << nent_o2[i] << std::endl;
    }
  }

  return err;
}

