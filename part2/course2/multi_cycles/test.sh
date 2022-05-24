#!/usr/local/bin/ic-repl
function deploy(multi_cycles_canister,wasm) {
  let id = call multi_cycles_canister.create_canister(
    record {
      maintainers = 1;
      controllers = null;
      mode = variant { install };
      describe = null;
    }
  );
  
  call multi_cycles_canister.install_code(
    record {
      canister_id = id;
      mode = variant { install };
      wasm = wasm;
    }
  );
  id
};

identity alice;

