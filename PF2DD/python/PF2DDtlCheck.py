#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: chaomy
# @Date:   2018-02-15 23:23:55
# @Last Modified by:   chaomy
# @Last Modified time: 2018-03-11 13:17:52

import numpy as np


class PF2DDtlCheck(object):

    def check(self):
        dat = np.loadtxt("precmat.txt")
        print dat
        x = np.linspace(-100, 100, 500)
        y = np.linspace(-100, 100, 500)
        X, Y = np.meshgrid(x, x)

        for k in range(4, 5):
            self.set_111plt((15, 15))
            row = dat[k]
            L = np.mat([[row[2], row[3]], [row[4], row[5]]])
            sigma = L * L.transpose()
            invsig = np.linalg.inv(sigma)

            F = np.ndarray([len(x), len(y)])
            for i in range(len(x)):
                for j in range(len(y)):
                    ps = np.mat([x[i], y[j]]).transpose()
                    F[i][j] = np.exp(-(ps).transpose() * invsig * (ps))
            self.ax.clabel(self.ax.contour(X, Y, F),
                           inline=0.1, lw=8, fontsize=6)
            self.fig.savefig("fig_{:03d}.png".format(k), **self.figsave)

    def check_full(self):
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
