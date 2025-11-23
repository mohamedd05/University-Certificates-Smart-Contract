# 📜 University Certificates Smart Contract

A decentralized, tamper-proof certificate issuance and verification system built using **Solidity**.

This smart contract allows universities or authorized institutions to issue blockchain-authenticated certificates to students. It supports issuing, updating, revoking, retrieving, and verifying certificates — all stored immutably on-chain.

---

## 🚀 Features

### 🎓 **Certificate Management**

* Issue certificates to student wallet addresses
* Update certificate details (name, course, date)
* Revoke or restore certificates
* Retrieve certificates by student
* Verify certificate authenticity on-chain

### 🔐 **Access Control**

* Only the **admin (university)** can:

  * Issue certificates
  * Update certificates
  * Revoke certificates
  * Transfer admin role

### 🛡️ **Security**

* Validates certificate existence before actions
* Prevents issuing certificates to zero address
* On-chain verification ensures no tampering

---

## 🧩 Contract Overview

### **Data Structure**

Each certificate contains:

```solidity
struct Certificate {
    uint256 id;
    address student;
    string studentName;
    string courseName;
    uint256 issueDate;
    bool revoked;
}
```

### **Core Functionality**

| Function                     | Description                                      |
| ---------------------------- | ------------------------------------------------ |
| `issueCertificate()`         | Issues a new certificate and assigns a unique ID |
| `updateCertificate()`        | Updates student name, course, or issuance date   |
| `setRevoked()`               | Revokes or restores a certificate                |
| `getCertificatesByStudent()` | Returns all certificates for a student           |
| `verifyCertificate()`        | Confirms certificate ownership & validity        |
| `transferAdmin()`            | Transfers admin privileges to a new address      |

---

## 📦 Installation & Compilation

### **Requirements**

* Node.js & npm
* Hardhat / Foundry / Remix
* Solidity `0.8.30`

## 🧪 Testing & Deployment Status

This contract has been tested and verified on:

- **Remix IDE — Prague Environment**
- **Ethereum Sepolia Testnet**

Testing included:
- Successful contract deployment
- Certificate issuance, updates, and revocation
- Admin role transfer validation
- On-chain verification using `verifyCertificate`
- Retrieval of student certificate data using `getCertificatesByStudent`

All functions behaved as expected during testnet execution.

### **Compile using Hardhat**

```bash
npm install
npx hardhat compile
```

---

## 🔧 Deployment

### **Using Hardhat**

```bash
npx hardhat run scripts/deploy.js --network <network_name>
```

### **Or directly via Remix**

1. Open [Remix](https://remix.ethereum.org)
2. Paste the contract into the workspace
3. Select compiler version **0.8.30**
4. Deploy

The deploying address becomes the **admin**.

---

## 📘 Usage Guide

### **Issue Certificate**

```solidity
issueCertificate(
    studentAddress,
    "Mohamedd05",
    "Computer Science BSc",
    0 // uses block.timestamp if 0
);
```

### **Update Certificate**

```solidity
updateCertificate(certId, "Mohamedd05", "Software Engineering MSc", newDate);
```

### **Revoke Certificate**

```solidity
setRevoked(certId, true);
```

### **Verify Certificate**

```solidity
bool isValid = verifyCertificate(certId, studentAddress);
```

### **Get Certificates for a Student**

```solidity
getCertificatesByStudent(studentAddress);
```

---

## 📡 Events

| Event                                  | Purpose                                 |
| -------------------------------------- | --------------------------------------- |
| `CertificateIssued(certId, student)`   | Emitted when a certificate is created   |
| `CertificateUpdated(certId)`           | Emitted after certificate modifications |
| `CertificateRevoked(certId, revoked)`  | Emitted when revocation status changes  |
| `AdminTransferred(oldAdmin, newAdmin)` | Emitted when admin changes              |


## 🔒 Admin Controls

Only the admin can call sensitive functions.
To transfer admin rights:

```solidity
transferAdmin(newAdminAddress);
```
