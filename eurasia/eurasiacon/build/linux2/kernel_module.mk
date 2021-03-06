# Copyright	2010 Imagination Technologies Limited. All rights reserved.
#
# No part of this software, either material or conceptual may be
# copied or distributed, transmitted, transcribed, stored in a
# retrieval system or translated into any human or computer
# language in any form by any means, electronic, mechanical,
# manual or other-wise, or disclosed to third parties without
# the express written permission of: Imagination Technologies
# Limited, HomePark Industrial Estate, Kings Langley,
# Hertfordshire, WD4 8LZ, UK
#
# $Revision: 1.7 $
# $Log: kernel_module.mk $

# Rules for making kernel modules with kbuild. This makefile doesn't define
# any rules that build the modules, it only copies the kbuild Makefile into
# the right place and then invokes kbuild to do the actual build

$(call target-build-only,kernel module)

MODULE_KBUILD_DIR := $(MODULE_OUT)/kbuild

# $(THIS_MODULE)_makefile names the kbuild makefile fragment used to build
# this module's objects
$(call must-be-nonempty,$(THIS_MODULE)_makefile)
MODULE_KBUILD_MAKEFILE := $($(THIS_MODULE)_makefile)
$(if $(wildcard $(abspath $(MODULE_KBUILD_MAKEFILE))),,$(error In makefile $(THIS_MAKEFILE): Module $(THIS_MODULE) requires kbuild makefile $(MODULE_KBUILD_MAKEFILE), which is missing))

# $(THIS_MODULE)_target specifies the name of the kernel module
$(call must-be-nonempty,$(THIS_MODULE)_target)
MODULE_KBUILD_OBJECTS := $($(THIS_MODULE)_target:.ko=.o)

# Here we could maybe include $(MODULE_KBUILD_MAKEFILE) and look at
# $(MODULE_KBUILD_OBJECTS)-y to see which source files might be built

.PHONY: $(THIS_MODULE)
$(THIS_MODULE): MODULE_KBUILD_MAKEFILE := $(MODULE_KBUILD_MAKEFILE)
$(THIS_MODULE): MODULE_KBUILD_OBJECTS := $(MODULE_KBUILD_OBJECTS)
$(THIS_MODULE):
	@echo "kbuild module '$@'"
	@echo " MODULE_KBUILD_MAKEFILE := $(MODULE_KBUILD_MAKEFILE)"
	@echo " MODULE_KBUILD_OBJECTS := $(MODULE_KBUILD_OBJECTS)"
	@echo ' Being built:' $(if $(filter $@,$(KERNEL_COMPONENTS)),"yes (separate module)",$(if $(filter $@,$(EXTRA_PVRSRVKM_COMPONENTS)),"yes (into pvrsrvkm)","no"))
	@echo "Module $@ is a kbuild module. Run 'make kbuild' to make it"
	@false

ALL_KBUILD_MODULES += $(THIS_MODULE)
INTERNAL_KBUILD_MAKEFILE_FOR_$(THIS_MODULE) := $(MODULE_KBUILD_MAKEFILE)
INTERNAL_KBUILD_OBJECTS_FOR_$(THIS_MODULE) := $(MODULE_KBUILD_OBJECTS)
