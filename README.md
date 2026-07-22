# 🐛 Coverage-Guided Fuzzing Harness for cJSON

An automated, coverage-guided fuzzing setup targeting the [cJSON](https://github.com/DaveGamble/cJSON) lightweight JSON parser library using **LLVM libFuzzer**, **AddressSanitizer (ASan)**, and **UndefinedBehaviorSanitizer (UBSan)**.

---

## 📌 Project Overview

This repository demonstrates modern dynamic security testing and vulnerability research techniques by:
* **Harness Engineering:** Crafting an efficient C++ fuzz harness (`LLVMFuzzerTestOneInput`) that safely feeds mutated payloads into cJSON's parsing APIs while managing memory cleanup.
* **Compiler Instrumentation:** Leveraging `clang++` flags to instrument branch coverage and memory sanitizers (ASan/UBSan) for real-time fault detection.
* **Bug Triage & RCA:** Triaging crash artifacts, reproducing memory violations, and identifying root causes using AddressSanitizer stack traces.
* **Portable Execution:** Providing native Linux compilation steps and Dockerized sandboxing.

---

## 🛠️ Architecture & Fuzzing Pipeline
[1] SEED CORPUS
       └─> Raw JSON samples (valid / invalid structures)
  
  [2] LIBFUZZER ENGINE
       └─> In-process mutation & coverage feedback loop
  
  [3] TARGET PARSER
       └─> Instrumented cJSON build (Clang -fsanitize=fuzzer,address,undefined)
  
  [4] SANITIZER EVALUATION
       ├──> [Violation Detected?]
       │     ├── YES ──> Save minimized payload to ./crashes/ & output ASan log
       │     └── NO  ──> Keep mutated input in memory if coverage expanded
       │
       └──> [Loop back to Engine for next test case]

---

## 💻 Prerequisites & Environment

This project is built and tested on **Linux (Ubuntu, Debian, Kali Linux)**.

```bash
sudo apt update && sudo apt install -y build-essential clang llvm docker.io git xxd


🚀 Quickstart & Usage
1. Project Directory Layout

.
├── harness/
│   └── fuzz_harness.cpp   # libFuzzer entry point
├── target/
│   └── cJSON/             # cJSON library target source
├── corpus/                # Initial seed inputs (.json files)
├── crashes/               # Output directory for ASan bug reports
├── build.sh               # Automated compilation script
└── Dockerfile             # Containerized fuzzing setup



2. Seed Corpus Setup

Initialize the seed folder with valid JSON structures to accelerate edge discovery:
Bash

mkdir -p corpus crashes
echo '{"key": "value"}' > corpus/seed1.json
echo '[1, 2, "test", true, null]' > corpus/seed2.json


3. Compilation & Build

Compile the harness with sanitizers enabled:
Bash

clang++ -fsanitize=fuzzer,address,undefined -g -O1 \
  harness/fuzz_harness.cpp \
  -x c target/cJSON/cJSON.c \
  -I. \
  -o cjson_fuzzer

4. Executing the Fuzzer

    Single-core Fuzzing:
    Bash

./cjson_fuzzer corpus/ -artifact_prefix=crashes/


Multi-core Parallel Fuzzing (4 Workers):
Bash

./cjson_fuzzer corpus/ -jobs=4 -workers=4 -artifact_prefix=crashes/


Time-Bounded Fuzzing Run (e.g., 1 Hour):
Bash

./cjson_fuzzer corpus/ -max_total_time=3600 -artifact_prefix=crashes/


🔍 Crash Reproduction & Triage

When a memory violation or undefined behavior occurs, libFuzzer halts execution and saves the minimal payload to ./crashes/crash-<hash>.
Reproduce a Crash Report

Pass the crash artifact directly to the compiled binary to output the AddressSanitizer stack trace:
Bash

./cjson_fuzzer crashes/crash-<hash>

Inspect the Malformed Payload

View raw hex bytes of the triggering input:
Bash

xxd crashes/crash-<hash>

🐳 Docker Containerization

Run the environment inside an isolated container:
Bash

# Build Docker image
docker build -t cjson-fuzz-harness .

# Run container with mounted crashes volume
docker run --rm -v $(pwd)/crashes:/fuzzer/crashes cjson-fuzz-harness
