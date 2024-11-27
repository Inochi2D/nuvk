/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.internal.impl.tracking;
import nuvk.resource;
import nuvk.sync;
import numem.collections.map;

struct NuvkResourceTrackingInfo {
    NuvkSyncDirection lastOperation;
}

/**
    A class used by nuvk to track resource reads and writes in a command buffer.

    This should not be accessed manually.
*/
class NuvkResourceTracker {
@nogc:
private:
    // weak_map!(NuvkResource, NuvkResourceTrackingInfo) tracked;

public:

}