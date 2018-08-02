#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: chaomy
# @Date:   2018-02-15 23:23:55
# @Last Modified by:   chaomy
# @Last Modified time: 2018-02-18 21:21:27

import numpy as np
from scipy.optimize import minimize


class PF2DDtlFit(object):

    def fit(self):
        m1 = np.mat([20, 20]).transpose()
        L1 = np.mat([[2., 0.0], [4, 5]])

        m1[0], m1[1] = 19.9986, 24.1854
        L1[0, 0], L1[1, 0], L1[1, 1] = 5.19478, -0.000770632, 9.66477

        print("m1 ", m1)
        self.plt1(m1, L1)
 
    def calerr1(self, xx):
        mu = np.mat([xx[0], xx[1]]).transpose()
        L = np.mat([[xx[2], 0.0], [xx[3], xx[4]]])
        invsig = np.linalg.inv(L * L.transpose())
        err = 0.0
        cnt = 0
        F = np.ndarray(self.Z.shape)
        for i in range(self.sz[0]):
            for j in range(self.sz[1]):
                ps = self.meshs[cnt]
                F[i][j] = np.exp(-(ps - mu).transpose() * invsig * (ps - mu))
                err += (F[i][j] - self.Z[i][j])**2
                cnt += 1
        return err

    def calerr(self, xx):
        m1 = np.mat([xx[0], xx[1]]).transpose()
        L1 = np.mat([[xx[2], 0.0], [xx[3], xx[4]]])

        m2 = np.mat([xx[5], xx[6]]).transpose()
        L2 = np.mat([[xx[7], 0.0], [xx[8], xx[9]]])

        invs1 = np.linalg.inv(L1.transpose() * L1)
        invs2 = np.linalg.inv(L2.transpose() * L2)

        err = 0.0
        cnt = 0

        F = np.zeros(self.Z.shape)
        for i in range(self.sz[0]):
            for j in range(self.sz[1]):
                ps = self.meshs[cnt]
                F[i][j] += np.exp(-(ps - m1).transpose() * invs1 * (ps - m1))
                F[i][j] += np.exp(-(ps - m2).transpose() * invs2 * (ps - m2))
                err += (F[i][j] - self.Z[i][j])**2
                cnt += 1

        print("err is ", err)
        return err
