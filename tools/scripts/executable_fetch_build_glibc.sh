#!/bin/bash

set -euo pipefail

GLIBC_VERSION="${GLIBC_VERSION:-2.39}"

mkdir -p ~/.local/lib
pushd ~/.local/lib

wget https://mirrors.ustc.edu.cn/gnu/glibc/glibc-${GLIBC_VERSION}.tar.gz
tar -axvf glibc-${GLIBC_VERSION}.tar.gz && cd glibc-${GLIBC_VERSION}
mkdir build && cd build
../configure --prefix=$HOME/.local/lib/glibc${GLIBC_VERSION}
make -j$(($(nproc) / 2))
make install

echo "
Example usage:

#!/bin/bash
# 自定义 glibc 路径
GLIBC_PATH="$HOME/.local/lib/glibc239"
# glibc对应程序链接器路径，后续会使用该动态链接器运行程序
LD_LOADER="${GLIBC_PATH}/lib/ld-linux-x86-64.so.2"
# tree-sitter所需依赖路径，第一条指定新安装的glibc路径，后面跟其他依赖路径
LIB_PATH="${GLIBC_PATH}/lib:/lib/x86_64-linux-gnu"
# tree-sitter 程序路径（替换为你的实际路径）
BIN_PATH="$HOME/.local/myapps/npm/node_modules/tree-sitter-cli/tree-sitter"

# 使用glibc版本对应的程序连接器运行tree-sitter程序
exec "${LD_LOADER}" \
  --library-path "${LIB_PATH}" \
  "${BIN_PATH}" \
  "$@"

"

popd
