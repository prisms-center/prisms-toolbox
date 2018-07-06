#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: chaomy
# @Date:   2018-02-15 23:23:55
# @Last Modified by:   chaomy
# @Last Modified time: 2018-03-11 14:29:38

import numpy as np
import gn_dd_data_dat as dddat


class PF2DDtlConvt(object):

    def convt2DD(self, dm=2):
        if dm in [2]:
            self.convt2DD2D()

    def convt2DD2D(self):
        X, Y, Z = self.dx * self.X, self.dy * self.Y, self.Z
        dat = np.loadtxt("precmat.txt")
        self.precs = []
        pcid = 1
        side = 2e3
        ratio = 2 * side / 1e2

        for row in dat:
            mu = np.mat([row[0], row[1]]).transpose()
            L = np.mat([[row[2], row[3]], [row[4], row[5]]])

            (U, S, V) = np.linalg.svd(L * L.transpose())
            S = 1.1 * np.sqrt(S)
            print S

            A = np.identity(3)
            A[:2, :2] = U

            S *= ratio
            mu = mu * ratio - side

            prec = dddat.prec()
            prec.precid = pcid
            prec.coords = np.array([mu[0, 0], mu[1, 0], 0.0])
            prec.dimaxi = np.array([S[0], S[1], 200])

            prec.rotate = A
            prec.strain = np.zeros(6)
            pcid += 1

            self.precs.append(prec)
        fid = self.write_precip_header()
        self.write_precip_data(fid)

    def write_precip_header(self):
        fid = open("prec.dat", 'w')
        fid.write(dddat.precfile_header)
        return fid

    def write_precip_data(self, fid):
        strformat = '{} ' + '{:4.3f} ' * 6
        strformat += '{:8.7f} ' * 6
        strformat += '{:1.1f} ' * 6
        strformat += '\n'
        for prec in self.precs:
            line = strformat.format(
                prec.precid,
                prec.coords[0], prec.coords[1], prec.coords[2],
                prec.dimaxi[0], prec.dimaxi[1], prec.dimaxi[2],
                prec.rotate[0, 0], prec.rotate[0, 1],
                prec.rotate[0, 2], prec.rotate[1, 0],
                prec.rotate[1, 1], prec.rotate[1, 2],
                prec.strain[0], prec.strain[1],
                prec.strain[2], prec.strain[3],
                prec.strain[4], prec.strain[5])
            fid.write(line)
        fid.close()
