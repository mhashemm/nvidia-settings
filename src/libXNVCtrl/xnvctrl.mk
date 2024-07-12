# Copyright (c) 2008-2019 NVIDIA, Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice (including the next
# paragraph) shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

##############################################################################
# makefile fragment to define how to build LIBXNVCTRL
##############################################################################

# The calling Makefile may export any of the following variables; we
# assign default values if they are not exported by the caller

ifndef XNVCTRL_LDFLAGS
  XNVCTRL_LDFLAGS := $(shell $(PKG_CONFIG) --libs x11)
endif

ifndef XNVCTRL_CFLAGS
  XNVCTRL_CFLAGS := $(shell $(PKG_CONFIG) --cflags x11)
endif

LIBXNVCTRL = $(OUTPUTDIR)/libXNVCtrl.a

LIBXNVCTRL_SHARED = $(OUTPUTDIR)/libXNVCtrl.so
LIBXNVCTRL_ABI_VERSION_MAJOR = 0
LIBXNVCTRL_ABI_VERSION_MINOR = 0
LIBXNVCTRL_LIBS += -lXext -lX11

LIBXNVCTRL_SRC = $(XNVCTRL_DIR)/NVCtrl.c

LIBXNVCTRL_OBJ = $(call BUILD_OBJECT_LIST,$(LIBXNVCTRL_SRC))

$(eval $(call DEFINE_OBJECT_RULE,TARGET,$(LIBXNVCTRL_SRC)))

$(LIBXNVCTRL) : $(LIBXNVCTRL_OBJ)
	$(call quiet_cmd,AR) ru $@ $(LIBXNVCTRL_OBJ)

$(LIBXNVCTRL_SHARED) : $(LIBXNVCTRL_OBJ)
	$(CC) -shared $(CFLAGS) $(LDFLAGS) -Wl,-soname=$(notdir $@).${LIBXNVCTRL_ABI_VERSION_MAJOR} -o $@.$(LIBXNVCTRL_ABI_VERSION_MAJOR).$(LIBXNVCTRL_ABI_VERSION_MINOR).0 $^ $(LIBXNVCTRL_LIBS)
	ln -s $(notdir $@).$(LIBXNVCTRL_ABI_VERSION_MAJOR).$(LIBXNVCTRL_ABI_VERSION_MINOR).0 $@
	ln -s $(notdir $@).$(LIBXNVCTRL_ABI_VERSION_MAJOR).$(LIBXNVCTRL_ABI_VERSION_MINOR).0 $@.$(LIBXNVCTRL_ABI_VERSION_MAJOR)
