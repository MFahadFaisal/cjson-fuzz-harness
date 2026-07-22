#!/bin/bash
echo "[+] Compiling cJSON library with sanitizer instrumentation..."
clang -c -g -O1 -fsanitize=fuzzer-no-link,address,undefined target/cJSON/cJSON.c -o cjson.o

echo "[+] Compiling libFuzzer harness..."
clang++ -g -O1 -fsanitize=fuzzer,address,undefined harness/fuzz_harness.cpp cjson.o -I target/cJSON/ -o cjson_fuzzer

echo "[+] Build complete! Run the fuzzer with: ./cjson_fuzzer corpus/ -artifact_prefix=crashes/"
