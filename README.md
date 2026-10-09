# llama-cpp-openwrt

Statically linked `llama.cpp` (`llama-cli`) builds and deployment scripts optimized for resource-constrained OpenWrt `aarch64` devices (musl libc), verified on hardware like the GL.iNet Slate 7 (GL-BE3600, Qualcomm IPQ5332).

## Features

- **Static musl build:** Zero shared library dependencies (`libc`, `libstdc++`, etc.).
- **No OpenMP dependency:** Built with `-DGGML_OPENMP=OFF` to avoid dynamic `libgomp.so` linkage while using native POSIX threads.
- **Embedded-tuned:** Runs sub-150M parameter models (e.g., SmolLM2-135M) within ~250 MB total RAM.

---

## Hardware Requirements

- **Architecture:** `aarch64` (ARM64)
- **RAM:** Minimum 512 MB free RAM
- **Storage:** ~150 MB free on `/overlay` or external USB mount

---

## Quick Start on OpenWrt

Pre-built binaries are available in the [v0.1.0 Release](https://github.com/assix/llama-cpp-openwrt/releases/tag/v0.1.0).

SSH into your router:

```sh
mkdir -p /root/llm && cd /root/llm

# 1. Download static binary from v0.1.0 release
wget -O llama-cli [https://github.com/assix/llama-cpp-openwrt/releases/download/v0.1.0/llama-cli](https://github.com/assix/llama-cpp-openwrt/releases/download/v0.1.0/llama-cli)
chmod +x llama-cli

# 2. Download SmolLM2-135M Instruct (Q4_K_M ~100 MB)
curl -L -o smollm2-135m-q4_k_m.gguf \
  "[https://huggingface.co/bartowski/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Instruct-Q4_K_M.gguf](https://huggingface.co/bartowski/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Instruct-Q4_K_M.gguf)"

# 3. Run test inference
./llama-cli \
  -m smollm2-135m-q4_k_m.gguf \
  -p "<|im_start|>user\nExplain what a router does in 10 words.<|im_end|>\n<|im_start|>assistant\n" \
  -n 32 \
  -c 256 \
  -t 3 \
  --no-mmap
```

---

## Router Execution Flags

| Flag | Value | Purpose |
|---|---|---|
| `-t` | `3` | Reserves 1 CPU core for critical networking processes (`netifd`, `dnsmasq`). |
| `-c` | `256` | Caps KV cache allocation to under ~20 MB RAM. |
| `--no-mmap` | - | Loads weights directly into heap to reduce flash wear on `/overlay`. |
| `-n` | `32` | Limits generation length to preserve CPU cycles. |

---

## Use Case: Automated Log Triage

Download and execute the log analysis script:

```sh
wget -O inference-against-logs.sh [https://raw.githubusercontent.com/assix/llama-cpp-openwrt/main/scripts/inference-against-logs.sh](https://raw.githubusercontent.com/assix/llama-cpp-openwrt/main/scripts/inference-against-logs.sh)
chmod +x inference-against-logs.sh
./inference-against-logs.sh
```

---

## Compiling from Source

To compile the static binary natively on an `aarch64` host:

```bash
chmod +x scripts/build-static.sh
./scripts/build-static.sh
```

---

## Releases & Downloads

* **Latest Release:** [v0.1.0](https://github.com/assix/llama-cpp-openwrt/releases/tag/v0.1.0)

---

## License

MIT License. See [LICENSE](LICENSE) for details.
