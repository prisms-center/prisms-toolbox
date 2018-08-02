#ifndef PF2DD2D_H_
#define PF2DD2D_H_

/*
 * transform phase field vtk code to paradis inputs 2D case
 */

#include "PF2DD.hpp"

using arma::mat;
using std::cout;
using std::endl;
using std::ofstream;
using std::setprecision;
using std::vector;

class PRCGroup {
 public:
  int np;
  double area;
  vector<double> center;
  vector<double> xbd;
  vector<double> ybd;
  vector<arma::mat> mus;  // np x 2
  vector<arma::mat> Ls;   // np x 4 [0, 0] [0, 1] [1, 0] [1, 1]
  vector<vector<double>> xy;
  vector<double> z;
  PRCGroup()
      : np(1),
        center(vector<double>(2, 0)),
        xbd(vector<double>({1e30, -1e30})),
        ybd(vector<double>({1e30, -1e30})){};
};

class PF2DD2D : public PF2DD {
 private:
  int optid;
  int nx, ny;
  int nt;  // use how many ellip to fit
  int nvars;
  double dx, dy, dxy;

  unordered_map<string, string> sparams;
  unordered_map<string, double (PF2DD2D::*)(const vector<double> &x)> calobj;
  unordered_map<string, double (PF2DD2D::*)(const vector<double> &x)> drvopt;

  vector<vector<double>> zz;
  vector<PRCGroup> pcgs;

  vector<double> zrng;
  vector<double> ini;
  vector<double> lob;
  vector<double> hib;
  vector<double> deb;

 public:
  PF2DD2D() : nx(3200), ny(3200), nt(1), zrng({1e-4, 0.2}) {
    zz = vector<vector<double>>(nx, vector<double>(ny, 0));
    drvopt["ellip"] = &PF2DD2D::runCMAES;
    drvopt["sphere"] = &PF2DD2D::runCMAESSphere;
    drvopt["fcenter"] = &PF2DD2D::runCMAESFixCenter;
    calobj["ellip"] = &PF2DD2D::errFunct;
    calobj["sphere"] = &PF2DD2D::errFunctSphere;
    calobj["fcenter"] = &PF2DD2D::errFunctFixCenter;
    sparams["ptype"] = string("fcenter");
  };

  void loadmtx();
  void loadvtk();
  void loadtxt();
  void findPrecs();
  void bfs(int i, int j, PRCGroup &pcg);

  void fitEllip();
  void fitEllipTestInit();
  void calMean(PRCGroup &pcg);
  void outContour();
  void outMatrix();
  void outParadisDat();
  void outParadisDatPeriodic();

  void runOpt();
  double runCMAES(const vector<double> &in);
  double runCMAESSphere(const vector<double> &in);
  double runCMAESFixCenter(const vector<double> &in);
  double cmaes(arma::mat &iterate);
  double errFunct(const vector<double> &x);
  double errFunctSphere(const vector<double> &x);
  double errFunctFixCenter(const vector<double> &x);
  double errFunctGrad(const vector<double> &x, vector<double> &g);
  double objectiveFuc(const vector<double> &x, vector<double> &g);

  arma::mat encodev(const vector<double> &vv);
  vector<double> decodestdv(const arma::mat &vv);
};

// // [a, b] -> [0, 10]
// inline arma::mat pfHome::encodev(const arma::mat &vv) {
//   arma::mat rs(nvars, 1);
//   for (int i = 0; i < nvars; i++)
//     rs[i] = 10 * acos(1. - 2. / deb[i] * (vv[i] - lob[i])) * INVPI;
//   return rs;
// }

// [a, b] -> [0, 10]
inline arma::mat PF2DD2D::encodev(const vector<double> &vv) {
  arma::mat rs(nvars, 1);
  for (int i = 0; i < nvars; i++)
    rs[i] = 10 * acos(1. - 2. / deb[i] * (vv[i] - lob[i])) * INVPI;
  return rs;
}

// [0, 10] -> [a, b]  y = a + (b-a) × (1 – cos(π × x / 10)) / 2
inline vector<double> PF2DD2D::decodestdv(const arma::mat &vv) {
  vector<double> rs(vv.size());
  for (int i = 0; i < nvars; i++)
    rs[i] = lob[i] + deb[i] * 0.5 * (1. - cos(PI * 0.1 * vv[i]));
  return rs;
}

  // // [a, b] -> [0, 10]
  // inline vector<double> pfHome::encodestdv(const vector<double> &vv) {
  //   vector<double> rs(vv.size());
  //   for (int i = 0; i < nvars; i++)
  //     rs[i] = 10 * acos(1. - 2. / deb[i] * (vv[i] - lob[i])) * INVPI;
  //   return rs;
  // }

#endif