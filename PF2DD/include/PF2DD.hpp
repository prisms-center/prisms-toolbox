/*
 * transform phase field vtk code to paradis inputs
 */

#ifndef PF2DD_H_
#define PF2DD_H_

#define PI 3.14159265359
#define GAU2D (1. / 2 * PI)
#define INVPI 0.31830988618
#define SMALL 1e-11

#include <armadillo>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <unordered_map>
#include <vector>
#include "nlopt.hpp"

#include "IntegrationTools/PField.hh"

using std::cout;
using std::endl;
using std::ifstream;
using std::ofstream;
using std::setprecision;
using std::string;
using std::unordered_map;
using std::vector;

class PF2DD {
 public:
  PF2DD(){};
  virtual void loadtxt(){};
  virtual void loadvtk(){};
  virtual void outContour(){};
  virtual void outMatrix(){};
  virtual void outParadisDat(){};
  virtual void findPrecs(){};
  virtual void fitEllip(){};
};

inline double square11(const double& x) { return x * x; }

#endif