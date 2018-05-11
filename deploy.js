const path = require('path');
const fs = require('fs');

const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const {interface, bytecode} = require('./compile');

let filepath = path.resolve(__dirname, 'mnemonics', 'seed words.txt');
const words = fs.readFileSync(filepath, 'utf8');
filepath = path.resolve(__dirname, 'mnemonics', 'infura id.txt');
const infuraId = fs.readFileSync(filepath, 'utf8');

console.log('seed words are: ', words);
console.log('infura id: ', infuraId);

const provider = new HDWalletProvider(
    words,
    'https://rinkeby.infura.io/' + infuraId
);

const web3 = new Web3(provider);

// this is wrapped into a function because await cannot
// be used outside of a function
const deploy = async () => {
    const accounts = await web3.eth.getAccounts();
    console.log('attempting to deploy from account', accounts[0]);

    const result = await new web3.eth.Contract(JSON.parse(interface))
        .deploy({data: '0x' + bytecode})
        .send({from: accounts[0], gas:'1000000'});
        
    console.log('Contract deployed to', result.options.address);
}
deploy();