import SwiftUI

struct ContentView: View {
    @State private var recipientAddress: String = ""
    @State private var amount: String = ""
    @State private var transactionResult: String = ""
    @State private var transactionHistory: [String] = []
    
    var body: some View {
        VStack {
            // Welcome Message
            Text("Welcome to Your Fabric App")
                .font(.title)
                .padding()
            
            Divider()
            
            // Transaction Section
            VStack(alignment: .leading) {
                Text("Initiate Transaction:")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                // Recipient Address Input
                TextField("Recipient Address", text: $recipientAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                
                // Amount Input
                TextField("Amount", text: $amount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding(.bottom, 10)
                
                // Button to initiate transaction
                Button(action: {
                    initiateTransaction()
                }) {
                    Text("Initiate Transaction")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            
            Divider()
            
            // Transaction Result
            VStack(alignment: .leading) {
                Text("Transaction Result:")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                // Display transaction result
                Text(transactionResult)
            }
            .padding()
            
            Divider()
            
            // Transaction History
            VStack(alignment: .leading) {
                Text("Transaction History:")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                // Display transaction history
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(transactionHistory, id: \.self) { transaction in
                            Text(transaction)
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
        }
    }
    
    // Function to initiate transaction
    func initiateTransaction() {
        // Define request data
        let requestData: [String: Any] = [
            "functionName": "submitTransaction",
            "args": [recipientAddress, amount] // Pass recipient address and amount as function arguments
        ]
        
        // Define request URL
        guard let url = URL(string: "http://localhost:3000/submitTransaction") else {
            print("Invalid URL")
            return
        }
        
        // Define request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode request data
        guard let requestDataJson = try? JSONSerialization.data(withJSONObject: requestData) else {
            print("Error encoding request data")
            return
        }
        
        // Attach request data to request body
        request.httpBody = requestDataJson
        
        // Make HTTP request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error:", error ?? "Unknown error")
                return
            }
            
            // Parse response data
            if let result = String(data: data, encoding: .utf8) {
                // Update transaction result in UI
                DispatchQueue.main.async {
                    self.transactionResult = result // Use self to refer to the property of the view
                    
                    // Add transaction to history
                    self.transactionHistory.append(result)
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
