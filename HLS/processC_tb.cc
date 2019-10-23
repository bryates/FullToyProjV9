#include "processC.hh"
#include <algorithm>

int main()
{
  using namespace std;

  // error count
  int err = 0;

  // input array;
  //int memoryBC[2][16] = {{2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53},
  int memoryBC[2][16] = {{10,20,30,40,50,60,70,80,90,100},
                            {3,4,6,8,12,14,18,20,24,30,32,38,42,44,48,54}};
  //int memoryAC[4][16] = {{1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,61},
  int memoryAC[4][16] = {{14,16,34,35,54,56,74,76,94,96},
                           {2,4,6,8,10,12,14,16,18,20,22,24,26,28,50,32},
                           {14,16,34,35,54,56,74,76,94,96},
                           //{1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,61},
                           {2,4,6,8,10,12,14,16,18,20,22,24,26,28,50,32}};
  ap_uint<5> nent_i1[4] = {10,16,6,16};
  ap_uint<5> nent_i2[4] = {10,16,10,16};
  ap_uint<5> nent_o[4] = {0,0,0,0};
  // output array
  int outarray1[2][16];

  // reference array
  //int refarray1[2][16] = {{2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,61},
  int refarray1[2][16] = {{14,20,34,40,54,60,74,80,94,100},
                            {3,4,6,8,12,14,18,20,24,30,32,38,42,44,50,54}};

  ap_uint<2> bx_o;

  cout << "Start event loop" << endl;
  for (unsigned int ievt = 0; ievt < 5; ++ievt) {
    cout << "Event: " << ievt << endl;

    // call top function
    processC(ievt, bx_o, memoryBC[ievt%2], memoryAC[ievt%4], outarray1[ievt%2], nent_i1, nent_i2, nent_o);
    //topfunction(ievt, bx_o, inarray1[ievt%2], inarray2[ievt%2], outarray[ievt%2]);

    // verify output
    for (int i = 0; i < nent_o[bx_o]; ++i) {
      //std::cout << memoryBC[ievt%2][i] << "\t" << memoryAC[ievt%4][i] << "\t";
      //std::cout << outarray1[ievt%2][i] << "\t" << refarray1[ievt%2][i] << std::endl;
      if (outarray1[ievt%2][i] != refarray1[ievt%2][i]) { err++;
      //std::cout << memoryBC[ievt%2][i] << "\t" << memoryAC[ievt][i] << std::endl;
      std::cout << outarray1[ievt%2][i] << "\t" << refarray1[ievt%2][i] << std::endl;
      }
    }
  }

  return err;
}

