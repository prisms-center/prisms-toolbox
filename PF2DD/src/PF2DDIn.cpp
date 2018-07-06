/*
 * @Author: chaomy
 * @Date:   2018-03-08 21:34:47
 * @Last Modified by:   chaomy
 * @Last Modified time: 2018-07-05 22:57:11
 */

#include "PF2DD.hpp"
#include "PF2DD2D.hpp"

/***************************************************
 * read precipiate matrix file precmat.txt
 ***************************************************/
void PF2DD2D::loadmtx() {
  ifstream ifs("precmat.txt", std::ifstream::in);
  string buff;
  pcgs.clear();
  int cn = 0;
  while (getline(ifs, buff)) {
    PRCGroup pcg;
    arma::mat L(2, 2);
    arma::vec mu(2);
    sscanf(buff.c_str(), "%lf %lf %lf %lf %lf %lf", &mu(0), &mu(1), &L(0, 0),
           &L(0, 1), &L(1, 0), &L(1, 1));
    pcg.Ls.push_back(L);
    pcg.mus.push_back(mu);
    pcgs.push_back(pcg);
  }
  ifs.close();
}

/***************************************************
 * load .txt data file
 ***************************************************/
void PF2DD2D::loadtxt() {
  ifstream ifs("mesh.txt", std::ifstream::in);
  string buff;
  int tx, ty;
  double tz;
  dx = 1600. / nx;
  dy = 1600. / ny;
  dxy = dx * dy;
  while (getline(ifs, buff)) {
    sscanf(buff.c_str(), "%d %d %lf", &tx, &ty, &tz);
    zz[tx][ty] = tz;
  }
  ifs.close();
}

/***************************************************
 * load phaseField vtk file
 ***************************************************/
void PF2DD2D::loadvtk() {
  typedef PRISMS::PField<double *, double, 2> ScalarField2D;
  typedef PRISMS::Body<double *, 2> Body2D;

  double tmp[2];
  Body2D body;

  // body.read_vtk("../test/test_nonuniform.vtk");
  // ScalarField2D &conc = body.find_scalar_field("n");
  // body.read_vtk("../test/B1_032_3p0h.vtk");
  body.read_vtk("../test/B1_032_1p5h.vtk");
  ScalarField2D &conc = body.find_scalar_field("sum_n");

  ofstream ofs("mesh.txt", std::ofstream::out);
  dx = (body.mesh.max(0) - body.mesh.min(0)) / (nx);
  dy = (body.mesh.max(1) - body.mesh.min(1)) / (ny);
  dxy = dx * dy;

  for (int i = 0; i < nx; i++) {
    for (int j = 0; j < ny; j++) {
      double coord[2];
      coord[0] = dx * i;
      coord[1] = dy * j;
      zz[i][j] = conc(coord);
      ofs << setprecision(4) << i << " " << j << " " << zz[i][j] << endl;
    }
  }
  ofs.close();
}