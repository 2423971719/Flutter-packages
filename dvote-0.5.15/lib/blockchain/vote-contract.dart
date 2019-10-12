final votingProcessAbi = [
  {
    "constant": true,
    "inputs": [
      {"name": "processId", "type": "bytes32"}
    ],
    "name": "getPrivateKey",
    "outputs": [
      {"name": "privateKey", "type": "string"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "getGenesis",
    "outputs": [
      {"name": "", "type": "string"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "getChainId",
    "outputs": [
      {"name": "", "type": "uint256"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "getOracles",
    "outputs": [
      {"name": "", "type": "string[]"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {"name": "processId", "type": "bytes32"}
    ],
    "name": "getResults",
    "outputs": [
      {"name": "results", "type": "string"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {"name": "newValue", "type": "string"}
    ],
    "name": "setGenesis",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {"name": "", "type": "uint256"}
    ],
    "name": "processes",
    "outputs": [
      {"name": "entityAddress", "type": "address"},
      {"name": "metadata", "type": "string"},
      {"name": "censusMerkleRoot", "type": "string"},
      {"name": "censusMerkleTree", "type": "string"},
      {"name": "voteEncryptionPrivateKey", "type": "string"},
      {"name": "canceled", "type": "bool"},
      {"name": "results", "type": "string"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {"name": "metadata", "type": "string"},
      {"name": "merkleRoot", "type": "string"},
      {"name": "merkleTree", "type": "string"}
    ],
    "name": "create",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {"name": "entityAddress", "type": "address"}
    ],
    "name": "getNextProcessId",
    "outputs": [
      {"name": "", "type": "bytes32"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {"name": "str1", "type": "string"},
      {"name": "str2", "type": "string"}
    ],
    "name": "equalStrings",
    "outputs": [
      {"name": "", "type": "bool"}
    ],
    "payable": false,
    "stateMutability": "pure",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {"name": "", "type": "address"}
    ],
    "name": "entityProcessCount",
    "outputs": [
      {"name": "", "type": "uint256"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {"name": "idx", "type": "uint256"},
      {"name": "oraclePublicKey", "type": "string"}
    ],
    "name": "removeOracle",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {"name": "idx", "type": "uint256"},
      {"name": "validatorPublicKey", "type": "string"}
    ],
    "name": "removeValidator",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {"name": "processId", "type": "bytes32"}
    ],
    "name": "get",
    "outputs": [
      {"name": "entityAddress", "type": "address"},
      {"name": "metadata", "type": "string"},
      {"name": "censusMerkleRoot", "type": "string"},
      {"name": "censusMerkleTree", "type": "string"},
      {"name": "voteEncryptionPrivateKey", "type": "string"},
      {"name": "canceled", "type": "bool"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {"name": "processId", "type": "bytes32"},
      {"name": "privateKey", "type": "string"}
    ],
    "name": "publishPrivateKey",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {"name": "validatorPublicKey", "type": "string"}
    ],
    "name": "addValidator",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "getValidators",
    "outputs": [
      {"name": "", "type": "string[]"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {"name": "processId", "type": "bytes32"}
    ],
    "name": "cancel",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {"name": "processId", "type": "bytes32"}
    ],
    "name": "getProcessIndex",
    "outputs": [
      {"name": "", "type": "uint256"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {"name": "oraclePublicKey", "type": "string"}
    ],
    "name": "addOracle",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {"name": "processId", "type": "bytes32"},
      {"name": "results", "type": "string"}
    ],
    "name": "publishResults",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {"name": "newValue", "type": "uint256"}
    ],
    "name": "setChainId",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {"name": "entityAddress", "type": "address"}
    ],
    "name": "getEntityProcessCount",
    "outputs": [
      {"name": "", "type": "uint256"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {"name": "entityAddress", "type": "address"},
      {"name": "processCountIndex", "type": "uint256"}
    ],
    "name": "getProcessId",
    "outputs": [
      {"name": "", "type": "bytes32"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"name": "chainIdValue", "type": "uint256"}
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": false, "name": "genesis", "type": "string"}
    ],
    "name": "GenesisChanged",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": false, "name": "chainId", "type": "uint256"}
    ],
    "name": "ChainIdChanged",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": true, "name": "entityAddress", "type": "address"},
      {"indexed": false, "name": "processId", "type": "bytes32"},
      {"indexed": false, "name": "merkleTree", "type": "string"}
    ],
    "name": "ProcessCreated",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": true, "name": "entityAddress", "type": "address"},
      {"indexed": false, "name": "processId", "type": "bytes32"}
    ],
    "name": "ProcessCanceled",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": false, "name": "validatorPublicKey", "type": "string"}
    ],
    "name": "ValidatorAdded",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": false, "name": "validatorPublicKey", "type": "string"}
    ],
    "name": "ValidatorRemoved",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": false, "name": "oraclePublicKey", "type": "string"}
    ],
    "name": "OracleAdded",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": false, "name": "oraclePublicKey", "type": "string"}
    ],
    "name": "OracleRemoved",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": true, "name": "processId", "type": "bytes32"},
      {"indexed": false, "name": "privateKey", "type": "string"}
    ],
    "name": "PrivateKeyPublished",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": true, "name": "processId", "type": "bytes32"},
      {"indexed": false, "name": "results", "type": "string"}
    ],
    "name": "ResultsPublished",
    "type": "event"
  }
];

