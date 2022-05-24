#!/usr/local/bin/ic-repl
function deploy(dynamic_canister,wasm) {
  let id = call dynamic_canister.create_canister(
    record {
      maintainers = 1;
      controllers = null;
      mode = variant { install };
      describe = null;
    }
  );
  
  call dynamic_canister.install_code(
    record {
      canister_id = id;
      mode = variant { install };
      wasm = wasm;
    }
  );
  id
};

identity alice;

