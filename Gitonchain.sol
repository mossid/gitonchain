pragma solidity ^0.4.11;

contract Controller {
    // Eternal storage

    mapping (bytes32 => uint) private UintStorage;
    mapping (bytes32 => bool) private BoolStorage;

    // Permissions

    mapping (address => bool) private permitted;

    modifier onlyPermitted() {
        assert(permitted[msg.sender] || msg.sender == address(this));
        _;
    }

    // Accessors

    function getUint(bytes32 record) public constant returns (uint) {
        return UintStorage[record];
    }

    function setUint(bytes32 record, uint value) public onlyPermitted {
        UintStorage[record] = value;
    }

    function getBool(bytes32 record) public constant returns (bool) {
        return BoolStorage[record];
    }

    function setBool(bytes32 record, bool value) public onlyPermitted {
        BoolStorage[record] = value;
    }

    function permit(address handler) public onlyPermitted {
        permitted[handler] = true;
    }
 
    function addHandler(bytes methodid, address handler) public onlyPermitted {
        handlers[keccak256(methodid)] = handler;
        permit(handler);
    }

    function getHandler(bytes methodid) public constant returns (address) {
        return handlers[keccak256(methodid)];
    } 

    mapping (bytes32 => address) public handlers;

    function() public {
        bytes memory methodid = new bytes(4);
        for (uint i = 0; i < 4; i++) {
            methodid[i] = msg.data[i];
        }   
        bytes32 hash = keccak256(methodid);
        assert(handlers[hash] != 0);
        assert(handlers[hash].delegatecall(msg.data, this));
    }

    function Controller() {
        permit(msg.sender);
    }
}


