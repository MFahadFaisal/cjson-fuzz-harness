FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    clang \
    llvm \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /fuzzer
COPY . .

RUN chmod +x build.sh && ./build.sh

CMD ["./cjson_fuzzer", "corpus/", "-artifact_prefix=crashes/"]
