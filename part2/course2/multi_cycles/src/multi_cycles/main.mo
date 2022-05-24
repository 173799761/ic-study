/**
 * 多人 Cycle 钱包，可以用于团队协作，提供类似多签的功能
 *
 * @author 79号学员 郭梁
 * @date 2022/05/24 11:00
 */
import IC "./ic";
import Principal "mo:base/Principal";

actor class () = self {
  public func create_canister():async IC.canister_id{
    let settings = {
      freezing_threshold = null;
      controllers = ?[Principal.fromActor(self)];
      memory_allocation = null;
      compute_allocation = null;
    };
    let ic : IC.Self = actor("aaaaa-aa");
    let result = await ic.create_canister({settings = ? settings;});
    result.canister_id;
  };

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



};
