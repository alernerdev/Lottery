pragma solidity ^0.4.21;

contract Lottery {
    address public manager;
    address[] public players;
    
    constructor() public {
        // msg is a global variable that has some context: sender, gas, etc.
        manager = msg.sender;
    }
 
    // the underscore is the placeholder for where the function body goes
    modifier restricted() {
        // make sure the caller who calls this function is actually the manager
        require(msg.sender == manager);
        _;
    }   
    
    function enter() public payable {
        // need to send this much ether to play the game
        require(msg.value > .01 ether);
        
        players.push(msg.sender);
    }
    
    function pickWinner() public restricted {
        uint index = pseudoRandom() % players.length;
        address addr = players[index];
        addr.transfer(this.balance);
        
        // reset the contract by clearing out the players
        // this is dynamic array with initial size of zero
        players = new address[](0);
    }
    
    function getPlayers() public view returns(address[]) {
        return players;
    }
    
    // solidity does not have random number generator -- so this is faking it
    // mixing current block difficulty, addresses of players and current time
    function pseudoRandom() private view returns(uint) {
        // keccac256 is sha3
        return uint(keccak256(block.difficulty, now, players));
    }
}