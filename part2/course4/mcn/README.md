# multi_canister
## 在第3课作业的基础上，实现以下的功能：
* 1、对被限权的 canister 进行常规操作时 (比如 install_code)，并不立即执行，改为发起提案，只有提案通过后才执行 。（3 分）
* 2、简单的前端界面，允许查看当前的提案，已经部署的 canister 列表（包括 id, 当前状态等），小组成员名单等。 （1 分）
* 3、在前端整合 Internet Identity 登录，登录后看到自己的 Principal ID 。（1 分） 
* 本次课程作业先实现后端的限权操作，不涉及前端提交，或者时前端投票的具体操作。
本次课程作业先实现基本的提案功能，不涉及具体限权的操作。
### 要求：
1.至少实现一种限权操作，比如 install_code，如果额外实现了其它限权操作，适当加分。
2.在 install_code 的处理过程中，计算 Wasm 的 sha256 值，并作为提案的一部分（这样小组成员才能确认是否要投赞成还是否决）。

## II 和相关依赖安装
https://github.com/dfinity/agent-js/tree/main/packages
```bash
npm i --save @dfinity/auth-client
npm i --save @dfinity/agent
npm i --save @dfinity/identity
npm i --save @dfinity/authentication
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
dfx deploy mcn --argument '(record {minimum=1; controllers=vec {principal "54dz2-4wkpu-xqyva-45om5-lciwq-kl62c-l7dno-iwcms-pdoea-jj3vb-wqe"; principal "6p25l-itkzz-crd3k-534mc-fq4sj-oz5rl-4cldf-nkaxr-bpasr-2wl4e-lqe"; principal "zzpvw-spsbb-pcnsc-23gpy-ykq5i-6q27a-j7n7x-nqmp3-fb6y2-3eq26-pqe"}})'
```




* 在调用IC Management Canister 进行create canister时候已经以发消息的方式进行了cycles的支付
* 创建Canister
```bash
dfx canister call multi_canister create_canister '()';
```
* 查询Canister
```bash
dfx canister call multi_canister show_canisters '()'
```
* 查询小组成员 
```bash
dfx canister call multi_canister show_controllers '()'
```

* 获取指定Canister
```bash
dfx canister call multi_canister get_canister '(principal "sgymv-uiaaa-aaaaa-aaaia-cai")' 
```
* 查询当前principal余额
```bash
dfx identity get-wallet;      
```

* 创建提案 即`允许发起提案，比如对某个被多人钱包管理的 canister 限制权限`
```bash
dfx canister call multi_canister make_proposal '(variant{start},principal "sgymv-uiaaa-aaaaa-aaaia-cai",null)'
```

* 查询提案
```bash
dfx canister call multi_canister show_propose '()'
```
* 提案投票 即`统计小组成员对提案的投票（同意或否决），并根据投票结果执行决议`。
```bash
dfx canister call multi_canister vote_proposal '(1,true)'
```

## 调试过程 和限权测试结果 见pic 文件夹截图






