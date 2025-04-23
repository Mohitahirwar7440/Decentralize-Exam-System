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

    event ExamScheduled(uint256 examId, string subject, uint256 date);
    event ExamResultPublished(uint256 examId, address student, uint8 score);

    mapping(uint256 => mapping(address => uint8)) public results;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    function scheduleExam(uint256 examId, string memory subject, uint256 date) public onlyAdmin {
        exams[examId] = Exam(subject, date, true);
        emit ExamScheduled(examId, subject, date);
    }

    function publishResult(uint256 examId, address student, uint8 score) public onlyAdmin {
        require(exams[examId].isScheduled, "Exam not scheduled");
        results[examId][student] = score;
        emit ExamResultPublished(examId, student, score);
    }
}
v
