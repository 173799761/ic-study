
# 多人 Cycle 钱包，可以用于团队协作，提供类似多签的功能:smiley:

## 安装 candid 开发工具:smiley:

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
无外部依赖库版本 :confused:
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
 dfx canister install 生成wasm文件 见 `test_pic/wasm.jpeg`
在 install的时候会生成wasm文件 路径在这里./../../.dfx/local/canisters/XXX/XXX.wasm
```bash
 dfx canister install hello_cycles --mode reinstall
```

* git clone https://github.com/dfinity/examples/hello_cycles
```bash
dfx canister call hello_cycles wallet_balance '()'
```

 * 利用ic-repl脚本语言做测试 
 * 部署后更新 canister ID
将 .dfx/local/canister_ids.json 的 multi_cycles 对应的 principal 更新至 ./test.sh 文件对应位置
测试成功截图 `test_pic/ic-repl-install-code-success.jpeg`
```bash
// 加`as`的目的让 ic-repl 知道你的 canister 的 candid 接口可能在调用的时候会方便一些
import multi_cycles = "rrkah-fqaaa-aaaaa-aaaaq-cai" as "src/declarations/multi_cycles/multi_cycles.did";
```

 * 动态创建和管理Canister：create_canister、install_code、canister_status、start_canister、 stop_canister、 delete_canister 方法 执行以下脚本

```bash
./test.sh
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