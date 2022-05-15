// Persistent logger keeping track of what is going on.

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Deque "mo:base/Deque";
import List "mo:base/List";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Map "mo:base/HashMap";
import Logger "mo:ic-logger/Logger";
import ActorIcLoggers "ActorIcLoggers";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Types "types";
shared(msg) actor class Main() {

  type ActorIcLogger = ActorIcLoggers.ActorIcLogger;
  stable var canisterIdx : Nat = 0;//canister索引,当满100条记录后增1


  let eq: (Nat, Nat) -> Bool = func(x, y) { x == y };
  var cMaps: Map.HashMap<Nat, ActorIcLoggers.ActorIcLogger> = Map.HashMap<Nat, ActorIcLoggers.ActorIcLogger>(0, eq, Hash.hash);


   func _getCurLogger() : async ActorIcLoggers.ActorIcLogger{
        switch (cMaps.get(canisterIdx)) {
            case null { 
                 canisterIdx += 1;
                 var x = await ActorIcLoggers.ActorIcLogger(canisterIdx);
                 cMaps.put(canisterIdx,x);
                 x;
                //return x;
            };
            case _{
                var y = cMaps.get(canisterIdx);
                if(y.size > 100){
                  canisterIdx += 1;
                  var x = await ActorIcLoggers.ActorIcLogger(canisterIdx);
                  cMaps.put(canisterIdx,x);
                  x;
                }else{
                  y;
                }
            };
        };
  };

  //新增日志
  public shared (msg) func append(msgs: [Text]) {
    var x : ActorIcLogger =  await _getCurLogger();
    x.append(msgs);
  };

  //查看状态
  public query func stats() : async Logger.Stats {
    var x : ActorIcLogger =  await _getCurLogger();
    x.stats();
  };


}
