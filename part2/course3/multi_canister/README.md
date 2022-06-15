# multi_canister
## 在第2课作业的基础上，实现以下的功能：
用 Actor Class 参数来初始化 M, N, 以及最开始的小组成员（principal id)。（1分）
允许发起提案，比如对某个被多人钱包管理的 canister 限制权限。（1分）
统计小组成员对提案的投票（同意或否决），并根据投票结果执行决议。（2分）
在主网部署，并调试通过。（1 分）
本次课程作业先实现基本的提案功能，不涉及具体限权的操作。
* 要求：
1.设计发起提案 (propose) 和对提案进行投票 (vote) 的接口。
2.实现以下两种提案：
-开始对某个指定的 canister 限权。
-解除对某个指定的 canister 限权。
3.在调用 IC Management Canister 的时候，给出足够的 cycle。

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
dfx deploy 参数
```bash
dfx deploy multi_canister --argument '(record {minimum=1; controllers=vec {principal "54dz2-4wkpu-xqyva-45om5-lciwq-kl62c-l7dno-iwcms-pdoea-jj3vb-wqe"; principal "6p25l-itkzz-crd3k-534mc-fq4sj-oz5rl-4cldf-nkaxr-bpasr-2wl4e-lqe"; principal "zzpvw-spsbb-pcnsc-23gpy-ykq5i-6q27a-j7n7x-nqmp3-fb6y2-3eq26-pqe"}})'
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
* 获取指定Canister
```bash
dfx canister call multi_canister get_canister '(principal "sgymv-uiaaa-aaaaa-aaaia-cai")' 
```
* 查询当前principal余额
```bash
dfx identity get-wallet;      
```

* 创建提案
```bash
dfx canister call multi_canister make_proposal '(variant{start},principal "sbzkb-zqaaa-aaaaa-aaaiq-cai",null)'
```

* 查询提案
```bash
dfx canister call multi_canister show_propose '()'
```
* 提案投票
```bash
dfx canister call multi_canister vote_proposal '(1,true)'
```

## 调试过程见pic 文件夹截图






