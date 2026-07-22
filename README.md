# Coverage-Guided Fuzzing Harness for cJSON

An automated, coverage-guided fuzzing setup targeting the **cJSON** parser library using **LLVM libFuzzer**, **AddressSanitizer (ASan)**, and **UndefinedBehaviorSanitizer (UBSan)**.

## 📌 Project Overview
This project demonstrates modern dynamic vulnerability research techniques by:
- Engineering a custom C++ fuzzing harness using `LLVMFuzzerTestOneInput`.
- Instrumenting C target source code for coverage-guided branch exploration.
- Compiling memory sanitizers (`ASan`, `UBSan`) to catch out-of-bounds reads, write vulnerabilities, and pointer dereferences.
- Triaging and performing Root Cause Analysis (RCA) on discovered crash artifacts.

---

## 🛠️ Architecture & Fuzzing Pipeline
[ Seed Corpus ] ---> [ libFuzzer Engine ] ---> [ Mutated Payloads ]
|
v
[ Instrumented cJSON Parser ]
|
( Sanitizer Triggered? )
/

(Yes)                     (No)
/

[ ASan Crash Report ]          [ Next Iteration ]
[ Saved to /crashes ]


💻 Prerequisites (Linux Setup)

Ensure your system has `clang` and `llvm` installed.

### Ubuntu / Debian / Kali Linux
```bash
sudo apt update && sudo apt install -y build-essential clang llvm docker.io git
