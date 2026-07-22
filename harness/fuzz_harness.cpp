#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include "target/cJSON/cJSON.h"

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
    if (Size == 0 || Size > 65536) {
        return 0;
    }

    // --- FAKE BUG TRAP ---
    // If input starts with 'X', trigger an intentional NULL pointer crash!
    if (Data[0] == 'X') {
        char *ptr = NULL;
        *ptr = 'A'; // Triggers AddressSanitizer Crash!
    }

    cJSON *json = cJSON_ParseWithLength((const char *)Data, Size);
    if (json != NULL) {
        cJSON_Delete(json);
    }

    return 0;
}
