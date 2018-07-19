const putYourMoney = artifacts.require("putYourMoney");

// Test with Mocha
contract('putYourMoney', function(accounts) {
  // Setup a variable to hold the contract object.
  var putyourmoney

  beforeEach(async() => {
    market = await putYourMoney.new();
  });

  // A convenience to view account balances in the console before making changes.
  printBalances(accounts)
  // Create a test case for retreiving the deployed contract.
  // We pass 'done' to allow us to step through each test synchronously.
  it("Should retrive deployed contract.", function(done) {
    // Check if our instance has deployed
    putYourMoney.deployed().then(function(instance) {
      // Assign our contract instance for later use
      putyourmoney = instance
      console.log('new client', putyourmoney)  
      // Pass test if we have an object returned.
      assert.isOk(putyourmoney)
      // Tell Mocha move on to the next sequential test.
      done()
    })
  })

  // Test for depositing 1 Ether
  it("should deposit exactly 1 ether per client", function(done) {
    // Call the addClient function on the contract. Since that method is tagged payable,
    // we can send Ether by passing an object containing from, to and amount.
    // All transactions are carried sent in wei. We use a web3 utility to convert from Ether.
    putyourmoney.addClient("seba", "dir", "@.com", "srl", 125, 1531906989, 1, 1,{from:accounts[5], to:putyourmoney.address, value: web3.toWei(1, "ether")})
    putyourmoney.addClient("alex", "cri", "@.yahoo", "abc", 146, 1531907989, 1, 1,{from:accounts[6], to:putyourmoney.address, value: web3.toWei(1, "ether")})
    putyourmoney.addClient("boom", "rap", "@.out", "bbb", 178, 1531907678, 1, 1,{from:accounts[7], to:putyourmoney.address, value: web3.toWei(1, "ether")})
    .then(function(tx) {
      // Pass the test if we have a transaction reciept returned.
      assert.isOk(tx.receipt)
      // For convenience, show the balances of accounts after transaction.
      printBalances(accounts)
      done()
    }, function(error) {
        // Force an error if callback fails.
        assert.equal(true, false)
        console.error(error)
        done()
      })
  })

  // test if owner can change steps fee, change another account if you want it failed
  it("works to change the steps fee, just the owner address", function(done) {
    // Call the setAllSteps function on the contract.
    putyourmoney.setAllSteps(600000000000000000,800000000000000000,900000000000000000,{from:accounts[0], to:putyourmoney.address})
    .then(function(tx) {
      // Pass the test if we have a transaction reciept returned.
      assert.isOk(tx.receipt)
      // For convenience, show the balances of accounts after transaction.
      printBalances(accounts)
      done()
    }, function(error) {
        // Force an error if callback fails.
        assert.equal(true, false)
        console.error(error)
        done()
      })
  })

//test if there are exactly 3 clients
  it("there are 3 clients registered in smart contract", function() {
    return putYourMoney.deployed().then(function(instance){
     return putyourmoney.countNoClients.call();
    }).then(function(result){
     assert.equal(result.toNumber(), '3', 'there are not 3 clients registered in smartcontract');
    })
  });

  //test if there are exactly 3 eth in smartcontract
  it("contract balance equal to 3 ethers", function() {
    return putYourMoney.deployed().then(function(instance){
     return putyourmoney.getContractBalance.call();
    }).then(function(result){
     assert.equal(result.toNumber(), '3000000000000000000', 'the balance not equal with 3 ethers');
    })
  });


  //check that line in putyourmoney.sol, change the epoch time to test it: require (1532268549 >= clients[id-1].creationTime + 1 days);
  //change the from address if you want to test it failed, just accounts 5 6 7 works
    it("transfer first payment if it pass all steps", function() {
        return putYourMoney.deployed().then(function(instance) {
           // return putyourmoney.web3.eth.getBalance(putYourMoney.address).call(accounts[5]);
        }).then(function(balance){
            startingBalance = balance;
            return putyourmoney.transferStep2(accounts[1], {from: accounts[5]});
        }).then(function() {
           // return putyourmoney.web3.eth.getBalance(putYourMoney.address).call(accounts[5]);
        }).then(function(balance) {
            assert.equal(startingBalance, balance);
        })
    });

    
  //check that line in putyourmoney.sol, change the epoch time to test it: require (1537625349 >= clients[id-1].creationTime + 7 days);
  //change the from address if you want to test it failed, just accounts 5 6 7 works
  it("transfer back second payment if it pass all steps", function() {
    return putYourMoney.deployed().then(function(instance) {
       // return putyourmoney.web3.eth.getBalance(putYourMoney.address).call(accounts[5]);
    }).then(function(balance){
        startingBalance = balance;
        return putyourmoney.transferStep2(accounts[2], {from: accounts[6]});
    }).then(function() {
       // return putyourmoney.web3.eth.getBalance(putYourMoney.address).call(accounts[5]);
    }).then(function(balance) {
        assert.equal(startingBalance, balance);
    })
});


  // utility function to display the balances of each account.
  function printBalances(accounts) {
    accounts.forEach(function(ac, i) {
      console.log(i, web3.fromWei(web3.eth.getBalance(ac), 'ether').toNumber())
    })
  }
})