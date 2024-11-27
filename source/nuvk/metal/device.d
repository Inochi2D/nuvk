/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.metal.device;
import nuvk.context;
import nuvk;
static if (NuvkHasMetal):

import metal.mtldevice;
import foundation.collections.nsarray;
import numem.all;
