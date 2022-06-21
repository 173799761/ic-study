# mcn_canister
## 在第4课作业的基础上，实现以下的功能（一个简单但是功能自洽的 DAO 系统）（5分）：
* 1、前端对 canister 进行操作，包括 create_canister, install_code, start_canister, stop_canister, delete_canister。对被限权的 Canister 的操作时，会发起新提案。
* 2、前端可以上传 Wasm 代码，用于 install_code。
* 3、前端发起提案和投票的操作。
* 4、支持增加和删除小组成员的提案。
* 5、让多人钱包接管自己（对钱包本身的操作，比如升级，需要走提案流程）
* 本次课程作业先实现后端的限权操作，不涉及前端提交，或者时前端投票的具体操作。


### SHA256引用步骤

```bash
安装vessel命令行 https://github.com/dfinity/vessel
初始化项目文件 vessel init
```

配置vessel package  
在package-set.dhall 增加一条sha256的记录
```bash
let additions = [
      { name = "sha256"
        , repo = "https://github.com/enzoh/motoko-sha.git"
        , version = "9e2468f51ef060ae04fde8d573183191bda30189"
        , dependencies = [ "base" ]
        }
    ]
```

配置vessel.dhall
在vessel.dhall中增加当前项目所用到的库 sha256
```bash
{
  dependencies = [ "base", "matchers", "sha256" ],
  compiler = None Text
}
```

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

通过 import SHA256 "mo:sha256/SHA256";；实现sha256的引入


## II 和相关依赖安装
https://github.com/dfinity/agent-js/tree/main/packages
```bash
npm i --save @dfinity/auth-client
npm i --save @dfinity/agent
npm i --save @dfinity/identity
npm i --save @dfinity/authentication
```

* II登录核心代码
```bash
  const authClient = await AuthClient.create();
  //const iiUrl = document.getElementById("iiUrl").value;
  const iiUrlTxt = document.getElementById("iiUrl").innerText;
  console.log("~~~11", iiUrlTxt)
  authClient.login({
    identityProvider: null,
    onSuccess: async()=>{
        const identity = await authClient.getIdentity();
        console.log("~~~", identity.getPrincipal().toText())
        document.getElementById("loginStatus").innerText = identity.getPrincipal().toText();
        document.getElementById("loginBtn").style.display = "none";
        document.getElementById("iiUrl").innerText = iiUrlTxt;

        const agent = new HttpAgent({ identity });
        const webapp = Actor.createActor(mcn_idl, {
        agent,
        canisterId: mcn_id,
        });
        mcn_canister = webapp;
      // Call whoami which returns the principal (user id) of the current user.
        //const principal = await webapp.whoami();
        //console.log("~~~ login finish",webapp.show_canisters);
    }
  })
```

* idl手动创建http agent核心代码
```bash
import { idlFactory as mcn_idl,canisterId as mcn_id } from "../../declarations/mcn";
```

```bash
const identity = await authClient.getIdentity();
const agent = new HttpAgent({ identity });
const webapp = Actor.createActor(mcn_idl, {
agent,
canisterId: mcn_id,
});
mcn_canister = webapp;
```

###将install_code改为public方法，用于实现限权操作


## 生成测试用的 principal id 
dfx identity --help
```bash
dfx identity new alice   
dfx identity use alice
dfx identity get-principal //54dz2-4wkpu-xqyva-45om5-lciwq-kl62c-l7dno-iwcms-pdoea-jj3vb-wqe
```
```bash
dfx identity use default
dfx identity get-principal //6p25l-itkzz-crd3k-534mc-fq4sj-oz5rl-4cldf-nkaxr-bpasr-2wl4e-lqe
dfx identity whoami   //default
```
```bash
dfx identity new glen 
dfx identity use glen 
dfx identity get-principal //zzpvw-spsbb-pcnsc-23gpy-ykq5i-6q27a-j7n7x-nqmp3-fb6y2-3eq26-pqe
```

直接使用第二节课程作业中生成好的ic.mo文件
dfx deploy 参数 即`用 Actor Class 参数来初始化 M, N, 以及最开始的小组成员（principal id)`
```bash
dfx deploy mcn --argument '(1, vec {principal "54dz2-4wkpu-xqyva-45om5-lciwq-kl62c-l7dno-iwcms-pdoea-jj3vb-wqe"; principal "6p25l-itkzz-crd3k-534mc-fq4sj-oz5rl-4cldf-nkaxr-bpasr-2wl4e-lqe"; principal "zzpvw-spsbb-pcnsc-23gpy-ykq5i-6q27a-j7n7x-nqmp3-fb6y2-3eq26-pqe"})'
```







