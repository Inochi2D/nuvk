/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Nuvk Metal Backend
*/
module nuvk.internal.metal;
import nuvk.core.platform;

import nuvk.internal;

static if (NuvkIsAppleOS):

pragma(linkerDirective, "-framework", "CoreData");
pragma(linkerDirective, "-framework", "CoreGraphics");
pragma(linkerDirective, "-framework", "Foundation");
pragma(linkerDirective, "-framework", "Metal");

// UIKit is mobile-os specific.
static if (NuvkIsAppleMobileOS) {
    pragma(linkerDirective, "-framework", "UIKit");
}