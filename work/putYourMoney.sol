pragma solidity^0.4.0;

import './ownable.sol';

contract putYourMoney is Ownable{
    
    // modifier = a check if the value is right before executed the function
    modifier fixAmmount(uint value){
        //if msg.value is less than value it throw error
        require(msg.value >= value);
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
    
    //event to get fired when someone add a new client
    event addedClient(address owner, uint clientId, string fName, string lName, string email, string company, uint mobile );
    
    //add new client into array list
    function addClient(string _fName, string _lName, string _email, string _company, uint _mobile)  internal{
        address owner =msg.sender;      //set an address for each client
        uint id = clients.push(Client(_fName, _lName, _email, _company, _mobile));  //set an id for each owner
        clientAddress[owner] = id;     //save in id your client structure
        addedClient(owner, id, _fName, _lName, _email, _company, _mobile);   //fire the events to see them in our webpage
        
    }
    
    //view clients with all details
    function getClients(uint _id) view returns (string, string, string, string, uint) {
      return (clients[_id].fName,clients[_id].lName,clients[_id].email, clients[_id].company, clients[_id].mobile);
        }
    
    //just the owner can see his details
    function getOwnerClientDetails() returns (string, string, string, string, uint) {
        address owner =msg.sender;
        uint id = clientAddress[owner];
      return (clients[id-1].fName,clients[id-1].lName,clients[id-1].email, clients[id-1].company, clients[id-1].mobile);
        }
    
    
    
    
    
}