final votingProcessBytecode =
    "0x60806040523480156200001157600080fd5b506040516020806200274e833981018060405262000033919081019062000063565b600080546001600160a01b031916331790556004556200008f565b60006200005c82516200008c565b9392505050565b6000602082840312156200007657600080fd5b60006200008484846200004e565b949350505050565b90565b6126af806200009f6000396000f3fe608060405234801561001057600080fd5b50600436106101585760003560e01c80638ceb30c2116100c3578063c585ad911161007c578063c585ad91146102eb578063c994bc86146102fe578063ec8f670e14610311578063ef0e2ff414610324578063f2bcb15e14610337578063f3b86c991461034a57610158565b80638ceb30c2146102725780638eaa6ac014610285578063a803dc4c146102aa578063b5da04f5146102bd578063b7ab4db5146102d0578063c4d252f5146102d857610158565b8063579e51c711610115578063579e51c7146101e05780635d28560a1461020657806368141f2c14610219578063791f03331461022c5780637c09faeb1461024c5780637f07492d1461025f57610158565b8063182087921461015d5780631a43bcb5146101865780633408e4701461018e57806340884c52146101a357806346475c4c146101b857806347bb3da7146101cb575b600080fd5b61017061016b366004611cd9565b61035d565b60405161017d91906124b7565b60405180910390f35b61017061041c565b6101966104b3565b60405161017d9190612489565b6101ab6104b9565b60405161017d919061246a565b6101706101c6366004611cd9565b610591565b6101de6101d9366004611d3f565b610618565b005b6101f36101ee366004611cd9565b610755565b60405161017d97969594939291906123e0565b6101de610214366004611daa565b610a66565b610196610227366004611c79565b610cd2565b61023f61023a366004611d74565b610cf1565b60405161017d919061247b565b61019661025a366004611c79565b610d4b565b6101de61026d366004611cf7565b610d5d565b6101de610280366004611cf7565b610ebe565b610298610293366004611cd9565b610fb0565b60405161017d9695949392919061236a565b6101de6102b8366004611cf7565b6112ef565b6101de6102cb366004611d3f565b611411565b6101ab6114b2565b6101de6102e6366004611cd9565b611581565b6101966102f9366004611cd9565b6116a2565b6101de61030c366004611d3f565b6116b4565b6101de61031f366004611cf7565b611756565b6101de610332366004611cd9565b611949565b610196610345366004611c79565b6119d0565b610196610358366004611c9f565b6119eb565b6060600061036a836116a2565b90506005818154811061037957fe5b6000918252602091829020600460079092020101805460408051601f600260001961010060018716150201909416939093049283018590048502810185019091528181529283018282801561040f5780601f106103e45761010080835404028352916020019161040f565b820191906000526020600020905b8154815290600101906020018083116103f257829003601f168201915b5050505050915050919050565b60038054604080516020601f60026000196101006001881615020190951694909404938401819004810282018101909252828152606093909290918301828280156104a85780601f1061047d576101008083540402835291602001916104a8565b820191906000526020600020905b81548152906001019060200180831161048b57829003601f168201915b505050505090505b90565b60045490565b60606002805480602002602001604051908101604052809291908181526020016000905b828210156105885760008481526020908190208301805460408051601f60026000196101006001871615020190941693909304928301859004850281018501909152818152928301828280156105745780601f1061054957610100808354040283529160200191610574565b820191906000526020600020905b81548152906001019060200180831161055757829003601f168201915b5050505050815260200190600101906104dd565b50505050905090565b6060600061059e836116a2565b9050600581815481106105ad57fe5b6000918252602091829020600660079092020101805460408051601f600260001961010060018716150201909416939093049283018590048502810185019091528181529283018282801561040f5780601f106103e45761010080835404028352916020019161040f565b6000546001600160a01b0316331461064e57604051600160e51b62461bcd02815260040161064590612509565b60405180910390fd5b60038054604080516020601f600260001961010060018816150201909516949094049384018190048102820181019092528281526106e693909290918301828280156106db5780601f106106b0576101008083540402835291602001916106db565b820191906000526020600020905b8154815290600101906020018083116106be57829003601f168201915b505050505082610cf1565b1561070657604051600160e51b62461bcd028152600401610645906124e9565b8051610719906003906020840190611a25565b507fb07272e5a32a7a57581e0409555209cb59b02e13b62da30135eb3b3431078e36600360405161074a91906124c8565b60405180910390a150565b6005818154811061076257fe5b600091825260209182902060079091020180546001808301805460408051601f60026000199685161561010002969096019093169490940491820187900487028401870190528083526001600160a01b03909316955092939092919083018282801561080f5780601f106107e45761010080835404028352916020019161080f565b820191906000526020600020905b8154815290600101906020018083116107f257829003601f168201915b50505060028085018054604080516020601f60001961010060018716150201909416959095049283018590048502810185019091528181529596959450909250908301828280156108a15780601f10610876576101008083540402835291602001916108a1565b820191906000526020600020905b81548152906001019060200180831161088457829003601f168201915b5050505060038301805460408051602060026001851615610100026000190190941693909304601f81018490048402820184019092528181529495949350908301828280156109315780601f1061090657610100808354040283529160200191610931565b820191906000526020600020905b81548152906001019060200180831161091457829003601f168201915b5050505060048301805460408051602060026001851615610100026000190190941693909304601f81018490048402820184019092528181529495949350908301828280156109c15780601f10610996576101008083540402835291602001916109c1565b820191906000526020600020905b8154815290600101906020018083116109a457829003601f168201915b50505050600583015460068401805460408051602060026101006001861615026000190190941693909304601f8101849004840282018401909252818152959660ff9094169593945090830182828015610a5c5780601f10610a3157610100808354040283529160200191610a5c565b820191906000526020600020905b815481529060010190602001808311610a3f57829003601f168201915b5050505050905087565b6000835111610a8a57604051600160e51b62461bcd02815260040161064590612539565b6000825111610aae57604051600160e51b62461bcd02815260040161064590612549565b6000815111610ad257604051600160e51b62461bcd02815260040161064590612529565b336000610ade82610cd2565b9050610ae8611aa3565b506040805160e0810182526001600160a01b038481168252602080830189815283850189905260608401889052845180830186526000808252608086019190915260a08501819052855180840190965280865260c085019590955260058054600181018083559190965284517f036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db0600790970296870180546001600160a01b031916919095161784559051805194959194869493610bc9937f036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db101920190611a25565b5060408201518051610be5916002840191602090910190611a25565b5060608201518051610c01916003840191602090910190611a25565b5060808201518051610c1d916004840191602090910190611a25565b5060a082015160058201805460ff191691151591909117905560c08201518051610c51916006840191602090910190611a25565b505060055460008581526006602090815260408083206000199094019093556001600160a01b0388168083526007909152908290208054600101905590519092507f809f6d7403f260d87e5e9820dce1cbd03ed43803c14182fc7c466e6e86c5c5049150610cc29085908890612497565b60405180910390a2505050505050565b600080610cde836119d0565b9050610cea83826119eb565b9392505050565b600081604051602001610d04919061235e565b6040516020818303038152906040528051906020012083604051602001610d2b919061235e565b604051602081830303815290604052805190602001201490505b92915050565b60076020526000908152604090205481565b6000546001600160a01b03163314610d8a57604051600160e51b62461bcd02815260040161064590612509565b610dfd60028381548110610d9a57fe5b600091825260209182902001805460408051601f60026000196101006001871615020190941693909304928301859004850281018501909152818152928301828280156106db5780601f106106b0576101008083540402835291602001916106db565b610e1c57604051600160e51b62461bcd02815260040161064590612579565b600280546000198101908110610e2e57fe5b9060005260206000200160028381548110610e4557fe5b906000526020600020019080546001816001161561010002031660029004610e6e929190611aeb565b506002805490610e82906000198301611b60565b507fa28dc34059cd4716d51da651406dc8ff96399e3cf46725143a7f2855c68cf39481604051610eb291906124b7565b60405180910390a15050565b6000546001600160a01b03163314610eeb57604051600160e51b62461bcd02815260040161064590612509565b610efb60018381548110610d9a57fe5b610f1a57604051600160e51b62461bcd028152600401610645906124f9565b600180546000198101908110610f2c57fe5b9060005260206000200160018381548110610f4357fe5b906000526020600020019080546001816001161561010002031660029004610f6c929190611aeb565b506001805490610f80906000198301611b60565b507f53344ca00b011ca20d3dc9f1bb71ed60e097b598b9f35482879138cc15f28ef981604051610eb291906124b7565b60006060806060806000806006600089815260200190815260200160002054905060058181548110610fde57fe5b6000918252602090912060079091020154600580546001600160a01b039092169850908290811061100b57fe5b90600052602060002090600702016001018054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156110b05780601f10611085576101008083540402835291602001916110b0565b820191906000526020600020905b81548152906001019060200180831161109357829003601f168201915b50505050509550600581815481106110c457fe5b600091825260209182902060026007909202018101805460408051601f60001961010060018616150201909316949094049182018590048502840185019052808352919290919083018282801561115c5780601f106111315761010080835404028352916020019161115c565b820191906000526020600020905b81548152906001019060200180831161113f57829003601f168201915b505050505094506005818154811061117057fe5b6000918252602091829020600360079092020101805460408051601f60026000196101006001871615020190941693909304928301859004850281018501909152818152928301828280156112065780601f106111db57610100808354040283529160200191611206565b820191906000526020600020905b8154815290600101906020018083116111e957829003601f168201915b505050505093506005818154811061121a57fe5b6000918252602091829020600460079092020101805460408051601f60026000196101006001871615020190941693909304928301859004850281018501909152818152928301828280156112b05780601f10611285576101008083540402835291602001916112b0565b820191906000526020600020905b81548152906001019060200180831161129357829003601f168201915b50505050509250600581815481106112c457fe5b906000526020600020906007020160050160009054906101000a900460ff1691505091939550919395565b8160006112fb826116a2565b9050336001600160a01b03166005828154811061131457fe5b60009182526020909120600790910201546001600160a01b03161461134e57604051600160e51b62461bcd02815260040161064590612519565b6000611359856116a2565b90506005818154811061136857fe5b600091825260209091206005600790920201015460ff161561139f57604051600160e51b62461bcd02815260040161064590612569565b83600582815481106113ad57fe5b906000526020600020906007020160040190805190602001906113d1929190611a25565b50847f16e81256ba7e41ceea97db602f7c59414ba5110c3a6641245f6621279f6263018560405161140291906124b7565b60405180910390a25050505050565b6000546001600160a01b0316331461143e57604051600160e51b62461bcd02815260040161064590612509565b600180548082018083556000929092528251611481917fb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf601906020850190611a25565b50507f0eb17eb6d7f643e1f1a79af44e460fffabb6b2a8beff44bff08160d8d3403d3f8160405161074a91906124b7565b60606001805480602002602001604051908101604052809291908181526020016000905b828210156105885760008481526020908190208301805460408051601f600260001961010060018716150201909416939093049283018590048502810185019091528181529283018282801561156d5780601f106115425761010080835404028352916020019161156d565b820191906000526020600020905b81548152906001019060200180831161155057829003601f168201915b5050505050815260200190600101906114d6565b80600061158d826116a2565b9050336001600160a01b0316600582815481106115a657fe5b60009182526020909120600790910201546001600160a01b0316146115e057604051600160e51b62461bcd02815260040161064590612519565b60006115eb846116a2565b9050600581815481106115fa57fe5b600091825260209091206005600790920201015460ff161561163157604051600160e51b62461bcd02815260040161064590612569565b60016005828154811061164057fe5b60009182526020909120600790910201600501805460ff191691151591909117905560405133907fa8a2eafb1f78e64e1c3921d10b28aad02d1fa21cba6bbc76b7e8601b19a9c08d90611694908790612489565b60405180910390a250505050565b60009081526006602052604090205490565b6000546001600160a01b031633146116e157604051600160e51b62461bcd02815260040161064590612509565b60028054600181018083556000929092528251611725917f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace01906020850190611a25565b50507ff2cf567db3ebcbfcad45b1da586f6b7f795e01cad81a993c3cea865f259eec798160405161074a91906124b7565b816000611762826116a2565b9050336001600160a01b03166005828154811061177b57fe5b60009182526020909120600790910201546001600160a01b0316146117b557604051600160e51b62461bcd02815260040161064590612519565b60006117c0856116a2565b9050600581815481106117cf57fe5b600091825260209091206005600790920201015460ff161561180657604051600160e51b62461bcd02815260040161064590612569565b6118c66005828154811061181657fe5b6000918252602091829020600460079092020101805460408051601f60026000196101006001871615020190941693909304928301859004850281018501909152818152928301828280156118ac5780601f10611881576101008083540402835291602001916118ac565b820191906000526020600020905b81548152906001019060200180831161188f57829003601f168201915b505050505060405180602001604052806000815250610cf1565b156118e657604051600160e51b62461bcd028152600401610645906124d9565b83600582815481106118f457fe5b90600052602060002090600702016006019080519060200190611918929190611a25565b50847f8b7614f77555532e6b033ab6da00ac40495940598b8916b1c77a44351428ae0a8560405161140291906124b7565b6000546001600160a01b0316331461197657604051600160e51b62461bcd02815260040161064590612509565b80600454141561199b57604051600160e51b62461bcd02815260040161064590612559565b60048190556040517f5a4bfdb771a9b72401d824fd5b321058c7c69fbe4a7c209c37af285e6d061a8c9061074a908390612489565b6001600160a01b031660009081526007602052604090205490565b600082826003600454604051602001611a07949392919061231a565b60405160208183030381529060405280519060200120905092915050565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f10611a6657805160ff1916838001178555611a93565b82800160010185558215611a93579182015b82811115611a93578251825591602001919060010190611a78565b50611a9f929150611b89565b5090565b6040518060e0016040528060006001600160a01b0316815260200160608152602001606081526020016060815260200160608152602001600015158152602001606081525090565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f10611b245780548555611a93565b82800160010185558215611a9357600052602060002091601f016020900482015b82811115611a93578254825591600101919060010190611b45565b815481835581811115611b8457600083815260209020611b84918101908301611ba3565b505050565b6104b091905b80821115611a9f5760008155600101611b8f565b6104b091905b80821115611a9f576000611bbd8282611bc6565b50600101611ba9565b50805460018160011615610100020316600290046000825580601f10611bec5750611c0a565b601f016020900490600052602060002090810190611c0a9190611b89565b50565b6000610cea82356125fc565b6000610cea82356104b0565b600082601f830112611c3657600080fd5b8135611c49611c44826125b0565b612589565b91508082526020830160208301858383011115611c6557600080fd5b611c70838284612618565b50505092915050565b600060208284031215611c8b57600080fd5b6000611c978484611c0d565b949350505050565b60008060408385031215611cb257600080fd5b6000611cbe8585611c0d565b9250506020611ccf85828601611c19565b9150509250929050565b600060208284031215611ceb57600080fd5b6000611c978484611c19565b60008060408385031215611d0a57600080fd5b6000611d168585611c19565b925050602083013567ffffffffffffffff811115611d3357600080fd5b611ccf85828601611c25565b600060208284031215611d5157600080fd5b813567ffffffffffffffff811115611d6857600080fd5b611c9784828501611c25565b60008060408385031215611d8757600080fd5b823567ffffffffffffffff811115611d9e57600080fd5b611d1685828601611c25565b600080600060608486031215611dbf57600080fd5b833567ffffffffffffffff811115611dd657600080fd5b611de286828701611c25565b935050602084013567ffffffffffffffff811115611dff57600080fd5b611e0b86828701611c25565b925050604084013567ffffffffffffffff811115611e2857600080fd5b611e3486828701611c25565b9150509250925092565b6000610cea8383611ee6565b611e53816125fc565b82525050565b611e53611e65826125fc565b612654565b6000611e75826125ea565b611e7f81856125ee565b935083602082028501611e91856125d8565b60005b84811015611ec8578383038852611eac838351611e3e565b9250611eb7826125d8565b602098909801979150600101611e94565b50909695505050505050565b611e5381612607565b611e53816104b0565b6000611ef1826125ea565b611efb81856125ee565b9350611f0b818560208601612624565b611f1481612665565b9093019392505050565b6000611f29826125ea565b611f3381856125f7565b9350611f43818560208601612624565b9290920192915050565b600081546001811660008114611f6a5760018114611f9057611fcf565b607f6002830416611f7b81876125ee565b60ff1984168152955050602085019250611fcf565b60028204611f9e81876125ee565b9550611fa9856125de565b60005b82811015611fc857815488820152600190910190602001611fac565b8701945050505b505092915050565b600081546001811660008114611ff4576001811461201757611fcf565b607f600283041661200581876125f7565b60ff1984168152955085019250611fcf565b6002820461202581876125f7565b9550612030856125de565b60005b8281101561204f57815488820152600190910190602001612033565b5050909401949350505050565b60006120696029836125ee565b7f5468652070726976617465206b657920686173206e6f74206265656e207265768152600160ba1b6819585b1959081e595d02602082015260400192915050565b60006120b7601d836125ee565b7f4e65772067656e657369732063616e2774206265207468652073616d65000000815260200192915050565b60006120f06028836125ee565b7f56616c696461746f7220746f2072656d6f766520646f6573206e6f74206d61748152600160c31b670c6d040d2dcc8caf02602082015260400192915050565b600061213d6013836125ee565b7f4f6e6c7920636f6e7472616374206f776e657200000000000000000000000000815260200192915050565b6000612176600e836125ee565b7f496e76616c696420656e74697479000000000000000000000000000000000000815260200192915050565b60006121af6010836125ee565b7f456d707479206d65726b6c655472656500000000000000000000000000000000815260200192915050565b60006121e8600e836125ee565b7f456d707479206d65746164617461000000000000000000000000000000000000815260200192915050565b60006122216010836125ee565b7f456d707479206d65726b6c65526f6f7400000000000000000000000000000000815260200192915050565b600061225a601d836125ee565b7f4e657720636861696e49642063616e2774206265207468652073616d65000000815260200192915050565b6000612293601c836125ee565b7f50726f63657373206d757374206e6f742062652063616e63656c656400000000815260200192915050565b60006122cc6025836125ee565b7f4f7261636c6520746f2072656d6f766520646f6573206e6f74206d61746368208152600160db1b640d2dcc8caf02602082015260400192915050565b611e53612315826104b0565b6104b0565b60006123268287611e59565b6014820191506123368286612309565b6020820191506123468285611fd7565b91506123528284612309565b50602001949350505050565b6000610cea8284611f1e565b60c081016123788289611e4a565b818103602083015261238a8188611ee6565b9050818103604083015261239e8187611ee6565b905081810360608301526123b28186611ee6565b905081810360808301526123c68185611ee6565b90506123d560a0830184611ed4565b979650505050505050565b60e081016123ee828a611e4a565b81810360208301526124008189611ee6565b905081810360408301526124148188611ee6565b905081810360608301526124288187611ee6565b9050818103608083015261243c8186611ee6565b905061244b60a0830185611ed4565b81810360c083015261245d8184611ee6565b9998505050505050505050565b60208082528101610cea8184611e6a565b60208101610d458284611ed4565b60208101610d458284611edd565b604081016124a58285611edd565b8181036020830152611c978184611ee6565b60208082528101610cea8184611ee6565b60208082528101610cea8184611f4d565b60208082528101610d458161205c565b60208082528101610d45816120aa565b60208082528101610d45816120e3565b60208082528101610d4581612130565b60208082528101610d4581612169565b60208082528101610d45816121a2565b60208082528101610d45816121db565b60208082528101610d4581612214565b60208082528101610d458161224d565b60208082528101610d4581612286565b60208082528101610d45816122bf565b60405181810167ffffffffffffffff811182821017156125a857600080fd5b604052919050565b600067ffffffffffffffff8211156125c757600080fd5b506020601f91909101601f19160190565b60200190565b60009081526020902090565b5190565b90815260200190565b919050565b6000610d458261260c565b151590565b6001600160a01b031690565b82818337506000910152565b60005b8381101561263f578181015183820152602001612627565b8381111561264e576000848401525b50505050565b6000610d45826000610d458261266f565b601f01601f191690565b60601b9056fea265627a7a72305820dd6485485adde0c837e0c9a7cacf02df2a3dfb3296ce29e4ba7b0939f25cace96c6578706572696d656e74616cf50037";
