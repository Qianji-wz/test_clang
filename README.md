# test_clang

从零搭建 C/C++ 编程规范与 Git 门禁示例。

## 最小可用 CMake C++ 项目

当前仓库已包含一个最小可用的 CMake C++ 示例项目。

项目结构：

- `CMakeLists.txt`
- `include/greeter.h`
- `src/greeter.cpp`
- `src/main.cpp`

### 构建

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build -j
```

或使用 Presets：

```bash
cmake --preset default
cmake --build --preset default
```

### 运行

```bash
./build/test_clang_app
./build/test_clang_app Alice
```

### 测试

```bash
ctest --test-dir build --output-on-failure
```

或使用 Presets：

```bash
ctest --preset default
```

## 目标

- 统一代码风格（`clang-format`）
- 静态检查（`clang-tidy`）
- 本地提交前阻断（`pre-commit`）
- 远端合并前阻断（CI）

## 目录说明

- `.clang-format`: 代码格式规则
- `.clang-tidy`: 静态检查规则（已配置 `WarningsAsErrors: '*'`）
- `docs/CODING_STANDARD.md`: 编程规范文档
- `scripts/check_style.sh`: 统一质量检查入口
- `scripts/install_git_hooks.sh`: 一键安装本地 Git Hooks
- `.githooks/pre-commit`: 提交前门禁
- `.github/workflows/quality-gate.yml`: CI 门禁

## 前置依赖

请安装：

- `clang-format`
- `clang-tidy`
- `git`

Linux 示例：

```bash
sudo apt-get update
sudo apt-get install -y clang-format clang-tidy
```

## 使用方式

1. 安装本地 Git Hook：

```bash
bash scripts/install_git_hooks.sh
```

2. 手动运行全量检查：

```bash
bash scripts/check_style.sh
```

3. 如果只想检查已暂存文件（与 pre-commit 一致）：

```bash
bash scripts/check_style.sh --staged
```

## 常见问题

### 1) `clang-tidy` 跳过了

`clang-tidy` 依赖 `compile_commands.json`。如果仓库是 CMake 项目，可以这样生成：

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -sf build/compile_commands.json compile_commands.json
```

### 2) 如何自动修复格式

```bash
clang-format -i path/to/file.cpp
```

## 建议落地流程

1. 先在团队内评审 `docs/CODING_STANDARD.md`
2. 再启用本地 Hook（减少无效提交）
3. 最后启用 CI 必须通过（保护主分支）
