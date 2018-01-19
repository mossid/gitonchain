pragma solidity ^0.4.11;

contract ExampleHandler {
    struct S {
        uint a;
        bool b;
    }

    // mapping (uint => S) s;
    function getSa(uint idx, Controller c) constant returns (uint) {
        return c.getUint(keccak256('ExampleHandler', 's', 'a'));
    }

    function getSb(uint idx, Controller c) constant returns (bool) {
        return c.getBool(keccak256('ExampleHandler', 's', 'b'));
    }

    function getS(uint idx, Controller c) constant returns (S) {
        return S(getSa(idx, c), getSb(idx, c));
    }

    function setSa(uint idx, uint value, Controller c) private {
        c.setUint(keccak256('ExampleHandler', 's', 'a'), value);
    }

    function setSb(uint idx, bool value, Controller c) private {
        c.setBool(keccak256('ExampleHandler', 's', 'b'), value);
    }

    function setS(uint idx, S value, Controller c) public {
        setSa(idx, value.a, c);
        setSb(idx, value.b, c);
    }
}
