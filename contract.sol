pragma solidity ^0.4.24;

//authors:dcipher.io
//july-2018
//dcipher.io - "put your money where you mouth is" - escrow solution


import './ownable1.sol';

contract putYourMoney is Ownable{
    
    // modifier = a check if the value is right before executed the function
    modifier fixAmmount(uint value){
        // msg.value should be exactly 1 ether, else it will throw error
        require(msg.value == value);
            _; //continue to execute the funciton
         
    }
    
    //client structure, all the clients info
    struct Client{
        string fName;
        string lName;
        string email;
        string company;
        uint   mobile;
    }
    
    //store the client structure into clients array
    Client[] clients; 
    //specify an address to a client
    mapping (address => uint) clientAddress;
    
    /*
    mapping (address => Client) clientAddress2;
    address[] public clientsDatabase;
    */
    
    //event to get fired when someone add a new client
    event addedClient(address owner, uint clientId, string fName, string lName, string email, string company, uint mobile);
    
    //add new client into array list
    function addClient(string _fName, string _lName, string _email, string _company, uint _mobile)  payable fixAmmount(1000000000000000000){
        address owner =msg.sender;      //set an address for each client
        uint id = clients.push(Client(_fName, _lName, _email, _company, _mobile));  //set an id for each owner
        clientAddress[owner] = id;     //save in id your client structure
        addedClient(owner, id, _fName, _lName, _email, _company, _mobile);   //fire the events to see them in our webpage
        
    
        balances[msg.sender] += msg.value;
    }
    
    
    
    
    //view clients with all details
    function getClients(uint _id) view returns (string, string, string, string, uint) {
      return (clients[_id].fName,clients[_id].lName,clients[_id].email, clients[_id].company, clients[_id].mobile);
        }
    
    /*
    //Get an array with all clients registered
    function getClientsList() view public returns (address[]) {
        return clientsDatabase;
    }
    */
    
    //count the clients
    function countNoClients() view public returns (uint){
        return clients.length;
    }    
        
    
    //just the owner can see his details
    function getOwnerClientDetails() returns (string, string, string, string, uint) {
        address owner =msg.sender;
        uint id = clientAddress[owner];
      return (clients[id-1].fName,clients[id-1].lName,clients[id-1].email, clients[id-1].company, clients[id-1].mobile);
        }
    
    //set the owner of the contract  
    constructor () public {
         owner = msg.sender;
        } 
    
    
    //view the balance in contract
    function getContractBalance() constant returns(uint){
        return this.balance;
    }
    
    //Set the default steps fee hardcoded
        uint step1 = 1000000000000000000 wei;
        uint step2 = 500000000000000000 wei;
        uint step3 = 500000000000000000 wei;
        bool step1valid = false;
        bool step2valid = false;
        bool step3valid = false;
        
    //after deploying the contract, owner can define all the steps fee together
        function setStepsFee(uint _step1, uint _step2, uint _step3) onlyOwner{
            step1 = _step1;
            step2 = _step2;
            step3 = _step3;
        }
        
    //after deploying the contract, owner can define just the value of step1
        function setStep1(uint _step1) onlyOwner{
            step1 = _step1;
        }
        //after deploying the contract, owner can define just the value of step2
        function setStep2(uint _step2) onlyOwner{
            step2 = _step2;
        }
    //after deploying the contract, owner can define just the value of step3
        function setStep3(uint _step3) onlyOwner{
            step3 = _step3;
        }
        
    //view all steps     
    function getAllSteps() constant returns (uint, uint, uint) {
        return (step1,step2,step3);
        }
    
    mapping (address => uint256) public balances;
    //similar to withdraw but ether is sent to specified address, not the caller
    function transfer(address to, uint value) returns(bool success)  {
        if(balances[msg.sender] < value) throw;
        balances[msg.sender] -= value;
        to.transfer(value);
        return true;
    }
    
    function transferStep2(address to) returns(bool success) {
        if(balances[msg.sender] < step2) throw;
        balances[msg.sender] -= step2;
        to.transfer(step2);
        return true;
    }
    
    function transferStep3(address to) returns(bool success)  {
        if(balances[msg.sender] < step3) throw;
        balances[msg.sender] -= step3;
        to.transfer(step3);
        return true;
    }
    
    //withdraw the remaining eth
    function withdrawEther() external onlyOwner {
    owner.transfer(this.balance);
    }
    
    
    
    //kill the contract
    function kill() public onlyOwner{
        if(msg.sender == owner)
            selfdestruct(owner);
    }
    
}
