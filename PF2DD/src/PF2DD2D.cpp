/*
 * @Author: chaomy
 * @Date:   2018-02-17 13:49:33
 * @Last Modified by:   chaomy
 * @Last Modified time: 2018-07-05 23:15:49
 */

#include "PF2DD2D.hpp"
#include "PF2DD.hpp"

using arma::as_scalar;
using arma::endr;

/***************************************************
 * find all precipitates in the configuration
 ***************************************************/
void PF2DD2D::findPrecs() {  // do a breath first search to find precipitates
  int cn = 0;
  for (int i = 0; i < nx; i++) {
    for (int j = 0; j < ny; j++) {
      if (zz[i][j] > zrng[0]) {
        PRCGroup pcg;
        bfs(i, j, pcg);
        cn++;
        pcgs.push_back(pcg);
      }
    }
  }
  for (PRCGroup &pcg : pcgs) calMean(pcg);
  cout << "we have " << cn << " precipitate groups" << endl;
}

/***************************************************
 * breath first search to find whole precipiates
 ***************************************************/
void PF2DD2D::bfs(int i, int j, PRCGroup &pcg) {
  if (zz[i][j] >= zrng[0]) {
    pcg.area += 1;
    if (zz[i][j] <= zrng[1]) {
      pcg.xy.push_back(vector<double>({i * dx, j * dy}));
      pcg.z.push_back(zz[i][j]);
    }
  }
  zz[i][j] = 0;
  if ((i - 1 >= 0) && zz[i - 1][j] > zrng[0]) bfs(i - 1, j, pcg);
  if ((i + 1 < nx) && zz[i + 1][j] > zrng[0]) bfs(i + 1, j, pcg);
  if ((j - 1 >= 0) && zz[i][j - 1] > zrng[0]) bfs(i, j - 1, pcg);
  if ((j + 1 < ny) && zz[i][j + 1] > zrng[0]) bfs(i, j + 1, pcg);
}

/***************************************************
 * try different inital positions to fit 2D ellipse
 ***************************************************/
void PF2DD2D::fitEllipTestInit() {
  double a = 2, b = 5, c = 8;
  vector<vector<double>> inits({{4.5, 4.5, 4.5, 4.5}});
  // vector<vector<double>> inits({{a, b, c}, {b, c, a}, {c, a, b}, {b, a, c},
  // {a, c, b}, {c, b, a}});
  for (int k = 0; k < pcgs.size(); k++) {
    // for (int k = 0; k < 3; k++) {
    PRCGroup &pcg = pcgs[optid = k];
    vector<double> erv(inits.size());
    vector<arma::mat> optmus;
    vector<arma::mat> optLs;

    int mid = 0;
    for (int j = 0; j < inits.size(); j++) {
      cout << "err " << (erv[j] = (this->*drvopt[sparams["ptype"]])(inits[j]))
           << endl;
      if (erv[j] <= erv[mid]) {
        mid = j;
        optmus = pcg.mus;
        optLs = pcg.Ls;
      }
    }
    cout << "opt err " << mid + 1 << " = " << erv[mid] << endl;
    pcg.mus = optmus;
    pcg.Ls = optLs;
  }
}

/***************************************************
 * execute fitting 2D ellipse shape
 ***************************************************/
void PF2DD2D::fitEllip() {
  for (int k = 4; k < 5; k++) {
    PRCGroup &pcg = pcgs[optid = k];
    vector<double> erv(nt);
    vector<arma::mat> optmus;
    vector<arma::mat> optLs;
    int mid = 0;
    for (int j = 0; j < nt; j++) {
      pcg.np = j + 1;
      erv[j] = (this->*drvopt[sparams["ptype"]])(vector<double>({4, 5, 6}));
      if (erv[j] <= erv[mid]) {
        mid = j;
        optmus = pcg.mus;
        optLs = pcg.Ls;
      }
    }
    cout << "err " << mid + 1 << " = " << erv[mid] << endl;
    pcg.np = mid + 1;
    pcg.mus = optmus;
    pcg.Ls = optLs;
    optid++;  // go to next precipitate group
  }
}

/***************************************************
 * calculate the mean position of a precipiates
 ***************************************************/
void PF2DD2D::calMean(PRCGroup &pcg) {
  vector<double> &mu = pcg.center;
  int npts = pcg.xy.size();
  for (int i = 0; i < npts; i++) {
    mu[0] += pcg.xy[i][0];
    mu[1] += pcg.xy[i][1];
    pcg.xbd[0] = std::min(pcg.xbd[0], pcg.xy[i][0]);
    pcg.xbd[1] = std::max(pcg.xbd[1], pcg.xy[i][0]);
    pcg.ybd[0] = std::min(pcg.ybd[0], pcg.xy[i][1]);
    pcg.ybd[1] = std::max(pcg.ybd[1], pcg.xy[i][1]);
  }
  mu[0] /= npts;
  mu[1] /= npts;
  cout << setprecision(3) << "mean " << mu[0] << " " << mu[1] << endl;
  cout << setprecision(3) << "x [" << pcg.xbd[0] << " " << pcg.xbd[1] << "]"
       << " y [" << pcg.ybd[0] << " " << pcg.ybd[1] << "]" << endl;
}