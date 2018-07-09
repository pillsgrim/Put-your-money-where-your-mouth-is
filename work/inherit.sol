pragma solidity^0.4.0;

import './putYourMoney.sol';

//we create an interface, we need to tell it what to return, just the function definition from another contract, not the body
//we need to deploy the other contract to get the address
contract BankInterface{
    function getBalance() view returns (uint);
    function deposit() payable;
}


contract inherit is putYourMoney{
    
    // before function is executed
    modifier fixAmmount(uint value){
        //if msg.value is less than value it throw error
        require(msg.value >= value);
            _; //continue to execute the funciton
         
    }
    
    //input the new address of external contract
    function initBank(address _bankAddress) onlyOwner{
        BankContract = BankInterface(_bankAddress);
    }
    
    //we name BankInterface to BankContract, as parameter it has exeternalAddress
    BankInterface BankContract;

    
    //just the owner of previous address can transfer to new address
    //it first verify the amount, then the function is executed if the amount is right
    //easy to read that way, it also could be used in another function with another value
    function transferClient(address _newowner) payable fixAmmount(1000000000000000000){
            address owner = msg.sender;    //initial owner
            require(owner != _newowner);   //owner to be another one, not old owner
            uint clientId = clientAddress[owner];  //owner = id
            delete(clientAddress[owner]);  //delete the first owner
            clientAddress[_newowner] = clientId;  // set a new owner
            assert(clientAddress[owner] == 0);   //for error hendling
           // BankContract.deposit.value(msg.value)();// move money to bankcontract address
    }
    
    //getBalance from bankInterface
    function getBankBalance() view returns (uint){
        return BankContract.getBalance();
    }
    
    //if in company.sol the function visibility is internal, we have to create new function which inherit the addClient function from company.sol to create new client
    function addNewClient(string _fName, string _lName, string _email, string _company, uint _mobile) payable fixAmmount(1000000000000000000) {
        addClient(_fName,  _lName,  _email,  _company, _mobile);
        BankContract.deposit.value(msg.value)();// move money to bankcontract address
    }
    
}