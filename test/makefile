#  Copyright (c) 1996
#  Rensselaer Polytechnic Institute
# 
#  Permission to use, copy, modify, distribute and sell this software
#  and its documentation for any purpose is hereby granted without fee,
#  provided that the above copyright notice appear in all copies and
#  that both that copyright notice and this permission notice appear
#  in supporting documentation.  Rensselaer Polytechnic Institute makes no
#  representations about the suitability of this software for any
#  purpose.  It is provided "as is" without express or implied warranty.
# 

GNATMAKE=gnatmake
ADA_INCLUDE=-I../SGL
# Debuging flags :-v -gnatv -gnatf #-gnatdc
GFLAGS_OPT=-O3 -gnatn
#GFLAGS=-g
GFLAGS=-g -gnato #-v -gnatv -gnatf -gnatdc

vectors: dummy
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_vectors.adb

lists: dummy
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_lists.adb

algorithms: dummy
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_algorithms.adb

maps: dummy
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_maps.adb

all: dummy
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_vectors.adb
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_lists.adb
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_trees.adb
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_sets.adb
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_maps.adb
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_stacks.adb
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_queues.adb
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_algorithms.adb
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_container_signatures.adb
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_functions.adb
	$(GNATMAKE) $(GFLAGS) $(ADA_INCLUDE) test_iterators.adb
	$(GNATMAKE) $(GFLAGS_OPT) $(ADA_INCLUDE) benchmark.adb

test: all
	./test_vectors
	./test_lists
	./test_trees
	./test_sets
	./test_maps
	./test_stacks
	./test_queues
	./test_algorithms
	./test_container_signatures
	./test_functions
	./test_iterators

clean: dummy
	rm -f *.ali *.o *~ b_*.c test_vectors.exe test_lists.exe test_trees.exe test_sets.exe test_maps.exe test_stacks.exe test_queues.exe test_algorithms.exe test_container_signatures.exe test_functions.exe test_iterators.exe benchmark.exe

dummy:
