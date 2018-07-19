const path = require('path');
const fs = require('fs');
const solc = require('solc');

const putyourmoneyPath = path.resolve(__dirname, 'contracts', 'putyourmoney.sol');
const source = fs.readFileSync(putyourmoneyPath, 'utf8');

module.exports = solc.compile(source, 1).contracts[':putyourmoney'];