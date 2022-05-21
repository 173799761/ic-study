// Persistent logger keeping track of what is going on.

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Deque "mo:base/Deque";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Logger "mo:ic-logger/Logger";

actor class ActorIcLogger() {
  
  stable var state : Logger.State<Text> = Logger.new<Text>(0, null);
  let logger = Logger.Logger<Text>(state);


  // Add a set of messages to the log.
  public shared (msg) func append(msgs: [Text]) {
    logger.append(msgs);
  };

  // Return log stats, where:
  //   start_index is the first index of log message.
  //   bucket_sizes is the size of all buckets, from oldest to newest.
  public query func stats() : async Logger.Stats {
    logger.stats()
  };

  // Return the messages between from and to indice (inclusive).
  public shared query (msg) func view(from: Nat, to: Nat) : async Logger.View<Text> {
    logger.view(from, to)
  };

    //查询日志条数
  public shared query (msg) func logSize() : async Nat {
     let stats : Logger.Stats = logger.stats();
     var counts = 0;
     for (size in Iter.fromArray(stats.bucket_sizes)) {
        counts := counts + size;
     };
     counts;
  };


}
