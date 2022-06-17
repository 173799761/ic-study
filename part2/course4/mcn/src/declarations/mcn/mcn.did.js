export const idlFactory = ({ IDL }) => {
  const CanisterInfo = IDL.Record({
    'canister_id' : IDL.Principal,
    'is_restricted' : IDL.Bool,
  });
  const OperationType = IDL.Variant({
    'addRestricted' : IDL.Null,
    'stop' : IDL.Null,
    'removeRestricted' : IDL.Null,
    'delete' : IDL.Null,
    'start' : IDL.Null,
    'install' : IDL.Null,
  });
  const Wasm_module = IDL.Vec(IDL.Nat8);
  const Proposal = IDL.Record({
    'wasm_module' : IDL.Opt(Wasm_module),
    'proposal_refusers' : IDL.Vec(IDL.Principal),
    'operation_type' : OperationType,
    'proposal_approvers' : IDL.Vec(IDL.Principal),
    'canister_id' : IDL.Principal,
    'proposal_refuse_num' : IDL.Nat,
    'proposal_maker' : IDL.Principal,
    'proposal_approve_num' : IDL.Nat,
    'proposal_completed' : IDL.Bool,
    'proposal_id' : IDL.Nat,
  });
  const VoteSuccess = IDL.Record({ 'propose' : Proposal });
  const VoteErr = IDL.Record({
    'kind' : IDL.Variant({
      'InvalidController' : IDL.Null,
      'ActionFail' : IDL.Null,
      'BadProposeID' : IDL.Null,
      'Expiration' : IDL.Null,
      'Other' : IDL.Null,
      'HasBeenExecuted' : IDL.Null,
    }),
    'message' : IDL.Opt(IDL.Text),
  });
  const VoteResult = IDL.Variant({ 'ok' : VoteSuccess, 'err' : VoteErr });
  const anon_class_20_1 = IDL.Service({
    'create_canister' : IDL.Func([], [IDL.Opt(IDL.Principal)], []),
    'get_canister' : IDL.Func([IDL.Principal], [IDL.Opt(CanisterInfo)], []),
    'greet' : IDL.Func([IDL.Text], [IDL.Text], []),
    'make_proposal' : IDL.Func(
        [OperationType, IDL.Principal, IDL.Opt(Wasm_module)],
        [VoteResult],
        [],
      ),
    'show_canisters' : IDL.Func([], [IDL.Vec(CanisterInfo)], []),
    'show_controllers' : IDL.Func([], [IDL.Vec(IDL.Principal)], []),
    'show_propose' : IDL.Func([], [IDL.Vec(Proposal)], []),
    'vote_proposal' : IDL.Func([IDL.Nat, IDL.Bool], [VoteResult], []),
  });
  return anon_class_20_1;
};
export const init = ({ IDL }) => {
  return [
    IDL.Record({ 'controllers' : IDL.Vec(IDL.Principal), 'minimum' : IDL.Nat }),
  ];
};
