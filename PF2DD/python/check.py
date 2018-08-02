#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: chaomy
# @Date:   2018-02-15 23:23:55
# @Last Modified by:   chaomy
# @Last Modified time: 2018-02-18 23:28:53

import plt_drv
import numpy as np
from scipy.optimize import minimize


class plttool(plt_drv.plt_drv):

    def __init__(self):
        plt_drv.plt_drv.__init__(self)
        self.loaddata()

    def loaddata(self):
        self.sz = (200, 200)
        self.dx = 0.5
        self.dy = 0.5
        sz = self.sz

        data = np.loadtxt("mesh.txt")

        self.X, self.Y, self.Z = data[:, 0].reshape(sz), data[:, 1].reshape(sz), data[
            :, 2].reshape(sz)

        self.meshs = []
        for i in range(self.sz[0]):
            for j in range(self.sz[1]):
                self.meshs.append(
                    np.mat([self.X[i][j], self.Y[i][j]]).transpose())

    def plt1(self, mu=np.mat([20, 20]).transpose(), L=np.mat([[2., 0.0], [3, 5]])):
        X, Y, Z = dx * self.X, dy * self.Y, self.Z

        self.set_111plt((15, 15))
        cs = self.ax.contour(X, Y, Z)
        self.ax.clabel(cs, inline=0.1, lw=5, fontsize=6)

        sigma = L * L.transpose()
        invsig = np.linalg.inv(sigma)
        print("sigma is", sigma)

        err = 0
        F = np.ndarray(Z.shape)
        for i in range(self.sz[0]):
            for j in range(self.sz[1]):
                ps = np.mat([X[i][j], Y[i][j]]).transpose()
                F[i][j] = np.exp(-(ps - mu).transpose() * invsig * (ps - mu))
                err += (F[i][j] - Z[i][j])**2

        self.ax.clabel(self.ax.contour(X, Y, F), inline=0.1, lw=8, fontsize=6)
        self.fig.savefig("fig_save.png", **self.figsave)
        print err

    def fit(self):
        m1 = np.mat([20, 20]).transpose()
        L1 = np.mat([[2., 0.0], [4, 5]])

        m1[0], m1[1] = 19.9986, 24.1854
        L1[0, 0], L1[1, 0], L1[1, 1] = 5.19478, -0.000770632, 9.66477

        print("m1 ", m1)
        self.plt1(m1, L1)

    def check(self):
        X, Y, Z = self.dx * self.X, self.dy * self.Y, self.Z
        dat = np.loadtxt("precmat.txt")

        self.set_111plt((15, 15))
        cs = self.ax.contour(X, Y, Z)
        self.ax.clabel(cs, inline=0.1, lw=5, fontsize=6)
        self.fig.savefig("fig_PF.png", **self.figsave)

        self.set_111plt((15, 15))

        for row in dat:
            mu = np.mat([row[0], row[1]]).transpose()
            L = np.mat([[row[2], row[3]], [row[4], row[5]]])

            sigma = L * L.transpose()
            invsig = np.linalg.inv(sigma)
            print sigma

            F = np.ndarray(Z.shape)
            for i in range(self.sz[0]):
                for j in range(self.sz[1]):
                    ps = np.mat([X[i][j], Y[i][j]]).transpose()
                    F[i][j] = np.exp(-(ps - mu).transpose()
                                     * invsig * (ps - mu))

            self.ax.clabel(self.ax.contour(X, Y, F),
                           inline=0.1, lw=8, fontsize=6)
        self.fig.savefig("fig_DD.png", **self.figsave)

    def convt2DD(self):
        X, Y, Z = self.dx * self.X, self.dy * self.Y, self.Z
        dat = np.loadtxt("precmat.txt")
        for row in dat:
            mu = np.mat([row[0], row[1]]).transpose()
            L = np.mat([[row[2], row[3]], [row[4], row[5]]])

            (U, S, V) = np.linalg.svd(L * L.transpose())
            print np.sqrt(S)

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

    def plt(self, m1, L1, m2, L2):
        X, Y, Z = self.X, self.Y, self.Z
        self.set_111plt((15, 15))
        cs = self.ax.contour(X, Y, Z)
        self.ax.clabel(cs, inline=0.1, lw=5, fontsize=6)

        invs1 = np.linalg.inv(L1.transpose() * L1)
        invs2 = np.linalg.inv(L2.transpose() * L2)

        print invs1
        print invs2

        cnt = 0
        F1 = np.zeros(Z.shape)
        for i in range(self.sz[0]):
            for j in range(self.sz[1]):
                ps = self.meshs[cnt]
                F1[i][j] = np.exp(-(ps - m1).transpose() * invs1 * (ps - m1))
                cnt += 1
        self.ax.clabel(self.ax.contour(X, Y, F1), inline=0.1, lw=8, fontsize=6)

        cnt = 0
        F2 = np.zeros(Z.shape)
        for i in range(self.sz[0]):
            for j in range(self.sz[1]):
                ps = self.meshs[cnt]
                F2[i][j] = np.exp(-(ps - m2).transpose() * invs2 * (ps - m2))
                cnt += 1
        self.ax.clabel(self.ax.contour(X, Y, F2), inline=0.1, lw=8, fontsize=6)

        self.fig.savefig("fig_save.png", **self.figsave)

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

if __name__ == '__main__':
    drv = plttool()
    # drv.plt()
    # drv.fit()
    # drv.check()
    drv.convt2DD()
