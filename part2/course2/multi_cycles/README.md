
# 多人 Cycle 钱包，可以用于团队协作，提供类似多签的功能

## 安装 candid 开发工具

 * 下载对应版本 didc-macos
```bash
https://github.com/dfinity/candid
```
 * 修改名称
```bash
mv didc-macos didc
```
 * 修改可执行权限
```bash
chmod a+x didc
```
 * 移动到bin目录
```bash
sudo mv didc /Usrs/mofeng/bin
```

 * mac os zsh .bash_profile export配置
```bash
#didc
DIDC_HOME=/Users/mofeng/bin
export DIDC_HOME
export PATH=$PATH:$DIDC_HOME
```

## 下载 IC Management Candid 文件
 * 进入github仓库的spec文件夹 选中ic.did 点击raw页签 把raw文件下载下来
```bash
https://github.com/dfinity/interface-spec
```
 * 运行如下命令 用motoko作为目标语言 生成对应的类型定义文件
```bash
didc bind -t mo ic.did
```

 * 运行如下命令 重定向输出到对应mo文件里
```bash
didc bind -t mo ic.did > src/multi_cycles/ic.mo
```


## 安装 ic-repl 工具

 * 下载Mac版本
 有外部依赖库版本 前置条件 在 mac 上面安装 openssl 的系统库
```bash
https://github.com/chenyan2002/ic-repl/releases
```
无外部依赖库版本
```bash
https://github.com/ninegua/ic-nix
```

 * 修改可执行权限
```bash
chmod a+x ic-repl-macos
```
 * 移动到bin目录
```bash
sudo mv ic-repl-macos /Usrs/mofeng/bin/ic-repl
```

 * 移动到bin目录
 dfx canister install 生成wasm文件
在 install的时候会生成wasm文件 路径在这里./../../.dfx/local/canisters/XXX/XXX.wasm
```bash
 dfx canister install hello_cycles --mode reinstall
```

 * 常用命令
 创建钱包
```bash
dfx canister call multi_cycles create_canister '()';
```
## vs code 高亮问题
要在开始 vscode 前，先运行 dfx start。我是从命令行，在项目目录下打开 code . 的

# 开发参考资料

如果您想了解更多的开发资料，请参阅以下在线文档:

- [Quick Start](https://sdk.dfinity.org/docs/quickstart/quickstart-intro.html)
- [SDK Developer Tools](https://sdk.dfinity.org/docs/developers-guide/sdk-guide.html)
- [Motoko Programming Language Guide](https://sdk.dfinity.org/docs/language-guide/motoko.html)
- [Motoko Language Quick Reference](https://sdk.dfinity.org/docs/language-guide/language-manual.html)
- [JavaScript API Reference](https://erxue-5aaaa-aaaab-qaagq-cai.raw.ic0.app)