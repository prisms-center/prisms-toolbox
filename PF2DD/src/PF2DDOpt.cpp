/*
 * @Author: chaomingyang
 * @Date:   2018-02-17 15:46:58
 * @Last Modified by:   chaomy
 * @Last Modified time: 2018-07-05 23:01:30
 */

#include "PF2DD2D.hpp"
using arma::endr;

double objWrapper(const vector<double> &x, vector<double> &g, void *data) {
  PF2DD2D *obj = static_cast<PF2DD2D *>(data);
  return obj->objectiveFuc(x, g);
}

/***************************************************
 * use nlopt for optimization
 ***************************************************/
void PF2DD2D::runOpt() {
  PRCGroup &pcg = pcgs[optid];
  ini.clear();
  lob.clear();
  hib.clear();

  for (int i = 0; i < pcg.np; i++) {
    ini.push_back(pcg.center[0]);
    ini.push_back(0.99 * pcg.center[1] + 0.01 * pcg.ybd[i % 2]);

    lob.push_back(pcg.xbd[0]);
    lob.push_back(pcg.ybd[0]);
    hib.push_back(pcg.xbd[1]);
    hib.push_back(pcg.ybd[1]);

    ini.push_back(1);
    ini.push_back(2);
    ini.push_back(3);

    lob.push_back(1e-5);
    lob.push_back(1e-5);
    lob.push_back(1e-5);
    hib.push_back(pcg.xbd[1]);
    hib.push_back(pcg.xbd[1]);
    hib.push_back(pcg.xbd[1]);
  }

  nlopt::opt *opt = new nlopt::opt(nlopt::LN_SBPLX, ini.size());

  opt->set_min_objective(objWrapper, this);
  opt->set_lower_bounds(lob);
  opt->set_upper_bounds(hib);
  opt->set_xtol_rel(1e-4);
  opt->set_maxeval(1000);

  double minf;
  nlopt::result rs = opt->optimize(ini, minf);
  delete opt;

  for (int i = 0; i < pcg.np; i++) {
    int cn = 5 * i;
    vector<double> mu({ini[cn++], ini[cn++]});

    arma::mat L(2, 2);
    L << ini[cn++] << 0.0 << endr << ini[cn++] << ini[cn++] << endr;
    vector<double> Lv({L(0, 0), L(0, 1), L(1, 0), L(1, 1)});

    cout << "mean " << mu[0] << " " << mu[1] << endl;
    pcg.mus.push_back(mu);
    pcg.Ls.push_back(Lv);
  }
  cout << "err = " << minf << endl;
}

/***************************************************
 * cost function when we use nlopt
 ***************************************************/
double PF2DD2D::objectiveFuc(const vector<double> &x, vector<double> &g) {
  return errFunct(x);
}