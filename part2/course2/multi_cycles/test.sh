#!/Users/mofeng/bin/ic-repl
function deploy(multi_cycles,wasm) {
  let id = call multi_cycles.create_canister(
    record {
      maintainers = 1;
      controllers = null;
      mode = variant { install };
      describe = null;
    }
  );
  
  call multi_cycles.install_code(
    record {
      canister_id = id;
      mode = variant { install };
      wasm = wasm;
    }
  );
  id
};

identity alice;
import multi_cycles = "rrkah-fqaaa-aaaaa-aaaaq-cai";
let id = deploy(multi_cycles,file "hello_cycles.wasm");
let canister = id.canister_id;
call canister.wallet_balance();
//call canister.greet("world");
