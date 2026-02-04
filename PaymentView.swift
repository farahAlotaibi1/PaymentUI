//
//  PaymentView.swift
//  ApplePay1
//
//  Created by Farah  on 15/08/1447 AH.
//


import SwiftUI

struct PaymentView: View {
    @State private var cardName: String = ""
    @State private var cardNumber: String = ""
    @State private var cvc: String = ""
    @State private var expiry: String = ""
    
  
    @State private var showApplePaySheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // العنوان العلوي
                Text("اختر طريقة الدفع")
                    .font(.headline)
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack(spacing: 12) {
                        Image("mada_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 25)

                        Image("visa_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 25)

                        Image("mastercard_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 25)

                        Spacer()
                    }
                    .padding(.horizontal, 5)

                    VStack(spacing: 0) {
                        
                        TextField("Name on Card", text: $cardName)
                            .keyboardType(.asciiCapable)
                            .padding()
                            .autocorrectionDisabled()
                            .onChange(of: cardName) { _, newValue in
                                cardName = filterEnglishLetters(newValue).uppercased()
                            }

                        Divider()

                        TextField("Card Number", text: $cardNumber)
                            .keyboardType(.asciiCapableNumberPad)
                            .padding()
                            .onChange(of: cardNumber) { _, newValue in
                                let filtered = filterEnglishNumbers(newValue)
                                cardNumber = String(filtered.prefix(16))
                            }

                        Divider()

                        HStack(spacing: 0) {
                            TextField("CVC", text: $cvc)
                                .keyboardType(.asciiCapableNumberPad)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .onChange(of: cvc) { _, newValue in
                                    let filtered = filterEnglishNumbers(newValue)
                                    cvc = String(filtered.prefix(3))
                                }

                            Divider()

                            
                            TextField("MM / YY", text: $expiry)
                                .keyboardType(.asciiCapableNumberPad)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .onChange(of: expiry) { _, newValue in
                                    formatExpiry(newValue)
                                }
                        }
                        .frame(height: 55)
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                }
                .padding(.horizontal)

                VStack(spacing: 15) {
                    
                    Button("Pay SAR 1.00") {
                        print("Regular Pay Clicked")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(12)

                    
                    Button {
                        showApplePaySheet = true
                    } label: {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Pay with Apple Pay")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        
        .sheet(isPresented: $showApplePaySheet) {
            ApplePaySimulationView()
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Helpers
    func filterEnglishLetters(_ text: String) -> String {
        let regex = "[^A-Za-z ]"
        return text.replacingOccurrences(of: regex, with: "", options: .regularExpression)
    }

    func filterEnglishNumbers(_ text: String) -> String {
        let regex = "[^0-9]"
        return text.replacingOccurrences(of: regex, with: "", options: .regularExpression)
    }

    func formatExpiry(_ value: String) {
        let numbers = filterEnglishNumbers(value)
        let limited = String(numbers.prefix(4))

        if limited.count > 2 {
            let index = limited.index(limited.startIndex, offsetBy: 2)
            expiry = "\(limited[..<index])/\(limited[index...])"
        } else {
            expiry = limited
        }
    }
}

// MARK: - نافذة محاكاة Apple Pay
struct ApplePaySimulationView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Image(systemName: "applelogo")
                Text("Pay")
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            .font(.title3).fontWeight(.bold)
            .padding()

            
            VStack(spacing: 15) {
                
                HStack {
                    Image(systemName: "creditcard.fill")
                        .resizable()
                        .frame(width: 45, height: 32)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("Simulated Card - AmEx").fontWeight(.semibold)
                        Text("•••• 1234").font(.caption).foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(.gray)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                Divider()

                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Pay Blue Coffee Beans").font(.caption).foregroundColor(.gray)
                        Text("Total").font(.headline)
                    }
                    Spacer()
                    Text("SAR 1.00").font(.title2).fontWeight(.bold)
                }
                .padding(.horizontal)
            }

            Spacer()

        
            Button(action: {
                
                dismiss()
            }) {
                Text("Pay")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(30)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    PaymentView()
}

