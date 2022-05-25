import type { Principal } from '@dfinity/principal';
export interface _SERVICE {
  'greet' : (arg_0: string) => Promise<string>,
  'transfer' : (arg_0: [Principal, string], arg_1: bigint) => Promise<
      { 'refunded' : bigint }
    >,
  'wallet_balance' : () => Promise<bigint>,
  'wallet_receive' : () => Promise<{ 'accepted' : bigint }>,
}
