pragma solidity^0.4.24;

//authors:dcipher.io
//july-2018
//dcipher.io - "put your money where you mouth is" - escrow solution

import './ownable1.sol';

contract putYourMoney is Ownable{
    
    // modifier = a check if the value equal to n before the function is executed
    modifier fixAmmount(uint value){
        // msg.value should be exactly n ether, else it will throw error
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
        uint  creationTime;
        uint  step2valid;
        uint  step3valid;
    }
    
    //store the client structure into clients array
    Client[] clients; 
    //specify an address to a client
    mapping (address => uint) clientAddress;

    //event to get fired when someone add a new client
    event addedClient(address owner, uint clientId, string fName, string lName, string email, string company, uint mobile, uint creationTime, uint step2valid, uint step3valid);
    
    //add new client into array list
    function addClient(string _fName, string _lName, string _email, string _company, uint _mobile, uint _creationTime, uint _step2valid, uint _step3valid) public  payable fixAmmount(1000000000000000000){
        _creationTime = now;     //get the current timestamp when a new client register
        _step2valid = 1;         //default value (acting as a false value for step2), if _step2valid = 2 it's acting as true
        _step3valid = 1;        //default value (acting as a false value for step3), if _step3valid = 2 it's acting as true
        address owner = msg.sender;      //set an address for each client
        uint id = clients.push(Client(_fName, _lName, _email, _company,  _mobile, _creationTime, _step2valid, _step3valid));  //set an id and push all the info into it
        clientAddress[owner] = id;       //save in id your client structure
        
        emit addedClient(owner, id, _fName, _lName, _email, _company, _mobile,  _creationTime, _step2valid, _step3valid);   //fire the events to see them in our webpage, without emit is deprecated
        
        balances[msg.sender] += msg.value;  //balance of each sender(client)
    }
    
    /*
    //view clients with all details
    function getClients(uint _id) view returns (string, string, string, string, uint, uint) {
      return (clients[_id].fName,clients[_id].lName,clients[_id].email, clients[_id].company, clients[_id].mobile, clients[_id].creationTime);
        }
    */
    
    //count how many clients are registered
    function countNoClients() view public returns (uint){
        return clients.length;
    }    
        
    
    //just the owner can see his details
    function getOwnerClientDetails() view returns (string, string, string, string, uint, uint, uint, uint)  {
        address owner = msg.sender;
        uint id = clientAddress[owner];
      return (clients[id-1].fName,clients[id-1].lName,clients[id-1].email, clients[id-1].company, clients[id-1].mobile, clients[id-1].creationTime, clients[id-1].step2valid, clients[id-1].step3valid);
        }
    
    //set the owner of the contract  
    constructor () public {
         owner = msg.sender;
        } 
    
    //view the balance in contract
    function getContractBalance()  public constant returns(uint){
        return address(this).balance;
    }
    
    
    //Set the default steps fee hardcoded
        uint step1 = 1000000000000000000 wei;
        uint step2 = 500000000000000000 wei;
        uint step3 = 500000000000000000 wei;
        
    //after deploying the contract, owner can define all the steps fee together
        function setStepsFee(uint _step1, uint _step2, uint _step3) public onlyOwner{
            step1 = _step1;
            step2 = _step2;
            step3 = _step3;
        }
        
    //after deploying the contract, owner can define just the value of step1
        function setValueStep1(uint _step1) public onlyOwner{
            step1 = _step1;
        }
        //after deploying the contract, owner can define just the value of step2
        function setValueStep2(uint _step2) public onlyOwner{
            step2 = _step2;
        }
    //after deploying the contract, owner can define just the value of step3
        function setValueStep3(uint _step3) public onlyOwner{
            step3 = _step3;
        }
        
        
    //view all steps     
    function getAllSteps() public view returns (uint, uint, uint) {
        return (step1,step2,step3);
        }
    
    mapping (address => uint256) public balances;
    //similar to withdraw but ether is sent to specified address, not the caller
    /*
    function transfer(address to, uint value) returns(bool success)  {
        if(balances[msg.sender] < value) throw;
        balances[msg.sender] -= value;
        to.transfer(value);
        return true;
    }
    */
    
    function transferStep2(address to) returns(bool)  {
        uint id = clientAddress[msg.sender];
        require (clients[id-1].step2valid == 1);
        require (1531645782 >= clients[id-1].creationTime + 1 days);
        if(balances[msg.sender] <= step2) throw;
            balances[msg.sender] -= step2;
            to.transfer(step2);
            clients[id-1].step2valid = 2;
        return true;
    }
    
    function transferStep3(address to) returns(bool)  {
        uint id = clientAddress[msg.sender];
        require (clients[id-1].step3valid == 1);
        require (now >= clients[id-1].creationTime + 7 days);
        if (balances[msg.sender] <= step3) throw;
            balances[msg.sender] -= step3;
            to.transfer(step3);
            clients[id-1].step3valid = 2;
        return true;
    }

    //withdraw the remaining eth from contract
    function withdrawEther() external onlyOwner {
    owner.transfer(address(this).balance);
    }
    
    //kill the contract
    function kill() public onlyOwner{
        if(msg.sender == owner)
            selfdestruct(owner);
    }
    
}
