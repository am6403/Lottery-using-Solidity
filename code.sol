
pragma solidity ^ 0.8.7;

contract lottery{

    address public manager;
    address payable[] public players;
    
    constructor ()public{
        manager=msg.sender;
    }

    function alreadyenter()view private returns(bool){
        for(uint i=0;i<players.length;i++){
            if(players[i]==msg.sender){
                return true;
            }
            return false;
        }
    }

    function enter() payable public{
        require(msg.sender!=manager,"Manager can't Enter");
        require(msg.value>=1 ether,"MInimum amount to pay");
        require(alreadyenter()==false);
        players.push(payable(msg.sender));
    }
    
    function random() view private returns(uint){
        return uint(sha256(abi.encodePacked(block.difficulty,block.number,players)));
    }

    function pickwinner() public{
        require(msg.sender==manager);
        uint index=random()%players.length;
        address contractaddress=address(this);
        players[index].transfer(contractaddress.balance);
    }

}
