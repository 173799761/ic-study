import type { Principal } from '@dfinity/principal';
export interface Main {
  'allow' : (arg_0: Array<Principal>) => Promise<undefined>,
  'append' : (arg_0: Array<string>) => Promise<undefined>,
  'pop_buckets' : (arg_0: bigint) => Promise<undefined>,
  'stats' : () => Promise<Stats>,
  'view' : (arg_0: bigint, arg_1: bigint) => Promise<View>,
}
export interface Stats {
  'bucket_sizes' : Array<bigint>,
  'start_index' : bigint,
}
export interface View { 'messages' : Array<string>, 'start_index' : bigint }
export interface _SERVICE extends Main {}
