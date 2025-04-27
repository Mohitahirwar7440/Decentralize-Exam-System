// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedExamSystem {
    address public admin;

    struct Exam {
        string subject;
        uint256 date;
        bool isScheduled;
    }

    mapping(uint256 => Exam) public exams;
    mapping(uint256 => mapping(address => uint8)) public results;

    mapping(address => bool) public registeredStudents;

    event ExamScheduled(uint256 examId, string subject, uint256 date);
    event ExamResultPublished(uint256 examId, address student, uint8 score);
    event StudentRegistered(address student);
    event StudentDeregistered(address student);
    event ExamRemoved(uint256 examId);
    event AdminChanged(address oldAdmin, address newAdmin);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    function scheduleExam(uint256 examId, string memory subject, uint256 date) public onlyAdmin {
        require(!exams[examId].isScheduled, "Exam already scheduled");
        exams[examId] = Exam(subject, date, true);
        emit ExamScheduled(examId, subject, date);
    }

    function publishResult(uint256 examId, address student, uint8 score) public onlyAdmin {
        require(exams[examId].isScheduled, "Exam not scheduled");
        require(registeredStudents[student], "Student not registered");
        require(score <= 100, "Invalid score");
        results[examId][student] = score;
        emit ExamResultPublished(examId, student, score);
    }

    function registerStudent(address student) public onlyAdmin {
        require(!registeredStudents[student], "Student already registered");
        registeredStudents[student] = true;
        emit StudentRegistered(student);
    }

    function deregisterStudent(address student) public onlyAdmin {
        require(registeredStudents[student], "Student not registered");
        registeredStudents[student] = false;
        emit StudentDeregistered(student);
    }

    function isStudentRegistered(address student) public view returns (bool) {
        return registeredStudents[student];
    }

    function getResult(uint256 examId, address student) public view returns (uint8) {
        require(exams[examId].isScheduled, "Exam not scheduled");
        require(registeredStudents[student], "Student not registered");
        return results[examId][student];
    }

    function removeExam(uint256 examId) public onlyAdmin {
        require(exams[examId].isScheduled, "Exam not found");
        delete exams[examId];
        emit ExamRemoved(examId);
    }

    function changeAdmin(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), "Invalid address");
        emit AdminChanged(admin, newAdmin);
        admin = newAdmin;
    }

    // --------- New Functions Below ---------

    // View exam details by ID
    function getExamDetails(uint256 examId) public view returns (string memory subject, uint256 date, bool isScheduled) {
        Exam memory exam = exams[examId];
        require(exam.isScheduled, "Exam not scheduled");
        return (exam.subject, exam.date, exam.isScheduled);
    }

    // List multiple exam details (batch retrieval)
    function getMultipleExams(uint256[] memory examIds) public view returns (Exam[] memory) {
        Exam[] memory examList = new Exam[](examIds.length);
        for (uint256 i = 0; i < examIds.length; i++) {
            examList[i] = exams[examIds[i]];
        }
        return examList;
    }

    // Allow students to view their own result
    function viewMyResult(uint256 examId) public view returns (uint8) {
        require(registeredStudents[msg.sender], "You are not a registered student");
        require(exams[examId].isScheduled, "Exam not scheduled");
        return results[examId][msg.sender];
    }
}
