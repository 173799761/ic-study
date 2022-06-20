import { mcn } from "../../declarations/mcn";
import { AuthClient } from "@dfinity/auth-client";
import { Actor, HttpAgent } from "@dfinity/agent";
import { idlFactory as mcn_idl,canisterId as mcn_id } from "../../declarations/mcn";

const webapp_id = process.env.WHOAMI_CANISTER_ID;

let agent = new HttpAgent;
let mcn_canister = null;

// Autofills the <input> for the II Url to point to the correct canister.
document.body.onload = () => {
  let iiUrl;
  if (process.env.DFX_NETWORK === "local") {
    iiUrl = `http://localhost:8000/?canisterId=${process.env.II_CANISTER_ID}`;
  } else if (process.env.DFX_NETWORK === "ic") {
    iiUrl = `https://${process.env.II_CANISTER_ID}.ic0.app`;
  } else {
    iiUrl = `https://${process.env.II_CANISTER_ID}.dfinity.network`;
  }
  document.getElementById("iiUrl").innerText = iiUrl;

};

document.getElementById("show").addEventListener("click", async () => {
    try {
        let message_pos = document.getElementById("message");
        message_pos.replaceChildren([]);
        console.log("mcnShowControllers=====")
        const mcnShowControllers = await mcn_canister.show_controllers();
        console.log("mcnShowControllers-----", mcnShowControllers)
        for(let i = 0 ; i < mcnShowControllers.length; i++){
            let post = document.createElement('post');
            post.innerText = mcnShowControllers[i];
            let post2 = document.createElement('post2');
            post2.innerText = '\n'
            message_pos.appendChild(post);
            message_pos.appendChild(post2);
            // document.getElementById("message").innerText = mcnShowControllers;
        }      
    } catch (error) {
       console.error(error);
       alert(error) 
    }
    
})

document.getElementById("showDeployed").addEventListener("click", async () => {
  try {  
  let message_pos = document.getElementById("sec_canisters");
    message_pos.replaceChildren([]);
    console.log("show_canisters=====")
    const canisters = await mcn_canister.show_canisters();
    console.log("show_canisters-----", canisters)
    for(let i = 0 ; i < canisters.length; i++){
        let post = document.createElement('post');
        post.innerText = canisters[i].canister_id + ' & '+ canisters[i].is_restricted + '\n';
        message_pos.appendChild(post);
        // document.getElementById("message").innerText = mcnShowControllers;
    }
  }catch (error) {
    console.error(error);
    alert(error) 
 }
})


document.getElementById("loginBtn").addEventListener("click", async () => {

  const authClient = await AuthClient.create();
  //const iiUrl = document.getElementById("iiUrl").value;
  const iiUrlTxt = document.getElementById("iiUrl").innerText;
  console.log("~~~11", iiUrlTxt)
  authClient.login({
    identityProvider: null,
    onSuccess: async()=>{
        const identity = await authClient.getIdentity();
        console.log("~~~", identity.getPrincipal().toText())
        document.getElementById("loginStatus").innerText = identity.getPrincipal().toText();
        document.getElementById("loginBtn").style.display = "none";
        document.getElementById("iiUrl").innerText = iiUrlTxt;

        const agent = new HttpAgent({ identity });
        const webapp = Actor.createActor(mcn_idl, {
        agent,
        canisterId: mcn_id,
        });
        mcn_canister = webapp;
      // Call whoami which returns the principal (user id) of the current user.
        //const principal = await webapp.whoami();
        //console.log("~~~ login finish",webapp.show_canisters);
    }
  })

    // await new Promise((resolve, reject) => {
    //     authClient.login({
    //         identityProvider: iiUrl,
    //         onSuccess: resolve,
    //         onError: reject,
    //     });
    // });

  });




//   document.getElementById("loginBtn").addEventListener("click", async () => {
//     // When the user clicks, we start the login process.
//     // First we have to create and AuthClient.
//     const authClient = await AuthClient.create();
//     // Find out which URL should be used for login.
//     const iiUrl = document.getElementById("iiUrl").value;
  
//     // Call authClient.login(...) to login with Internet Identity. This will open a new tab
//     // with the login prompt. The code has to wait for the login process to complete.
//     // We can either use the callback functions directly or wrap in a promise.
//     await new Promise((resolve, reject) => {
//       authClient.login({
//         identityProvider: iiUrl,
//         onSuccess: resolve,
//         onError: reject,
//       });
//     });
//       // At this point we're authenticated, and we can get the identity from the auth client:
//       const identity = authClient.getIdentity();
//       // Using the identity obtained from the auth client, we can create an agent to interact with the IC.
//       const agent = new HttpAgent({ identity });
//       // Using the interface description of our webapp, we create an actor that we use to call the service methods.
//       // const webapp = Actor.createActor(webapp_idl, {
//       //   agent,
//       //   canisterId: webapp_id,
//       // });
//       // Call whoami which returns the principal (user id) of the current user.
//       const principal = await webapp.whoami();
//       // show the principal on the page
//       document.getElementById("loginStatus").innerText = principal.toText();
//     });
