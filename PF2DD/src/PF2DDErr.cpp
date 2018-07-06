/*
 * @Author: chaomingyang
 * @Date:   2018-02-17 15:46:58
 * @Last Modified by:   chaomy
 * @Last Modified time: 2018-07-05 23:00:55
 */

#include "PF2DD2D.hpp"
using arma::endr;

/***************************************************
 * cost function in the routine using nlopt
 ***************************************************/
double PF2DD2D::errFunct(const vector<double> &x) {
  PRCGroup &pcg = pcgs[optid];
  double err = 0;
  pcg.mus.clear();
  pcg.Ls.clear();
  vector<arma::mat> &mus = pcg.mus;
  vector<arma::mat> &Ls = pcg.Ls;

  vector<double> dters(pcg.np);
  for (int i = 0; i < pcg.np; i++) {
    int cn = 5 * i;
    arma::mat mu(2, 0);
    mu << x[cn++] << endr << x[cn++] << endr;
    mus.push_back(mu);
    arma::mat L(2, 2);
    L << x[cn++] << 0.0 << endr << x[cn++] << x[cn++] << endr;
    Ls.push_back(L);
    dters[i] = arma::det(L);
  }

  for (int i = 0; i < pcg.xy.size(); i++) {
    arma::mat ps(2, 0);
    ps << pcg.xy[i][0] << endr << pcg.xy[i][1] << endr;
    double tm = 0;
    for (int j = 0; j < pcg.np; j++)
      tm += std::exp(-as_scalar((ps - mus[j]).t() *
                                arma::inv(Ls[j] * Ls[j].t()) * (ps - mus[j])));
    err += square11(tm / float(pcg.np) - pcg.z[i]);
  }
  // in case one becomes too small  0.1
  for (double ee : dters) err += 0.1 * (square11(1. / ee));
  return err;
}

/***************************************************
 * cost function that only applies to sphere
 ***************************************************/
double PF2DD2D::errFunctSphere(const vector<double> &x) {
  PRCGroup &pcg = pcgs[optid];
  double err = 0;

  pcg.mus.clear();
  pcg.Ls.clear();
  vector<arma::mat> &mus = pcg.mus;
  vector<arma::mat> &Ls = pcg.Ls;

  vector<double> dters(pcg.np);
  for (int i = 0; i < pcg.np; i++) {
    int cn = 4 * i;
    arma::mat mu(2, 0);
    mu << x[cn++] << endr << x[cn++] << endr;
    mus.push_back(mu);

    arma::mat L(2, 2);
    L << x[cn++] << 0.0 << endr << 0.0 << x[cn++] << endr;
    Ls.push_back(L);
    dters[i] = arma::det(L);
  }

  for (int i = 0; i < pcg.xy.size(); i++) {
    arma::mat ps(2, 0);
    ps << pcg.xy[i][0] << endr << pcg.xy[i][1] << endr;
    double tm = 0;
    for (int j = 0; j < pcg.np; j++)
      tm += std::exp(-as_scalar((ps - mus[j]).t() *
                                arma::inv(Ls[j] * Ls[j].t()) * (ps - mus[j])));
    err += square11(tm / float(pcg.np) - pcg.z[i]);
  }
  // in case one becomes too small
  for (double ee : dters) err += 0.01 * (square11(1. / ee));
  return err;
}

/***************************************************
 * cost function that applies to fixed center
 ***************************************************/
double PF2DD2D::errFunctFixCenter(const vector<double> &x) {
  PRCGroup &pcg = pcgs[optid];
  pcg.mus.clear();
  pcg.Ls.clear();
  vector<arma::mat> &mus = pcg.mus;
  vector<arma::mat> &Ls = pcg.Ls;

  vector<double> dters(pcg.np);
  double err = 0, farea = 0.0;

  for (int i = 0; i < pcg.np; i++) {
    int cn = nvars * i;
    arma::mat mu(2, 0);
    mu << pcg.center[0] << endr << pcg.center[1] << endr;
    mus.push_back(mu);
    arma::mat L(2, 2);
    L << x[cn++] << x[cn++] << endr << x[cn++] << x[cn++] << endr;
    Ls.push_back(L);
    dters[i] = arma::det(L);
  }

  for (int i = 0; i < pcg.xy.size(); i++) {
    arma::mat ps(2, 0);
    ps << pcg.xy[i][0] << endr << pcg.xy[i][1] << endr;
    double tm = 0;
    for (int j = 0; j < pcg.np; j++)
      tm += std::exp(-as_scalar((ps - mus[j]).t() *
                                arma::inv(Ls[j] * Ls[j].t()) * (ps - mus[j])));
    err += square11(tm * GAU2D / float(pcg.np) - pcg.z[i]);
  }

  for (double ee : dters) farea += ee * ee;
  err += 0.03 * square11(farea - pcg.area);
  return err;
}

/***************************************************
 * unfinished, calculate gradients for certain algorithm
 ***************************************************/
double PF2DD2D::errFunctGrad(const vector<double> &x, vector<double> &g) {
  return 0;
}