FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# -----------------------------------------------------------------------------
# Install OS-level dependencies
# -----------------------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        wget gnupg lsb-release ca-certificates curl \
        python3 python3-pip python3-venv \
        graphviz && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# Install LLVM/Clang 18.1.3 from apt.llvm.org
# -----------------------------------------------------------------------------
RUN wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs)-18 main" > /etc/apt/sources.list.d/llvm.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        clang-18 lld-18 llvm-18-tools llvm-18-dev && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/clang      clang      /usr/bin/clang-18      100 && \
    update-alternatives --install /usr/bin/clang++    clang++    /usr/bin/clang++-18    100 && \
    update-alternatives --install /usr/bin/llvm-link  llvm-link  /usr/bin/llvm-link-18  100 && \
    update-alternatives --install /usr/bin/llvm-dis   llvm-dis   /usr/bin/llvm-dis-18   100 && \
    update-alternatives --install /usr/bin/opt        opt        /usr/bin/opt-18        100

# -----------------------------------------------------------------------------
# Python dependencies
# -----------------------------------------------------------------------------
RUN pip3 install --no-cache-dir pydot==1.4.2

# -----------------------------------------------------------------------------
# Copy project files
# -----------------------------------------------------------------------------
WORKDIR /workspace
COPY . /workspace

CMD ["/bin/bash"] 