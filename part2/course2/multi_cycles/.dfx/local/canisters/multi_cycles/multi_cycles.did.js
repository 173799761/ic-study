export const idlFactory = ({ IDL }) => {
  const canister_id = IDL.Principal;
  const wasm_module = IDL.Vec(IDL.Nat8);
  const anon_class_10_1 = IDL.Service({
    'create_canister' : IDL.Func([], [canister_id], []),
    'delete_canister' : IDL.Func([canister_id], [], []),
    'greet' : IDL.Func([IDL.Text], [IDL.Text], []),
    'install_code' : IDL.Func(
        [
          IDL.Record({
            'mode' : IDL.Variant({
              'reinstall' : IDL.Null,
              'upgrade' : IDL.Null,
              'install' : IDL.Null,
            }),
            'canister_id' : canister_id,
            'wasm' : wasm_module,
          }),
        ],
        [],
        [],
      ),
    'start_canister' : IDL.Func([canister_id], [], []),
    'stop_canister' : IDL.Func([canister_id], [], []),
  });
  return anon_class_10_1;
};
export const init = ({ IDL }) => { return []; };
