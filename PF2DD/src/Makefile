# make PFunction src

PFTOOLS   = /Users/chaomingyang/src/PRISM/IntegrationTools
CINCLUDE  = -I${PFTOOLS}/include -I../include

CXX       =  g++
CPPFLAGS +=  -Wall -O3 -std=c++11
CDLINK    =  -lm -lnlopt -larmadillo -framework Accelerate

SRCS = ./PF2DD2D.cpp \
	   ./PF2DDOpt.cpp \
	   ./PF2DDErr.cpp \
	   ./PF2DDCMAES.cpp \
	   ./PF2DDIn.cpp \
	   ./PF2DDOut.cpp \
	   ./PF2DDMain.cpp

MAKETARGET 	=  pf2dd.exe


OBJECTS := $(subst .cpp,.o,${SRCS})

CC = ${CXX}

%.o: %.cpp
	${CC} -c  $<  ${CINCLUDE} ${CPPFLAGS}  #

${MAKETARGET}:$(OBJECTS)


all: ${MAKETARGET}
	${CC}  -o  ${MAKETARGET}  ${OBJECTS}  ${CDLINK}  ${CPPFLAGS}

clean:
	rm -f *.o