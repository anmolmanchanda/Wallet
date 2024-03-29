// Import required libraries
const express = require('express');
const bodyParser = require('body-parser');
const { Gateway, Wallets } = require('fabric-network');
const fs = require('fs');
const path = require('path');

// Initialize Express app
const app = express();
const port = 3000;

// Middleware for parsing JSON request bodies
app.use(bodyParser.json());

// Endpoint for submitting a transaction to the blockchain network
app.post('/submitTransaction', async (req, res) => {
    try {
        // Load connection profile
        const ccpPath = path.resolve(__dirname, 'connection.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

        // Connect to Fabric gateway
        const gateway = new Gateway();
        await gateway.connect(ccp, {
            wallet: Wallets.newFileSystemWallet('./wallet'),
            identity: 'user1',
            discovery: { enabled: true, asLocalhost: true }
        });

        // Get network and contract
        const network = await gateway.getNetwork('mychannel');
        const contract = network.getContract('mycontract');

        // Submit transaction
        const result = await contract.submitTransaction(req.body.functionName, ...req.body.args);

        // Disconnect from gateway
        await gateway.disconnect();

        // Return transaction result
        res.send(result.toString());
    } catch (error) {
        console.error('Error submitting transaction:', error);
        res.status(500).send('Error submitting transaction');
    }
});

// Start the Express server
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
