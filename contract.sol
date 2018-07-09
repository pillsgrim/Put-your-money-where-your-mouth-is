pragma solidity ^0.4.22;

//authors:alexandru dirman
//july-2018
//dcipher.io - "put your money where you mouth is" - escrow solution


contract proforma  {
    address public owner;
    
    event Receive(uint value);
    
    struct proformaStruct {
        address client;     //the person who pay the money
        string fName;
        string lName;
        string email;
        address company;    //who receive the request(money)
        address validator;  //the person who says if the task is completed or not
        
        uint pay_step1;      //answer client email(request),50% return to client of total amount if the company respond in 24 h
        uint pay_step2;      //sent to client initial documentation(offer,research,demo...),  pay_step1+25% of total amount
        uint pay_step3;      //return the rest of 25 % to the client if the offer is accepted by the client
        uint commission_company;    //if the client reject the offer, we keep 25%
        
        bool iscompleted ;    //client step validation
        }
        
    struct TransactionStruct
        {                        
            //Links to transaction from buyer
            address client;             //person who is making payment
            uint client_nounce;         //nounce of client transaction                            
        }

    //database of clients, each client then contain an array of his transactions
    //    mapping(address => proformaStruct[]) public clientsDatabase;
     
        //mapping addresses- clients
    mapping (address => proformaStruct) clients;
    //define an address array that will store all of the instructor addresses
    address[] public clientsDatabase; 
    
            //Every address have a Funds bank. All refunds, sales and escrow comissions are sent to this bank. Address owner can withdraw them at any time.
        mapping(address => uint) public restCompanyAmount;

        mapping(address => uint) public companyFee1;
        mapping(address => uint) public companyFee2;
        mapping(address => uint) public companyFee3;
        
        
        
        /// @dev allows only the owner to call functions with this modifier
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }   
    
    //view the balance in contract
    function getBalanceContract() constant returns(uint){
        return this.balance;
    }
    

    //set the owner of the contract  
    constructor () public {
         owner = msg.sender;
        } 
        
        //Accept any amount of eth and transfer the difference back to the customer
        function payAmountReturnChange(address to) payable onlyOwner{
          uint fixAmount = 1000000000000000000 wei;
          require (msg.value >= fixAmount);
          uint moneyToReturn = msg.value - fixAmount; 
        
          if(moneyToReturn > 0)
            to.transfer(moneyToReturn);
        }
        
        uint step1 = 1000000000000000000 wei;
        uint step2 = 500000000000000000 wei;
        uint step3 = 500000000000000000 wei;
        
        function overallStepsPay() constant returns (uint, uint, uint) {
            return (step1,step2,step3);
        }
        
        /*  
        //step1 = 50 % fee
        uint step1 = msg.value/2;
        //  restCompanyAmount[owner] += step1; 
        
        //step2 = 25 % fee
        uint step2 = step1/2;
        
        //
        uint step3 = 0;
        */
        
        
        
        /*
        
        function payStep1(uint step1) {
        //company step1 fee = 50% from 1 eth
          require (step1 == 1000000000000000000 wei);
          //companyFee1[msg.sender] = step1;
        }
        
        function payStep2(uint step2) {
        //company step2 fee = 25%
          require (step2 == 5000000000 wei);
          //companyFee2[msg.sender] = step2;
        }
        
        function payStep3(uint step3) {
        //company step3 fee = 25%
          require (step3 == 5000000000 wei);
          //companyFee3[msg.sender] = step3;
        }
        */
        
        /*
        function getpayStep1(address companyAddress) constant returns (uint) {
            return (companyFee1[companyAddress]);
        }
        
        function getpayStep2(address companyAddress) constant returns (uint) {
            return (companyFee2[companyAddress]);
        }
        
        function getpayStep3(address companyAddress) constant returns (uint) {
            return (companyFee3[companyAddress]);
        }
        
        */
        


    mapping (address => uint256) public balances;

    function setClient(address _address, string _fName, string _lName, string _email) payable returns(bool success) {
       //require(msg.value > 0 && msg.sender != companyAddress);
       var client = clients[_address];

        client.fName = _fName;
        client.lName = _lName;
        client.email   =_email;
        
        clientsDatabase.push(_address) -1;
        
        balances[msg.sender] += msg.value;
        return true;
    }

    //similar to withdraw but ether is sent to specified address, not the caller
    function transfer(address to, uint value) returns(bool success)  {
        if(balances[msg.sender] < value) throw;
        balances[msg.sender] -= value;
        to.transfer(value);
        return true;
    }
    
    function transferStep1(address to, uint step1) returns(bool success) {
        if(balances[msg.sender] < 1000000000000000000 wei) throw;
        balances[msg.sender] -= step1;
        to.transfer(step1);
        return true;
    }
    
    
    //Get an array with all clients registered
    function getClientsList() view public returns (address[]) {
        return clientsDatabase ;
    }
    
    //get fname and last name, email
    function getAllClientDetails(address cli) view public returns (string, string, string){
        return (clients[cli].fName, clients[cli].lName, clients[cli].email);
    }
    
    //count the clients
    function countNoClients() view public returns (uint){
        return clientsDatabase.length;
    }
    
//     function setCompleted(uint completed) public restricted {
//    last_completed_migration = completed;
//  } 
    
        
   
   /* 
    function setcommissionCompany(uint comission){
        require comission = 50;
        commissionCompany[msg.sender]=comission;
    }
        
    //used by the company in 24 h to accept the ticket
    //used to sent back to client 50 % of total amount
    function answerRequest() public {
      uint backToClient  = msg.value/2;
      balanceOf[msg.sender] += backToClient;
     
    } 
    */
         
         

         //function for the contract to accept ethereum
           function() payable public{}
           
           function kill() public {
        if(msg.sender == owner)
            selfdestruct(owner);
    }
        
        
}
