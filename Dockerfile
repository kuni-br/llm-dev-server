# =========================
# STAGE 1 — BUILD
# =========================
FROM ubuntu:24.04 AS builder

RUN apt update && apt install -y \
    build-essential \
    git \
    cmake \
    libopenblas-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN git clone https://github.com/ggml-org/llama.cpp.git

WORKDIR /build/llama.cpp

RUN cmake -B build \
    -DGGML_BLAS=ON \
    -DGGML_BLAS_VENDOR=OpenBLAS \
    -DLLAMA_BUILD_TESTS=OFF \
    -DGGML_SHARED=OFF \
    -DBUILD_SHARED_LIBS=OFF

RUN cmake --build build --target llama-server -j$(nproc)

# =========================
# STAGE 2 — RUNTIME
# =========================
FROM ubuntu:24.04

RUN apt update && apt install -y \
    libopenblas0 \
    libgomp1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia binário
COPY --from=builder /build/llama.cpp/build/bin/llama-server /app/llama-server

RUN chmod +x /app/llama-server

EXPOSE 8080

ENTRYPOINT ["./llama-server"]