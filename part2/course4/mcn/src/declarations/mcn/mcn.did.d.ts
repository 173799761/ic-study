import type { Principal } from '@dfinity/principal';
export interface ActionErr { 'message' : [] | [string] }
export type ActionResult = { 'ok' : ActionSuccess } |
  { 'err' : ActionErr };
export interface ActionSuccess { 'message' : [] | [string] }
export interface CanisterInfo {
  'canister_id' : Principal,
  'is_restricted' : boolean,
}
export type OperationType = { 'addRestricted' : null } |
  { 'stop' : null } |
  { 'removeRestricted' : null } |
  { 'delete' : null } |
  { 'start' : null } |
  { 'install' : null };
export interface Proposal {
  'wasm_module' : [] | [Wasm_module],
  'proposal_refusers' : Array<Principal>,
  'operation_type' : OperationType,
  'proposal_approvers' : Array<Principal>,
  'canister_id' : Principal,
  'proposal_refuse_num' : bigint,
  'proposal_maker' : Principal,
  'proposal_approve_num' : bigint,
  'proposal_completed' : boolean,
  'proposal_id' : bigint,
}
export interface VoteErr {
  'kind' : { 'InvalidController' : null } |
    { 'ActionFail' : null } |
    { 'BadProposeID' : null } |
    { 'Expiration' : null } |
    { 'Other' : null } |
    { 'HasBeenExecuted' : null },
  'message' : [] | [string],
}
export type VoteResult = { 'ok' : VoteSuccess } |
  { 'err' : VoteErr };
export interface VoteSuccess { 'propose' : Proposal }
export type Wasm_module = Array<number>;
export interface anon_class_20_1 {
  'create_canister' : () => Promise<[] | [Principal]>,
  'get_canister' : (arg_0: Principal) => Promise<[] | [CanisterInfo]>,
  'greet' : (arg_0: string) => Promise<string>,
  'install_code' : (arg_0: canister_id, arg_1: [] | [Wasm_module]) => Promise<
      ActionResult
    >,
  'make_proposal' : (
      arg_0: OperationType,
      arg_1: Principal,
      arg_2: [] | [Wasm_module],
    ) => Promise<VoteResult>,
  'show_canisters' : () => Promise<Array<CanisterInfo>>,
  'show_controllers' : () => Promise<Array<Principal>>,
  'show_propose' : () => Promise<Array<Proposal>>,
  'vote_proposal' : (arg_0: bigint, arg_1: boolean) => Promise<VoteResult>,
}
export type canister_id = Principal;
export interface _SERVICE extends anon_class_20_1 {}
