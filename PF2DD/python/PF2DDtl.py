#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: chaomy
# @Date:   2018-02-15 23:23:55
# @Last Modified by:   chaomy
# @Last Modified time: 2018-03-11 12:35:42


import plt_drv
import numpy as np
from PF2DDtlFit import PF2DDtlFit
from PF2DDtlPlot import PF2DDtlPlot
from PF2DDtlConvt import PF2DDtlConvt
from PF2DDtlCheck import PF2DDtlCheck
from optparse import OptionParser


class PF2DDtl(plt_drv.plt_drv,
              PF2DDtlPlot,
              PF2DDtlConvt,
              PF2DDtlCheck,
              PF2DDtlFit):

    def __init__(self):
        plt_drv.plt_drv.__init__(self)

    def loaddata(self):
        size = 3200
        self.sz = (size, size)
        # self.dx = 0.5
        # self.dy = 0.5
        sz = self.sz
        data = np.loadtxt("mesh.txt")
        self.X, self.Y, self.Z = data[:, 0].reshape(sz), data[:, 1].reshape(sz), data[
            :, 2].reshape(sz)
        self.meshs = []
        for i in range(self.sz[0]):
            for j in range(self.sz[1]):
                self.meshs.append(
                    np.mat([self.X[i][j], self.Y[i][j]]).transpose())

if __name__ == '__main__':
    usage = "usage:%prog [options] arg1 [options] arg2"
    parser = OptionParser(usage=usage)
    parser.add_option('-t', "--mtype", action="store",
                      type="string", dest="mtype")
    parser.add_option('-p', "--param", action="store",
                      type='string', dest="fargs")

    (options, args) = parser.parse_args()
    drv = PF2DDtl()
    dispatcher = {'plt': drv.plt1,
                  'fit': drv.fit,
                  'chk': drv.check,
                  'cnv': drv.convt2DD}

    if options.fargs is not None:
        dispatcher[options.mtype.lower()](options.fargs)
    else:
        dispatcher[options.mtype.lower()]()
