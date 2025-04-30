// app.js

// Connect to Ethereum provider
if (typeof window.ethereum !== 'undefined') {
    window.web3 = new Web3(window.ethereum);
    console.log("MetaMask detected!");
} else {
    alert("Please install MetaMask!");
}

// Replace with your deployed contract's address
const contractAddress = '<YOUR_CONTRACT_ADDRESS_HERE>';

// ABI for DecentralizedExamSystem
const contractABI = [
    {
        "inputs": [],
        "stateMutability": "nonpayable",
        "type": "constructor"
    },
    {
        "inputs": [
            { "internalType": "uint256", "name": "examId", "type": "uint256" },
            { "internalType": "string", "name": "subject", "type": "string" },
            { "internalType": "uint256", "name": "date", "type": "uint256" }
        ],
        "name": "scheduleExam",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            { "internalType": "address", "name": "student", "type": "address" }
        ],
        "name": "registerStudent",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            { "internalType": "uint256", "name": "examId", "type": "uint256" },
            { "internalType": "address", "name": "student", "type": "address" },
            { "internalType": "uint8", "name": "score", "type": "uint8" }
        ],
        "name": "publishResult",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            { "internalType": "uint256", "name": "", "type": "uint256" },
            { "internalType": "address", "name": "", "type": "address" }
        ],
        "name": "results",
        "outputs": [{ "internalType": "uint8", "name": "", "type": "uint8" }],
        "stateMutability": "view",
        "type": "function"
    }
];

// Create contract instance
const examSystem = new web3.eth.Contract(contractABI, contractAddress);

// Connect wallet
async function connectWallet() {
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    return accounts[0];
}

// Schedule an exam
async function scheduleExam(examId, subject, dateTimestamp) {
    const account = await connectWallet();
    try {
        await examSystem.methods.scheduleExam(examId, subject, dateTimestamp)
            .send({ from: account });
        alert('Exam scheduled successfully!');
    } catch (err) {
        console.error(err);
        alert('Failed to schedule exam.');
    }
}

// Register a student
async function registerStudent(studentAddress) {
    const account = await connectWallet();
    try {
        await examSystem.methods.registerStudent(studentAddress)
            .send({ from: account });
        alert('Student registered successfully!');
    } catch (err) {
        console.error(err);
        alert('Failed to register student.');
    }
}

// Publish exam result
async function publishResult(examId, studentAddress, score) {
    const account = await connectWallet();
    try {
        await examSystem.methods.publishResult(examId, studentAddress, score)
            .send({ from: account });
        alert('Result published successfully!');
    } catch (err) {
        console.error(err);
        alert('Failed to publish result.');
    }
}

// View a student's result
async function viewResult(examId, studentAddress) {
    try {
        const result = await examSystem.methods.results(examId, studentAddress).call();
        alert(`Score: ${result}`);
    } catch (err) {
        console.error(err);
        alert('Error fetching result.');
    }
}
