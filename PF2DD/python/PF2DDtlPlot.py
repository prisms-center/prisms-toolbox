#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: chaomy
# @Date:   2018-02-15 23:23:55
# @Last Modified by:   chaomy
# @Last Modified time: 2018-03-06 15:54:43

import numpy as np


class PF2DDtlPlot(object):

    def plt1(self, mu=np.mat([20, 20]).transpose(), L=np.mat([[2., 0.0], [3, 5]])):
        X, Y, Z = self.X, self.Y, self.Z
        self.set_111plt((15, 15))
        cs = self.ax.contour(X, Y, Z)
        self.ax.clabel(cs, inline=0.1, lw=5, fontsize=6)
        self.fig.savefig("fig_org.png", **self.figsave)

        self.set_111plt((15, 15))
        sz = self.sz
        data = np.loadtxt("fit.txt")
        data[:, 2][np.where(data[:, 2] > 1.0)[0]] = 1.0
        X, Y, Z = data[:, 0].reshape(sz), data[:, 1].reshape(sz), data[
            :, 2].reshape(sz)
        cs = self.ax.contour(X, Y, Z)
        self.ax.clabel(cs, inline=0.1, lw=5, fontsize=6)
        self.fig.savefig("fig_fit.png", **self.figsave)

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
