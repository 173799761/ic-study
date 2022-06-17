/**
 * 多人 Cycle 钱包，可以用于团队协作，提供类似多签的功能
 *
 * @author 79号学员 郭梁
 * @date 2022/06/17 11:00
 */
import IC "./ic";
import Principal "mo:base/Principal";
import Cycles "mo:base/ExperimentalCycles";
import Types "./types";
import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Option "mo:base/Option";

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
    Cycles.add(1_000_000_000_000);
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

  public shared func show_controllers() : async [Principal] {
    Iter.toArray(allControllers.vals());
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

  //判断canister是否存在
  private func checkCanisterExist(canister_id : Principal) : Bool {
    for (x in multiSignatureCanisters.vals()) {
      if (x == canister_id) {
        return true;
      };
    };
    false;
  };

   private func checkRestricted(canister_id : Principal) : Bool{
    for (x in multiSignatureCanisters.vals()) {
      if (x == canister_id and x.is_restricted == true) {
        return true;
      };
      if (x == canister_id and x.is_restricted == false) {
        return false;
      };
    };
    true;
   };

  //生成新的提案
  public shared ({caller})  func  make_proposal (action: Types.OperationType, canister_id : Principal, wasm: ?Types.Wasm_module) : async Types.VoteResult {
    if(checkCanisterExist(canister_id) == false) {
        return #err({
          message = ?"目标罐子不存在";
          kind = #InvalidController;
        });
    };

    switch (action) {
        case (#addRestricted) { 
          if(checkRestricted(canister_id) == true){
              return #err({
              message = ?"目标罐子已经存在权限限制";
              kind = #InvalidController;
            });
          } 
          };
        //3.2 remove Restricted/start stop install delete, check canister restricted
        case (_) { 
          if(checkRestricted(canister_id) == false){
              return #err({
              message = ?"start stop install delete, check canister 操作需要有权限限制";
              kind = #InvalidController;
            });
          } 
          };
    };
    
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
    #ok({propose=propose});
  };



  
  //投票
  public shared ({caller}) func vote_proposal (proposal_id: Nat, approve: Bool) : async Types.VoteResult {
    //检查权限
    //assert(checkPermissions(caller)); 
    //检查权限
    if(checkPermissions(caller) == false) {
      return #err({
        message = ?"您不是控制者，无法参与投票";
        kind = #InvalidController;
      });
    };

    switch(proposeMap.get(proposal_id)) {
      case null {
        let msg = "该提案号(" # Nat.toText(proposal_id) # ")不存在";
        #err({
          message = ?msg;
          kind = #BadProposeID;
        });
      };
      case (?proposal) {
        if (proposal.proposal_completed == false) {
          var proposal_approvers = proposal.proposal_approvers;
          var proposal_approve_num = proposal.proposal_approve_num;
          var proposal_refusers = proposal.proposal_refusers;
          var proposal_refuse_num = proposal.proposal_refuse_num;
          if(approve){
              proposal_approvers := Array.append([caller], proposal_approvers);
              proposal_approve_num += 1;
          } else {
              proposal_refusers := Array.append([caller], proposal_refusers);
              proposal_refuse_num += 1;
          };
          let new_proposal = {
              proposal_id = proposal.proposal_id;
              proposal_maker  = proposal.proposal_maker;
              operation_type = proposal.operation_type;
              canister_id = proposal.canister_id;
              wasm_module = proposal.wasm_module;
              proposal_approve_num = proposal_approve_num;
              proposal_approvers = proposal_approvers;
              proposal_refuse_num = proposal_refuse_num;
              proposal_refusers = proposal_refusers;
              proposal_completed = false;
          };
          proposeMap.put(proposal.proposal_id,new_proposal);  
          //执行投票
          if (proposal_approve_num >= minimum and (not proposal.proposal_completed)) {
              // auto execute proposal
              await execute_proposal(new_proposal);
          };
          #ok({propose=new_proposal});
        }else{
            let msg = "该提案号(" # Nat.toText(proposal_id) # ")已被执行，无法进行投票";
            #err({
              message = ?msg;
              kind = #HasBeenExecuted;
            });
        }
      };
    };
  };

  //执行投票
  private func execute_proposal (proposal : Types.Proposal) : async () {
      switch (proposal.operation_type) {
            case (#addRestricted) {
                add_restricted(proposal.canister_id);
            };
            case (#removeRestricted) {
                remove_restricted(proposal.canister_id);
            };
            case (#start) {
                await start_canister(proposal.canister_id);
            };
            case (#stop) {
                await stop_canister(proposal.canister_id);
            };
            case (#install) {
                await exec_install_code(proposal.canister_id, proposal.wasm_module);
            };
            case (#delete) {
                await delete_canister(proposal.canister_id);
            };
        };

        let new_proposal = {
            proposal_id = proposal.proposal_id;
            proposal_maker  = proposal.proposal_maker;
            operation_type = proposal.operation_type;
            canister_id = proposal.canister_id;
            wasm_module = proposal.wasm_module;
            proposal_approve_num = proposal.proposal_approve_num;
            proposal_approvers = proposal.proposal_approvers;
            proposal_refuse_num = proposal.proposal_refuse_num;
            proposal_refusers = proposal.proposal_refusers;
            proposal_completed = true;
        };
        proposeMap.put(proposal.proposal_id,new_proposal);
  };

  private func add_restricted(canister_id : Principal) : () {
        let new_canister_info : Types.CanisterInfo = {
            canister_id = canister_id;
            is_restricted = true;
        };
       multiSignatureCanisters.put(canister_id,new_canister_info);
    };

    private func remove_restricted(canister_id : Principal) : () {
        let new_canister_info : Types.CanisterInfo = {
            canister_id = canister_id;
            is_restricted = false;
        };
        multiSignatureCanisters.put(canister_id,new_canister_info);
    };


  //校验该调用者是否有权限
  private func checkPermissions(caller : Principal) : Bool {
    //检查 caller 是否在 allControllers 列表中
    for (x in allControllers.vals()) {
      if (x == caller) {
        return true;
      };
    };
    false;
  };

  //查询所有提案
  public shared({ caller }) func show_propose() : async [Types.Proposal] {
    Iter.toArray(proposeMap.vals());
  };

  //以下为之前第二课作业实现的接口 将公共接口换成了private接口，目的是为了通过投票达成后才能执行
  private func start_canister(canister_id : IC.canister_id) : async (){
    let ic : IC.Self = actor("aaaaa-aa");
    await ic.start_canister({canister_id = canister_id});
  };

  private func stop_canister(canister_id : IC.canister_id) : async (){
    let ic : IC.Self = actor("aaaaa-aa");
    await ic.stop_canister({canister_id = canister_id});
  };

  private func delete_canister(canister_id : IC.canister_id) : async (){
    let ic : IC.Self = actor("aaaaa-aa");
    await ic.delete_canister({canister_id = canister_id});
  };

    //安装/升级 Canister 代码
  private func exec_install_code(canister_id : IC.canister_id , wasm : ?Types.Wasm_module) : async () {

    let ic : IC.Self = actor("aaaaa-aa");
    let install = {
      arg = [];
      wasm_module = Option.unwrap(wasm);
  
      mode = #install;
      canister_id = canister_id;
    };
    await ic.install_code(install);
  
  };

  //安装/升级 Canister 代码
  public func install_code(canister_id : IC.canister_id , wasm : ?Types.Wasm_module) : async Types.ActionResult {
    if(checkCanisterExist(canister_id) == false) {
        return #err({
          message = ?"目标罐子不存在";
        });
    };

    if(checkRestricted(canister_id) == true){
        ignore await make_proposal(#install,canister_id,wasm);
       // #ok({ message = ?"成功"});
    }else{
      let ic : IC.Self = actor("aaaaa-aa");
      let install = {
        arg = [];
        wasm_module = Option.unwrap(wasm);
      // wasm_module = wasm;
        mode = #install;
        canister_id = canister_id;
      };
      await ic.install_code(install);
    };
    #ok({ message = ?"成功"});
  };

  public func greet(name : Text) : async Text {
    return "Hello, " # name # "!";
  };
};