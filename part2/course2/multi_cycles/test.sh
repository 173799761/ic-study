#!/Users/mofeng/bin/ic-repl
function deploy(multi_cycles,wasm) {
  let id = call multi_cycles.create_canister();

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
import multi_cycles = "rrkah-fqaaa-aaaaa-aaaaq-cai" as "src/declarations/multi_cycles/multi_cycles.did";
let canister = deploy(multi_cycles,file "hello_cycles.wasm");
call canister.greet("world");
//call multi_cycles.stop_canister(hello_cycles);
//call multi_cycles.start_canister(hello_cycles);
//call multi_cycles.stop_canister(hello_cycles);
//call multi_cycles.delete_canister(hello_cycles);

