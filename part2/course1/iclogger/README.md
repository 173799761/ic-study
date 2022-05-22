## iclogger 实现一个可以无限扩容的 Logger，支持添加文本记录，不支持删除
总体方案思路:
* 1、通过创建更多的Logger来实现，通过实现一个Logger canister,它的公共接口和ic-logger里演示的公共接口是一样的
* 2、当内部发现自己的日志记录数量达到了100条后，创建一个新的Logger canister容器,即产生一个新的actor
* 3、通过持续不断的添加新的Logger canister,即持续不断的生成新的actor,来实现一个无限扩容的Logger

详细实现的关键步骤：



## 如果你想在本地测试你的项目，你可以使用以下命令:

```bash
# 在后台运行 definity 服务
dfx start --background

# 将你的canisters部署到definity本地服务上，并生成你的candid界面
dfx deploy
```

部署完成后，您可以通过类似这个地址访问您的服务 `http://localhost:8000?canisterId={asset_canister_id}`.


### ic-logger的引用步骤
```bash
安装vessel命令行 https://github.com/dfinity/vessel
初始化项目文件 vessel init
```

配置vessel package  
在package-set.dhall 增加一条ic-logger的记录
```bash
let additions = [
      { name = "ic-logger"
      , repo = "https://github.com/ninegua/ic-logger"
      , version = "95e06542158fc750be828081b57834062aa83357"
      , dependencies = [ "base" ]
      }
    ]
```

配置vessel.dhall
在vessel.dhall中增加当前项目所用到的库 ic-logger

修改dfx.json设置
dfx.json defaults 增加packtool配置，让dfx知道如何使用veseel程序库
```bash
  "defaults": {
    "build": {
      "args": "",
      "packtool": "vessel sources"
    }
  }
```

通过 import Logger "mo:ic-logger/Logger"；实现ic-logger的引入


查看日志状态
```bash
dfx canister call iclogger stats '()'
```

添加日志记录
```bash
dfx canister call iclogger append '(vec{"first entry"})'
```

查看日志命令
```bash
dfx canister call iclogger view '(0,100)'
```
# 测试结果
test_result.jpg

# 开发参考资料

如果您想了解更多的开发资料，请参阅以下在线文档:

- [Quick Start](https://sdk.dfinity.org/docs/quickstart/quickstart-intro.html)
- [SDK Developer Tools](https://sdk.dfinity.org/docs/developers-guide/sdk-guide.html)
- [Motoko Programming Language Guide](https://sdk.dfinity.org/docs/language-guide/motoko.html)
- [Motoko Language Quick Reference](https://sdk.dfinity.org/docs/language-guide/language-manual.html)
- [JavaScript API Reference](https://erxue-5aaaa-aaaab-qaagq-cai.raw.ic0.app)