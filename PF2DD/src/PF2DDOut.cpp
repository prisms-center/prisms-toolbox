/*
 * @Author: chaomy
 * @Date:   2018-03-08 21:35:48
 * @Last Modified by:   chaomy
 * @Last Modified time: 2018-07-05 22:54:35
 */

#include "PF2DD2D.hpp"
using arma::as_scalar;
using arma::endr;

/***************************************************
 * write Contour .txt file for visulization
 ***************************************************/
void PF2DD2D::outContour() {
  ofstream ofs("fit.txt", std::ofstream::out);
  for (int m = 0; m < nx; m++) {
    for (int n = 0; n < ny; n++) {
      arma::mat ps(2, 0);
      ps << m * dx << endr << n * dy << endr;
      double tm = 0.0;
      for (PRCGroup &pcg : pcgs)
        for (int i = 0; i < pcg.np; i++)
          tm += std::exp(-as_scalar((ps - pcg.mus[i]).t() *
                                    arma::inv(pcg.Ls[i] * pcg.Ls[i].t()) *
                                    (ps - pcg.mus[i])));
      ofs << setprecision(8) << m << " " << n << " " << GAU2D * tm << endl;
    }
  }
  ofs.close();
}

/***************************************************
 * write precmat.txt to save rotation matrix and length
 ***************************************************/
void PF2DD2D::outMatrix() {
  ofstream ofs("precmat.txt", std::ofstream::out);
  for (int k = 0; k < pcgs.size(); k++) {
    // for (int k = 0; k < 3; k++) {
    PRCGroup &pcg = pcgs[k];
    for (int i = 0; i < pcg.np; i++)
      ofs << pcg.mus[i][0] << " " << pcg.mus[i][1] << " " << pcg.Ls[i](0, 0)
          << " " << pcg.Ls[i](0, 1) << " " << pcg.Ls[i](1, 0) << " "
          << pcg.Ls[i](1, 1) << endl;
  }
  ofs.close();
}

/***************************************************
 * write Paradis prec.dat without Periodicity
 ***************************************************/
void PF2DD2D::outParadisDat() {  // finish
  ofstream ofs("prec.dat", std::ofstream::out);
  arma::mat U, V;
  arma::vec s;
  int cn = 1;
  double ratio = 1. / 0.32;
  double shift = 800;
  for (int k = 0; k < pcgs.size(); k++) {
    // for (int k = 0; k < 3; k++) {
    PRCGroup &pcg = pcgs[k];
    for (int i = 0; i < pcg.np; i++) {
      pcg.mus[i] = ratio * (pcg.mus[i] - shift);
      arma::svd(U, s, V, pcg.Ls[i] * pcg.Ls[i].t());
      U.print("U");
      V.print("V");
      s = 1.0 * arma::sqrt(s) * ratio;
      ofs << cn++ << " ";
      ofs << pcg.mus[i][0] << " " << pcg.mus[i][1] << " " << 0.0 << " ";
      ofs << s[0] << " " << s[1] << " " << 200 << " ";
      ofs << U(1, 0) << " " << U(1, 1) << " " << 0.0 << " ";
      ofs << U(0, 0) << " " << U(0, 1) << " " << 0.0 << " ";
      ofs << 0.0 << " " << 0.0 << " " << 0.0 << " " << 0.0 << " " << 0.0 << " "
          << 0.0 << endl;
    }
  }
  ofs.close();
}

/***************************************************
 * write Paradis prec.dat with Periodicity
 ***************************************************/
void PF2DD2D::outParadisDatPeriodic() {
  ofstream ofs("prec.dat", std::ofstream::out);
  arma::mat U, V;
  arma::vec s;
  int cn = 1;
  double ratio = 1. / 0.32;
  double shift = 800 * ratio;
  double side = 1200 * ratio;
  int pid = 0;
  for (int k = 0; k < pcgs.size(); k++) {
    PRCGroup &pcg = pcgs[k];
    for (int i = 0; i < pcg.np; i++) {
      pcg.mus[i] = ratio * pcg.mus[i] - shift;
      arma::svd(U, s, V, pcg.Ls[i] * pcg.Ls[i].t());
      U.print("U");
      V.print("V");
      s = 1.0 * arma::sqrt(s) * ratio;

      ofs << cn++ << " ";
      ofs << pcg.mus[i][0] << " " << pcg.mus[i][1] << " " << 0.0 << " ";
      ofs << s[0] << " " << s[1] << " " << 200 << " ";
      ofs << U(1, 0) << " " << U(1, 1) << " " << 0.0 << " ";
      ofs << U(0, 0) << " " << U(0, 1) << " " << 0.0 << " ";
      ofs << 0.0 << " " << 0.0 << " " << 0.0 << " " << 0.0 << " " << 0.0 << " "
          << 0.0 << endl;
      if (pcg.mus[i][0] + 2 * shift < side) {
        ofs << cn++ << " ";
        ofs << pcg.mus[i][0] + 2 * shift << " " << pcg.mus[i][1] << " " << 0.0
            << " ";
        ofs << s[0] << " " << s[1] << " " << 200 << " ";
        ofs << U(1, 0) << " " << U(1, 1) << " " << 0.0 << " ";
        ofs << U(0, 0) << " " << U(0, 1) << " " << 0.0 << " ";
        ofs << 0.0 << " " << 0.0 << " " << 0.0 << " " << 0.0 << " " << 0.0
            << " " << 0.0 << endl;
      } else if (pcg.mus[i][0] - 2 * shift > -side) {
        ofs << cn++ << " ";
        ofs << pcg.mus[i][0] - 2 * shift << " " << pcg.mus[i][1] << " " << 0.0
            << " ";
        ofs << s[0] << " " << s[1] << " " << 200 << " ";
        ofs << U(1, 0) << " " << U(1, 1) << " " << 0.0 << " ";
        ofs << U(0, 0) << " " << U(0, 1) << " " << 0.0 << " ";
        ofs << 0.0 << " " << 0.0 << " " << 0.0 << " " << 0.0 << " " << 0.0
            << " " << 0.0 << endl;
      }
    }
  }
  ofs.close();
}
