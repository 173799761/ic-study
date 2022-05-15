import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Nat8 "mo:base/Nat8";
import Time "mo:base/Time";
import Int "mo:base/Int";
module {
   
    public type TokenInfo = {
        tokenId : TokenId;
        file : Text;
        name : Text;
        link : Text;
        description : Text;
    };

    public type TokenMeta = {
        tokenId : TokenId;
        file : Text;
        name : Text;
        link : Text;
        description : Text;
    };

    public type TokenId = Text;
    public let equal = Text.equal;
    public let hash = Text.hash;

    public class TokenUtil() {
        //tokenId生成 时间戳+index
        var token_index : Nat = 0;
        public func generate () : TokenId {
            token_index += 1;
            return Int.toText(token_index);
        };
    };
}
