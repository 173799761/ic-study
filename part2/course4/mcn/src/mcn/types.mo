import Principal "mo:base/Principal";
import Result "mo:base/Result";
module {

    public type Wasm_module = [Nat8];

    public type CanisterInfo = {
        canister_id: Principal;
        is_restricted: Bool;//这个罐子是否需要通过投票来执行
    };

    //操作类型,添加权限和删除权限也是需要投票共识
    public type OperationType = {
        #install;
        #start;
        #stop;
        #delete;
        #addRestricted;//添加权限
        #removeRestricted;//删除权限
    };

    //提案类型
    public type Proposal = {
        proposal_id : Nat;//提案唯一标识符
        proposal_maker : Principal;//谁提出来的提案
        operation_type : OperationType;//提案的操作类型
        canister_id : Principal;//提案对哪个罐子进行操作
        wasm_module : ?Wasm_module;//在install操作时候需要，其他操作不需要，所以是个option类型
        proposal_approve_num : Nat;//提案的支持人数
        proposal_approvers : [Principal];//提示支持人的Principal列表
        proposal_refuse_num : Nat;//提案反对的人数
        proposal_refusers: [Principal];//提案反对人的Principal列表
        proposal_completed: Bool;//提案是否已被执行
    };

        //投票返回结果
    public type VoteResult = Result.Result<VoteSuccess, VoteErr>;
    public type VoteSuccess = {
        propose : Proposal;
    };

    public type VoteErr = {
        message : ?Text;
        kind : {
        #BadProposeID;
        #InvalidController;
        #Expiration;
        #HasBeenExecuted;
        #ActionFail;
        #Other;
        };
    };

    //执行返回结果
    public type ActionResult = Result.Result<ActionSuccess, ActionErr>;
    public type ActionSuccess = {
        message : ?Text;
    };

    public type ActionErr = {
        message : ?Text;
    };

};