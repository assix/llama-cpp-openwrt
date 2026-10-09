#!/usr/bin/env bash
set -euo pipefail

# Build statically linked llama-cli for aarch64 musl (OpenWrt)
docker run --rm -v "$(pwd):/dist" alpine:latest sh -c "
  apk add --no-cache git build-base cmake linux-headers && \
  git clone --depth 1 https://github.com/ggerganov/llama.cpp.git && \
  cd llama.cpp && \
  cmake -B build \
    -DBUILD_SHARED_LIBS=OFF \
    -DGGML_OPENMP=OFF \
    -DCMAKE_EXE_LINKER_FLAGS='-static' && \
  cmake --build build --config Release -j\$(nproc) --target llama-cli && \
  strip build/bin/llama-cli && \
  cp build/bin/llama-cli /dist/
"
