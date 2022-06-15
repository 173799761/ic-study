/**
 * 多人 Cycle 钱包，可以用于团队协作，提供类似多签的功能
 *
 * @author 79号学员 郭梁
 * @date 2022/05/24 11:00
 */
import IC "./ic";
import Principal "mo:base/Principal";
import Cycles "mo:base/ExperimentalCycles";
import Types "./types";
import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";

// minimum: 提案通过最低维护者人数，即后续升级和维护 canister 最低需要多少人同意通过提案才能执行
// controllers: 控制者清单，控制者清单人数必须大于等于 minimum 数量
shared(owner) actor class ({minimum : Nat;controllers : [Principal]}) = self {
  //所有控制者
  private var allControllers = controllers;

  //提案ID
  private var proposeId : Nat = 0;

  //多签名Canister的缓存数据
  private var multiSignatureCanisters = Map.HashMap<Principal, Types.CanisterInfo>(10, Principal.equal, Principal.hash);

  //提案数据集合
  private var proposeMap = Map.HashMap<Nat, Types.Proposal>(10, Nat.equal, Hash.hash);

  // 1. create canister 
  public func create_canister() : async ?Principal{
    //确保 N 大于 M
    assert(allControllers.size() >= minimum);
    let settings = {
        freezing_threshold = null;
        controllers = ?allControllers;
        memory_allocation = null;
        compute_allocation = null;
      };

    let ic : IC.Self =  actor("aaaaa-aa");
    //Cycles.add(1_000_000_000_000);
    let create_result  = await ic.create_canister({settings = ? settings});

    let canister : Types.CanisterInfo = {
      canister_id = create_result.canister_id;
      is_restricted = false;
    };

    //缓存 canister
    multiSignatureCanisters.put(create_result.canister_id, canister);
    ?create_result.canister_id;
  };

  //显示所有Canister
  public shared func show_canisters() : async [Types.CanisterInfo] {
    Iter.toArray(multiSignatureCanisters.vals());
  };

  //获取Canister
  public shared func get_canister(canister_id : Principal) : async ?Types.CanisterInfo {
    multiSignatureCanisters.get(canister_id);
  };

  //获取提案自增ID
  private func nextProposeId() : Nat {
    proposeId := proposeId + 1;
    proposeId;
  };

  //生成新的提案
  public shared ({caller})  func  make_proposal (action: Types.OperationType, canister_id : Principal, wasm: ?Types.Wasm_module) : async () {
    let pid = nextProposeId();
    let propose = {
        proposal_id = pid;//提案唯一标识符
        proposal_maker = caller;//谁提出来的提案
        operation_type = action;//提案的操作类型
        canister_id = canister_id;//提案对哪个罐子进行操作
        wasm_module = wasm;//在install操作时候需要，其他操作不需要，所以是个option类型
        proposal_approve_num = 0;//提案的支持人数
        proposal_approvers = [];//提示支持人的Principal列表
        proposal_refuse_num = 0;//提案反对的人数
        proposal_refusers = [];//提案反对人的Principal列表
        proposal_completed = false;//提案是否已被执行
    };
    proposeMap.put(pid,propose);
  };

  //查询所有提案
  public shared({ caller }) func show_propose() : async [Types.Proposal] {
    Iter.toArray(proposeMap.vals());
  };

  //以下为之前第二课作业实现的接口
  public func start_canister(canister_id : IC.canister_id) : async (){
    let ic : IC.Self = actor("aaaaa-aa");
    await ic.start_canister({canister_id = canister_id});
  };

  public func stop_canister(canister_id : IC.canister_id) : async (){
    let ic : IC.Self = actor("aaaaa-aa");
    await ic.stop_canister({canister_id = canister_id});
  };

  public func delete_canister(canister_id : IC.canister_id) : async (){
    let ic : IC.Self = actor("aaaaa-aa");
    await ic.delete_canister({canister_id = canister_id});
  };

   //安装/升级 Canister 代码
  public func install_code({canister_id : IC.canister_id ;mode : { #reinstall; #upgrade; #install }; wasm : IC.wasm_module}) : async () {
    let ic : IC.Self = actor("aaaaa-aa");
    let install = {
      arg = [];
      wasm_module = wasm;
      mode = mode;
      canister_id = canister_id;
    };
    await ic.install_code(install);
  };

  public func greet(name : Text) : async Text {
    return "Hello, " # name # "!";
  };
};