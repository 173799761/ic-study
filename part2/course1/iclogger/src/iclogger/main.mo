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

  //当前的Log Canister对象
  private var curLogCanister : ?ActorIcLoggers.ActorIcLogger = null;

 //获取当前的 Log Canister 对象，当日志满100行时候,自动创建新的Log Canister
  private func getCurLogCanister() : async ActorIcLoggers.ActorIcLogger{
    switch(curLogCanister) {
      case null { 
        let logCanister : ActorIcLoggers.ActorIcLogger = await ActorIcLoggers.ActorIcLogger();
        curLogCanister :=  ?logCanister;
        logCanister;
      };
      case (?logCanister) {
        // 需要判断当前Logger 的 canister 是否达到最大值，达到最大值时，需要新创建
        let size = await logCanister.logSize();
        if(size >= 100) {
          let newLogger : ActorIcLoggers.ActorIcLogger = await ActorIcLoggers.ActorIcLogger();
          curLogCanister :=  ?newLogger;
          newLogger;
        } else {
          logCanister;
        };
      };
    };
  };

  // Add a set of messages to the log.
  public shared (msg) func append(msgs: [Text]) {
    var logger : ActorIcLoggers.ActorIcLogger = await getCurLogCanister();
    logger.append(msgs);
  };

  // Return log stats, where:
  //   start_index is the first index of log message.
  //   bucket_sizes is the size of all buckets, from oldest to newest.
  public  func stats() : async Logger.Stats {
    var logger : ActorIcLoggers.ActorIcLogger = await getCurLogCanister();
    await logger.stats()
  };

  // Return the messages between from and to indice (inclusive).
  public shared  (msg) func view(from: Nat, to: Nat) : async Logger.View<Text> {
    var logger : ActorIcLoggers.ActorIcLogger = await getCurLogCanister();
    await logger.view(from, to)
  };


}
