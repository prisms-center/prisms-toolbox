/*
 * @Author: chaomy
 * @Date:   2018-02-17 13:51:11
 * @Last Modified by:   chaomy
 * @Last Modified time: 2018-07-05 22:50:27
 */

#include "PF2DD2D.hpp"

/***************************************************
 * main work flow Phase field vtk to Paradis prec.dat
 ***************************************************/
int main(int argc, char* argv[]) {
  PF2DD2D* pt = new PF2DD2D();
  pt->loadvtk();
  pt->loadtxt();
  pt->findPrecs();
  pt->fitEllipTestInit();
  pt->outMatrix();
  pt->loadmtx();
  pt->outParadisDatPeriodic();
  delete pt;
}