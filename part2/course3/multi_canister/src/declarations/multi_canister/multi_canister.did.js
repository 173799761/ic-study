export const idlFactory = ({ IDL }) => {
  const anon_class_13_1 = IDL.Service({
    'create_canister' : IDL.Func([], [IDL.Opt(IDL.Principal)], []),
    'greet' : IDL.Func([IDL.Text], [IDL.Text], []),
  });
  return anon_class_13_1;
};
export const init = ({ IDL }) => {
  return [
    IDL.Record({ 'controllers' : IDL.Vec(IDL.Principal), 'minimum' : IDL.Nat }),
  ];
};
