// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract UniversityCertificates {
    // ====== DATA TYPES ======
    struct Certificate {
        uint256 id;           // Unique certificate ID
        address student;      // Student's wallet address
        string studentName;   // Student's name (for readability)
        string courseName;    // Name of the course or program
        uint256 issueDate;    // Timestamp when the certificate was issued
        bool revoked;         // Revocation status
    }

    // ====== STATE VARIABLES =====
    address public admin; // Contract admin (university)
    uint256 private nextCertId; // Counter for generating unique certificate IDs
    mapping(uint256 => Certificate) private certificates; // certId → Certificate
    mapping(address => uint256[]) private certificatesByStudent; // student → [certIds]
    //address public immutable admin; Might be used to save gas if there is no intentions to change the admin


    // ======== EVENTS ========
    event CertificateIssued(uint256 indexed certId, address indexed student);
    event CertificateUpdated(uint256 indexed certId);
    event CertificateRevoked(uint256 indexed certId, bool revoked);
    event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);

    // ======== MODIFIER ========
    modifier onlyAdmin() {
        require(msg.sender == admin, "Access denied: Only admin"); //Restricts access to admin-only functions.
        _;
    }

    // ======== CONSTRUCTOR =====
    constructor() {
        admin = msg.sender; //Sets the contract deployer as the initial admin. 
        nextCertId = 1; // Start certificate IDs from 1
    }
    

    // ======== ADMIN MANAGEMENT =========
    function transferAdmin(address newAdmin) external onlyAdmin { //Transfers admin privileges to another address.
        require(newAdmin != address(0), "Invalid address: zero address"); // Only the current admin can call this function.
        emit AdminTransferred(admin, newAdmin);
        admin = newAdmin; //newAdmin Address of the new admin.
    }

    // ======== CERTIFICATE ISSUANCE ========
    function issueCertificate( //Issues a new academic certificate to a student.
        address student,
        string calldata studentName,//The student's full name.
        string calldata courseName,//The name of the course or program.
        uint256 issueDate
    ) external onlyAdmin returns (uint256 certId) {//Only the admin can issue certificates.
        require(student != address(0), "Invalid student address");//The wallet address of the student.

        uint256 id = nextCertId++;//The unique ID of the newly issued certificate.
        uint256 dateToUse = issueDate == 0 ? block.timestamp : issueDate;

        certificates[id] = Certificate({
            id: id,
            student: student,
            studentName: studentName,
            courseName: courseName,
            issueDate: dateToUse,
            revoked: false
        });

        certificatesByStudent[student].push(id);

        emit CertificateIssued(id, student);
        return id;
    }
    
    // ======== CERTIFICATE UPDATE ========
    function updateCertificate( //Updates an existing certificate’s details.
        uint256 certId, //The ID of the certificate to update.
        string calldata newStudentName, //The updated student name.
        string calldata newCourseName, //The updated course name.
        uint256 newIssueDate
    ) external onlyAdmin { //Only the admin can modify a certificate.
        Certificate storage cert = certificates[certId];
        require(certificateExists(certId), "Certificate not found");

        cert.studentName = newStudentName;
        cert.courseName = newCourseName;
        if (newIssueDate != 0) {
            cert.issueDate = newIssueDate;
        }

        emit CertificateUpdated(certId);
    }

    // ======== CERTIFICATE REVOCATION ========
    function setRevoked(uint256 certId, bool revoked) external onlyAdmin { //Changes the revocation status of a certificate. Admin can revoke or restore certificates.
        Certificate storage cert = certificates[certId];
        require(certificateExists(certId), "Certificate not found");

        cert.revoked = revoked;
        emit CertificateRevoked(certId, revoked);
    }

    // ======== VIEW / VERIFICATION ========
    function getCertificatesByStudent(address student)
    public view returns (
        uint256[] memory ids,
        string[] memory names,
        string[] memory courses,
        uint256[] memory issueDates,
        bool[] memory revoked
    )
{
    uint256[] memory certIds = certificatesByStudent[student];
    uint256 len = certIds.length;

    ids = new uint256[](len);
    names = new string[](len);
    courses = new string[](len);
    issueDates = new uint256[](len);
    revoked = new bool[](len);

    for (uint256 i = 0; i < len; i++) {
        Certificate storage cert = certificates[certIds[i]];
        ids[i] = cert.id;
        names[i] = cert.courseName;
        courses[i] = cert.studentName;
        issueDates[i] = cert.issueDate;
        revoked[i] = cert.revoked;
    }
}

    /*function getCertificate(uint256 certId) // Retrieves all information about a certificate by ID. 
        public view returns (
            address student, //The wallet address of the student.
            string memory studentName, //The full name of the student.
            string memory courseName, //The name of the course or program.
            uint256 issueDate, //The timestamp of issuance.
            bool revoked //Indicates if the certificate has been revoked.
        )
    {
        Certificate storage cert = certificates[certId];
        require(certificateExists(certId), "Certificate not found");

        return (
            cert.student,
            cert.studentName,
            cert.courseName,
            cert.issueDate,
            cert.revoked
        );
    }

    
    function getCertificatesByStudent(address student) //Lists all certificate IDs associated with a student, by using his wallet address.
    external view returns (Certificate[] memory) //Array of certificates belonging to that student.
    {
    uint256[] memory ids = certificatesByStudent[student];
    Certificate[] memory result = new Certificate[](ids.length);
    for (uint256 i = 0; i < ids.length; i++) {
        result[i] = certificates[ids[i]];
    }
    return result;
    }*/
 
     function certificateExists(uint256 certId) private view returns (bool) {
        return certificates[certId].id != 0;
    }

    function verifyCertificate(uint256 certId, address student) // Verifies if a certificate belongs to a given student and is valid.
        public view returns (bool valid)
    {
        Certificate storage cert = certificates[certId];
        if (cert.id == 0) return false;
        if (cert.student != student) return false;
        if (cert.revoked) return false;
        return true;
    }
    
}
