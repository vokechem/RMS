-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 13, 2020 at 02:42 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `majuu`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Activation` (IN `_IsEmailverified` BOOLEAN, IN `_Email` VARCHAR(100), IN `_ActivationCode` VARCHAR(100))  NO SQL
BEGIN

UPDATE `users`
SET `IsEmailverified` = _IsEmailverified
WHERE `Username` = _username
AND `Email` = _Email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApproveApplication` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN


DECLARE lSaleDesc varchar(200);
DECLARE _NewApplicationNo varchar(50);
DECLARE _Year varchar(50);
 DROP TABLE IF EXISTS ApplicationApprovalContacts;
 create table ApplicationApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Approved Registration: ',_IDNumber);
SELECT
  IDNumber
FROM registration
WHERE IDNumber = _IDNumber LIMIT 1 INTO @PEID;
INSERT INTO `applications_approval_workflow` (IDNumber, Fullname, Status, Approver,Remarks,Created_By,Approved_At,Created_At)
  SELECT
    IDNumber,
    Fullname,
    'Approved',
    _Approver,
     _Remarks,
    _Approver,
    NOW(),
   NOW()
  FROM registration
  WHERE IDNumber = _IDNumber;
SELECT
  IFNULL(COUNT(*), 0)
FROM approvers
WHERE Mandatory = 1
AND ModuleCode = 'REG'
AND Deleted = 0 INTO @CountMandatory;
SELECT
  IFNULL(COUNT(*), 0)
FROM `applications_approval_workflow`
WHERE IDNumber = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 1
  AND ModuleCode = 'REG'
  AND Deleted = 0) INTO @CountMandatoryApproved;

SELECT
  IFNULL(MaxApprovals, 0)
FROM approvalmodules
WHERE ModuleCode = 'REG' LIMIT 1 INTO @MaxApprovals;
SELECT
  IFNULL(COUNT(*), 0)
FROM `applications_approval_workflow`
WHERE IDNumber = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 0
  AND Deleted = 0
  AND ModuleCode = 'REG') INTO @CountApproved;
  if @CountMandatoryApproved >= @CountMandatory  THEN
    BEGIN
          if @CountApproved >= @MaxApprovals  THEN
          BEGIN
UPDATE registration
SET Status = 'Approved',
    Approve_at = NOW()
WHERE IDNumber = _IDNumber;
UPDATE notifications
SET Status = 'Resolved'
WHERE Category = 'Applications Approval';
CALL Saveapplicationsequence(_IDNumber, 'Registration Approved', 'Awaiting Minor Medical', _Approver);
                 select CreatedBy from registration where IDNumber=_IDNumber LIMIT 1 into @Applicant;
                    insert into ApplicationApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
                    select IDNumber from registration where  IDNumber=_IDNumber LIMIT 1 into @ApplicantID;
                    insert into ApplicationApprovalContacts select Fullname,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
END;
END IF;
END;
END IF;    
call ResolveMyNotification(_Approver,'Applications Approval');
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
  select Name ,Email ,Mobile ,Msg ,IDNumber from ApplicationApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApproveAttestation` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
DECLARE _NewApplicationNo varchar(50);
DECLARE _Year varchar(50);
 DROP TABLE IF EXISTS AttestationApprovalContacts;
 create table AttestationApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Approved Attestation: ',_IDNumber);
SELECT
  ID
FROM attestation
WHERE Number = _IDNumber LIMIT 1 INTO @PEID;
INSERT INTO `attestation_approval_workflow` (Number, Fullname, Status, Approver,Remarks,Created_By,Approved_At,Created_At)
  SELECT
    attestation.Number,
    Fullname,
    'Approved',
    _Approver,
     _Remarks,
    _Approver,
    NOW(),
   NOW()
  FROM registration inner join attestation on attestation.Number=registration.IDNumber
  WHERE Number = _IDNumber;
SELECT
  IFNULL(COUNT(*), 0)
FROM approvers
WHERE Mandatory = 1
AND ModuleCode = 'ATN'
AND Deleted = 0 INTO @CountMandatory;
SELECT
  IFNULL(COUNT(*), 0)
FROM `attestation_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 1
  AND ModuleCode = 'ATN'
  AND Deleted = 0) INTO @CountMandatoryApproved;

SELECT
  IFNULL(MaxApprovals, 0)
FROM approvalmodules
WHERE ModuleCode = 'ATN' LIMIT 1 INTO @MaxApprovals;
SELECT
  IFNULL(COUNT(*), 0)
FROM `attestation_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 0
  AND Deleted = 0
  AND ModuleCode = 'ATN') INTO @CountApproved;
  if @CountMandatoryApproved >= @CountMandatory  THEN
    BEGIN
          if @CountApproved >= @MaxApprovals  THEN
          BEGIN
UPDATE attestation
SET Status = 'Approved',
    Approve_at = NOW()
WHERE Number = _IDNumber;
UPDATE notifications
SET Status = 'Resolved'
WHERE Category = 'Attestation Approval';
CALL Saveapplicationsequence(_IDNumber, 'Attestation Approval', 'Awaiting NEA', _Approver);
                 select CreatedBy from attestation where Number=_IDNumber LIMIT 1 into @Applicant;
                    insert into AttestationApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
                    select Number from attestation where  Number=_IDNumber LIMIT 1 into @ApplicantID;
                    insert into AttestationApprovalContacts select Fullname,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
END;
END IF;
END;
END IF;    
call ResolveMyNotification(_Approver,'Attestation Approval');
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
  select Name ,Email ,Mobile ,Msg ,IDNumber from AttestationApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApproveContract` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
DECLARE _NewApplicationNo varchar(50);
DECLARE _Year varchar(50);
 DROP TABLE IF EXISTS ContractApprovalContacts;
 create table ContractApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Approved Contract Processing: ',_IDNumber);
SELECT
  ID
FROM minormedical
WHERE Number = _IDNumber LIMIT 1 INTO @PEID;
INSERT INTO `contract_approval_workflow` (Number, Fullname, Status, Approver,Remarks,Created_By,Approved_At,Created_At)
  SELECT
    contract.Number,
    Fullname,
    'Approved',
    _Approver,
     _Remarks,
    _Approver,
    NOW(),
   NOW()
  FROM registration inner join contract on contract.Number=registration.IDNumber
  WHERE Number = _IDNumber;
SELECT
  IFNULL(COUNT(*), 0)
FROM approvers
WHERE Mandatory = 1
AND ModuleCode = 'CNT'
AND Deleted = 0 INTO @CountMandatory;
SELECT
  IFNULL(COUNT(*), 0)
FROM `contract_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 1
  AND ModuleCode = 'CNT'
  AND Deleted = 0) INTO @CountMandatoryApproved;

SELECT
  IFNULL(MaxApprovals, 0)
FROM approvalmodules
WHERE ModuleCode = 'CNT' LIMIT 1 INTO @MaxApprovals;
SELECT
  IFNULL(COUNT(*), 0)
FROM `contract_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 0
  AND Deleted = 0
  AND ModuleCode = 'CNT') INTO @CountApproved;
  if @CountMandatoryApproved >= @CountMandatory  THEN
    BEGIN
          if @CountApproved >= @MaxApprovals  THEN
          BEGIN
UPDATE contract
SET Status = 'Approved',
    Approve_at = NOW()
WHERE Number = _IDNumber;
UPDATE notifications
SET Status = 'Resolved'
WHERE Category = 'Contract Processing Approval';
CALL Saveapplicationsequence(_IDNumber, 'Contract Processing Approval', 'Awaiting NEA', _Approver);
                 select CreatedBy from contract where Number=_IDNumber LIMIT 1 into @Applicant;
                    insert into ContractApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
                    select Number from contract where  Number=_IDNumber LIMIT 1 into @ApplicantID;
                    insert into ContractApprovalContacts select Fullname,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
END;
END IF;
END;
END IF;    
call ResolveMyNotification(_Approver,'Contract Processing Approval');
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
  select Name ,Email ,Mobile ,Msg ,IDNumber from ContractApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApproveDCI` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
DECLARE _NewApplicationNo varchar(50);
DECLARE _Year varchar(50);
 DROP TABLE IF EXISTS DCIApprovalContacts;
 create table DCIApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Approved DCI: ',_IDNumber);
SELECT
  ID
FROM dci
WHERE Number = _IDNumber LIMIT 1 INTO @PEID;
INSERT INTO `dci_approval_workflow` (Number, Fullname, Status, Approver,Remarks,Created_By,Approved_At,Created_At)
  SELECT
    dci.Number,
    Fullname,
    'Approved',
    _Approver,
     _Remarks,
    _Approver,
    NOW(),
   NOW()
  FROM registration inner join dci on dci.Number=registration.IDNumber
  WHERE Number = _IDNumber;
SELECT
  IFNULL(COUNT(*), 0)
FROM approvers
WHERE Mandatory = 1
AND ModuleCode = 'DCI'
AND Deleted = 0 INTO @CountMandatory;
SELECT
  IFNULL(COUNT(*), 0)
FROM `dci_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 1
  AND ModuleCode = 'DCI'
  AND Deleted = 0) INTO @CountMandatoryApproved;

SELECT
  IFNULL(MaxApprovals, 0)
FROM approvalmodules
WHERE ModuleCode = 'DCI' LIMIT 1 INTO @MaxApprovals;
SELECT
  IFNULL(COUNT(*), 0)
FROM `dci_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 0
  AND Deleted = 0
  AND ModuleCode = 'DCI') INTO @CountApproved;
  if @CountMandatoryApproved >= @CountMandatory  THEN
    BEGIN
          if @CountApproved >= @MaxApprovals  THEN
          BEGIN
UPDATE dci
SET Status = 'Approved',
Approve_at = NOW()
WHERE Number = _IDNumber;
UPDATE notifications
SET Status = 'Resolved'
WHERE Category = 'DCI Approval';
CALL Saveapplicationsequence(_IDNumber, 'DCI Approval', 'Awaiting Passport Processing', _Approver);
                 select CreatedBy from dci where Number=_IDNumber LIMIT 1 into @Applicant;
                    insert into DCIApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
                    select Number from dci where  Number=_IDNumber LIMIT 1 into @ApplicantID;
                    insert into DCIApprovalContacts select Fullname,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
END;
END IF;
END;
END IF;    
call ResolveMyNotification(_Approver,'DCI Approval');
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
  select Name ,Email ,Mobile ,Msg ,IDNumber from DCIApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApproveFinalMedical` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
DECLARE _NewApplicationNo varchar(50);
DECLARE _Year varchar(50);
 DROP TABLE IF EXISTS FinalApprovalContacts;
 create table FinalApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Approved Final Medical: ',_IDNumber);
SELECT
  ID
FROM finalmedical
WHERE Number = _IDNumber LIMIT 1 INTO @PEID;
INSERT INTO `final_approval_workflow` (Number, Fullname, Status, Approver,Remarks,Created_By,Approved_At,Created_At)
  SELECT
    finalmedical.Number,
    Fullname,
    'Approved',
    _Approver,
     _Remarks,
    _Approver,
    NOW(),
   NOW()
  FROM registration inner join finalmedical on finalmedical.Number=registration.IDNumber
  WHERE Number = _IDNumber;
SELECT
  IFNULL(COUNT(*), 0)
FROM approvers
WHERE Mandatory = 1
AND ModuleCode = 'FNL'
AND Deleted = 0 INTO @CountMandatory;
SELECT
  IFNULL(COUNT(*), 0)
FROM final_approval_workflow
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 1
  AND ModuleCode = 'FNL'
  AND Deleted = 0) INTO @CountMandatoryApproved;

SELECT
  IFNULL(MaxApprovals, 0)
FROM approvalmodules
WHERE ModuleCode = 'FNL' LIMIT 1 INTO @MaxApprovals;
SELECT
  IFNULL(COUNT(*), 0)
FROM final_approval_workflow
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 0
  AND Deleted = 0
  AND ModuleCode = 'FNL') INTO @CountApproved;
  if @CountMandatoryApproved >= @CountMandatory  THEN
    BEGIN
          if @CountApproved >= @MaxApprovals  THEN
          BEGIN
UPDATE finalmedical
SET Status = 'Approved',
    Approve_at = NOW()
WHERE Number = _IDNumber;
UPDATE notifications
SET Status = 'Resolved'
WHERE Category = 'Final Medical Approval' and IDNumber=_IDNumber;
CALL Saveapplicationsequence(_IDNumber, 'Final Medical Approval', 'Awaiting COntract Processing', _Approver);
                 select CreatedBy from finalmedical where Number=_IDNumber LIMIT 1 into @Applicant;
                    insert into FinalApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
                    select Number from finalmedical where  Number=_IDNumber LIMIT 1 into @ApplicantID;
                    insert into FinalApprovalContacts select Fullname,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
END;
END IF;
END;
END IF;    
call ResolveMyNotification(_Approver,'Final Medical Approval');
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
  select Name ,Email ,Mobile ,Msg ,IDNumber from FinalApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApproveMajorMedical` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
DECLARE _NewApplicationNo varchar(50);
DECLARE _Year varchar(50);
 DROP TABLE IF EXISTS MajorApprovalContacts;
 create table MajorApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Approved DCI: ',_IDNumber);
SELECT
  ID
FROM major
WHERE Number = _IDNumber LIMIT 1 INTO @PEID;
INSERT INTO `major_approval_workflow` (Number, Fullname, Status, Approver,Remarks,Created_By,Approved_At,Created_At)
  SELECT
    major.Number,
    Fullname,
    'Approved',
    _Approver,
     _Remarks,
    _Approver,
    NOW(),
   NOW()
  FROM registration inner join major on major.Number=registration.IDNumber
  WHERE Number = _IDNumber;
SELECT
  IFNULL(COUNT(*), 0)
FROM approvers
WHERE Mandatory = 1
AND ModuleCode = 'MJR'
AND Deleted = 0 INTO @CountMandatory;
SELECT
  IFNULL(COUNT(*), 0)
FROM `major_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 1
  AND ModuleCode = 'MJR'
  AND Deleted = 0) INTO @CountMandatoryApproved;

SELECT
  IFNULL(MaxApprovals, 0)
FROM approvalmodules
WHERE ModuleCode = 'MJR' LIMIT 1 INTO @MaxApprovals;
SELECT
  IFNULL(COUNT(*), 0)
FROM `major_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 0
  AND Deleted = 0
  AND ModuleCode = 'MJR') INTO @CountApproved;
  if @CountMandatoryApproved >= @CountMandatory  THEN
    BEGIN
          if @CountApproved >= @MaxApprovals  THEN
          BEGIN
UPDATE major
SET Status = 'Approved',
    Approve_at = NOW()
WHERE Number = _IDNumber;
UPDATE notifications
SET Status = 'Resolved'
WHERE Category = 'Major Medical Approval';
CALL Saveapplicationsequence(_IDNumber, 'Major Medical Approval', 'Awaiting COntract Processing', _Approver);
                 select CreatedBy from major where Number=_IDNumber LIMIT 1 into @Applicant;
                    insert into MajorApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
                    select Number from major where  Number=_IDNumber LIMIT 1 into @ApplicantID;
                    insert into MajorApprovalContacts select Fullname,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
END;
END IF;
END;
END IF;    
call ResolveMyNotification(_Approver,'Major Medical Approval');
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
  select Name ,Email ,Mobile ,Msg ,IDNumber from MajorApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApproveMinorMedical` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
DECLARE _NewApplicationNo varchar(50);
DECLARE _Year varchar(50);
 DROP TABLE IF EXISTS MinorApprovalContacts;
 create table MinorApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Approved Registration: ',_IDNumber);
SELECT
  ID
FROM minormedical
WHERE Number = _IDNumber LIMIT 1 INTO @PEID;
INSERT INTO `minormedical_approval_workflow` (Number, Fullname, Status, Approver,Remarks,Created_By,Approved_At,Created_At)
  SELECT
    minorMedical.Number,
    Fullname,
    'Approved',
    _Approver,
     _Remarks,
    _Approver,
    NOW(),
   NOW()
  FROM registration inner join minormedical on minormedical.Number=registration.IDNumber
  WHERE Number = _IDNumber;
SELECT
  IFNULL(COUNT(*), 0)
FROM approvers
WHERE Mandatory = 1
AND ModuleCode = 'MNR'
AND Deleted = 0 INTO @CountMandatory;
SELECT
  IFNULL(COUNT(*), 0)
FROM `minormedical_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 1
  AND ModuleCode = 'MNR'
  AND Deleted = 0) INTO @CountMandatoryApproved;

SELECT
  IFNULL(MaxApprovals, 0)
FROM approvalmodules
WHERE ModuleCode = 'MNR' LIMIT 1 INTO @MaxApprovals;
SELECT
  IFNULL(COUNT(*), 0)
FROM `minormedical_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 0
  AND Deleted = 0
  AND ModuleCode = 'MNR') INTO @CountApproved;
  if @CountMandatoryApproved >= @CountMandatory  THEN
    BEGIN
          if @CountApproved >= @MaxApprovals  THEN
          BEGIN
UPDATE minormedical
SET Status = 'Approved',
    Approve_at = NOW()
WHERE Number = _IDNumber;
UPDATE notifications
SET Status = 'Resolved'
WHERE Category = 'Minor Medical Approval';
CALL Saveapplicationsequence(_IDNumber, 'Minor Medical Approved', 'Awaiting DCI', _Approver);
                 select CreatedBy from minormedical where Number=_IDNumber LIMIT 1 into @Applicant;
                    insert into MinorApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
                    select Number from minormedical where  Number=_IDNumber LIMIT 1 into @ApplicantID;
                    insert into MinorApprovalContacts select Fullname,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
END;
END IF;
END;
END IF;    
call ResolveMyNotification(_Approver,'Minor Medical Approval');
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
  select Name ,Email ,Mobile ,Msg ,IDNumber from MinorApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApproveNEA` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
DECLARE _NewApplicationNo varchar(50);
DECLARE _Year varchar(50);
 DROP TABLE IF EXISTS NEAApprovalContacts;
 create table NEAApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Approved nea: ',_IDNumber);
SELECT
  ID
FROM neaa
WHERE Number = _IDNumber LIMIT 1 INTO @PEID;
INSERT INTO `neaa_approval_workflow` (Number, Fullname, Status, Approver,Remarks,Created_By,Approved_At,Created_At)
  SELECT
    neaa.Number,
    Fullname,
    'Approved',
    _Approver,
     _Remarks,
    _Approver,
    NOW(),
   NOW()
  FROM registration inner join neaa on neaa.Number=registration.IDNumber
  WHERE Number = _IDNumber;
SELECT
  IFNULL(COUNT(*), 0)
FROM approvers
WHERE Mandatory = 1
AND ModuleCode = 'NEA'
AND Deleted = 0 INTO @CountMandatory;
SELECT
  IFNULL(COUNT(*), 0)
FROM `neaa_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 1
  AND ModuleCode = 'NEA'
  AND Deleted = 0) INTO @CountMandatoryApproved;

SELECT
  IFNULL(MaxApprovals, 0)
FROM approvalmodules
WHERE ModuleCode = 'NEA' LIMIT 1 INTO @MaxApprovals;
SELECT
  IFNULL(COUNT(*), 0)
FROM `neaa_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 0
  AND Deleted = 0
  AND ModuleCode = 'NEA') INTO @CountApproved;
  if @CountMandatoryApproved >= @CountMandatory  THEN
    BEGIN
          if @CountApproved >= @MaxApprovals  THEN
          BEGIN
UPDATE neaa
SET Status = 'Approved',
    Approve_at = NOW()
WHERE Number = _IDNumber;
UPDATE notifications
SET Status = 'Resolved'
WHERE Category = 'NEA Approval';
CALL Saveapplicationsequence(_IDNumber, 'NEA Approval', 'Awaiting NEA', _Approver);
                 select CreatedBy from neaa where Number=_IDNumber LIMIT 1 into @Applicant;
                    insert into NEAApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
                    select Number from neaa where  Number=_IDNumber LIMIT 1 into @ApplicantID;
                    insert into NEAApprovalContacts select Fullname,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
END;
END IF;
END;
END IF;    
call ResolveMyNotification(_Approver,'NEA Approval');
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
  select Name ,Email ,Mobile ,Msg ,IDNumber from NEAApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApprovePassport` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
DECLARE _NewApplicationNo varchar(50);
DECLARE _Year varchar(50);
 DROP TABLE IF EXISTS PassportApprovalContacts;
 create table PassportApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Approved Passport: ',_IDNumber);
SELECT
  ID
FROM passport
WHERE Number = _IDNumber LIMIT 1 INTO @PEID;
INSERT INTO `Passport_approval_workflow` (Number, Fullname, Status, Approver,Remarks,Created_By,Approved_At,Created_At)
  SELECT
    passport.Number,
    Fullname,
    'Approved',
    _Approver,
     _Remarks,
    _Approver,
    NOW(),
   NOW()
  FROM registration inner join passport on passport.Number=registration.IDNumber
  WHERE Number = _IDNumber;
SELECT
  IFNULL(COUNT(*), 0)
FROM approvers
WHERE Mandatory = 1
AND ModuleCode = 'PST'
AND Deleted = 0 INTO @CountMandatory;
SELECT
  IFNULL(COUNT(*), 0)
FROM `Passport_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 1
  AND ModuleCode = 'PST'
  AND Deleted = 0) INTO @CountMandatoryApproved;

SELECT
  IFNULL(MaxApprovals, 0)
FROM approvalmodules
WHERE ModuleCode = 'PST' LIMIT 1 INTO @MaxApprovals;
SELECT
  IFNULL(COUNT(*), 0)
FROM `Passport_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 0
  AND Deleted = 0
  AND ModuleCode = 'PST') INTO @CountApproved;
  if @CountMandatoryApproved >= @CountMandatory  THEN
    BEGIN
          if @CountApproved >= @MaxApprovals  THEN
          BEGIN
UPDATE passport
SET Passport_Status = 'Approved',
    Approve_at = NOW()
WHERE Number = _IDNumber;
UPDATE notifications
SET Status = 'Resolved'
WHERE Category = 'Passport Approval';
CALL Saveapplicationsequence(_IDNumber, 'Passport Approval', 'Awaiting Major Medical', _Approver);
                 select CreatedBy from passport where Number=_IDNumber LIMIT 1 into @Applicant;
                    insert into PassportApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
                    select Number from passport where  Number=_IDNumber LIMIT 1 into @ApplicantID;
                    insert into PassportApprovalContacts select Fullname,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
END;
END IF;
END;
END IF;    
call ResolveMyNotification(_Approver,'Passport Approval');
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
  select Name ,Email ,Mobile ,Msg ,IDNumber from PassportApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApproveRegistration` (IN `_IDNO` VARCHAR(50), IN `_Username` VARCHAR(50), IN `_UserID` VARCHAR(50))  BEGIN
 DECLARE lSaleDesc varchar(200);
  set lSaleDesc= CONCAT('Approved  Registration:', _UserName);
UPDATE Registration
SET Status = 'Approved'
WHERE IDNumber =_IDNO
AND UserName = _UserName;
UPDATE majuu.registrationapprovalworkflow
SET Status = 'Approved',
    Approver = _UserID,
    Approved_At = NOW()
WHERE IDNumber = _IDNO
AND UserName = _UserName
AND Status = 'Pending Approval';
CALL SaveAuditTrail(_userID, lSaleDesc, 'Approval', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApproveTicketing` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
DECLARE _NewApplicationNo varchar(50);
DECLARE _Year varchar(50);
 DROP TABLE IF EXISTS TicketApprovalContacts;
 create table TicketApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Approved Visa: ',_IDNumber);
SELECT
  ID
FROM ticketing
WHERE Number = _IDNumber LIMIT 1 INTO @PEID;
INSERT INTO `ticketing_approval_workflow` (Number, Fullname, Status, Approver,Remarks,Created_By,Approved_At,Created_At)
  SELECT
    ticketing.Number,
    Fullname,
    'Approved',
    _Approver,
     _Remarks,
    _Approver,
    NOW(),
   NOW()
  FROM registration inner join ticketing on ticketing.Number=registration.IDNumber
  WHERE Number = _IDNumber;
SELECT
  IFNULL(COUNT(*), 0)
FROM approvers
WHERE Mandatory = 1
AND ModuleCode = 'TKN'
AND Deleted = 0 INTO @CountMandatory;
SELECT
  IFNULL(COUNT(*), 0)
FROM `ticketing_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 1
  AND ModuleCode = 'TKN'
  AND Deleted = 0) INTO @CountMandatoryApproved;

SELECT
  IFNULL(MaxApprovals, 0)
FROM approvalmodules
WHERE ModuleCode = 'TKN' LIMIT 1 INTO @MaxApprovals;
SELECT
  IFNULL(COUNT(*), 0)
FROM `ticketing_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 0
  AND Deleted = 0
  AND ModuleCode = 'TKN') INTO @CountApproved;
  if @CountMandatoryApproved >= @CountMandatory  THEN
    BEGIN
          if @CountApproved >= @MaxApprovals  THEN
          BEGIN
UPDATE ticketing
SET Status = 'Approved',
    Approve_at = NOW()
WHERE Number = _IDNumber;
UPDATE notifications
SET Status = 'Resolved'
WHERE Category = 'Ticketing Approval';
CALL Saveapplicationsequence(_IDNumber, 'Ticketing Approval', 'Awaiting NEA', _Approver);
                 select CreatedBy from ticketing where Number=_IDNumber LIMIT 1 into @Applicant;
                    insert into TicketApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
                    select Number from ticketing where  Number=_IDNumber LIMIT 1 into @ApplicantID;
                    insert into TicketApprovalContacts select Fullname,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
END;
END IF;
END;
END IF;    
call ResolveMyNotification(_Approver,'Ticketing Approval');
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
  select Name ,Email ,Mobile ,Msg ,IDNumber from TicketApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApproveTraining` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
DECLARE _NewApplicationNo varchar(50);
DECLARE _Year varchar(50);
 DROP TABLE IF EXISTS TrainingApprovalContacts;
 create table TrainingApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Approved Training: ',_IDNumber);
SELECT
  ID
FROM training
WHERE Number = _IDNumber LIMIT 1 INTO @PEID;
INSERT INTO `training_approval_workflow` (Number, Fullname, Status, Approver,Remarks,Created_By,Approved_At,Created_At)
  SELECT
    training.Number,
    Fullname,
    'Approved',
    _Approver,
     _Remarks,
    _Approver,
    NOW(),
   NOW()
  FROM registration inner join training on training.Number=registration.IDNumber
  WHERE Number = _IDNumber;
SELECT
  IFNULL(COUNT(*), 0)
FROM approvers
WHERE Mandatory = 1
AND ModuleCode = 'TRG'
AND Deleted = 0 INTO @CountMandatory;
SELECT
  IFNULL(COUNT(*), 0)
FROM `training_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 1
  AND ModuleCode = 'TRG'
  AND Deleted = 0) INTO @CountMandatoryApproved;

SELECT
  IFNULL(MaxApprovals, 0)
FROM approvalmodules
WHERE ModuleCode = 'TRG' LIMIT 1 INTO @MaxApprovals;
SELECT
  IFNULL(COUNT(*), 0)
FROM `training_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 0
  AND Deleted = 0
  AND ModuleCode = 'TRG') INTO @CountApproved;
  if @CountMandatoryApproved >= @CountMandatory  THEN
    BEGIN
          if @CountApproved >= @MaxApprovals  THEN
          BEGIN
UPDATE training
SET Status = 'Approved',
    Approve_at = NOW()
WHERE Number = _IDNumber;
UPDATE notifications
SET Status = 'Resolved'
WHERE Category = 'Training Approva';
CALL Saveapplicationsequence(_IDNumber, 'Training Approval', 'Awaiting NEA', _Approver);
                 select CreatedBy from training where Number=_IDNumber LIMIT 1 into @Applicant;
                    insert into TrainingApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
                    select Number from training where  Number=_IDNumber LIMIT 1 into @ApplicantID;
                    insert into TrainingApprovalContacts select Fullname,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
END;
END IF;
END;
END IF;    
call ResolveMyNotification(_Approver,'Training Approva');
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
  select Name ,Email ,Mobile ,Msg ,IDNumber from TrainingApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApproveTravel` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
DECLARE _NewApplicationNo varchar(50);
DECLARE _Year varchar(50);
 DROP TABLE IF EXISTS TravelApprovalContacts;
 create table TravelApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Approved Travel: ',_IDNumber);
SELECT
  ID
FROM ticketing
WHERE Number = _IDNumber LIMIT 1 INTO @PEID;
INSERT INTO travelling_approval_workflow (Number, Fullname, Status, Approver,Remarks,Created_By,Approved_At,Created_At)
  SELECT
    travelling.Number,
    Fullname,
    'Approved',
    _Approver,
     _Remarks,
    _Approver,
    NOW(),
   NOW()
  FROM registration inner join travelling on travelling.Number=registration.IDNumber
  WHERE Number = _IDNumber;
SELECT
  IFNULL(COUNT(*), 0)
FROM approvers
WHERE Mandatory = 1
AND ModuleCode = 'TRG'
AND Deleted = 0 INTO @CountMandatory;
SELECT
  IFNULL(COUNT(*), 0)
FROM travelling_approval_workflow
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 1
  AND ModuleCode = 'TRG'
  AND Deleted = 0) INTO @CountMandatoryApproved;

SELECT
  IFNULL(MaxApprovals, 0)
FROM approvalmodules
WHERE ModuleCode = 'TRG' LIMIT 1 INTO @MaxApprovals;
SELECT
  IFNULL(COUNT(*), 0)
FROM `ticketing_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 0
  AND Deleted = 0
  AND ModuleCode = 'TRG') INTO @CountApproved;
  if @CountMandatoryApproved >= @CountMandatory  THEN
    BEGIN
          if @CountApproved >= @MaxApprovals  THEN
          BEGIN
UPDATE travelling
SET Approve_Status = 'Approved',
    Approve_at = NOW()
WHERE Number = _IDNumber;
UPDATE notifications
SET Status = 'Resolved'
WHERE Category = 'Travelling Approval';
CALL Saveapplicationsequence(_IDNumber, 'Travelling Approval', 'Awaiting NEA', _Approver);
                 select CreatedBy from travelling where Number=_IDNumber LIMIT 1 into @Applicant;
                    insert into TravelApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
                    select Number from travelling where  Number=_IDNumber LIMIT 1 into @ApplicantID;
                    insert into TravelApprovalContacts select Fullname,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
END;
END IF;
END;
END IF;    
call ResolveMyNotification(_Approver,'Travelling Approval');
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
  select Name ,Email ,Mobile ,Msg ,IDNumber from TicketApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ApproveVisa` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
DECLARE _NewApplicationNo varchar(50);
DECLARE _Year varchar(50);
 DROP TABLE IF EXISTS VisaApprovalContacts;
 create table VisaApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Approved Visa: ',_IDNumber);
SELECT
  ID
FROM visa
WHERE Number = _IDNumber LIMIT 1 INTO @PEID;
INSERT INTO `visa_approval_workflow` (Number, Fullname, Status, Approver,Remarks,Created_By,Approved_At,Created_At)
  SELECT
    visa.Number,
    Fullname,
    'Approved',
    _Approver,
     _Remarks,
    _Approver,
    NOW(),
   NOW()
  FROM registration inner join visa on visa.Number=registration.IDNumber
  WHERE Number = _IDNumber;
SELECT
  IFNULL(COUNT(*), 0)
FROM approvers
WHERE Mandatory = 1
AND ModuleCode = 'VSA'
AND Deleted = 0 INTO @CountMandatory;
SELECT
  IFNULL(COUNT(*), 0)
FROM `visa_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 1
  AND ModuleCode = 'VSA'
  AND Deleted = 0) INTO @CountMandatoryApproved;

SELECT
  IFNULL(MaxApprovals, 0)
FROM approvalmodules
WHERE ModuleCode = 'VSA' LIMIT 1 INTO @MaxApprovals;
SELECT
  IFNULL(COUNT(*), 0)
FROM `visa_approval_workflow`
WHERE Number = _IDNumber
AND Status = 'Approved'
AND Approver IN (SELECT
    Username
  FROM approvers
  WHERE Mandatory = 0
  AND Deleted = 0
  AND ModuleCode = 'VSA') INTO @CountApproved;
  if @CountMandatoryApproved >= @CountMandatory  THEN
    BEGIN
          if @CountApproved >= @MaxApprovals  THEN
          BEGIN
UPDATE visa
SET Visa_Status = 'Approved',
    Approve_at = NOW()
WHERE Number = _IDNumber;
UPDATE notifications
SET Status = 'Resolved'
WHERE Category = 'Visa Approval';
CALL Saveapplicationsequence(_IDNumber, 'Visa Approval', 'Awaiting NEA', _Approver);
                 select CreatedBy from visa where Number=_IDNumber LIMIT 1 into @Applicant;
                    insert into VisaApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
                    select Number from visa where  Number=_IDNumber LIMIT 1 into @ApplicantID;
                    insert into VisaApprovalContacts select Fullname,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
END;
END IF;
END;
END IF;    
call ResolveMyNotification(_Approver,'Visa Approval');
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
  select Name ,Email ,Mobile ,Msg ,IDNumber from VisaApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AttestationRedAlerts` ()  BEGIN
SELECT
  COUNT(*) AS AttestationRedAlerts
FROM attestation
WHERE SUBDATE(NOW(), INTERVAL 6 DAY)
AND Deleted = 0
AND Clearance_status = 'pending';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ContractRedAlerts` ()  BEGIN
SELECT
  COUNT(*) AS ContractRedAlerts
FROM contract
WHERE SUBDATE(NOW(), INTERVAL 4 DAY)
AND Deleted = 0
AND Contract_status = 'pending';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DailyRegistrationRecords` (IN `_date` DATE)  BEGIN
SELECT
  Fullname,
  Phone,
  Email,
  IDNumber,
  Gender,
  Country,
  County,
  DOB,
  Marital
FROM registration
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DCIRedAlerts` ()  BEGIN
SELECT
  COUNT(*) AS DCIRedAlerts
FROM dci
WHERE SUBDATE(NOW(), INTERVAL 10 DAY)
AND Deleted = 0
AND Certificate_status = 'processing';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeclineApplication` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
 DROP TABLE IF EXISTS ApplicationApprovalContacts;
 create table ApplicationApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));

set lSaleDesc= CONCAT(' Declined Application: ',_IDNumber); 
UPDATE applications_approval_workflow
SET Status='Declined',Approved_At=now(),Remarks=_Remarks
WHERE Approver=_Approver and IDNumber=_IDNumber;
update registration set Status='DECLINED' where IDNumber=_IDNumber;
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
   update notifications set Status='Resolved' where Category='Applications Approval' and  IDNumber=_IDNumber;   

select CreatedBy from registration where IDNumber=_IDNumber LIMIT 1 into @Applicant;
insert into ApplicationApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
select IDNumber from registration where  IDNumber=_IDNumber LIMIT 1 into @ApplicantID;
insert into ApplicationApprovalContacts select Fullname ,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
  select * from ApplicationApprovalContacts;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeclineAttestation` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
 DROP TABLE IF EXISTS AttestationApprovalContacts;
 create table AttestationApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Declined Attestation: ',_IDNumber); 
update neaa set Status='DECLINED',Approve_at=now()  where Number=_IDNumber;
call SaveAuditTrail(_Approver,lSaleDesc,'Attestation  decline','0' );
   update notifications set Status='Resolved',Approve_at=now() where Category='Attestation Approval' ;   
select CreatedBy from attestation where Number=_IDNumber LIMIT 1 into @Applicant;
insert into AttestationApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
select Number from neaa where  Number=_IDNumber LIMIT 1 into @ApplicantID;
insert into AttestationApprovalContacts select Fullname ,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
  select * from AttestationApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeclineContract` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
 DROP TABLE IF EXISTS ContractApprovalContacts;
 create table ContractApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Declined Contract processing: ',_IDNumber); 
update contract set Status='DECLINED',Approve_at=now()  where Number=_IDNumber;
call SaveAuditTrail(_Approver,lSaleDesc,'Contract Processing decline','0' );
   update notifications set Status='Resolved'where Category='Contract Processing Approval' ;   
select CreatedBy from contract where Number=_IDNumber LIMIT 1 into @Applicant;
insert into ContractApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
select Number from contract where  Number=_IDNumber LIMIT 1 into @ApplicantID;
insert into ContractApprovalContacts select Fullname ,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
  select * from DCIApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeclineDCI` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
 DROP TABLE IF EXISTS DCIApprovalContacts;
 create table DCIApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Declined Application: ',_IDNumber); 
update dci set Status='DECLINED' where Number=_IDNumber;
call SaveAuditTrail(_Approver,lSaleDesc,'dci decline','0' );
   update notifications set Status='Resolved' where Category='DCI Approval' and IDNumber=_IDNumber;   
select CreatedBy from dci where Number=_IDNumber LIMIT 1 into @Applicant;
insert into DCIApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
select Number from dci where  Number=_IDNumber LIMIT 1 into @ApplicantID;
insert into DCIApprovalContacts select Fullname ,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
  select * from DCIApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeclineFinal` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
 DROP TABLE IF EXISTS FinalApprovalContacts;
 create table FinalApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Declined Application: ',_IDNumber); 
update finalmedical set Status='DECLINED' where Number=_IDNumber;
call SaveAuditTrail(_Approver,lSaleDesc,'dci decline','0' );
   update notifications set Status='Resolved' where Category='DCI Approval' and IDNumber=_IDNumber ;   
select CreatedBy from finalmedical where Number=_IDNumber LIMIT 1 into @Applicant;
insert into FinalApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
select Number from finalmedical where  Number=_IDNumber LIMIT 1 into @ApplicantID;
insert into FinalApprovalContacts select Fullname ,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
  select * from FinalApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeclineMajorMedical` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
 DROP TABLE IF EXISTS MajorApprovalContacts;
 create table MajorApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Declined Major medical: ',_IDNumber); 
update major set Status='DECLINED' where Number=_IDNumber;
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
   update notifications set Status='Resolved' where Category='Major Medical Approval'  and IDNumber=_IDNumber;   
select CreatedBy from major where Number=_IDNumber LIMIT 1 into @Applicant;
insert into MajorApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
select Number from major where  Number=_IDNumber LIMIT 1 into @ApplicantID;
insert into MajorApprovalContacts select Fullname ,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
  select * from MajorApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeclineMinorMedical` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
 DROP TABLE IF EXISTS MinorApprovalContacts;
 create table MinorApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Declined minor medical: ',_IDNumber); 
update minormedical set Status='DECLINED' where Number=_IDNumber;
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
   update notifications set Status='Resolved' where Category='Minor Medical Approval' ;   
select CreatedBy from minormedical where Number=_IDNumber LIMIT 1 into @Applicant;
insert into MinorApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
select Number from minormedical where  Number=_IDNumber LIMIT 1 into @ApplicantID;
insert into MinorApprovalContacts select Fullname ,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
  select * from MinorApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeclineNEA` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
 DROP TABLE IF EXISTS NEAApprovalContacts;
 create table NEAApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Declined Contract processing: ',_IDNumber); 
update neaa set Status='DECLINED',Approve_at=now()  where Number=_IDNumber;
call SaveAuditTrail(_Approver,lSaleDesc,'NEA decline','0' );
   update notifications set Status='Resolved'where Category='NEA Approval' ;   
select CreatedBy from neaa where Number=_IDNumber LIMIT 1 into @Applicant;
insert into NEAApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
select Number from neaa where  Number=_IDNumber LIMIT 1 into @ApplicantID;
insert into NEAApprovalContacts select Fullname ,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
  select * from NEAApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeclinePassport` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
 DROP TABLE IF EXISTS MinorApprovalContacts;
 create table MinorApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Declined Passport Processing: ',_IDNumber); 
update passport set Passport_Status='DECLINED' where Number=_IDNumber;
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
   update notifications set Status='Resolved' where Category='Passport Approval' ;   
select CreatedBy from passport where Number=_IDNumber LIMIT 1 into @Applicant;
insert into PassportApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
select Number from passport where  Number=_IDNumber LIMIT 1 into @ApplicantID;
insert into PassportApprovalContacts select Fullname ,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
  select * from PassportApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeclineTicketing` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
 DROP TABLE IF EXISTS TicketApprovalContacts;
 create table TicketApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Declined Ticketing: ',_IDNumber); 
update major set Status='DECLINED' where Number=_IDNumber;
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
   update notifications set Status='Resolved' where Category='Tiketing Approval'  and IDNumber=_IDNumber;   
select CreatedBy from ticketing where Number=_IDNumber LIMIT 1 into @Applicant;
insert into TicketApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
select Number from ticketing where  Number=_IDNumber LIMIT 1 into @ApplicantID;
insert into TicketApprovalContacts select Fullname ,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
  select * from TicketApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeclineTraining` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
 DROP TABLE IF EXISTS TrainingApprovalContacts;
 create table TrainingApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Declined Training: ',_IDNumber); 
update training set Status='DECLINED' where Number=_IDNumber;
call SaveAuditTrail(_Approver,lSaleDesc,'Approval Training','0' );
   update notifications set Status='Resolved' where Category='Training Approval' and IDNumber=_IDNumber ;   
select CreatedBy from training where Number=_IDNumber LIMIT 1 into @Applicant;
insert into TrainingApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
select Number from training where  Number=_IDNumber LIMIT 1 into @ApplicantID;
insert into TrainingApprovalContacts select Fullname ,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
  select * from TrainingApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeclineTravel` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
 DROP TABLE IF EXISTS TravelApprovalContacts;
 create table TravelApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Declined travel: ',_IDNumber); 
update travelling set Approve_Status='DECLINED' where Number=_IDNumber;
call SaveAuditTrail(_Approver,lSaleDesc,'Approval','0' );
   update notifications set Status='Resolved' where Category='Travelling Approval'  and IDNumber=_IDNumber;   
select CreatedBy from travelling where Number=_IDNumber LIMIT 1 into @Applicant;
insert into TravelApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
select Number from travelling where  Number=_IDNumber LIMIT 1 into @ApplicantID;
insert into TravelApprovalContacts select Fullname ,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
  select * from TravelApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeclineVisa` (IN `_Approver` VARCHAR(50), IN `_IDNumber` VARCHAR(50), IN `_Remarks` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
 DROP TABLE IF EXISTS VisaApprovalContacts;
 create table VisaApprovalContacts(Name varchar(100),Email varchar(150),Mobile varchar(50),Msg varchar(50),IDNumber varchar(50));
set lSaleDesc= CONCAT('Declined Visa processing: ',_IDNumber); 
update visa set Visa_Status='DECLINED',Approve_at=now()  where Number=_IDNumber;
call SaveAuditTrail(_Approver,lSaleDesc,'Visa decline','0' );
   update notifications set Status='Resolved'where Category='Visa Approval' ;   
select CreatedBy from visa where Number=_IDNumber LIMIT 1 into @Applicant;
insert into VisaApprovalContacts select Name,Email,Phone,'Applicant',_IDNumber from users where Username =@Applicant;
select Number from visa where  Number=_IDNumber LIMIT 1 into @ApplicantID;
insert into VisaApprovalContacts select Fullname ,Email,Phone,'Applicant',_IDNumber from registration where  IDNumber=@ApplicantID; 
  select * from VisaApprovalContacts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeletBranch` (IN `_ID` INT, `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted Branch with iD:',_ID);
UPDATE branches
SET Deleted = 1,
    Deleted_By = _UserID
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteApprover` (IN `_Username` VARCHAR(50), IN `_UserID` VARCHAR(50), IN `_Module` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted Approver: '+ _Username );
UPDATE approvers
SET Deleted = 1,
    Deleted_At = NOW(),
    DeletedBY = _UserID
WHERE Username = _Username
AND ModuleCode = _Module;
CALL SaveAuditTrail(_userID, lSaleDesc, 'DELETE', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteAttestation` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted attestation  with ID: ', _ID);
UPDATE attestation
SET Deleted = 1
WHERE ID = _ID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteConfigurations` (IN `_UserID` VARCHAR(50), IN `_Code` VARCHAR(50))  BEGIN
UPDATE `configurations`
SET `Deleted` = 1,
    `Deleted_By` = _UserID
WHERE Code = _Code;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteContract` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted contract processing  with ID: ', _ID);
UPDATE contract
SET Deleted = 1
WHERE ID = _ID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Deletecountry` (IN `_ID` VARCHAR(50), IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted county with CODE:',_ID);
UPDATE countries
SET Deleted = 1,
    Deleted_By = _UserID
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Deletecounty` (IN `_Code` VARCHAR(50), IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted county with CODE:',_Code);
UPDATE counties
SET Deleted = 1,
    Deleted_By = _UserID
WHERE Code = _Code;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteDCI` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted DCI Clearance  with ID: ', _ID);
UPDATE dci
SET Deleted = 1
WHERE ID = _ID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteDocument` (IN `_Name` VARCHAR(100), IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);

set lSaleDesc= CONCAT('Deleted Document with name: ',_Name);
UPDATE registrationdocuments
SET Deleted = 1,
    Deleted_At = NOW(),
    Deleted_By = _UserID
WHERE FileName = _Name;
CALL SaveAuditTrail(_UserID, lSaleDesc, 'DELETE', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteEducationalDetails` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted educational details with iD: ', _ID);
UPDATE educationaldetails
SET Deleted = 1
WHERE ID = _ID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteFinalMedical` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted Final medical  with ID: ', _ID);
UPDATE finalmedical
SET Deleted = 1
WHERE ID = _ID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteMajorMedical` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted minor medical  with ID: ', _ID);
UPDATE major
SET Deleted = 1
WHERE ID = _ID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeletemedicalFacility` (IN `_MedID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted medical facility with ID: ', _MedID);
UPDATE medicalfacility
SET Deleted = 1
WHERE MedID = _MedID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteMinorMedical` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted minor medical  with ID: ', _ID);
UPDATE minormedical
SET Deleted = 1
WHERE ID = _ID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteNEAA` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted NEAA  with ID: ', _ID);
UPDATE neaa
SET Deleted = 1
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteNextOFKIn` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted Next of kin with iD: ', _ID);
UPDATE nextofkin
SET Deleted = 1
WHERE ID = _ID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteParent` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted parent  with iD: ', _ID);
UPDATE parents
SET Deleted = 1
WHERE ID = _ID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeletePassport` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted Passport Processing   with iD: ', _ID);
UPDATE passport
SET Deleted = 1
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteRegistration` (IN `_IDNumber` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted APpplicant with IDNumber: ', _IDNumber);
UPDATE registration
SET Deleted = 1
WHERE IDNumber = _IDNumber;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteRole` (IN `_RoleID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted Role with iD: ', _RoleID);
UPDATE roles
SET deleted = 1
WHERE RoleID = _RoleID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteSiblings` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);

UPDATE siblings
SET Deleted = 1
WHERE ID = _ID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteTicketing` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted Ticketing  with ID: ', _ID);
UPDATE ticketing
SET Deleted = 1
WHERE ID = _ID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteTraining` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted training  with ID: ', _ID);
UPDATE training
SET Deleted = 1
WHERE ID = _ID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteTravelling` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted Travelling  with ID: ', _ID);
UPDATE travelling
SET Deleted = 1
WHERE ID = _ID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Deleteuser` (IN `_UserName` VARCHAR(50), IN `_UserID` VARCHAR(20))  NO SQL
BEGIN

DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted User with Username: ', _UserName);

UPDATE users
SET deleted = 1
WHERE Username = _Username;
CALL SaveAuditTrail(_UserID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteuserGroup` (IN `_UserGroupID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted UserGroup with iD:',_UserGroupID);
UPDATE usergroups
SET deleted = 1
WHERE UserGroupID = _UserGroupID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteVisa` (IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Deleted  Visa Processing with ID: ', _ID);
UPDATE visa
SET Deleted = 1
WHERE ID = _ID;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Delete', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EmailVerification` (IN `_Code` VARCHAR(100), IN `_UserName` VARCHAR(50))  NO SQL
BEGIN
if( SELECT
    COUNT(*)
  FROM users
  WHERE Username = _UserName
  AND ActivationCode = _Code) > 0 THEN

Begin
UPDATE users
SET IsEmailverified = 1,
    IsActive = 1
WHERE Username = _UserName
AND ActivationCode = _Code;
SELECT
  'Email Verified' AS msg;
END;
ELSE
 
BEGIN
SELECT
  'User does not exist or wrong activation code' AS msg;
END;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `finalmedicalRedAlerts` ()  BEGIN
SELECT
  COUNT(*) AS finalmedicalRedAlerts
FROM finalmedical
WHERE SUBDATE(NOW(), INTERVAL 3 DAY)
AND Deleted = 0
AND MedicalResult = 'pending';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateDCI` (IN `_Certificate_status` VARCHAR(50), IN `_FromDate` DATE, IN `_ToDate` DATE, IN `_AllDates` BOOLEAN)  NO SQL
BEGIN

  if(_AllDates=1) THEN
  Begin
      if(_Certificate_status='Processing') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  minormedical.Result,
  dci.ID,
  DCI.Number,
  DCI.DOT,
  DCI.CostIncurred,
  DCI.Processing,
  dci.Certificate_status,
  dci.DOC,
  dci.Cost
FROM `dci`
  INNER JOIN registration
    ON registration.`IDNumber` = dci.Number
  INNER JOIN minormedical
    ON dci.Number = minormedical.Number
WHERE minormedical.Result = 'Pass'
AND dci.Deleted = 0
AND dci.Certificate_status = 'Processing'
AND minormedical.Deleted = 0
ORDER BY dci.Created_At DESC;
END;
END IF;
      if(_Certificate_status='collected') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  minormedical.Result,
  dci.ID,
  DCI.Number,
  DCI.DOT,
  DCI.CostIncurred,
  DCI.Processing,
  dci.Certificate_status,
  dci.DOC,
  dci.Cost
FROM `dci`
  INNER JOIN registration
    ON registration.`IDNumber` = dci.Number
  INNER JOIN minormedical
    ON dci.Number = minormedical.Number
WHERE minormedical.Result = 'Pass'
AND dci.Deleted = 0
AND dci.Certificate_status = 'collected'
AND minormedical.Deleted = 0
ORDER BY dci.Created_At DESC;
END;
END IF;
       if(_Certificate_status='Defaulted') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  minormedical.Result,
  dci.ID,
  DCI.Number,
  DCI.DOT,
  DCI.CostIncurred,
  DCI.Processing,
  dci.Certificate_status,
  dci.DOC,
  dci.Cost
FROM `dci`
  INNER JOIN registration
    ON registration.`IDNumber` = dci.Number
  INNER JOIN minormedical
    ON dci.Number = minormedical.Number
WHERE minormedical.Result = 'Pass'
AND dci.Deleted = 0
AND dci.Certificate_status = 'Defaulted'
AND minormedical.Deleted = 0
ORDER BY dci.Created_At DESC;
END;
END IF;
      
       if(_Certificate_status='All') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  minormedical.Result,
  dci.ID,
  DCI.Number,
  DCI.DOT,
  DCI.CostIncurred,
  DCI.Processing,
  dci.Certificate_status,
  dci.DOC,
  dci.Cost
FROM `dci`
  INNER JOIN registration
    ON registration.`IDNumber` = dci.Number
  INNER JOIN minormedical
    ON dci.Number = minormedical.Number
WHERE minormedical.Result = 'Pass'
AND dci.Deleted = 0
AND minormedical.Deleted = 0
ORDER BY dci.Created_At DESC;
END;
END IF;
END;
ELSE
  Begin
   if(_Certificate_status='Processing') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  minormedical.Result,
  dci.ID,
  DCI.Number,
  DCI.DOT,
  DCI.CostIncurred,
  DCI.Processing,
  dci.Certificate_status,
  dci.DOC,
  dci.Cost
FROM `dci`
  INNER JOIN registration
    ON registration.`IDNumber` = dci.Number
  INNER JOIN minormedical
    ON dci.Number = minormedical.Number
WHERE CAST(dci.Created_At AS date) BETWEEN CAST(_FromDate AS date) AND CAST(DATE_ADD(_ToDate, INTERVAL 1 DAY) AS date)
AND minormedical.Result = 'Pass'
AND dci.Deleted = 0
AND dci.Certificate_status = 'Processing'
AND minormedical.Deleted = 0
ORDER BY dci.Created_At DESC;
END;
END IF;
        if(_Certificate_status='collected') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  minormedical.Result,
  dci.ID,
  DCI.Number,
  DCI.DOT,
  DCI.CostIncurred,
  DCI.Processing,
  dci.Certificate_status,
  dci.DOC,
  dci.Cost
FROM `dci`
  INNER JOIN registration
    ON registration.`IDNumber` = dci.Number
  INNER JOIN minormedical
    ON dci.Number = minormedical.Number
WHERE CAST(dci.Created_At AS date) BETWEEN CAST(_FromDate AS date) AND CAST(DATE_ADD(_ToDate, INTERVAL 1 DAY) AS date)
AND minormedical.Result = 'Pass'
AND dci.Deleted = 0
AND dci.Certificate_status = 'collected'
AND minormedical.Deleted = 0
ORDER BY dci.Created_At DESC;
END;
END IF;
       if(_Certificate_status='Defaulted') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  minormedical.Result,
  dci.ID,
  DCI.Number,
  DCI.DOT,
  DCI.CostIncurred,
  DCI.Processing,
  dci.Certificate_status,
  dci.DOC,
  dci.Cost
FROM `dci`
  INNER JOIN registration
    ON registration.`IDNumber` = dci.Number
  INNER JOIN minormedical
    ON dci.Number = minormedical.Number
WHERE CAST(dci.Created_At AS date) BETWEEN CAST(_FromDate AS date) AND CAST(DATE_ADD(_ToDate, INTERVAL 1 DAY) AS date)
AND minormedical.Result = 'Pass'
AND dci.Deleted = 0
AND dci.Certificate_status = 'Defaulted'
AND minormedical.Deleted = 0
ORDER BY dci.Created_At DESC;

END;
END IF;
      
       if(_Certificate_status='All') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  minormedical.Result,
  dci.ID,
  DCI.Number,
  DCI.DOT,
  DCI.CostIncurred,
  DCI.Processing,
  dci.Certificate_status,
  dci.DOC,
  dci.Cost
FROM `dci`
  INNER JOIN registration
    ON registration.`IDNumber` = dci.Number
  INNER JOIN minormedical
    ON dci.Number = minormedical.Number
WHERE CAST(dci.Created_At AS date) BETWEEN CAST(_FromDate AS date) AND CAST(DATE_ADD(_ToDate, INTERVAL 1 DAY) AS date)
AND minormedical.Result = 'Pass'
AND dci.Deleted = 0
AND minormedical.Deleted = 0
ORDER BY dci.Created_At DESC;
END;
END IF;

END;
END IF;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerateMinorMedicalDaily` (IN `_FromDate` DATE, IN `_ToDate` DATE, IN `_All` BOOLEAN)  BEGIN
  if(_All=1) Then
    Begin
DROP TABLE IF EXISTS MinorMedicalBuffer;
  create table MinorMedicalBuffer(Fullname varchar(100),IDNumber varchar(100),Number varchar(100),DOM Date,MedicalFacility varchar(100),
Type varchar(20),Cost varchar(20),Created_at datetime);
INSERT INTO MinorMedicalBuffer
  SELECT
    registration.Fullname,
    registration.IDNumber,
    minormedical.Number,
    minormedical.DOM,
    minormedical.MedicalFacility,
    minormedical.Type,
    minormedical.Cost,
    minormedical.Created_at
  FROM minormedical
    INNER JOIN registration
      ON registration.IDNumber = minormedical.Number
  WHERE minormedical.Deleted = 0;
SELECT
  Fullname,
  Number,
  DOM,
  MedicalFacility,
  Type,
  cost,
  DATE(Created_At) AS date
FROM MinorMedicalBuffer
GROUP BY TIME(Created_at)
ORDER BY date;
END;
ELSE
 Begin
DROP TABLE IF EXISTS MinorMedicalBuffer;
create table MinorMedicalBuffer(Fullname varchar(100),IDNumber varchar(100),Number varchar(100),DOM Date,MedicalFacility varchar(100),
Type varchar(20),Cost varchar(20),Created_at Datetime);
INSERT INTO MinorMedicalBuffer
  SELECT
    registration.Fullname,
    registration.IDNumber,
    minormedical.Number,
    minormedical.DOM,
    minormedical.MedicalFacility,
    minormedical.Type,
    minormedical.Cost,
    minormedical.Created_at
  FROM minormedical
    INNER JOIN registration
      ON registration.IDNumber = minormedical.Number
  WHERE minormedical.Deleted = 0
  AND minormedical.created_at BETWEEN _FromDate AND DATE_ADD(_ToDate, INTERVAL 1 DAY);
SELECT
  Fullname,
  Number,
  DOM,
  MedicalFacility,
  Type,
  cost,
  DATE(Created_At) AS date
FROM MinorMedicalBuffer
GROUP BY TIME(Created_at)
ORDER BY date;
END;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generatePassport` (IN `_Status` VARCHAR(50), IN `_FromDate` DATE, IN `_ToDate` DATE, IN `_AllDates` BOOLEAN)  NO SQL
BEGIN

  if(_AllDates=1) THEN
  Begin
      if(_Status='Processing') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  passport.Cost,
  passport.Passport_Collection_Date,
  PassPortNumber,
  Tracking_Number,
  POD,
  passport.ID,
  passport.Number,
  passport.Status,
  passport.PassportOption,
  passport.CostIncurred,
  passport.Location
FROM `passport`
  INNER JOIN registration
    ON registration.`IDNumber` = passport.Number
  INNER JOIN dci
    ON dci.Number = passport.Number
WHERE passport.Deleted = 0
AND passport.Status = 'Processing'
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0
ORDER BY passport.Created_At DESC;
END;
END IF;
      if(_Status='Collected') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  passport.Cost,
  passport.Passport_Collection_Date,
  PassPortNumber,
  Tracking_Number,
  POD,
  passport.ID,
  passport.Number,
  passport.Status,
  passport.PassportOption,
  passport.CostIncurred,
  passport.Location
FROM `passport`
  INNER JOIN registration
    ON registration.`IDNumber` = passport.Number
  INNER JOIN dci
    ON dci.Number = passport.Number
WHERE passport.Deleted = 0
AND dci.Certificate_status = 'Collected'
AND passport.Status = 'Collected'
AND dci.Deleted = 0
ORDER BY passport.Created_At DESC;
END;
END IF;
       if(_Status='Defaulted') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  passport.Cost,
  passport.Passport_Collection_Date,
  PassPortNumber,
  Tracking_Number,
  POD,
  passport.ID,
  passport.Number,
  passport.Status,
  passport.PassportOption,
  passport.CostIncurred,
  passport.Location
FROM `passport`
  INNER JOIN registration
    ON registration.`IDNumber` = passport.Number
  INNER JOIN dci
    ON dci.Number = passport.Number
WHERE passport.Deleted = 0
AND dci.Certificate_status = 'Collected'
AND passport.Status = 'Defaulted'
AND dci.Deleted = 0
ORDER BY passport.Created_At DESC;
END;
END IF;
      
       if(_Status='All') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  passport.Cost,
  passport.Passport_Collection_Date,
  PassPortNumber,
  Tracking_Number,
  POD,
  passport.ID,
  passport.Number,
  passport.Status,
  passport.PassportOption,
  passport.CostIncurred,
  passport.Location
FROM `passport`
  INNER JOIN registration
    ON registration.`IDNumber` = passport.Number
  INNER JOIN dci
    ON dci.Number = passport.Number
WHERE passport.Deleted = 0
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0
ORDER BY passport.Created_At DESC;
END;
END IF;
END;
ELSE
  Begin
   if(_Status='Processing') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  passport.Cost,
  passport.Passport_Collection_Date,
  PassPortNumber,
  Tracking_Number,
  POD,
  passport.ID,
  passport.Number,
  passport.Status,
  passport.PassportOption,
  passport.CostIncurred,
  passport.Location
FROM `passport`
  INNER JOIN registration
    ON registration.`IDNumber` = passport.Number
  INNER JOIN dci
    ON dci.Number = passport.Number
WHERE CAST(passport.Created_At AS date) BETWEEN CAST(_FromDate AS date) AND CAST(DATE_ADD(_ToDate, INTERVAL 1 DAY) AS date)
AND passport.Deleted = 0
AND passport.Status = 'Processing'
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0
ORDER BY passport.Created_At DESC;
END;
END IF;
        if(_Status='collected') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  passport.Cost,
  passport.Passport_Collection_Date,
  PassPortNumber,
  Tracking_Number,
  POD,
  passport.ID,
  passport.Number,
  passport.Status,
  passport.PassportOption,
  passport.CostIncurred,
  passport.Location
FROM `passport`
  INNER JOIN registration
    ON registration.`IDNumber` = passport.Number
  INNER JOIN dci
    ON dci.Number = passport.Number
WHERE CAST(passport.Created_At AS date) BETWEEN CAST(_FromDate AS date) AND CAST(DATE_ADD(_ToDate, INTERVAL 1 DAY) AS date)
AND passport.Deleted = 0
AND passport.Status = 'collected'
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0
ORDER BY passport.Created_At DESC;
END;
END IF;
       if(_Status='Defaulted') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  passport.Cost,
  passport.Passport_Collection_Date,
  PassPortNumber,
  Tracking_Number,
  POD,
  passport.ID,
  passport.Number,
  passport.Status,
  passport.PassportOption,
  passport.CostIncurred,
  passport.Location
FROM `passport`
  INNER JOIN registration
    ON registration.`IDNumber` = passport.Number
  INNER JOIN dci
    ON dci.Number = passport.Number
WHERE CAST(passport.Created_At AS date) BETWEEN CAST(_FromDate AS date) AND CAST(DATE_ADD(_ToDate, INTERVAL 1 DAY) AS date)
AND passport.Deleted = 0
AND passport.Status = 'Defaulted'
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0
ORDER BY passport.Created_At DESC;

END;
END IF;
      
       if(_Status='All') THEN
      Begin
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  passport.Cost,
  passport.Passport_Collection_Date,
  PassPortNumber,
  Tracking_Number,
  POD,
  passport.ID,
  passport.Number,
  passport.Status,
  passport.PassportOption,
  passport.CostIncurred,
  passport.Location
FROM `passport`
  INNER JOIN registration
    ON registration.`IDNumber` = passport.Number
  INNER JOIN dci
    ON dci.Number = passport.Number
WHERE CAST(passport.Created_At AS date) BETWEEN CAST(_FromDate AS date) AND CAST(DATE_ADD(_ToDate, INTERVAL 1 DAY) AS date)
AND passport.Deleted = 0
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0
ORDER BY passport.Created_At DESC;
END;
END IF;

END;
END IF;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerateRegistration` (IN `_FromDate` DATE, IN `_ToDate` DATE, IN `_All` BOOLEAN)  BEGIN
  if(_All=1) Then
    Begin
DROP TABLE IF EXISTS requesthandledBuffer;
  create table requesthandledBuffer(IDNumber varchar(100),Phone varchar(100),DOB Date,Created_at datetime,County varchar(100),Fullname varchar(50));
INSERT INTO requesthandledBuffer
  SELECT
    IDNumber,
    Phone,
    DOB,
    Created_at,
    County,
    Fullname
  FROM registration
  WHERE Deleted = 0;
SELECT
  COUNT(IDNumber) AS Count,
  IDNumber,
  Fullname,
  Phone,
  DOB,
  County,
  DATE(Created_At) AS date
FROM requesthandledBuffer
GROUP BY TIME(Created_at);
END;
ELSE
 Begin
DROP TABLE IF EXISTS requesthandledBuffer;
  create table requesthandledBuffer(IDNumber varchar(100),Phone varchar(100),DOB Date,Created_at Date,County varchar(100),Fullname varchar(50));
INSERT INTO requesthandledBuffer
  SELECT
    IDNumber,
    Phone,
    DOB,
    created_at,
    County,
    Fullname
  FROM registration
  WHERE Deleted = 0
  AND created_at BETWEEN _FromDate AND DATE_ADD(_ToDate, INTERVAL 1 DAY);
SELECT
  COUNT(IDNumber) AS Count,
  IDNumber,
  Fullname,
  Phone,
  DOB,
  County,
  DATE(Created_At) AS date
FROM requesthandledBuffer
GROUP BY TIME(Created_at);

END;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerateRegistrationDaily` (IN `_FromDate` DATE, IN `_ToDate` DATE, IN `_All` BOOLEAN)  BEGIN
  if(_All=1) Then
    Begin
DROP TABLE IF EXISTS requesthandledBuffer1;
  create table requesthandledBuffer1(IDNumber varchar(100),Phone varchar(100),DOB Date,Created_at datetime,County varchar(100),Fullname varchar(50));
INSERT INTO requesthandledBuffer1
  SELECT
    IDNumber,
    Phone,
    DOB,
    Created_at,
    County,
    Fullname
  FROM registration
  WHERE Deleted = 0;
SELECT
  IDNumber,
  Fullname,
  Phone,
  DOB,
  County,
  DATE(Created_At) AS date,
  TIME(Created_At) AS time
FROM requesthandledBuffer1
GROUP BY TIME(Created_at)
ORDER BY date;
END;
ELSE
 Begin
DROP TABLE IF EXISTS requesthandledBuffer1;
  create table requesthandledBuffer1(IDNumber varchar(100),Phone varchar(100),DOB Date,Created_at datetime,County varchar(100),Fullname varchar(50));
INSERT INTO requesthandledBuffer1
  SELECT
    IDNumber,
    Phone,
    DOB,
    created_at,
    County,
    Fullname
  FROM registration
  WHERE Deleted = 0
  AND created_at BETWEEN _FromDate AND DATE_ADD(_ToDate, INTERVAL 1 DAY);
SELECT
  IDNumber,
  Fullname,
  Phone,
  DOB,
  County,
  DATE(Created_At) AS date,
  TIME(Created_At) AS time
FROM requesthandledBuffer1
GROUP BY TIME(Created_at)
ORDER BY date;
END;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllvenues` ()  BEGIN

SELECT
  Venues.ID,
  Branches.Description AS Branch,
  Venues.Name,
  Venues.Description
FROM Venues
  INNER JOIN Branches
    ON Branches.ID = Venues.Branch
WHERE Venues.deleted = 0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getapplicationdocuments` ()  NO SQL
BEGIN
SELECT
  `ID`,
  `IDNumber`,
  DocName,
  `Description`,
  Path,
  Created_At
  Created_By
FROM `registrationdocuments`
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getapplicationsPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
    registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
  registration.Status,
  registration.Weight,
  registration.Languages,
  registration.Skills  from registration
WHERE registration.Status = 'Pending Approval'
AND registration.IDNumber
NOT IN (SELECT
    IDNumber
  FROM `applications_approval_workflow`
  WHERE Approver = _Approver)
AND _Approver IN (SELECT
    Username
  FROM approvers
  WHERE ModuleCode = 'REG'
  AND Active = 1
  AND Deleted = 0);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetApprovalModules` ()  NO SQL
BEGIN
SELECT
  *
FROM approvalmodules;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetApproverDetails` (IN `_ApplicationNo` VARCHAR(50))  BEGIN
-- SELECT Username from approvers where ModuleCode='PAYMT' and Deleted=0 and Active=1 and level=1 LIMIT 1 into @Approver;
SELECT
  Phone AS ApproversPhone,
  Email AS ApproversMail
FROM users
WHERE Username IN (SELECT
    Username
  FROM approvers
  WHERE ModuleCode = 'REG'
  AND Deleted = 0
  AND Active = 1);
-- select Phone as ApproversPhone,Email as ApproversMail from users 
-- where Username IN(Select Approver from applications_approval_workflow where ApplicationNo=_ApplicationNo and Status='Pending Approval');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getApprovers` ()  NO SQL
BEGIN
SELECT
  approvers.ID,
  approvers.Username,
  users.Name,
  approvers.ModuleCode,
  approvalmodules.Name AS ModuleName,
  approvers.Mandatory,
  Active
FROM `approvers`
  INNER JOIN users
    ON users.Username = approvers.Username
  INNER JOIN approvalmodules
    ON approvalmodules.ModuleCode = approvers.ModuleCode
WHERE approvers.Deleted = 0
AND approvers.Active = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Getattestation` ()  BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  attestation.ID,
  attestation.Number,
  attestation.DOS,
  attestation.Clearance_status,
  attestation.Cost,
  attestation.Clearance_Date,
  visa.Status
FROM attestation
  INNER JOIN registration
    ON registration.IDNumber = attestation.Number
  INNER JOIN visa
    ON visa.Number = attestation.Number
WHERE attestation.Deleted = 0
AND visa.Status = 'Issued'
AND visa.Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAttestationPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
    registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
  registration.Status,
  attestation.Number,
  attestation.DOS,
  registration.Weight,
  registration.Languages,
  registration.Skills  from registration inner join attestation on attestation.Number=registration.IDNumber
WHERE attestation.Status='Pending Approval'
AND attestation.Deleted=0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAuditrails` ()  NO SQL
SELECT
  `AuditID`,
  `Date`,
  `Username`,
  `Description`,
  `Category`,
  `IpAddress`
FROM `audittrails`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getBranches` ()  NO SQL
BEGIN
SELECT
  `ID`,
  `Description`,
  `Created_At`,
  `Created_By`,
  `Updated_At`,
  `Updated_By`,
  `Deleted_By`
FROM branches
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCompanyDetails` (IN `_Code` VARCHAR(50))  BEGIN
SELECT
  `ID`,
  `Code`,
  `Name`,
  `PhysicalAdress`,
  `Street`,
  `PoBox`,
  `PostalCode`,
  `Town`,
  `Telephone1`,
  `Telephone2`,
  `Mobile`,
  `Fax`,
  `Email`,
  `Website`,
  `PIN`,
  `Logo`,
  `NextPE`,
  `NextComm`,
  `NextSupplier`,
  `NextMember`,
  `NextProcMeth`,
  `NextStdDoc`,
  `NextApplication`,
  `NextRev`,
  NextPEType
FROM `configurations`
WHERE Deleted = 0;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getContract` ()  NO SQL
SELECT   registration.Fullname,registration.IDNumber,registration.Phone,contract.Number,Contract.ID
  ,contract.Contract_status,contract.Cost,major.MCertificate,contract.EmployerName,contract.EmployerID,
  contract.VisaNumber,contract.EmployerContact,contract.EmployerAddress,contract.ContractNumber
  from contract 
  inner join major on major.Number=contract.Number
  inner join registration on registration.IDNumber=contract.Number
WHERE contract.Deleted=0 and major.MCertificate='Issued' and major.deleted=0$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetContractMontly` ()  BEGIN
SELECT
  COUNT(*) AS Count,
  MONTHNAME(Created_At) AS Month,
  YEAR(Created_At) AS year
FROM contract
WHERE Deleted = 0
AND Contract_status = 'Issued'
GROUP BY MONTH(Created_At);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getcontractPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
  contract.Status,
  contract.Number,
  contract.Contract_status,
  contract.Cost,
  contract.EmployerName,
  contract.VisaNumber,
  registration.Weight,
  registration.Languages,
  registration.Skills  from registration
   inner join contract on contract.Number=registration.IDNumber
WHERE contract.Status = 'Pending Approval' and contract.Deleted=0 ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getcounties` ()  NO SQL
BEGIN
SELECT
  `ID`,
  `Code`,
  `Name`
FROM `counties`
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getcountries` ()  NO SQL
BEGIN
SELECT
  `ID`,
  `Code`,
  `Name`
FROM `countries`
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCustomTraining` (IN `_Training_status` VARCHAR(50), IN `_FromDate` DATE, IN `_ToDate` DATE, IN `_AllDates` BOOLEAN)  NO SQL
BEGIN

  if(_AllDates=1) THEN
  Begin
      if(_Training_status='enrolled') THEN
      Begin
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.Phone,
  training.Number,
  training.ID,
  training.COM,
  training.EOM,
  training.Transcript_status,
  training.Training_status,
  training.DOF,
  training.Cost,
  training.Created_at AS date,
  dci.Certificate_status
FROM training
  INNER JOIN registration
    ON registration.IDNumber = training.Number
  INNER JOIN dci
    ON dci.Number = training.Number
WHERE training.Deleted = 0
AND training.Training_status = 'enrolled'
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0
ORDER BY training.Created_At DESC;
END;
END IF;
      if(_Training_status='Completed') THEN
      Begin
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.Phone,
  training.Number,
  training.ID,
  training.COM,
  training.EOM,
  training.Training_status,
  training.Transcript_status,
  training.DOF,
  training.Cost,
  training.Created_at AS date,
  dci.Certificate_status
FROM training
  INNER JOIN registration
    ON registration.IDNumber = training.Number
  INNER JOIN dci
    ON dci.Number = training.Number
WHERE training.Deleted = 0
AND training.Training_status = 'Completed'
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0
ORDER BY training.Created_At DESC;
END;
END IF;
       if(_Training_status='Defaulted') THEN
      Begin
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.Phone,
  training.Number,
  training.ID,
  training.COM,
  training.EOM,
  training.Training_status,
  training.Transcript_status,
  training.DOF,
  training.Cost,
  training.Created_at AS date,
  dci.Certificate_status
FROM training
  INNER JOIN registration
    ON registration.IDNumber = training.Number
  INNER JOIN dci
    ON dci.Number = training.Number
WHERE training.Deleted = 0
AND training.Training_status = 'Defaulted'
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0
ORDER BY training.Created_At DESC;

END;
END IF;
      
       if(_Training_status='All') THEN
      Begin
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.Phone,
  training.Number,
  training.ID,
  training.COM,
  training.EOM,
  training.Training_status,
  training.Transcript_status,
  training.DOF,
  training.Cost,
  training.Created_at AS date,
  dci.Certificate_status
FROM training
  INNER JOIN registration
    ON registration.IDNumber = training.Number
  INNER JOIN dci
    ON dci.Number = training.Number
WHERE training.Deleted = 0
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0
ORDER BY training.Created_At DESC;
END;
END IF;
END;
ELSE
  Begin
   if(_Training_status='enrolled') THEN
      Begin
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.Phone,
  training.Number,
  training.ID,
  training.COM,
  training.EOM,
  training.Training_status,
  training.Transcript_status,
  training.DOF,
  training.Cost,
  training.Created_at AS date,
  dci.Certificate_status
FROM training
  INNER JOIN registration
    ON registration.IDNumber = training.Number
  INNER JOIN dci
    ON dci.Number = training.Number
WHERE CAST(training.Created_At AS date) BETWEEN CAST(_FromDate AS date) AND CAST(DATE_ADD(_ToDate, INTERVAL 1 DAY) AS date)
AND training.Deleted = 0
AND training.Training_status = 'enrolled'
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0;
END;
END IF;
      if(_Training_status='Completed') THEN
      Begin
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.Phone,
  training.Number,
  training.ID,
  training.COM,
  training.EOM,
  training.Training_status,
  training.Transcript_status,
  training.DOF,
  training.Cost,
  training.Created_at AS date,
  dci.Certificate_status
FROM training
  INNER JOIN registration
    ON registration.IDNumber = training.Number
  INNER JOIN dci
    ON dci.Number = training.Number
WHERE CAST(training.Created_At AS date) BETWEEN CAST(_FromDate AS date) AND CAST(DATE_ADD(_ToDate, INTERVAL 1 DAY) AS date)
AND training.Deleted = 0
AND training.Training_status = 'Completed'
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0;
END;
END IF;
       if(_Training_status='Defaulted') THEN
      Begin
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.Phone,
  training.Number,
  training.ID,
  training.COM,
  training.EOM,
  training.Training_status,
  training.Transcript_status,
  training.DOF,
  training.Cost,
  training.Created_at AS date,
  dci.Certificate_status
FROM training
  INNER JOIN registration
    ON registration.IDNumber = training.Number
  INNER JOIN dci
    ON dci.Number = training.Number
WHERE CAST(training.Created_At AS date) BETWEEN CAST(_FromDate AS date) AND CAST(DATE_ADD(_ToDate, INTERVAL 1 DAY) AS date)
AND training.Deleted = 0
AND training.Training_status = 'Defaulted'
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0;

END;
END IF;
      
       if(_Training_status='All') THEN
      Begin
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.Phone,
  training.Number,
  training.ID,
  training.COM,
  training.EOM,
  training.Training_status,
  training.Transcript_status,
  training.DOF,
  training.Cost,
  training.Created_at AS date,
  dci.Certificate_status
FROM training
  INNER JOIN registration
    ON registration.IDNumber = training.Number
  INNER JOIN dci
    ON dci.Number = training.Number
WHERE CAST(training.Created_At AS date) BETWEEN CAST(_FromDate AS date) AND CAST(DATE_ADD(_ToDate, INTERVAL 1 DAY) AS date)
AND training.Deleted = 0
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0;

END;
END IF;

END;
END IF;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyAttestation` (IN `_date` DATE)  BEGIN
SELECT
  COUNT(*) AS DailyAttestation
FROM attestation
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyattestationReport` (IN `_date` DATE)  BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  attestation.ID,
  attestation.Number,
  attestation.DOS,
  attestation.Clearance_status,
  attestation.Cost,
  attestation.Clearance_Date,
  visa.Status
FROM attestation
  INNER JOIN registration
    ON registration.IDNumber = attestation.Number
  INNER JOIN visa
    ON visa.Number = attestation.Number
WHERE attestation.Deleted = 0
AND visa.Status = 'Issued'
AND visa.Deleted = 0
AND DATE(Created_at) = DATE(_date);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyContract` (IN `_date` DATE)  BEGIN
SELECT
  COUNT(*) AS DailyContract
FROM contract
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDailyContractReports` (IN `_date` DATE)  NO SQL
SELECT   registration.Fullname,registration.IDNumber,registration.Phone,contract.Number,Contract.ID
  ,contract.Contract_status,contract.Cost,major.MCertificate,contract.EmployerName,contract.EmployerID,
  contract.VisaNumber,contract.EmployerContact,contract.EmployerAddress,contract.ContractNumber
  from contract 
  inner join major on major.Number=contract.Number
  inner join registration on registration.IDNumber=contract.Number
WHERE contract.Deleted=0 and major.MCertificate='Issued' and major.deleted=0 and DATE(contract.Created_at) = DATE(_date)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyDCI` (IN `_date` DATE)  BEGIN
SELECT
  COUNT(*) AS DailyDCI
FROM dci
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDailyDCIRecords` (IN `_date` DATE)  NO SQL
SELECT  registration.Fullname, registration.IDNumber,registration.Phone, registration.Gender, 
  minormedical.Result,dci.ID,
  DCI.Number,DCI.DOT,DCI.CostIncurred,DCI.Processing,dci.Certificate_status,dci.DOC,dci.Cost FROM `dci`
inner join registration on registration.`IDNumber`=dci.Number 
  inner join minormedical on dci.Number=minormedical.Number 
WHERE minormedical.Result='Pass' and dci.Deleted=0 and minormedical.Deleted=0 and DATE(dci.Created_at) = DATE(_date)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyFinal` (IN `_date` DATE)  BEGIN
SELECT
  COUNT(*) AS DailyFinal
FROM finalmedical
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDailyFinalmedical` (IN `_date` DATE)  BEGIN
SELECT
  registration.Fullname,
  registration.IDNumber,
  finalmedical.ID,
  finalmedical.MedicalFacility,
  finalmedical.MedicalResult,
  finalmedical.DOM,
  finalmedical.Cost,
  attestation.Clearance_status,
  finalmedical.ID,
  finalmedical.Number,
  finalmedical.Type,
  finalmedical.RepeatCost,
  finalmedical.Other
FROM finalmedical
  INNER JOIN registration
    ON registration.IDNumber = finalmedical.Number
  INNER JOIN attestation
    ON attestation.Number = finalmedical.Number
WHERE finalmedical.Deleted = 0
AND attestation.Clearance_status = 'cleared'
AND attestation.Deleted = 0
AND DATE(Created_at) = DATE(_date);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyMajor` (IN `_date` DATE)  BEGIN
SELECT
  COUNT(*) AS DailyMajor
FROM major
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDailyMajormedical` (IN `_date` DATE)  NO SQL
SELECT  registration.Fullname, registration.IDNumber,registration.Phone, registration.Gender,major.MedicalFacility,passport.Status,Major.DOM,major.Type,
  major.RepeatCost,major.Others,
major.MedicalResults,Major.MCertificate,major.DOC,major.Number,major.Cost , Major.ID from major
inner join registration on registration.IDNumber=major.Number
  inner JOIN passport on passport.Number=major.Number
   where major.Deleted=0 and passport.Status='Issued' and DATE(major.Created_at) = DATE(_date)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyMinorMedical` (IN `_date` DATE)  BEGIN
SELECT
  COUNT(*) AS DailyMinormedical
FROM minormedical
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyMinorMedicalRecords` (IN `_date` DATE)  BEGIN
SELECT
  registration.Fullname,
  registration.IDnumber,
  registration.Gender,
  registration.county,
  minormedical.DOM,
  minormedical.Result,
  minormedical.Type,
  minormedical.MedicalFacility
FROM minormedical
  INNER JOIN registration
    ON registration.IDNumber = minormedical.Number
WHERE DATE(minormedical.Created_at) = DATE(_date)
AND minormedical.Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyNEA` (IN `_date` DATE)  BEGIN
SELECT
  COUNT(*) AS DailyNEA
FROM neaa
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyNEAA` (IN `_date` DATE)  SQL SECURITY INVOKER
BEGIN

SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Deleted,
  registration.phone,
  neaa.Number,
  neaa.DOS,
  neaa.ID,
  neaa.Approved_Status,
  neaa.DOA,
  neaa.Reason,
  neaa.RDate,
  Contract.Contract_status
FROM neaa
  INNER JOIN registration
    ON registration.IDNumber = neaa.Number
  INNER JOIN contract
    ON contract.Number = neaa.Number
WHERE neaa.Deleted = 0
AND contract.Contract_status = 'issued'
AND Contract.Deleted = 0
AND DATE(neaa.Created_at) = DATE(_date);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDailypassport` (IN `_date` DATE)  BEGIN
SELECT
  COUNT(*) AS Dailypassport
FROM passport
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDailypassportRecords` (IN `_date` DATE)  NO SQL
SELECT  registration.Fullname, registration.IDNumber,registration.Phone, registration.Gender,passport.Cost,passport.Passport_Collection_Date,
  PassPortNumber,Tracking_Number,POD,passport.ID,passport.Number,passport.Status,passport.PassportOption,passport.CostIncurred,passport.Location
FROM `passport`
inner join registration on registration.`IDNumber`=passport.Number 
  inner join dci on dci.Number=passport.Number
WHERE passport.Deleted=0 and dci.Certificate_status='Collected' and dci.Deleted=0 and DATE(passport.Created_at) = DATE(_date)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyRegistration` (IN `_date` DATE)  BEGIN
SELECT
  COUNT(*) AS DailyRegistration
FROM registration
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyReports` (IN `_date` DATE, IN `_dci` VARCHAR(255))  BEGIN
SELECT
  COUNT(*) AS DailyDCI
FROM (_dci)
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyTicketing` (IN `_date` DATE)  BEGIN
SELECT
  COUNT(*) AS DailyTicketing
FROM ticketing
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyTraining` (IN `_date` DATE)  BEGIN
SELECT
  COUNT(*) AS DailyTraining
FROM training
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDailytrainingRecords` (IN `_date` DATE)  BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.Phone,
  training.Number,
  training.ID,
  training.COM,
  training.EOM,
  training.Training_status,
  training.Transcript_status,
  training.DOF,
  training.Cost,
  dci.Certificate_status
FROM training
  INNER JOIN registration
    ON registration.IDNumber = training.Number
  INNER JOIN dci
    ON dci.Number = training.Number
WHERE training.Deleted = 0
AND dci.Certificate_status = 'Collected'
AND DATE(training.Created_at) = DATE(_date);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyTravelling` (IN `_date` DATE)  BEGIN
SELECT
  COUNT(*) AS DailyTravelling
FROM travelling
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyTravellingReports` (IN `_date` DATE)  BEGIN
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Gender,
  travelling.ID,
  travelling.Number,
  travelling.DOT,
  travelling.Status,
  travelling.Cost,
  finalmedical.MedicalResult
FROM travelling
  INNER JOIN registration
    ON registration.IDNumber = travelling.Number
  INNER JOIN finalmedical
    ON finalmedical.Number = travelling.Number
WHERE travelling.Deleted = 0
AND finalmedical.MedicalResult = 'pass'
AND finalmedical.Deleted = 0
AND DATE(Created_at) = DATE(_date);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDailyVisa` (IN `_date` DATE)  BEGIN
SELECT
  COUNT(*) AS DailyRegistration
FROM visa
WHERE DATE(Created_at) = DATE(_date)
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDailyvisaReports` (IN `_date` DATE)  BEGIN
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  neaa.Approved_Status,
  visa.ID,
  visa.Number,
  visa.VAD,
  visa.VID,
  visa.Status,
  visa.Cost
FROM visa
  INNER JOIN registration
    ON registration.IDNumber = visa.Number
  INNER JOIN neaa
    ON neaa.Number = visa.Number
WHERE visa.Deleted = 0
AND neaa.Approved_Status = 'Approved'
AND neaa.Deleted = 0
AND DATE(visa.Created_at) = DATE(_date);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDCI` ()  NO SQL
SELECT  registration.Fullname, registration.IDNumber,registration.Phone, registration.Gender, 
  minormedical.Result,dci.ID,
  DCI.Number,DCI.DOT,DCI.CostIncurred,DCI.Processing,dci.Certificate_status,dci.DOC,dci.Cost FROM `dci`
inner join registration on registration.`IDNumber`=dci.Number 
  inner join minormedical on dci.Number=minormedical.Number 
WHERE minormedical.Result='Pass' and dci.Deleted=0 and minormedical.Deleted=0$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDCIlPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
    registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
  dci.Certificate_status,
  dci.Status,
  dci.Number,
  registration.Weight,
  registration.Languages,
  registration.Skills  from registration
   inner join dci on Number=IDNumber
WHERE dci.Status = 'Pending Approval' and dci.Deleted=0 and registration.Deleted=0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDciMontly` ()  BEGIN
SELECT
  SUM(Cost) AS Count,
  MONTHNAME(Created_At) AS Month,
  YEAR(Created_At) AS year
FROM dci
WHERE Deleted = 0
AND Processing = 'Job Majuu'
GROUP BY MONTH(Created_At);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDCIPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
  dci.Status,
  dci.Number,
  dci.DOT,
  dci.Certificate_status,
  dci.DOC,
  dci.Cost,
  dci.Processing,
  registration.Weight,
  registration.Languages,
  registration.Skills  from registration
   inner join dci on dci.Number=registration.IDNumber
  INNER join minormedical on dci.Number=registration.IDNumber
WHERE dci.Status = 'Pending Approval' and dci.Deleted=0 and registration.Deleted=0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDCIPerProcessingBY` (IN `_Processing` VARCHAR(25))  BEGIN

SELECT
  SUM(Cost) AS DCICost
FROM dci
WHERE Deleted = 0
AND Processing = _Processing;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDocumentperApplication` (IN `_IDNumber` VARCHAR(50))  BEGIN
SELECT
  IDNumber
FROM registration
WHERE IDNumber = _IDNumber LIMIT 1 INTO @Application;
SET @row_number = 0;
SELECT
  (@row_number := @row_number + 1) AS ID,
  DocName,
  Description
FROM registrationdocuments
WHERE Deleted = 0
AND (IDNumber = _IDNumber
OR _IDNumber = @IDNumber);
  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetEducational` ()  BEGIN
SELECT
  IDNumber,
  Institution,
  Period,
  Decription
FROM educationaldetails
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getEducationaldetailsperApplication` (IN `_IDNumber` VARCHAR(50))  BEGIN
SELECT
  IDNumber
FROM registration
WHERE IDNumber = _IDNumber LIMIT 1 INTO @Application;
SET @row_number = 0;
SELECT
  (@row_number := @row_number + 1) AS ID,
  Institution,
  Period,
  Decription
FROM educationaldetails
WHERE Deleted = 0
AND (IDNumber = _IDNumber
OR _IDNumber = @IDNumber);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getfinalapplicants` ()  BEGIN
SELECT
  *
FROM registration
  INNER JOIN minormedical
    ON minormedical.Number = registration.IDNumber
  INNER JOIN major
    ON major.Number = minormedical.Number
  INNER JOIN finalmedical
    ON finalmedical.Number = minormedical.Number
WHERE finalmedical.MedicalResult = 'fail'
AND minormedical.Result = 'fail'
AND major.MedicalResults = 'fail';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getFinalmedical` ()  BEGIN
SELECT
  registration.Fullname,
  registration.IDNumber,
  finalmedical.ID,
  finalmedical.MedicalFacility,
  finalmedical.MedicalResult,
  finalmedical.DOM,
  finalmedical.Cost,
  attestation.Clearance_status,
  finalmedical.ID,
  finalmedical.Number,
  finalmedical.Type,
  finalmedical.RepeatCost,
  finalmedical.Other
FROM finalmedical
  INNER JOIN registration
    ON registration.IDNumber = finalmedical.Number
  INNER JOIN attestation
    ON attestation.Number = finalmedical.Number
WHERE finalmedical.Deleted = 0
AND attestation.Clearance_status = 'cleared'
AND attestation.Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetFinalMedicalCost` ()  BEGIN
SELECT
  SUM(cost)
FROM finalmedical
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetFinalMontly` ()  BEGIN
SELECT
  SUM(Cost) AS Count,
  MONTHNAME(Created_At) AS Month,
  YEAR(Created_At) AS year
FROM finalmedical
WHERE Deleted = 0
GROUP BY MONTH(Created_At);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getFinalPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
  finalmedical.Status,
  finalmedical.Number,
  finalmedical.MedicalFacility,
  finalmedical.DOM,
  registration.Weight,
  registration.Languages,
  registration.Skills  from registration
   inner join finalmedical on finalmedical.Number=registration.IDNumber
WHERE finalmedical.Status = 'Pending Approval' and finalmedical.Deleted=0 ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetGroupRoles` (IN `_UserGroupID` BIGINT)  NO SQL
SELECT roles.RoleID, RoleName,`Edit`, `Remove`, `AddNew`, `View`, `Export`,Category FROM roles LEFT JOIN groupaccess 
    ON groupaccess.RoleID = roles.RoleID AND groupaccess.UserGroupID=_UserGroupID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMajormedical` ()  NO SQL
SELECT  registration.Fullname, registration.IDNumber,registration.Phone, registration.Gender,major.MedicalFacility,passport.Status,Major.DOM,major.Type,
  major.RepeatCost,major.Others,
major.MedicalResults,Major.MCertificate,major.DOC,major.Number,major.Cost,major.Status , Major.ID from major
inner join registration on registration.IDNumber=major.Number
  inner JOIN passport on passport.Number=major.Number
   where major.Deleted=0 and passport.Status='Collected'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getmajormedicalCostPerType` (IN `_type` VARCHAR(255))  BEGIN
SELECT
  SUM(cost) AS MajorCost
FROM major
WHERE Deleted = 0
AND Type = _type;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMajorMedicalMontly` ()  BEGIN
SELECT
  SUM(Cost) AS Count,
  MONTHNAME(Created_At) AS Month,
  YEAR(Created_At) AS year
FROM major
WHERE Deleted = 0
GROUP BY MONTH(Created_At);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMajorPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
 major.Number,
  major.MedicalFacility,
  major.MedicalResults,
  major.DOM,
  major.MCertificate,
  major.DOC,
  major.Cost,
  registration.Weight,
  registration.Languages,
  registration.Skills  from registration
   inner join major on major.Number=registration.IDNumber
  INNER join passport on passport.Number=registration.IDNumber
WHERE major.Status = 'Pending Approval' and major.Deleted=0 ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMedicalFacility` ()  BEGIN
SELECT
  MedID,
  Name,
  Description
FROM medicalfacility
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMinorMedical` ()  NO SQL
SELECT  registration.Fullname, registration.IDNumber,registration.Phone, registration.Gender,minormedical.Cost,
  minormedical.MedicalFacility,minormedical.ID,minormedical.RepeatCost,minormedical.Type,minormedical.Others,
  minormedical.Number,minormedical.DOM,minormedical.Status
  ,minormedical.Result,MedicalFacility.`Name` as medicalfacility ,medicalfacility.MedID FROM `minormedical`
inner join registration on registration.`IDNumber`=minormedical.Number 
  inner join medicalfacility on medicalfacility.Name=minormedical.MedicalFacility 
WHERE minormedical.Deleted=0 and registration.Status='Approved'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMinormedicalMontly` ()  BEGIN
SELECT
  SUM(Cost) AS Count,
  MONTHNAME(Created_At) AS Month,
  YEAR(Created_At) AS year
FROM minormedical
WHERE Deleted = 0
AND Type = 'New'
GROUP BY MONTH(Created_At);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMinorMedicalPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
    registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
  minormedical.Status,
  minormedical.Number,
  registration.Weight,
  registration.Languages,
  registration.Skills  from registration
   inner join minormedical on Number=IDNumber
WHERE minormedical.Status = 'Pending Approval' and minormedical.Deleted=0 and registration.Deleted=0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMinormedicalPerType` (IN `_Type` VARCHAR(25))  BEGIN
SELECT
  SUM(Cost) AS total
FROM minormedical
WHERE Deleted = 0
AND Type = _Type;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMinorPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
  registration.Status,
  registration.Weight,
  registration.Languages,
  minormedical.DOM,
  minormedical.MedicalFacility,
  minormedical.Result,
  minormedical.Cost,
  minormedical.Type,
  minormedical.Status,
  registration.Skills  from registration inner join minormedical on minormedical.Number=registration.IDNumber
WHERE registration.Status = 'Pending Approval' 
AND minormedical.Number
NOT IN (SELECT
    Number
  FROM `minormedical_approval_workflow`
  WHERE Approver = _Approver)
AND _Approver IN (SELECT
    Username
  FROM approvers
  WHERE ModuleCode = 'MNR'
  AND Active = 1
  AND Deleted = 0);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMonthlyCost` ()  BEGIN
SELECT
  SUM(Cost) AS MinorMedical,
  MONTHNAME(Created_At) AS Month,
  YEAR(Created_At) AS year
FROM minormedical
WHERE Deleted = 0
GROUP BY MONTH(Created_At);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMonthlyGraph` ()  BEGIN
SELECT
  COUNT(*) AS Count,
  MONTHNAME(Created_At) AS Month,
  YEAR(Created_At) AS year
FROM registration
WHERE Deleted = 0
GROUP BY MONTH(Created_At);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMonthlyRegistration` (IN `_Year` DATE)  BEGIN
SELECT
  COUNT(*) AS MonthlyRegistration,
  MONTHNAME(Created_At) AS Month,
  YEAR(Created_At) AS year
FROM registration
WHERE YEAR(Created_At) = YEAR(_Year)
GROUP BY MONTH(Created_At);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMonthlyTravelled` ()  BEGIN
SELECT
  COUNT(*) AS Count,
  MONTHNAME(Created_At) AS Month,
  YEAR(Created_At) AS year
FROM travelling
WHERE Deleted = 0
GROUP BY MONTH(Created_At);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMyPendingNotification` (IN `_UserName` VARCHAR(50))  NO SQL
BEGIN
SELECT  Username,COUNT(*) As Total, Category, Description, Created_At, DueDate, Status  from  notifications where Username=_Username
and status='Not Resolved' group by Category;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetNEAA` ()  BEGIN

SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Deleted,
  registration.phone,
  neaa.Number,
  neaa.DOS,
  neaa.ID,
  neaa.Approved_Status,
  neaa.DOA,
  neaa.Reason,
  neaa.RDate,
  Contract.Contract_status
FROM neaa
  INNER JOIN registration
    ON registration.IDNumber = neaa.Number
  INNER JOIN contract
    ON contract.Number = neaa.Number
WHERE neaa.Deleted = 0
AND contract.Contract_status = 'issued'
AND Contract.Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getNeaaPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
  neaa.Status,
  neaa.Number,
  neaa.Approved_Status,

  registration.Weight,
  registration.Languages,
  registration.Skills  from registration
   inner join neaa on neaa.Number=registration.IDNumber
WHERE neaa.Status = 'Pending Approval' and neaa.Deleted=0 ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetNextOfKin` ()  BEGIN
SELECT
  IDNumber,
  KinName,
  KRelationship,
  CurrentResident,
  Contact
FROM nextofkin
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getNextOFKinperApplication` (IN `_IDNumber` VARCHAR(50))  BEGIN
SELECT
  IDNumber
FROM registration
WHERE IDNumber = _IDNumber LIMIT 1 INTO @Application;
SET @row_number = 0;
SELECT
  (@row_number := @row_number + 1) AS ID,
  KinName,
  KRelationship,
  CurrentResident,
  Contact
FROM nextofkin
WHERE Deleted = 0
AND (IDNumber = _IDNumber
OR _IDNumber = @IDNumber);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOneapplicationdocuments` (IN `_ApplicationID` INT)  NO SQL
BEGIN
SELECT
  `ID`,
  `Number`,
  `Description`,
  `FileName`,
  `DateUploaded`,
  `Path`,
  Created_By
FROM `registrationdocuments`
WHERE Deleted = 0
AND Number = _ApplicationID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOneattestation` (IN `_ID` INT)  BEGIN
SELECT
  registration.Fullname,
  registration.Fullname,
  registration.Gender,
  attestation.ID,
  attestation.Number,
  attestation.DOS,
  attestation.Clearance_status,
  attestation.Clearance_Date,
  visa.Status
FROM attestation
  INNER JOIN registration
    ON registration.IDNumber = attestation.Number
  INNER JOIN visa
    ON visa.Number = attestation.Number
WHERE attestation.Deleted = 0
AND visa.Status = 'Approved'
AND visa.Deleted = 0
AND attestation.ID = _ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOneBranch` (IN `_ID` INT)  NO SQL
BEGIN
SELECT
  `ID`,
  `Description`,
  `Created_At`,
  `Created_By`,
  `Updated_At`,
  `Updated_By`,
  `Deleted_By`
FROM branches
WHERE ID = _ID
AND Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOneContract` (IN `_ID` INT)  NO SQL
SELECT  registration.Fullname, registration.IDNumber,registration.Phone, registration.Gender,contract.Cost,contract.Number,contract.Contract_status FROM `contract`
inner join registration on registration.`IDNumber`=contract.Number  
  inner join passport on passport.Number=contract.Number
   inner join major on major.Number=contract.Number
WHERE contract.Deleted=0 and major.MCertificate='Issued' and contract.ID=_ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOneDCI` (IN `_ID` VARCHAR(255))  NO SQL
SELECT  registration.Fullname, registration.IDNumber,registration.Phone, registration.Gender, 
  minormedical.Result,
  DCI.Number,DCI.DOT,dci.Certificate_status,dci.DOC
   ,dci.Cost FROM `dci`
inner join registration on registration.`IDNumber`=dci.Number 
  inner join minormedical on dci.Number=minormedical.Number 
WHERE minormedical.Result='Pass' and dci.Deleted=0 and dci.ID=_ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOneFinalmedical` (IN `_ID` INT)  BEGIN
SELECT
  registration.Fullname,
  registration.IDNumber,
  finalmedical.ID,
  finalmedical.MedicalFacility,
  finalmedical.MedicalResult,
  finalmedical.DOM,
  finalmedical.Cost,
  attestation.Clearance_status
FROM finalmedical
  INNER JOIN registration
    ON registration.IDNumber = finalmedical.Number
  INNER JOIN attestation
    ON attestation.Number = finalmedical.Number
WHERE finalmedical.Deleted = 0
AND attestation.Clearance_status = 'cleared'
AND attestation.Deleted = 0
AND ID = _ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOneMajormedical` (IN `_ID` INT)  NO SQL
SELECT  registration.Fullname, registration.IDNumber,registration.Phone, registration.Gender,major.MedicalFacility,passport.Status,
major.MedicalResults,Major.MCertificate,major.DOC,major.Number,major.Cost from major
inner join registration on registration.IDNumber=major.Number
  inner JOIN passport on passport.Number=major.Number
   where major.Deleted=0 and passport.Status='Issued'and major.ID=_ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOneMedicalFacility` (IN `_MedID` INT)  BEGIN
SELECT
  *
FROM medicalfacility
WHERE MedID = _MedID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOneMinorMedical` (IN `_ID` VARCHAR(255))  BEGIN
SELECT
  *
FROM minormedical
WHERE ID = _ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOneNEAA` (IN `_ID` INT)  BEGIN

SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Deleted,
  registration.phone,
  neaa.Number,
  neaa.DOS,
  neaa.ID,
  neaa.Approved_Status,
  neaa.DOA,
  neaa.Reason,
  neaa.RDate,
  Contract.Contract_status,
  contract.Number
FROM neaa
  INNER JOIN registration
    ON registration.IDNumber = neaa.Number
  INNER JOIN contract
    ON contract.Number = neaa.Number
WHERE neaa.Deleted = 0
AND contract.Contract_status = 'issued'
AND Contract.Deleted = 0
AND neaa.ID = _ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOnepassport` (IN `_ID` VARCHAR(255))  NO SQL
SELECT  registration.Fullname, registration.IDNumber,registration.Phone, registration.Gender,passport.Cost,passport.Passport_Collection_Date,passport.Status
  PassPortNumber,Tracking_Number,POD
FROM `passport`
inner join registration on registration.`IDNumber`=passport.Number 
    inner join dci on dci.Number=passport.Number
WHERE passport.Deleted=0 and passport.Status='Issued' and passport.ID=_ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOneRegistration` (IN `_IDNumber` INT)  BEGIN
SELECT
  IDNumber,
  Fullname,
  Gender,
  Phone,
  DOB,
  Email,
  Country,
  Religion,
  Marital,
  Height,
  Weight,
  Languages,
  Skills
FROM registration
WHERE IDNumber = _IDNumber;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOneTicketing` (IN `_ID` INT)  BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  ticketing.ID,
  ticketing.Number,
  ticketing.Ticket_status,
  ticketing.Flight_Date,
  attestation.Clearance_status,
  ticketing.Destination,
  ticketing.Airline,
  ticketing.Cost
FROM ticketing
  INNER JOIN attestation
    ON attestation.Number = ticketing.Number
  INNER JOIN registration
    ON registration.IDNumber = ticketing.Number
WHERE attestation.Clearance_status = 'cleared'
AND ticketing.deleted = 0
AND attestation.deleted = 0
AND ticketing.ID = _ID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getonetraining` (IN `_ID` INT)  BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.Phone,
  training.Number,
  training.COM,
  training.EOM,
  training.Training_status,
  training.Transcript_status,
  training.DOF,
  training.Cost,
  dci.Certificate_status
FROM training
  INNER JOIN registration
    ON registration.IDNumber = training.Number
  INNER JOIN dci
    ON dci.Number = training.Number
WHERE training.Deleted = 0
AND dci.Certificate_status = 'issued'
AND training.ID = _ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOneTravelling` (IN `_ID` INT)  BEGIN
SELECT
  registration.IDNumber,
  registration.Gender,
  travelling.ID,
  travelling.Number,
  travelling.DOT,
  travelling.Status,
  travelling.Cost,
  finalmedical.MedicalResult
FROM travelling
  INNER JOIN registration
    ON registration.IDNumber = travelling.Number
  INNER JOIN finalmedical
    ON finalmedical.Number = travelling.Number
WHERE finalmedical.Deleted = 0
AND finalmedical.MedicalResult = 'pass'
AND finalmedical.Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOnevenue` (IN `_ID` INT)  BEGIN

SELECT
  Venues.ID,
  Venues.ID,
  Branches.Description AS Branch,
  Venues.Name,
  Venues.Description
FROM Venues
  INNER JOIN Branches
    ON Branches.ID = Venues.Branch
WHERE Venues.deleted = 0
AND ID = _ID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOnevisa` (IN `_ID` INT)  BEGIN
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  neaa.Approved_Status,
  visa.ID,
  visa.Number,
  visa.VAD,
  visa.VID,
  visa.Status,
  visa.Cost
FROM visa
  INNER JOIN registration
    ON registration.IDNumber = visa.Number
  INNER JOIN neaa
    ON neaa.Number = visa.Number
WHERE visa.Deleted = 0
AND neaa.Approved_Status = 'Approved'
AND neaa.Deleted = 0
AND visa.ID = _ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPanelMembers` (IN `_ApplicationNo` VARCHAR(50))  BEGIN
SET @row_number = 0;
SELECT
  (@row_number := @row_number + 1) AS ID,
  panels.ApplicationNo,
  panels.UserName,
  users.Name,
  users.Email,
  users.Phone,
  panels.Status,
  Role
FROM panels
  INNER JOIN users
    ON users.Username = panels.UserName
WHERE ApplicationNo = _ApplicationNo
AND panels.deleted = 0
ORDER BY ID ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetParent` ()  BEGIN
SELECT
  IDNumber,
  Name,
  ParentID,
  Relationship
FROM parents
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getParentperApplication` (IN `_IDNumber` VARCHAR(50))  BEGIN
SELECT
  IDNumber
FROM registration
WHERE IDNumber = _IDNumber LIMIT 1 INTO @Application;
SET @row_number = 0;
SELECT
  (@row_number := @row_number + 1) AS ID,
  Name,
  ParentID,
  Relationship
FROM parents
WHERE Deleted = 0
AND (IDNumber = _IDNumber
OR _IDNumber = @IDNumber);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getpassport` ()  NO SQL
SELECT  registration.Fullname, registration.IDNumber,registration.Phone, registration.Gender,passport.Cost,passport.Passport_Collection_Date,
  PassPortNumber,Tracking_Number,POD,passport.ID,passport.Number,passport.Status,passport.PassportOption,passport.CostIncurred,passport.Location
FROM `passport`
inner join registration on registration.`IDNumber`=passport.Number 
  inner join dci on dci.Number=passport.Number
WHERE passport.Deleted=0 and dci.Certificate_status='Collected' and dci.Deleted=0$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPassportMontly` ()  BEGIN
SELECT
  SUM(Cost) AS Count,
  MONTHNAME(Created_At) AS Month,
  YEAR(Created_At) AS year
FROM Passport
WHERE Deleted = 0
GROUP BY MONTH(Created_At);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPassportPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
    registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
   passport.Number,
  passport.POD,
  passport.Tracking_Number,
  passport.Status,
  passport.PassPortNumber,
  passport.Passport_Collection_Date,
  passport.PassportOption,
  registration.Weight,
  registration.Languages,
  registration.Skills  from registration
   inner join passport on Number=IDNumber
  inner join dci on dci.Number=registration.IDNumber
WHERE passport.Passport_Status = 'Pending Approval' and passport.Deleted=0 and dci.Deleted=0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetregistrationDocumentPerRegistration` (IN `_ApplicationID` VARCHAR(50))  BEGIN
SELECT
  IDNumber
FROM registration
WHERE IDNumber = _ApplicationID LIMIT 1 INTO @Application;
SELECT
   `ID`,
  `IDNumber`,
  DocName,
  `Description`,
  Path,
  Created_At,
  Created_By
FROM registrationDocuments
WHERE Deleted = 0
AND IDNumber = @Application;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getregistrations` ()  BEGIN
SELECT
  IDNumber,
  Fullname,
  Gender,
  phone,
  DOB,
  Email,
  Country,
  County,
  Village,
  Religion,
  Marital,
  Height,
  Weight,
  photo,
  FullPhoto,
  BirthCer,
  Husband,
  HusbandMobile,
  HusbandID,
  Languages,
  Skills,
  Status,
  Classify,
  Agent
FROM registration
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRole` (IN `_RoleId` BIGINT)  NO SQL
BEGIN
SELECT
  *
FROM roles
WHERE RoleID = _RoleID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRoles` ()  NO SQL
BEGIN
SELECT
  RoleID,
  RoleName,
  RoleDescription
FROM roles
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSiblings` ()  BEGIN
SELECT
  IDNumber,
  SiblingName,
  Sex,
  Age
FROM siblings
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSiblingsperApplication` (IN `_IDNumber` VARCHAR(50))  BEGIN
SELECT
  IDNumber
FROM registration
WHERE IDNumber = _IDNumber LIMIT 1 INTO @Application;
SET @row_number = 0;
SELECT
  (@row_number := @row_number + 1) AS ID,
  SiblingName,
  Sex,
  Age 
FROM siblings
WHERE Deleted = 0
AND (IDNumber = _IDNumber
OR _IDNumber = @IDNumber);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSMSSenderDetails` ()  NO SQL
BEGIN
SELECT
  *
FROM smsdetails;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSMTPDetails` ()  NO SQL
BEGIN
SELECT
  *
FROM smtpdetails;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTicketing` ()  BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  ticketing.ID,
  ticketing.Number,
  ticketing.Ticket_status,
  ticketing.Flight_Date,
  attestation.Clearance_status,
  ticketing.Destination,
  ticketing.Airline,
  ticketing.Cost
FROM ticketing
  INNER JOIN attestation
    ON attestation.Number = ticketing.Number
  INNER JOIN registration
    ON registration.IDNumber = ticketing.Number
WHERE attestation.Clearance_status = 'cleared'
AND ticketing.deleted = 0
AND attestation.deleted = 0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTicketingPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
  ticketing.Number,
  ticketing.Ticket_status,
  ticketing.Flight_Date,
  ticketing.Ticket_status,
  registration.Weight,
  registration.Languages,
  registration.Skills  from registration
   inner join ticketing on ticketing.Number=registration.IDNumber
WHERE ticketing.Status = 'Pending Approval' and ticketing.Deleted=0 ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTotalApplcicants` ()  NO SQL
BEGIN
SELECT
  COUNT(*) AS totalApplicants
FROM registration
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTotalRegistration` ()  BEGIN
SELECT
  COUNT(*) AS total
FROM registration
WHERE registration.Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTotaltravelled` ()  BEGIN
SELECT
  COUNT(*) AS travelled
FROM travelling AS travelledApplicants
WHERE travelledApplicants.Status = 'travelled'
AND travelledApplicants.Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `gettraining` ()  BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.Phone,
  training.Number,
  training.ID,
  training.COM,
  training.EOM,
  training.Training_status,
  training.Transcript_status,
  training.DOF,
  training.Cost,
  dci.Certificate_status
FROM training
  INNER JOIN registration
    ON registration.IDNumber = training.Number
  INNER JOIN dci
    ON dci.Number = training.Number
WHERE training.Deleted = 0
AND dci.Certificate_status = 'Collected'
AND dci.Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTrainingtPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
  training.COM,
  training.EOM,
  training.Number,
  training.Training_status,
  training.Transcript_status,
  registration.Weight,
  registration.Languages,
  registration.Skills  from registration
   inner join training on training.Number=registration.IDNumber
WHERE training.Status = 'Pending Approval' and training.Deleted=0 ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTravelledApplicants` ()  BEGIN
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Gender,
  travelling.ID,
  travelling.Number,
  travelling.DOT,
  travelling.Status,
  travelling.Cost
FROM travelling
  INNER JOIN registration
    ON registration.IDNumber = travelling.Number
WHERE travelling.Deleted = 0
AND travelling.Status = 'Travelled';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTravelling` ()  BEGIN
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Gender,
  travelling.ID,
  travelling.Number,
  travelling.DOT,
  travelling.Status,
  travelling.Cost,
  finalmedical.MedicalResult
FROM travelling
  INNER JOIN registration
    ON registration.IDNumber = travelling.Number
  INNER JOIN finalmedical
    ON finalmedical.Number = travelling.Number
WHERE travelling.Deleted = 0
AND finalmedical.MedicalResult = 'pass'
AND finalmedical.Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTravellingPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
  travelling.Number,
  registration.Weight,
  registration.Languages,
  registration.Skills  from registration
   inner join travelling on travelling.Number=registration.IDNumber
WHERE travelling.Approve_Status = 'Pending Approval' and travelling.Deleted=0 ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getuser` (IN `_Username` VARCHAR(128))  NO SQL
BEGIN
SELECT
  users.Name,
  users.Username,
  users.Email,
  users.Password,
  users.Phone,
  users.Create_at,
  ChangePassword,
  users.Board,
  users.Update_at,
  users.Login_at,
  users.Deleted,
  users.IsActive,
  users.IsEmailverified,
  usergroups.Name AS UserGroupID,
  users.Photo,
  users.Category,
  users.Signature,
  users.IDnumber,
  users.Gender,
  users.DOB,
  users.ActivationCode
FROM users
  INNER JOIN usergroups
    ON usergroups.UserGroupID = users.UserGroupID
WHERE (UserName = _UserName
OR Email = _UserName);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetuserAccess` (IN `_Username` VARCHAR(50))  NO SQL
BEGIN

DROP TABLE IF EXISTS Rolesbuffer;
 
CREATE TEMPORARY TABLE Rolesbuffer (
    Username varchar(50),
RoleID Bigint NOT NULL
,Edit boolean
,Remove boolean
,AddNew boolean
,View boolean
,Export boolean
)ENGINE=MEMORY;

INSERT INTO Rolesbuffer
  SELECT
    _Username,
    RoleID,
    Edit,
    Remove,
    AddNew,
    View,
    Export
  FROM useraccess
  WHERE Username = _Username;

INSERT INTO Rolesbuffer (Username, RoleID)
  SELECT
    _Username,
    RoleID
  FROM groupaccess
  WHERE UserGroupID IN (SELECT
      UserGroupID
    FROM users
    WHERE Username = _Username)
  AND RoleID NOT IN (SELECT
      RoleID
    FROM useraccess
    WHERE Username = _Username);

SELECT
  Username,
  Rolesbuffer.RoleID,
  RoleName,
  Edit,
  Remove,
  AddNew,
  View,
  Export,
  Category
FROM Rolesbuffer
  INNER JOIN Roles
    ON Rolesbuffer.RoleID = Roles.RoleID;
DROP TABLE Rolesbuffer;
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getusergroup` (IN `_UserGroupID` INT(128))  NO SQL
BEGIN
SELECT
  *
FROM usergroups
WHERE Deleted = 0
AND UserGroupID = _UserGroupID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUsergroups` ()  NO SQL
BEGIN
SELECT
  *
FROM usergroups
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserRoles` (IN `_Username` VARCHAR(100))  NO SQL
BEGIN
SELECT
  `Username`,
  useraccess.RoleID,
  RoleName,
  useraccess.Edit,
  useraccess.Remove,
  useraccess.AddNew,
  useraccess.View,
  useraccess.Export
FROM `useraccess`
  INNER JOIN roles
    ON roles.RoleID = useraccess.RoleID
WHERE Username = _Username;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUsers` ()  NO SQL
BEGIN
SELECT
  users.Name,
  Username,
  users.Board,
  Email,
  Phone,
  IsActive,
  usergroups.Name AS UserGroup,
  users.UserGroupID,
  Photo,
  Signature,
  IDnumber,
  DOB,
  Gender,
  Category
FROM users
  INNER JOIN usergroups
    ON users.UserGroupID = usergroups.UserGroupID
WHERE users.Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetvenuesPerBranch` (IN `_Branch` INT)  BEGIN

SELECT
  Venues.ID,
  Venues.ID,
  Branches.Description AS Branch,
  Venues.Name,
  Venues.Description
FROM Venues
  INNER JOIN Branches
    ON Branches.ID = Venues.Branch
WHERE Venues.deleted = 0
AND Venues.Branch = _Branch;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getvisa` ()  BEGIN
SELECT
  registration.Fullname,
  registration.IDNumber,
  registration.Phone,
  registration.Gender,
  neaa.Approved_Status,
  visa.ID,
  visa.Number,
  visa.VAD,
  visa.VID,
  visa.Status,
  visa.Cost
FROM visa
  INNER JOIN registration
    ON registration.IDNumber = visa.Number
  INNER JOIN neaa
    ON neaa.Number = visa.Number
WHERE visa.Deleted = 0
AND neaa.Approved_Status = 'Approved'
AND neaa.Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getVisaPendingApprovals` (IN `_Approver` VARCHAR(50))  NO SQL
BEGIN
SELECT
  registration.IDNumber,
  registration.Fullname,
  registration.Gender,
  registration.phone,
  registration.photo,
  registration.FullPhoto,
  registration.Classify,
  registration.DOB,
  registration.Email,
  registration.Country,
  registration.Religion                        ,
  registration.Marital,
  registration.Height,
  visa.Status,
  visa.Number,
visa.VAD,
  visa.VID,
  visa.Cost,
  registration.Weight,
  registration.Languages,
  registration.Skills  from registration
   inner join visa on visa.Number=registration.IDNumber
WHERE visa.Visa_Status = 'Pending Approval' and visa.Deleted=0 ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GiveUserAllRoles` (IN `_Username` VARCHAR(50))  NO SQL
BEGIN
UPDATE useraccess
SET `Edit` = 1,
    `Remove` = 1,
    `AddNew` = 1,
    `View` = 1,
    `Export` = 1,
    `UpdateBy` = _Username,
    UpdatedAt = NOW()
WHERE Username = _Username;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `majorRedAlerts` ()  BEGIN
SELECT
  COUNT(*) AS majorRedAlerts
FROM major
WHERE SUBDATE(NOW(), INTERVAL 4 DAY)
AND Deleted = 0
AND MCertificate = 'pending';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `minormedicalRedAlerts` ()  BEGIN
SELECT
  COUNT(*) AS minormedicalRedAlerts
FROM minormedical
WHERE SUBDATE(NOW(), INTERVAL 3 DAY)
AND Deleted = 0
AND Result = 'pending';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NEARedAlerts` ()  BEGIN
SELECT
  COUNT(*) AS NEARedAlerts
FROM neaa
WHERE SUBDATE(NOW(), INTERVAL 4 DAY)
AND Deleted = 0
AND Approved_Status = 'pending';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PassportRedAlerts` ()  BEGIN
SELECT
  COUNT(*) AS PassportRedAlerts
FROM passport
WHERE SUBDATE(NOW(), INTERVAL 20 DAY)
AND Deleted = 0
AND Status = 'Processing';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure1` ()  BEGIN
SELECT
  COUNT(*) AS WeeklyRegistration
FROM visa
WHERE WEEK(Created_at, 1) = CURRENT_DATE
AND Deleted = 0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RemoveAllUserroles` (IN `_Username` VARCHAR(50))  NO SQL
BEGIN

UPDATE useraccess
SET `Edit` = 0,
    `Remove` = 0,
    `AddNew` = 0,
    `View` = 0,
    `Export` = 0,
    `UpdateBy` = _Username,
    UpdatedAt = NOW()
WHERE Username = _Username;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Resetpassword` (IN `_Email` VARCHAR(128), IN `_Password` VARCHAR(128))  NO SQL
BEGIN

if( SELECT
    COUNT(*)
  FROM users
  WHERE Email = _Email) > 0 THEN
BEGIN

UPDATE users
SET `Password` = _Password,
    ChangePassword = 1
WHERE Email = _Email;
SELECT
  'Password changed' AS msg;
END;
ELSE
BEGIN
SELECT
  'User Not Found' AS msg;

END;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ResolveMyNotification` (IN `_UserName` VARCHAR(50), IN `_Category` VARCHAR(50))  BEGIN
SELECT
  ID
FROM notifications
WHERE Username = _UserName
AND Category = _Category
AND Status = 'Not Resolved' LIMIT 1 INTO @UnresolvedID;
UPDATE notifications
SET Status = 'Resolved'
WHERE Username = _UserName
AND Category = _Category
AND ID = @UnresolvedID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveApplicant` (IN `_Name` VARCHAR(128), IN `_Location` VARCHAR(50), IN `_POBox` VARCHAR(50), IN `_PostalCode` VARCHAR(50), IN `_Town` VARCHAR(100), IN `_Mobile` VARCHAR(50), IN `_Telephone` VARCHAR(50), IN `_Email` VARCHAR(100), IN `_Logo` VARCHAR(100), IN `_Website` VARCHAR(100), IN `_UserID` VARCHAR(50), IN `_County` VARCHAR(50), IN `_RegistrationDate` DATETIME, IN `_PIN` VARCHAR(50), IN `_RegistrationNo` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
DECLARE NewCode varchar(50);
SELECT
  IFNULL(NextSupplier, 1)
FROM configurations INTO @NextPE;
 
set NewCode=CONCAT('AP-',@NextPE);
set lSaleDesc= CONCAT('Added new applicant with Name: ', _Name);
INSERT INTO `applicants` (`ApplicantCode`, `Name`, County, `Location`, `POBox`, `PostalCode`, `Town`, `Mobile`, `Telephone`, `Email`, `Logo`, `Website`, `Created_By`, `Created_At`, `Deleted`, RegistrationDate, PIN, RegistrationNo)
  VALUES (NewCode, _Name, _County, _Location, _POBox, _PostalCode, _Town, _Mobile, _Telephone, _Email, _Logo, _Website, _UserID, NOW(), 0, _RegistrationDate, _PIN, _RegistrationNo);

UPDATE configurations
SET NextSupplier = @NextPE + 1;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Saveapplicationsequence` (IN `_ApplicationNo` VARCHAR(50), IN `_Action` VARCHAR(255), IN `_ExpectedAction` VARCHAR(150), IN `_UserID` VARCHAR(50))  BEGIN
if(select count(*) from applicationsequence where Action=_Action and IDNumber=_ApplicationNo)>0 THEN
Begin
  End;
else
begin
  insert into applicationsequence (IDNumber, Date , Action ,Status ,ExpectedAction,User)
    VALUES(_ApplicationNo,now(),_Action,'Done',_ExpectedAction,_UserID);
  End;
  End if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveApprover` (IN `_Username` VARCHAR(50), IN `_ModuleCode` VARCHAR(50), IN `_Mandatory` BOOLEAN, IN `_UserID` VARCHAR(50), IN `_IsActive` BOOLEAN)  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);

DECLARE NewCode varchar(50);
set lSaleDesc= CONCAT('Added new Approver:  '+_Username);
 
if( SELECT
    COUNT(*)
  FROM approvers
  WHERE Username = _Username
  AND ModuleCode = _ModuleCode) > 0 THEN
Begin

UPDATE approvers
SET Mandatory = _Mandatory,
    Active = _IsActive,
    UpdatedBy = _UserID
WHERE Username = _Username
AND ModuleCode = _ModuleCode;

CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');

END;
ELSE
Begin

INSERT INTO `approvers` (`Username`, ModuleCode, Mandatory, `Create_at`, `CreatedBy`, Active, Deleted)
  VALUES (_Username, _ModuleCode, _Mandatory, NOW(), _UserID, _IsActive, 0);
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');

END;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveAttestation` (IN `_Number` INT, IN `_DOS` DATETIME, IN `_Status` VARCHAR(255), IN `_Clearance` DATETIME, IN `_Cost` VARCHAR(25), IN `_userID` INT)  BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new   VISA Processing with  IDnumber:',_Number);
INSERT INTO attestation (Number, DOS, Clearance_status, Clearance_Date, Cost,Status, Created_at, CreatedBy, Updated_at, UpdatedBy, Deleted)
  VALUES (_Number, _DOS, _Status, _Clearance, _Cost,'Pending Approval', NOW(), _userID, 0, 0, 0);
INSERT INTO notifications (Username, Category, Description, Created_At, DueDate, Status,IDNumber)
  SELECT
    Username,
    'Attestation Approval',
    'Attestation pending approval',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 5 DAY),
    'Not Resolved',
    _Number
  FROM approvers
  WHERE ModuleCode = 'ATN'
  AND Active = 1
  AND Deleted = 0;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveAuditTrail` (IN `_Username` VARCHAR(50), IN `_Description` VARCHAR(128), IN `_Category` VARCHAR(50), IN `_IpAddress` VARCHAR(50))  NO SQL
BEGIN
INSERT INTO `audittrails` (`Date`, `Username`, `Description`, `Category`, `IpAddress`)
  VALUES (NOW(), _Username, _Description, _Category, _IpAddress);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveBranch` (IN `_Description` VARCHAR(525), IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);

set lSaleDesc= CONCAT('Added new Branch with Name: ', _Description);
INSERT INTO branches (`Description`, `Created_At`, Created_By, `Updated_At`, `Updated_By`, `Deleted`)
  VALUES (_Description, NOW(), _UserID, NOW(), _UserID, 0);

CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveConfigurations` (IN `_Name` VARCHAR(255), IN `_PhysicalAdress` VARCHAR(255), IN `_Street` VARCHAR(255), IN `_PoBox` VARCHAR(255), IN `_PostalCode` VARCHAR(50), IN `_Town` VARCHAR(100), IN `_Telephone1` VARCHAR(100), IN `_Telephone2` VARCHAR(100), IN `_Mobile` VARCHAR(100), IN `_Fax` VARCHAR(100), IN `_Email` VARCHAR(100), IN `_Website` VARCHAR(100), IN `_PIN` VARCHAR(50), IN `_Logo` VARCHAR(100), IN `_UserID` VARCHAR(50), IN `_Code` VARCHAR(50))  BEGIN
if( SELECT
    COUNT(*)
  FROM configurations) > 0 THEN

		BEGIN
UPDATE `configurations`
SET Code = _Code,
    `Name` = _Name,
    `PhysicalAdress` = _PhysicalAdress,
    `Street` = _Street,
    `PoBox` = _PoBox,
    `PostalCode` = _PostalCode,
    `Town` = _Town,
    `Telephone1` = _Telephone1,
    `Telephone2` = _Telephone2,
    `Mobile` = _Mobile,
    `Fax` = _Fax,
    `Email` = _Email,
    `Website` = _Website,
    `PIN` = _PIN,
    `Logo` = _Logo,

    `Updated_At` = NOW(),
    `Updated_By` = _UserID;

END;
ELSE
			BEGIN
SELECT
  YEAR(NOW()) INTO @Year;
INSERT INTO configurations (Code, Name, PhysicalAdress, Street, PoBox, PostalCode, Town, Telephone1,
Telephone2, Mobile, Fax, Email, Website, PIN, Logo,
NextPE, NextComm, NextSupplier, NextMember, NextProcMeth, NextStdDoc, NextApplication, NextRev, NextPEType,
Created_At, Updated_At,
Created_By, Updated_By, Deleted, Deleted_By, Year)
  VALUES (_Code, _Name, _PhysicalAdress, _Street, _PoBox, _PostalCode, _Town, _Telephone1, _Telephone2, _Mobile, _Fax, _Email, _Website, _PIN, _Logo, '1', '1', '1', '1', '1', '1', '1', '1', '1', NOW(), NOW(), _UserID, ' ', 0, ' ', @Year);
END;
END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveContract` (IN `_Number` INT, IN `_Contract_status` VARCHAR(55), IN `_Cost` VARCHAR(255), IN `_EmployerName` VARCHAR(55), IN `_EmployerID` VARCHAR(55), IN `_EmployerContact` VARCHAR(55), IN `_EmployerAddress` VARCHAR(55), IN `_VisaNumber` VARCHAR(55), IN `_ContractNumber` VARCHAR(55), IN `_userID` VARCHAR(55))  BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new   contract with  IDnumber:',_Number);
INSERT INTO contract (Number, Contract_status, Cost, EmployerName, EmployerID, EmployerContact, EmployerAddress, VisaNumber, ContractNumber, Status,Created_at, Updated_at, CreatedBy, UpdateBy, Deleted)
  VALUES (_Number, _Contract_status, _Cost, _EmployerName, _EmployerID, _EmployerContact, _EmployerAddress, _VisaNumber, _ContractNumber,'Pending Approval', NOW(), 0, _userID, 0, 0);
  INSERT INTO notifications (Username, Category, Description, Created_At, DueDate, Status)
  SELECT
    Username,
    'Contract Processing Approval',
    'Contract pending approval',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 5 DAY),
    'Not Resolved'
  FROM approvers
  WHERE ModuleCode = 'CNT'
  AND Active = 1
  AND Deleted = 0;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Savecounties` (IN `_Code` VARCHAR(50), IN `_Description` VARCHAR(525), IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);

set lSaleDesc= CONCAT('Added new county with Name: ', _Description);
INSERT INTO `counties` (`Code`, `Name`, `Created_At`, Created_By, `Updated_At`, `Updated_By`, `Deleted`)
  VALUES (_Code, _Description, NOW(), _UserID, NOW(), _UserID, 0);

CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Savecountries` (IN `_Code` VARCHAR(50), IN `_Name` VARCHAR(525), IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);

set lSaleDesc= CONCAT('Added new county with Name: ', _Name);
INSERT INTO `countries` (`Code`, `Name`, `Created_At`, Created_By, `Updated_At`, `Updated_By`, `Deleted`)
  VALUES (_Code, _Name, NOW(), _UserID, NOW(), _UserID, 0);

CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveDCI` (IN `_Number` INT, IN `_DOT` DATETIME, IN `_Status` VARCHAR(55), IN `_DOC` VARCHAR(55), IN `_Cost` VARCHAR(128), IN `_CostIncurred` VARCHAR(55), IN `_Processing` VARCHAR(55), IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new DCI Clearance:',_Number);
INSERT INTO dci (Number, DOT, Certificate_status, DOC, Cost, CostIncurred, Processing,Status, Created_at, CreatedBy, Updated_at, UpdatedBy, Deleted)
  VALUES (_Number, _DOT, _Status, _DOC, _Cost, _CostIncurred, _Processing,'Pending Approval', NOW(), _userID, 0, 0, 0);
INSERT INTO notifications (Username, Category, Description, Created_At, DueDate, Status)
  SELECT
    Username,
    'DCI Approval',
    'DCI pending approval',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 5 DAY),
    'Not Resolved'
  FROM approvers
  WHERE ModuleCode = 'DCI'
  AND Active = 1
  AND Deleted = 0;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveDocument` (IN `_ApplicationID` BIGINT, IN `_DocName` VARCHAR(100), IN `_Description` VARCHAR(525), IN `_Path` VARCHAR(255), IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);

set lSaleDesc= CONCAT('Added new Document for application: ', _ApplicationID);
INSERT INTO `registrationdocuments` (IDNumber,DocName, `Description`,Path, `Created_At`, `Created_By`, `Deleted` )
  VALUES (_ApplicationID,_DocName, _Description,_Path,NOW(), _UserID,0);
CALL SaveAuditTrail(_UserID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveEducational` (IN `_IDNumber` VARCHAR(128), IN `_Institution` VARCHAR(25), IN `_Period` VARCHAR(55), IN `_Description` VARCHAR(128), IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new User with username:',_Institution);
INSERT INTO educationaldetails (IDNumber, Institution, Period, Decription, Created_at, CreatedBy, UpdateBy, Update_at, Deleted)
  VALUES (_IDNumber, _Institution, _Period, _Description, NOW(), _userID, 0, 0, 0);
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveFinalMedical` (IN `_Number` INT, IN `_facility` VARCHAR(25), IN `_DOM` DATETIME, IN `_Result` VARCHAR(25), IN `_Cost` VARCHAR(25), IN `_Type` VARCHAR(55), IN `_RepeatCost` VARCHAR(55), IN `_Others` VARCHAR(25), IN `_userID` INT)  BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new   Final medical with  IDnumber:',_Number);
INSERT INTO finalmedical (Number, MedicalFacility, DOM, MedicalResult, Cost, Type, RepeatCost, Other,Status, Created_at, CreatedBy, Updated_at, UpdatedBy, Deleted)
  VALUE (_Number, _facility, _DOM, _Result, _Cost, _Type, _RepeatCost, _Others,'Pending Approval', NOW(), _userID, 0, 0, 0);
INSERT INTO notifications (Username, Category, Description, Created_At, DueDate, Status,IDNumber)
  SELECT
    Username,
    'Final Medical Approval ',
    'Final Medical pending approval',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 5 DAY),
    'Not Resolved',
    _Number
  FROM approvers
  WHERE ModuleCode = 'FNL'
  AND Active = 1
  AND Deleted = 0;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveMajor` (IN `_Number` INT, IN `_Facility` VARCHAR(55), IN `_Result` VARCHAR(55), IN `_DOM` DATETIME, IN `_Mcertificate` VARCHAR(255), IN `_DOC` DATETIME, IN `_Cost` VARCHAR(128), IN `_Type` VARCHAR(55), IN `_RepeatCost` VARCHAR(55), IN `_Others` VARCHAR(55), IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new Minor medical:',_Number);
INSERT INTO major (Number, MedicalFacility, MedicalResults, DOM, MCertificate, DOC, Cost, Type, RepeatCost, Others,Status, Created_at, CreatedBy, Updated_at, UpdatedBy, Deleted)
  VALUES (_Number, _Facility, _Result, _DOM, _Mcertificate, _DOC, _Cost, _Type, _RepeatCost, _Others,'Pending Approval', NOW(), _userID, 0, 0, 0);
   INSERT INTO notifications( Username, Category, Description, Created_At, DueDate, Status,IDNumber)
 SELECT
    Username,
    'Major Medical Approval',
    'Major pending approval',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 3 DAY),
    'Not Resolved',
    _Number
  FROM approvers
  WHERE ModuleCode = 'MJR'
  AND Active = 1
  AND Deleted = 0;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveMedicalFacility` (IN `_Name` VARCHAR(50), IN `_Description` VARCHAR(128), IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new medical facility with Name: ', _Name);
INSERT INTO `medicalfacility` (`Name`, `Description`, `Created_at`, `CreatedBy`, `Updated_at`, `UpdatedBy`, `Deleted`)
  VALUES (_Name, _Description, NOW(), _UserID, 0, 0, 0);
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveMedicalForm` (IN `_IDNumber` VARCHAR(50), IN `_Path` VARCHAR(100), IN `_Attachementname` VARCHAR(105), IN `_UserID` VARCHAR(50))  BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Generated hearing Notice for Application: ', _IDNumber);
INSERT INTO medicalform (IDnumber, DateGenerated, Path, Filename, Created_By)
  VALUES (_IDNumber, NOW(), _Path, _Attachementname, _UserID);
CALL SaveAuditTrail(_UserID, lSaleDesc, 'Add', '0');
CALL Saveapplicationsequence(_IDNumber, 'Medical Form Generate', 'Medical', _UserID);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveMinorMedical` (IN `_Number` INT, IN `_DOM` DATETIME, IN `_Facility` VARCHAR(55), IN `_Result` VARCHAR(55), IN `_Cost` VARCHAR(128), IN `_Type` VARCHAR(55), IN `_RepeatCost` VARCHAR(55), IN `_Others` VARCHAR(55), IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new Minor medical:',_Number);
INSERT INTO minormedical (Number, DOM, MedicalFacility, Result, Cost, Type, RepeatCost, Others,Status, Created_at, CreatedBy, UpdateBy, Updated_at, Deleted)
  VALUES (_Number, _DOM, _Facility, _Result, _Cost, _Type, _RepeatCost, _Others,'Pending Approval' ,NOW(), _userID, 0, 0, 0);
INSERT INTO notifications (Username, Category, Description, Created_At, DueDate, Status)
  SELECT
    Username,
    'Minor Medical Approval',
    'MinorMedical pending approval',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 3 DAY),
    'Not Resolved'
  FROM approvers
  WHERE ModuleCode = 'MNR'
  AND Active = 1
  AND Deleted = 0;
CALL SaveAuditTrail(_UserID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveNEAA` (IN `_Number` INT, IN `_DOS` DATETIME, IN `_Approved` VARCHAR(255), IN `_DOA` DATETIME, IN `_Reason` VARCHAR(255), IN `_Rdate` DATETIME, IN `_userID` VARCHAR(255))  BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new training  with name:',_Number);
INSERT INTO neaa (Number, DOS, Approved_Status, DOA, Reason, RDate,Status, Created_at, CreatedBy, Updated_at, UpdatedBy, Deleted)
  VALUES (_Number, _DOS, _Approved, DOA, _Reason, _Rdate,'Pending Approval', NOW(), _userID, 0, 0, 0);
INSERT INTO notifications (Username, Category, Description, Created_At, DueDate, Status,IDNumber)
  SELECT
    Username,
    'NEA Approval',
    'NEA pending approval',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 5 DAY),
    'Not Resolved',
    _Number
  FROM approvers
  WHERE ModuleCode = 'NEA'
  AND Active = 1
  AND Deleted = 0;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveNextOFKin` (IN `_IDNumber` VARCHAR(128), IN `_KinName` VARCHAR(25), IN `_Relationship` VARCHAR(128), IN `_CurrentResident` VARCHAR(55), IN `_Contact` VARCHAR(255), IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new Next of kin  with name:',_KinName);
INSERT INTO nextofkin (IDNumber, KinName, KRelationship, CurrentResident, Contact, Created_at, CreatedBy, Deleted)
  VALUES (_IDNumber, _KinName, _Relationship, _CurrentResident, _Contact, NOW(), _userID, 0);
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveParent` (IN `_IDNumber` VARCHAR(128), IN `_Name` VARCHAR(25), IN `_ParentID` VARCHAR(55), IN `_Relationship` VARCHAR(128), IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new User with username:',_Name);
INSERT INTO parents (IDNumber, Name, ParentID, Relationship, Created_at, CreatedBy, Deleted)
  VALUES (_IDNumber, _Name, _ParentID, _Relationship, NOW(), _userID, 0);
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SavePassport` (IN `_Number` INT, IN `_POD` DATETIME, IN `_Tracking_Number` VARCHAR(25), IN `_Status` VARCHAR(55), IN `_DOC` DATETIME, IN `_PassPortNumber` VARCHAR(128), IN `_Option` VARCHAR(55), IN `_Cost` VARCHAR(55), IN `_CostIncurred` VARCHAR(55), IN `_Location` VARCHAR(25), IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added passport processing:',_Number);
INSERT INTO passport (Number, POD, Tracking_Number,Passport_Status, Status, Passport_Collection_Date, PassPortNumber, PassportOption, Cost, CostIncurred, Location, Created_At
, CreatedBy, Updated_at, UpdatedBy, Deleted)
  VALUES (_Number, _POD, _Tracking_Number,'Pending Approval', _Status, _DOC, _PassPortNumber, _Option, _Cost, _CostIncurred, _Location, NOW(), _userID, 0, 0, 0);
INSERT INTO notifications (Username, Category, Description, Created_At, DueDate, Status)
  SELECT
    Username,
    'Passport Approval',
    'Passport pending approval',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 14 DAY),
    'Not Resolved'
  FROM approvers
  WHERE ModuleCode = 'PST'
  AND Active = 1
  AND Deleted = 0;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveRegistration` (IN `_IDNumber` INT(11), IN `_Fullname` VARCHAR(150), IN `_Gender` VARCHAR(25), IN `_Phone` VARCHAR(128), IN `_DOB` DATETIME, IN `_Email` VARCHAR(20), IN `_Country` VARCHAR(150), IN `_County` VARCHAR(50), IN `_Village` VARCHAR(100), IN `_Religion` VARCHAR(255), IN `_Marital` VARCHAR(50), IN `_Height` VARCHAR(50), IN `_Weight` VARCHAR(255), IN `_Photo` VARCHAR(255), IN `_FullPhoto` VARCHAR(55), IN `_BirthCer` VARCHAR(255), IN `_Husband` VARCHAR(255), IN `_HusbandMobile` VARCHAR(255), IN `_HusbandID` VARCHAR(255), IN `_Languages` VARCHAR(255), IN `_Skills` VARCHAR(255), IN `_Classify` VARCHAR(255), IN `_Agent` VARCHAR(255), IN `_Job` VARCHAR(55), IN `_Status` VARCHAR(255), IN `_UserID` VARCHAR(55))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new Applicant:',_IDNumber);
INSERT INTO registration (IDNumber, Fullname, Gender, phone, DOB, Email, Country, County, Village, Religion, Marital, Height, Weight, photo, FullPhoto, BirthCer
, Husband, HusbandMobile, HusbandID, Languages, Skills, Classify, Agent, Job,Status,
Created_at, CreatedBy, Updated_at, Updated_By, Deleted)
  VALUES (_IDNumber, _Fullname, _Gender, _Phone, _DOB, _Email, _Country, _County, _Village, _Religion, _Marital, 
_Height, _Weight, _Photo, _FullPhoto, _BirthCer, _Husband, _HusbandMobile, _HusbandID, _Languages, _Skills, _Classify, _Agent, _Job,_Status, NOW(), _UserID, 0, 0, 0);
INSERT INTO notifications (Username, Category, Description, Created_At, DueDate, Status,IDNumber)
  SELECT
    Username,
    'Applications Approval',
    'Applications pending approval',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 3 DAY),
    'Not Resolved',
    _IDNumber
  FROM approvers
  WHERE ModuleCode = 'REG'
  AND Active = 1
  AND Deleted = 0;
CALL SaveAuditTrail(_UserID, lSaleDesc, 'Add', '0');


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveRegistrationDocument` (IN `_Number` VARCHAR(255), IN `_name` VARCHAR(255), IN `_Description` VARCHAR(255), IN `_path` VARCHAR(255), IN `_userID` VARCHAR(255))  BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('upload Registration Document For:',_Number);
INSERT INTO registrationdocuments (Number, FileName, Description, Path, Created_At, Created_By, Deleted)
  VALUES (_Number, _name, _Description, _path, NOW(), _userID, 0);
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveRole` (IN `_RoleName` VARCHAR(50), IN `_RoleDescription` VARCHAR(128), IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new Role with Name: ', _RoleName ,' and desc',_RoleDescription);
INSERT INTO `roles` (`RoleName`, `RoleDescription`, `UpdateBy`, `CreateBy`, `CreatedAt`, `UpdatedAt`, `Deleted`)
  VALUES (_RoleName, _RoleDescription, _UserID, _UserID, NOW(), NOW(), 0);
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveSiblings` (IN `_IDNumber` VARCHAR(128), IN `_Name` VARCHAR(25), IN `_Sex` VARCHAR(128), IN `_Age` VARCHAR(55), IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new Siblings name:',_Name);
INSERT INTO siblings (IDNumber, SiblingName, Sex, Age, Created_at, Created_By, Deleted)
  VALUES (_IDNumber, _Name, _Sex, _Age, NOW(), _userID, 0);
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveTicketing` (IN `_Number` INT, IN `_Status` VARCHAR(255), IN `_Flight_date` DATETIME, IN `_Destination` VARCHAR(55), IN `_Airline` VARCHAR(55), IN `_Cost` VARCHAR(55), IN `_userID` INT)  BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added Ticketing:',_Number);
INSERT INTO ticketing (Number, Ticket_status, Flight_Date, Destination, Airline, Cost,Status,Created_at, CreatedBy, Updated_at, UpdatedBy, Deleted)
  VALUES (_Number, _Status, _Flight_Date, _Destination, _Airline, _Cost,'Pending Approval', NOW(), _userID, 0, 0, 0);
INSERT INTO notifications (Username, Category, Description, Created_At, DueDate, Status,IDNumber)
  SELECT
    Username,
    'Ticketing Approval',
    'Ticketing pending approval',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 5 DAY),
    'Not Resolved',
    _Number
  FROM approvers
  WHERE ModuleCode = 'TKN'
  AND Active = 1
  AND Deleted = 0;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveTraining` (IN `_Number` VARCHAR(128), IN `_COM` DATETIME, IN `_EOM` DATETIME, IN `_Training_status` VARCHAR(55), IN `_Transcript_status` VARCHAR(255), IN `_DOF` DATETIME, IN `_Cost` VARCHAR(255), IN `_userID` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new training  with name:',_Number);
INSERT INTO training (Number, COM, EOM, Training_status, Transcript_status, DOF, Cost,Status, Created_at, CreatedBy, Updated_at, Updatedby, Deleted)
  VALUES (_Number, _COM, _EOM, _Training_status, _Transcript_status, _DOF, _Cost,'Pending Approval', NOW(), _userID, 0, 0, 0);
INSERT INTO notifications (Username, Category, Description, Created_At, DueDate, Status,IDNumber)
  SELECT
    Username,
    'Training Approval',
    'Training pending approval',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 5 DAY),
    'Not Resolved',
    _Number
  FROM approvers
  WHERE ModuleCode = 'TRG'
  AND Active = 1
  AND Deleted = 0;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Savetravelling` (IN `_Number` INT, IN `_DOT` DATETIME, IN `_Status` VARCHAR(25), IN `_Cost` VARCHAR(25), IN `_userID` VARCHAR(255))  BEGIN
  DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new Travelling  with name:',_Number);
INSERT INTO travelling (Number, DOT, Status, Cost, Approve_Status,Created_at, CreatedBy, Update_at, UpdateBy, Deleted)
  VALUES (_Number, _DOT, _Status, _Cost,'Pending Approval', NOW(), _userID, 0, 0, 0);
  INSERT INTO notifications (Username, Category, Description, Created_At, DueDate, Status,IDNumber)
  SELECT
    Username,
    'Travelling Approval',
    'Travel pending approval',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 5 DAY),
    'Not Resolved',
    _Number
  FROM approvers
  WHERE ModuleCode = 'TRG'
  AND Active = 1
  AND Deleted = 0;
  CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveUser` (IN `_Name` VARCHAR(120), IN `_Email` VARCHAR(128), IN `_Password` VARCHAR(128), IN `_UserGroupID` BIGINT, IN `_Username` VARCHAR(50), IN `_userID` VARCHAR(50), IN `_Phone` VARCHAR(20), IN `_Signature` VARCHAR(128), IN `_IsActive` BOOLEAN, IN `_IDnumber` INT, IN `_DOB` DATETIME, IN `_Gender` VARCHAR(50), IN `_ActivationCode` VARCHAR(50), IN `_Board` BOOLEAN)  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new User with username:',_Username);

INSERT INTO `users` (`Name`, `Username`, `Email`, `Phone`, `Password`, `Create_at`, `Deleted`, `IsActive`, `IsEmailverified`, ActivationCode, `UserGroupID`, CreatedBy, Category, Signature, Photo, IDnumber, Gender, DOB, ChangePassword, Board)

  VALUES (_Name, _Username, _Email, _Phone, _Password, NOW(), 0, _IsActive, 0, _ActivationCode, _UserGroupID, _userID, 'System_User', _Signature, 'default.png', _IDnumber, _Gender, _DOB, 1, _Board);

CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');

INSERT INTO `useraccess` (`Username`, `RoleID`, `Edit`, `Remove`, `AddNew`, `View`, `Export`, `UpdateBy`, `CreateBy`, `CreatedAt`, `UpdatedAt`)
  SELECT
    _Username,
    RoleID,
    Edit,
    Remove,
    AddNew,
    View,
    Export,
    _userID,
    _userID,
    NOW(),
    NOW()
  FROM groupaccess
  WHERE UserGroupID = _UserGroupID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveuserAcces` (IN `_Username` VARCHAR(50), IN `_RoleID` BIGINT, IN `_Edit` BOOLEAN, IN `_Remove` BOOLEAN, IN `_AddNew` BOOLEAN, IN `_View` BOOLEAN, IN `_Export` BOOLEAN, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
if( SELECT
    COUNT(*)
  FROM useraccess
  WHERE Username = _Username
  AND RoleID = _RoleID) > 0 THEN
BEGIN

set lSaleDesc= CONCAT('Updated  useraccess of role for user: ', _Username );
UPDATE useraccess
SET Edit = _Edit,
    Remove = _Remove,
    AddNew = _AddNew,
    View = _View,
    Export = _Export,
    UpdateBy = _userID,
    UpdatedAt = NOW()
WHERE Username = _Username
AND RoleID = _RoleID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END;
ELSE
BEGIN
set lSaleDesc= CONCAT('Added new useraccess for user: ', _Username );
INSERT INTO `useraccess` (`Username`, `RoleID`, `Edit`, `Remove`, `AddNew`, `View`, `Export`, `UpdateBy`, `CreateBy`, `CreatedAt`, `UpdatedAt`)
  VALUES (_Username, _RoleID, _Edit, _Remove, _AddNew, _View, _Export, _userID, _userID, NOW(), NOW());

CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveUserGroup` (IN `_Name` VARCHAR(128), IN `_Description` VARCHAR(128), IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new UserGroup with name: ',_Name ,'and Decs: ',_Description);



INSERT INTO `usergroups` (`Name`, `Description`, `CreatedAt`, `UpdatedAt`, `Deleted`, CreatedBy, UpdatedBy)
  VALUES (_Name, _Description, NOW(), NOW(), 0, _userID, _userID);

CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveVisa` (IN `_Number` INT, IN `_VAD` DATETIME, IN `_VID` DATETIME, IN `_Status` VARCHAR(25), IN `_Cost` VARCHAR(25), IN `_userID` VARCHAR(255))  BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Added new VISA Processing with  IDnumber:',_Number);
INSERT INTO visa (Number, VAD, VID, Status, Cost,Visa_Status, Created_at, CreatedBy, Updated_at, UpdatedBy, Deleted)
  VALUES (_Number, _VAD, _VID, _Status, _Cost,'Pending Approval', NOW(), _userID, 0, 0, 0);
INSERT INTO notifications (Username, Category, Description, Created_At, DueDate, Status,IDNumber)
  SELECT
    Username,
    'Visa Approval',
    'Visa pending approval',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 5 DAY),
    'Not Resolved',
    _Number
  FROM approvers
  WHERE ModuleCode = 'VSA'
  AND Active = 1
  AND Deleted = 0;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Add', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SetMaxApproval` (IN `_MaximumApprovers` INT, IN `_ModuleCode` VARCHAR(50), IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);

DECLARE NewCode varchar(50);
set lSaleDesc= CONCAT('Updated Maximum Approvals for Module' ,_ModuleCode);

UPDATE approvalmodules
SET MaxApprovals = _MaximumApprovers
WHERE ModuleCode = _ModuleCode;

CALL SaveAuditTrail(_UserID, lSaleDesc, 'Add', '0');


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Signup` (IN `_Name` VARCHAR(120), IN `_Username` VARCHAR(50), IN `_Email` VARCHAR(128), IN `_Phone` VARCHAR(20), IN `_Password` VARCHAR(128), IN `_Category` VARCHAR(50), IN `_ActivationCode` VARCHAR(100), IN `_IDnumber` VARCHAR(50), IN `_DOB` DATETIME)  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
SELECT
  UserGroupID
FROM usergroups
WHERE name = 'Portal users' INTO @userGroup;
 
set lSaleDesc= CONCAT('New Sign up with username:',_Username);
INSERT INTO `users` (`Name`, `Username`, `Email`, `Phone`, `Password`, `Create_at`, `Deleted`, `IsActive`, `IsEmailverified`, `ActivationCode`, `UserGroupID`, CreatedBy, Category, Photo, IDnumber, DOB, ChangePassword)
  VALUES (_Name, _Username, _Email, _Phone, _Password, NOW(), 0, 0, 0, _ActivationCode, @userGroup, _Username, _Category, 'default.png', _IDnumber, _DOB, 0);

INSERT INTO `useraccess` (`Username`, `RoleID`, `Edit`, `Remove`, `AddNew`, `View`, `Export`, `CreateBy`, `CreatedAt`)
  SELECT
    _Username,
    RoleID,
    Edit,
    Remove,
    AddNew,
    View,
    Export,
    _Username,
    NOW()
  FROM groupaccess
  WHERE UserGroupID = @userGroup;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ValidatePrivilege` (IN `_Username` VARCHAR(50), IN `_RoleName` VARCHAR(128))  NO SQL
BEGIN
SELECT
  `Username`,
  useraccess.RoleID,
  `Edit`,
  `Remove`,
  `AddNew`,
  `View`,
  `Export`
FROM `useraccess`
  INNER JOIN roles
    ON useraccess.RoleID = roles.RoleID
WHERE Username = _Username
AND Roles.RoleName = _RoleName;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TicketingRedAlerts` ()  BEGIN
SELECT
  COUNT(*) AS TicketingRedAlerts
FROM ticketing
WHERE SUBDATE(NOW(), INTERVAL 5 DAY)
AND Deleted = 0
AND Ticket_status = 'pending';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalCost` ()  BEGIN
SELECT
  (SELECT
      SUM(Cost)
    FROM minormedical
    WHERE Deleted = 0) + (SELECT
      SUM(Cost)
    FROM major
    WHERE Deleted = 0) + (SELECT
      SUM(Cost)
    FROM finalmedical
    WHERE Deleted = 0) + (SELECT
      SUM(Cost)
    FROM dci
    WHERE Deleted = 0) + (SELECT
      SUM(Cost)
    FROM passport
    WHERE Deleted = 0) + (SELECT
      SUM(Cost)
    FROM ticketing
    WHERE Deleted = 0) AS TotalCost;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalCostIncurred` ()  BEGIN
SELECT
  (SELECT
      SUM(CostIncurred)
    FROM dci
    WHERE Deleted = 0) + (SELECT
      SUM(CostIncurred)
    FROM passport
    WHERE Deleted = 0) AS TotalCostIncurred;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalCostPassportperOption` (IN `_passportOption` VARCHAR(55))  BEGIN
SELECT
  SUM(cost) AS PassportCost
FROM passport
WHERE Deleted = 0
AND PassportOption = _passportOption;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotaldciCost` ()  BEGIN
SELECT
  SUM(Cost) AS DCICost
FROM dci
WHERE deleted = 0
AND Processing = 'Job majuu';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalFinalMedicalCost` ()  BEGIN
SELECT
  SUM(Cost) AS FinalCost
FROM finalmedical
WHERE Deleted = 0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalMajorCost` ()  BEGIN
SELECT
  SUM(cost) AS MajorCost
FROM major
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalMinorMedicalCost` ()  BEGIN
SELECT
  SUM(Cost) AS MinorCost
FROM minormedical
WHERE deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalpassportCost` ()  BEGIN
SELECT
  SUM(cost) AS PassportCost
FROM passport
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalRepeatCost` ()  BEGIN
SELECT
  (SELECT
      SUM(RepeatCost)
    FROM minormedical
    WHERE Deleted = 0) + (SELECT
      SUM(RepeatCost)
    FROM major
    WHERE Deleted = 0) + (SELECT
      SUM(RepeatCost)
    FROM finalmedical
    WHERE Deleted = 0) AS TotalRepeatCost;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalSystemUsers` ()  BEGIN
SELECT
  COUNT(*) AS SystemUsers
FROM users
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalTicketingCost` ()  BEGIN
SELECT
  SUM(Cost) AS TicketingCost
FROM ticketing
WHERE Deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalVisaCost` ()  BEGIN
SELECT
  SUM(cost) AS total
FROM visa
WHERE deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TrainingRedAlerts` ()  BEGIN
SELECT
  COUNT(*) AS TrainingRedAlerts
FROM training
WHERE SUBDATE(NOW(), INTERVAL 9 DAY)
AND Deleted = 0
AND Training_status = 'enrolled';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateApprover` (IN `_ID` INT, IN `_Username` VARCHAR(50), IN `_ModuleCode` VARCHAR(50), IN `_Level` INT, IN `_Active` BOOLEAN, IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Updated Approver: '+ _Username +' for module: '+ _ModuleCode);
UPDATE approvers
SET Username = _Username,
    ModuleCode = _ModuleCode,
    Level = _Level,
    Update_at = NOW(),
    UpdatedBy = _UserID,
    Active = _Active
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'UPDATE', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateAttestation` (IN `_Number` INT, IN `_DOS` DATETIME, IN `_Status` VARCHAR(255), IN `_Clearance` DATETIME, IN `_Cost` VARCHAR(25), IN `_userID` INT, IN `_ID` INT)  BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Update   Attestation with  IDnumber:',_Number);
UPDATE attestation
SET Number = _Number,
    DOS = _DOS,
    Clearance_status = _Status,
    Clearance_Date = _Clearance,
    Cost = _Cost,
    Updated_at = NOW(),
    UpdatedBy = _userID
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBranch` (IN `_ID` INT, IN `_Description` VARCHAR(100), IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Updated  Branch: ',_ID);
UPDATE Branches
SET Description = _Description,
    Updated_At = NOW(),
    Updated_By = _UserID
WHERE ID = _ID;
CALL SaveAuditTrail(_UserID, lSaleDesc, 'Update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateConfigurations` (IN `_Name` VARCHAR(255), IN `_PhysicalAdress` VARCHAR(255), IN `_Street` VARCHAR(255), IN `_PoBox` VARCHAR(255), IN `_PostalCode` VARCHAR(50), IN `_Town` VARCHAR(100), IN `_Telephone1` VARCHAR(100), IN `_Telephone2` VARCHAR(100), IN `_Mobile` VARCHAR(100), IN `_Fax` VARCHAR(100), IN `_Email` VARCHAR(100), IN `_Website` VARCHAR(100), IN `_PIN` VARCHAR(50), IN `_Logo` VARCHAR(100), IN `_UserID` VARCHAR(50), IN `_Code` VARCHAR(50))  BEGIN
UPDATE `configurations`
SET `Name` = _Name,
    `PhysicalAdress` = _PhysicalAdress,
    `Street` = _Street,
    `PoBox` = _PoBox,
    `PostalCode` = _PostalCode,
    `Town` = _Town,
    `Telephone1` = _Telephone1,
    `Telephone2` = _Telephone2,
    `Mobile` = _Mobile,
    `Fax` = _Fax,
    `Email` = _Email,
    `Website` = _Website,
    `PIN` = _PIN,
    `Logo` = _Logo,

    `Updated_At` = NOW(),
    `Updated_By` = _UserID
WHERE Code = _Code;




END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateContract` (IN `_Number` INT, IN `_Contract_status` VARCHAR(55), IN `_Cost` VARCHAR(255), IN `_EmployerName` VARCHAR(55), IN `_EmployerID` VARCHAR(55), IN `_EmployerContact` VARCHAR(55), IN `_EmployerAddress` VARCHAR(55), IN `_VisaNumber` VARCHAR(55), IN `_ContractNumber` VARCHAR(55), IN `_userID` VARCHAR(55), IN `_ID` INT)  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Update new Contract processing:',_Number);
UPDATE contract
SET Number = _Number,
    Contract_status = _Contract_status,
    Cost = _Cost,
    EmployerName = _EmployerName,
    EmployerID = _EmployerID,
    EmployerContact = _EmployerContact,
    EmployerAddress = _EmployerAddress,
    VisaNumber = _VisaNumber,
    ContractNumber = _ContractNumber,
    Updated_at = NOW(),
    UpdateBy = _userID
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Updatecountry` (IN `_Code` VARCHAR(50), IN `_Description` VARCHAR(100), IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Updated  country: ',_Code);
UPDATE countries
SET Name = _Description,
    Updated_At = NOW(),
    Updated_By = _UserID
WHERE Code = _Code;
CALL SaveAuditTrail(_UserID, lSaleDesc, 'Update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Updatecounty` (IN `_Code` VARCHAR(50), IN `_Description` VARCHAR(100), IN `_UserID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Updated  county: ',_Code);
UPDATE counties
SET Name = _Description,
    Updated_At = NOW(),
    Updated_By = _UserID
WHERE Code = _Code;
CALL SaveAuditTrail(_UserID, lSaleDesc, 'Update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateDCI` (IN `_Number` INT, IN `_DOT` DATETIME, IN `_Status` VARCHAR(55), IN `_DOC` VARCHAR(55), IN `_Cost` VARCHAR(128), IN `_userID` VARCHAR(50), IN `_ID` INT, IN `_CostIncurred` VARCHAR(25), IN `_processing` VARCHAR(55))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Update new DCI Clearance:',_Number);
UPDATE dci
SET Number = _Number,
    DOT = _DOT,
    Certificate_status = _status,
    DOC = _DOC,
    Cost = _Cost,
    CostIncurred = _CostIncurred,
    Processing = _processing,
    Updated_at = NOW(),
    UpdatedBy = _userID
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateEducational` (IN `_IDNumber` VARCHAR(128), IN `_Institution` VARCHAR(25), IN `_Period` VARCHAR(55), IN `_Description` VARCHAR(128), IN `_ID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Updated Educational  with iD: ', _ID ,'and name:' ,_Institution);
UPDATE educationaldetails
SET IDNumber = _IDNumber,
    Institution = _Institution,
    Period = _Period,
    Decription = _Description,
    UpdateBy = _userID,
    Update_at = NOW()
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateFinalMedical` (IN `_Number` INT, IN `_facility` VARCHAR(25), IN `_DOM` DATETIME, IN `_Result` VARCHAR(25), IN `_Cost` VARCHAR(25), IN `_Type` VARCHAR(55), IN `_RepeatCost` VARCHAR(55), IN `_Others` VARCHAR(55), IN `_UserID` INT, IN `_ID` VARCHAR(255))  BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Update Final medical with  IDnumber:',_Number);
UPDATE finalmedical
SET Number = _Number,
    MedicalFacility = _facility,
    DOM = _DOM,
    MedicalResult = _Result,
    Cost = _Cost,
    Type = _Type,
    RepeatCost = _RepeatCost,
    Other = _Others,
    Updated_at = NOW(),
    UpdatedBy = _UserID
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateGroupRoles` (IN `_UserGroupID` BIGINT, IN `_RoleID` BIGINT, IN `_Status` BOOLEAN, IN `_Desc` VARCHAR(50), IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
if( SELECT
    COUNT(*)
  FROM groupaccess
  WHERE UserGroupID = _UserGroupID
  AND RoleID = _RoleID) > 0 THEN
set lSaleDesc= CONCAT('Updated groupaccess  role'+_RoleID+' for userGroup: ', _UserGroupID );
 

BEGIN
if(_Desc ='Create')THEN
Begin
UPDATE groupaccess
SET AddNew = _Status,
    UpdateBy = _userID,
    UpdatedAt = NOW()
WHERE UserGroupID = _UserGroupID
AND RoleID = _RoleID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');

END;
END IF;
if(_Desc='View')THEN
Begin
UPDATE groupaccess
SET View = _Status,
    UpdateBy = _userID,
    UpdatedAt = NOW()
WHERE UserGroupID = _UserGroupID
AND RoleID = _RoleID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END;
END IF;
if(_Desc='Delete')THEN
Begin
UPDATE groupaccess
SET Remove = _Status,
    UpdateBy = _userID,
    UpdatedAt = NOW()
WHERE UserGroupID = _UserGroupID
AND RoleID = _RoleID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END;
END IF;
if(_Desc='Update')THEN
Begin
UPDATE groupaccess
SET Edit = _Status,
    UpdateBy = _userID,
    UpdatedAt = NOW()
WHERE UserGroupID = _UserGroupID
AND RoleID = _RoleID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END;
END IF;
if(_Desc='Export')THEN
Begin
UPDATE groupaccess
SET Export = _Status,
    UpdateBy = _userID,
    UpdatedAt = NOW()
WHERE UserGroupID = _UserGroupID
AND RoleID = _RoleID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END;
END IF;

END;

ELSE
BEGIN
set lSaleDesc= CONCAT('created groupaccess  role'+_RoleID+' for userGroup: ', _UserGroupID );
 
if(_Desc ='Create')THEN
Begin


INSERT INTO `groupaccess` (`UserGroupID`, `RoleID`, `Edit`, `Remove`, `AddNew`, `View`, `Export`, `UpdateBy`,
`CreateBy`, `CreatedAt`, `UpdatedAt`, `Deleted`)
  VALUES (_UserGroupID, _RoleID, FALSE, FALSE, _Status, FALSE, FALSE, _userID, _userID, NOW(), NOW(), 0);
CALL SaveAuditTrail(_userID, lSaleDesc, 'Create', '0');

END;
END IF;
if(_Desc='View')THEN
Begin
INSERT INTO `groupaccess` (`UserGroupID`, `RoleID`, `Edit`, `Remove`, `AddNew`, `View`, `Export`, `UpdateBy`,
`CreateBy`, `CreatedAt`, `UpdatedAt`, `Deleted`)
  VALUES (_UserGroupID, _RoleID, FALSE, FALSE, FALSE, _Status, FALSE, _userID, _userID, NOW(), NOW(), 0);
CALL SaveAuditTrail(_userID, lSaleDesc, 'Create', '0');

END;
END IF;
if(_Desc='Delete')THEN
Begin
INSERT INTO `groupaccess` (`UserGroupID`, `RoleID`, `Edit`, `Remove`, `AddNew`, `View`, `Export`, `UpdateBy`,
`CreateBy`, `CreatedAt`, `UpdatedAt`, `Deleted`)
  VALUES (_UserGroupID, _RoleID, FALSE, _Status, FALSE, FALSE, FALSE, _userID, _userID, NOW(), NOW(), 0);
CALL SaveAuditTrail(_userID, lSaleDesc, 'Create', '0');
END;
END IF;
if(_Desc='Update')THEN
Begin
INSERT INTO `groupaccess` (`UserGroupID`, `RoleID`, `Edit`, `Remove`, `AddNew`, `View`, `Export`, `UpdateBy`,
`CreateBy`, `CreatedAt`, `UpdatedAt`, `Deleted`)
  VALUES (_UserGroupID, _RoleID, _Status, FALSE, FALSE, FALSE, FALSE, _userID, _userID, NOW(), NOW(), 0);
CALL SaveAuditTrail(_userID, lSaleDesc, 'Create', '0');
END;
END IF;
if(_Desc='Export')THEN
Begin
INSERT INTO `groupaccess` (`UserGroupID`, `RoleID`, `Edit`, `Remove`, `AddNew`, `View`, `Export`, `UpdateBy`,
`CreateBy`, `CreatedAt`, `UpdatedAt`, `Deleted`)
  VALUES (_UserGroupID, _RoleID, FALSE, FALSE, FALSE, FALSE, _Status, _userID, _userID, NOW(), NOW(), 0);
CALL SaveAuditTrail(_userID, lSaleDesc, 'Create', '0');
END;
END IF;
END;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateMajor` (IN `_Number` INT, IN `_Facility` VARCHAR(55), IN `_Result` VARCHAR(55), IN `_DOM` DATETIME, IN `_Mcertificate` VARCHAR(255), IN `_DOC` DATETIME, IN `_Cost` VARCHAR(128), IN `_Type` VARCHAR(55), IN `_RepeatCost` VARCHAR(55), IN `_Others` VARCHAR(55), IN `_userID` VARCHAR(50), IN `_ID` VARCHAR(55))  NO SQL
BEGIN
UPDATE major
SET Number = _Number,
    MedicalFacility = _Facility,
    MedicalResults = _Result,
    DOM = _DOM,
    MCertificate = _Mcertificate,
    DOC = _DOC,
    Cost = _Cost,
    Type = _Type,
    RepeatCost = _RepeatCost,
    Others = _Others,
    Updated_at = NOW(),
    UpdatedBy = _userID
WHERE ID = _ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateMedicalFacility` (IN `_Name` VARCHAR(128), IN `_Description` VARCHAR(128), IN `_MedID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Updated Medical facility with name: ', _name);
UPDATE medicalfacility
SET Name = _Name,
    Description = _Description,
    Updated_at = NOW(),
    UpdatedBy = _userID
WHERE MedID = _MedID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateMinorMedical` (IN `_Number` VARCHAR(128), IN `_DOM` DATETIME, IN `_Facility` VARCHAR(55), IN `_Result` VARCHAR(55), IN `_Cost` VARCHAR(128), IN `_Type` VARCHAR(55), IN `_RepeatCost` VARCHAR(55), IN `_Others` VARCHAR(55), IN `_userID` VARCHAR(50), IN `_ID` INT)  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Update new Minor medical:',_Number);
UPDATE minormedical
SET Number = _Number,
    DOM = _DOM,
    MedicalFacility = _Facility,
    Result = _Result,
    Cost = _Cost,
    Type = _Type,
    RepeatCost = _RepeatCost,
    Others = _Others,
    UpdateBy = _userID,
    Updated_at = NOW()
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateNEAA` (IN `_Number` INT, IN `_DOS` DATETIME, IN `_Approved_Status` VARCHAR(55), IN `_DOA` DATETIME, IN `_Reason` VARCHAR(255), IN `_RDate` DATETIME, IN `_userID` INT, IN `_ID` INT)  BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Update new NEAA:',_Number);
UPDATE neaa
SET Number = _Number,
    DOS = _DOS,
    Approved_Status = _Approved_Status,
    DOA = _DOA,
    Reason = _Reason,
    RDate = _RDate,
    Updated_at = NOW(),
    UpdatedBy = _userID
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateNextOFKin` (IN `_IDNumber` VARCHAR(128), IN `_KinName` VARCHAR(25), IN `_Relationship` VARCHAR(128), IN `_CurrentResident` VARCHAR(55), IN `_Contact` VARCHAR(255), IN `_userID` VARCHAR(50), IN `_ID` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Updated next of kIN with name: ', _KinName );
UPDATE nextofkin
SET IDNumber = _IDNumber,
    KinName = _KinName,
    KRelationship = _Relationship,
    CurrentResident = _CurrentResident,
    Contact = _Contact
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateParent` (IN `_IDNumber` VARCHAR(128), IN `_Name` VARCHAR(25), IN `_ParentID` VARCHAR(55), IN `_Relationship` VARCHAR(128), IN `_userID` VARCHAR(50), IN `_ID` INT)  NO SQL
BEGIN
UPDATE parents
SET IDNumber = _IDNumber,
    Name = _Name,
    ParentID = ParentID,
    Relationship = _Relationship
WHERE ID = _ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdatePassport` (IN `_Number` INT, IN `_POD` DATETIME, IN `_Tracking_Number` VARCHAR(25), IN `_Status` VARCHAR(55), IN `_DOC` DATETIME, IN `_PassPortNumber` VARCHAR(128), IN `_Option` VARCHAR(255), IN `_Cost` VARCHAR(55), IN `_CostIncurred` VARCHAR(255), IN `_Location` VARCHAR(55), IN `_userID` VARCHAR(50), IN `_ID` INT)  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Update  Passport:',_Number);
UPDATE passport
SET Number = _Number,
    POD = _POD,
    Tracking_Number = _Tracking_Number,
    Status = _status,
    Passport_Collection_Date = _DOC,
    PassPortNumber = _PassPortNumber,
    PassportOption = _Option,
    Cost = _Cost,
    CostIncurred = _CostIncurred,
    Location = _Location,
    Updated_at = NOW(),
    UpdatedBy = _userID
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Updatepassword` (IN `_Password` VARCHAR(128), IN `_Username` VARCHAR(50))  BEGIN
UPDATE users
SET `Password` = _Password
WHERE Username = _Username;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateProfile` (IN `_Name` VARCHAR(120), IN `_Email` VARCHAR(128), IN `_phone` VARCHAR(20), IN `_Photo` VARCHAR(100), IN `_username` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Updated  User with username: ',_username );

UPDATE `users`
SET `Name` = _Name,
    `Email` = _Email,
    `Phone` = _Phone,
    `Update_at` = NOW(),
    UpdatedBy = _username,
    Photo = _Photo
WHERE `Username` = _username;
CALL SaveAuditTrail(_username, lSaleDesc, 'Update', '0');

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateProfilePhoto` (IN `_Photo` VARCHAR(100), IN `_username` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Changed User Photo for user: ',_username );

UPDATE `users`
SET Photo = _Photo
WHERE `Username` = _username;
CALL SaveAuditTrail(_username, lSaleDesc, 'Update', '0');

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateRegistration` (IN `_IDNumber` INT(11), IN `_Fullname` VARCHAR(150), IN `_Gender` VARCHAR(255), IN `_Phone` VARCHAR(128), IN `_DOB` DATETIME, IN `_Email` VARCHAR(20), IN `_Country` VARCHAR(150), IN `_Passport` VARCHAR(50), IN `_Religion` VARCHAR(100), IN `_Marital` VARCHAR(255), IN `_Height` VARCHAR(50), IN `_Weight` VARCHAR(50), IN `_Languages` VARCHAR(255), IN `_Skills` VARCHAR(255), IN `_UserID` VARCHAR(55))  NO SQL
    SQL SECURITY INVOKER
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Update with Applicant:',_IDNumber);
UPDATE `Registration`
SET `Fullname` = _Fullname,
    Gender = _Gender,
    Phone = _Phone,
    DOB = _DOB,
    `Email` = _Email,
    `Country` = _Country,
    Passport = _Passport,
    `Religion` = _Religion,
    Marital = _Marital,
    Height = _Height,
    Weight = _Weight,
    Languages = _Languages,
    Skills = _Skills,
    Updated_at = NOW(),
    Updated_by = _UserID
WHERE `IDNumber` = _IDNumber;
CALL SaveAuditTrail(_UserID, lSaleDesc, 'Update', '0');


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateRoles` (IN `_RoleName` VARCHAR(128), IN `__RoleDescription` VARCHAR(128), IN `_RoleID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Updated Role with iD: ', _RoleID ,'and name:' ,_RoleName);
UPDATE roles
SET RoleName = _RoleName,
    RoleDescription = __RoleDescription,
    UpdatedAt = NOW(),
    UpdateBy = _userID
WHERE RoleID = _RoleID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateSiblings` (IN `_IDNumber` VARCHAR(128), IN `_Name` VARCHAR(25), IN `_Sex` VARCHAR(128), IN `_Age` VARCHAR(55), IN `_userID` VARCHAR(50), IN `_ID` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Updated next of kIN with name: ', _Name );
UPDATE siblings
SET IDNumber = _IDNumber,
    SiblingName = _Name,
    Sex = _Sex,
    Age = _Age
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateTicketing` (IN `_Number` INT, IN `_Status` VARCHAR(255), IN `_Flight_date` DATETIME, IN `_Destination` VARCHAR(55), IN `_Airline` VARCHAR(55), IN `_Cost` VARCHAR(55), IN `_userID` INT, IN `_ID` INT)  BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Update Ticketing:',_Number);
UPDATE ticketing
SET Number = _Number,
    Ticket_status = _Status,
    Flight_Date = _Flight_date,
    Destination = _Destination,
    Airline = _Airline,
    Cost = _Cost,
    Updated_at = NOW(),
    UpdatedBy = _userID
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateTraining` (IN `_Number` VARCHAR(128), IN `_COM` DATETIME, IN `_EOM` DATETIME, IN `_Training_status` VARCHAR(55), IN `_Transcript_status` VARCHAR(255), IN `_DOF` DATETIME, IN `_Cost` VARCHAR(255), IN `_userID` VARCHAR(255), IN `_ID` VARCHAR(255))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Update new training:',_Number);
UPDATE training
SET Number = _Number,
    COM = _COM,
    EOM = _EOM,
    Training_status = _Training_status,
    Transcript_status = _Transcript_status,
    DOF = _DOF,
    Cost = _Cost,
    Updated_at = NOW(),
    UpdatedBy = _userID
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Updatetravelling` (IN `_Number` INT, IN `_DOT` DATETIME, IN `_Status` VARCHAR(25), IN `_Cost` VARCHAR(25), IN `_userID` VARCHAR(255), IN `_ID` VARCHAR(255))  BEGIN

UPDATE travelling
SET Number = _Number,
    DOT = _DOT,
    Status = _Status,
    Cost = _Cost,
    Update_at = NOW(),
    UpdateBy = _userID
WHERE ID = _ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUser` (IN `_Name` VARCHAR(128), IN `_Email` VARCHAR(128), IN `_UserGroup` BIGINT, IN `_username` VARCHAR(50), IN `_IsActive` BOOLEAN, IN `_userID` VARCHAR(50), IN `_Phone` VARCHAR(20), IN `_Signature` VARCHAR(128), IN `_IDnumber` INT, IN `_DOB` DATETIME, IN `_Gender` VARCHAR(50), IN `_Board` BOOLEAN)  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Updated  User with username: ',_username );

UPDATE `users`
SET `Name` = _Name,
    `Email` = _Email,
    Board = _Board,
    `Phone` = _Phone,
    `Update_at` = NOW(),
    `IsActive` = _IsActive,
    `UserGroupID` = _UserGroup,
    UpdatedBy = _userID,
    Signature = _Signature,
    IDnumber = _IDnumber,
    Gender = _Gender,
    DOB = _DOB
WHERE `Username` = _username;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUserAccess` (IN `_Username` VARCHAR(50), IN `_RoleID` BIGINT, IN `_Desc` VARCHAR(50), IN `_Status` BOOLEAN, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
		DECLARE lSaleDesc varchar(200);
		if( SELECT
    COUNT(*)
  FROM useraccess
  WHERE Username = _Username
  AND RoleID = _RoleID) > 0 THEN

		BEGIN
			set lSaleDesc= CONCAT('Updated  user access of role for user: ', _Username );
 

			if(_Desc ='Create')THEN
			Begin
UPDATE useraccess
SET AddNew = _Status,
    UpdateBy = _userID,
    UpdatedAt = NOW()
WHERE Username = _Username
AND RoleID = _RoleID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');

END;
END IF;
			if(_Desc='View')THEN
			Begin
UPDATE useraccess
SET View = _Status,
    UpdateBy = _userID,
    UpdatedAt = NOW()
WHERE Username = _Username
AND RoleID = _RoleID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END;
END IF;
			if(_Desc='Delete')THEN
			Begin
UPDATE useraccess
SET Remove = _Status,
    UpdateBy = _userID,
    UpdatedAt = NOW()
WHERE Username = _Username
AND RoleID = _RoleID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END;
END IF;
			if(_Desc='Update')THEN
			Begin
UPDATE useraccess
SET Edit = _Status,
    UpdateBy = _userID,
    UpdatedAt = NOW()
WHERE Username = _Username
AND RoleID = _RoleID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END;
END IF;
			if(_Desc='Export')THEN
			Begin
UPDATE useraccess
SET Export = _Status,
    UpdateBy = _userID,
    UpdatedAt = NOW()
WHERE Username = _Username
AND RoleID = _RoleID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END;
END IF;
END;
ELSE
		BEGIN
			set lSaleDesc= CONCAT('Updated  user access of role for user: ', _Username );
 

			if(_Desc ='Create')THEN
			Begin
INSERT INTO useraccess (Username, RoleID, Edit, Remove, AddNew, View, Export, UpdateBy, CreateBy, CreatedAt, UpdatedAt)
  VALUES (_Username, _RoleID, FALSE, FALSE, _Status, FALSE, FALSE, _userID, _userID, NOW(), NOW());

CALL SaveAuditTrail(_userID, lSaleDesc, 'Create', '0');


END;
END IF;
			if(_Desc='View')THEN
				Begin
INSERT INTO useraccess (Username, RoleID, Edit, Remove, AddNew, View, Export, UpdateBy, CreateBy, CreatedAt, UpdatedAt)
  VALUES (_Username, _RoleID, FALSE, FALSE, FALSE, _Status, FALSE, _userID, _userID, NOW(), NOW());

CALL SaveAuditTrail(_userID, lSaleDesc, 'Create', '0');
END;
END IF;
			if(_Desc='Delete')THEN
			Begin
INSERT INTO useraccess (Username, RoleID, Edit, Remove, AddNew, View, Export, UpdateBy, CreateBy, CreatedAt, UpdatedAt)
  VALUES (_Username, _RoleID, FALSE, _Status, FALSE, FALSE, FALSE, _userID, _userID, NOW(), NOW());

CALL SaveAuditTrail(_userID, lSaleDesc, 'Create', '0');
END;
END IF;
			if(_Desc='Update')THEN
			Begin
INSERT INTO useraccess (Username, RoleID, Edit, Remove, AddNew, View, Export, UpdateBy, CreateBy, CreatedAt, UpdatedAt)
  VALUES (_Username, _RoleID, _Status, FALSE, FALSE, FALSE, FALSE, _userID, _userID, NOW(), NOW());

CALL SaveAuditTrail(_userID, lSaleDesc, 'Create', '0');
END;
END IF;
			if(_Desc='Export')THEN
			Begin
INSERT INTO useraccess (Username, RoleID, Edit, Remove, AddNew, View, Export, UpdateBy, CreateBy, CreatedAt, UpdatedAt)
  VALUES (_Username, _RoleID, FALSE, FALSE, FALSE, FALSE, _Status, _userID, _userID, NOW(), NOW());

CALL SaveAuditTrail(_userID, lSaleDesc, 'Create', '0');
END;
END IF;
END;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUserGroup` (IN `_Name` VARCHAR(128), IN `_Description` VARCHAR(128), IN `_UserGroupID` BIGINT, IN `_userID` VARCHAR(50))  NO SQL
BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Updated UserGroup with iD: ',_UserGroupID);

UPDATE usergroups
SET Name = _Name,
    Description = _Description,
    UpdatedAt = NOW(),
    UpdatedBy = _userID
WHERE UserGroupID = _UserGroupID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'Update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updatevisa` (IN `_Number` INT, IN `_VAD` DATETIME, IN `_VID` DATETIME, IN `_Status` VARCHAR(25), IN `_Cost` VARCHAR(25), IN `_userID` VARCHAR(255), IN `_ID` VARCHAR(255))  BEGIN
DECLARE lSaleDesc varchar(200);
set lSaleDesc= CONCAT('Update new training:',_Number);
UPDATE visa
SET Number = _Number,
    VAD = _VAD,
    VID = _VID,
    Status = _Status,
    Cost = _Cost,
    Updated_at = NOW(),
    UpdatedBy = _userID
WHERE ID = _ID;
CALL SaveAuditTrail(_userID, lSaleDesc, 'update', '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `visaRedAlerts` ()  BEGIN
SELECT
  COUNT(*) AS visaRedAlerts
FROM visa
WHERE SUBDATE(NOW(), INTERVAL 6 DAY)
AND Deleted = 0
AND Status = 'pending';
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `agency`
--

CREATE TABLE `agency` (
  `ID` int(11) DEFAULT NULL,
  `Name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LicenseNo` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `County` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Createdby` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updateby` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `applicationapprovalcontacts`
--

CREATE TABLE `applicationapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `applicationapprovalcontacts`
--

INSERT INTO `applicationapprovalcontacts` (`Name`, `Email`, `Mobile`, `Msg`, `IDNumber`) VALUES
('kelvin chemey', 'kelvinchemey@gmail.com', '+254700392599', 'Applicant', '30486756'),
('Kelvin Chemey', 'kelvinchemey@gmail.c', '25700392599', 'Applicant', '30486756');

-- --------------------------------------------------------

--
-- Table structure for table `applicationsequence`
--

CREATE TABLE `applicationsequence` (
  `ID` int(11) NOT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `Action` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ExpectedAction` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `User` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `applicationsequence`
--

INSERT INTO `applicationsequence` (`ID`, `IDNumber`, `Date`, `Action`, `Status`, `ExpectedAction`, `User`) VALUES
(1, '30487656', '2020-05-11 19:59:10', 'Registration Approved', 'Done', 'Awaiting DCI', 'Admin'),
(2, '35733158', '2020-05-12 11:58:48', 'Registration Approved', 'Done', 'Awaiting DCI', 'Admin'),
(3, '30487656', '2020-05-12 20:33:15', 'Minor Medical Approved', 'Done', 'Awaiting DCI', 'Admin'),
(4, '35733158', '2020-05-12 22:07:35', 'Minor Medical Approved', 'Done', 'Awaiting DCI', 'Admin'),
(5, '30487656', '2020-05-14 13:17:24', 'DCI Approval', 'Done', 'Awaiting Passport Processing', 'Admin'),
(6, '30487656', '2020-05-14 13:21:37', 'Passport Approval', 'Done', 'Awaiting Major Medical', 'Admin'),
(7, '30487656', '2020-05-14 13:33:45', 'Major Medical Approval', 'Done', 'Awaiting COntract Processing', 'Admin'),
(8, '30476567', '2020-05-14 17:18:31', 'Registration Approved', 'Done', 'Awaiting Minor Medical', 'Admin'),
(9, '30476567', '2020-05-15 09:23:06', 'Minor Medical Approved', 'Done', 'Awaiting DCI', 'Admin'),
(10, '715760571', '2020-05-15 09:24:12', 'DCI Approval', 'Done', 'Awaiting Passport Processing', 'Admin'),
(11, '715760571', '2020-05-15 09:24:53', 'Passport Approval', 'Done', 'Awaiting Major Medical', 'Admin'),
(12, '715760571', '2020-05-15 09:25:28', 'Registration Approved', 'Done', 'Awaiting Minor Medical', 'Admin'),
(13, '715760571', '2020-05-15 09:26:44', 'Major Medical Approval', 'Done', 'Awaiting COntract Processing', 'Admin'),
(14, '30476567', '2020-05-15 09:26:53', 'Major Medical Approval', 'Done', 'Awaiting COntract Processing', 'Admin'),
(15, '715760571', '2020-05-15 09:35:09', 'Minor Medical Approved', 'Done', 'Awaiting DCI', 'Admin'),
(16, '30476567', '2020-05-15 09:38:12', 'DCI Approval', 'Done', 'Awaiting Passport Processing', 'Admin'),
(17, '2147483647', '2020-05-15 10:19:12', 'Registration Approved', 'Done', 'Awaiting Minor Medical', 'Admin'),
(18, '2147483647', '2020-05-15 10:26:20', 'Minor Medical Approved', 'Done', 'Awaiting DCI', 'Admin'),
(19, '2147483647', '2020-05-15 10:27:53', 'DCI Approval', 'Done', 'Awaiting Passport Processing', 'Admin'),
(20, '459697979', '2020-05-15 10:29:37', 'Registration Approved', 'Done', 'Awaiting Minor Medical', 'Admin'),
(21, '30595696', '2020-05-15 10:59:12', 'Registration Approved', 'Done', 'Awaiting Minor Medical', 'Admin'),
(22, '30487656', '2020-05-17 11:57:38', 'Medical Form Generate', 'Done', 'Medical', 'Admin'),
(23, '30476567', '2020-05-17 15:19:39', 'Medical Form Generate', 'Done', 'Medical', 'Admin'),
(24, '30564567', '2020-05-18 20:36:03', 'Registration Approved', 'Done', 'Awaiting Minor Medical', 'Admin'),
(25, '4567894', '2020-05-19 11:05:36', 'Registration Approved', 'Done', 'Awaiting Minor Medical', 'Admin'),
(26, '30487656', '2020-05-22 11:49:56', 'Contract Processing Approval', 'Done', 'Awaiting NEA', 'Admin'),
(27, '30487656', '2020-05-22 12:03:24', 'Visa Approval', 'Done', 'Awaiting NEA', 'Admin'),
(28, '30487656', '2020-05-22 13:17:10', 'Final Medical Approval', 'Done', 'Awaiting COntract Processing', 'Admin'),
(29, '30487656', '2020-05-22 15:10:23', 'Training Approval', 'Done', 'Awaiting NEA', 'Admin'),
(30, '30487656', '2020-05-22 21:19:36', 'Ticketing Approval', 'Done', 'Awaiting NEA', 'Admin'),
(31, '30487656', '2020-05-22 22:05:32', 'Travelling Approval', 'Done', 'Awaiting NEA', 'Admin'),
(32, '34567858', '2020-05-25 08:43:33', 'Registration Approved', 'Done', 'Awaiting Minor Medical', 'Admin'),
(33, '33487656', '2020-05-25 09:31:46', 'Registration Approved', 'Done', 'Awaiting Minor Medical', 'Admin'),
(34, '3546786', '2020-05-26 12:38:23', 'Registration Approved', 'Done', 'Awaiting Minor Medical', 'Admin'),
(35, '30487656', '2020-05-27 09:11:47', 'NEA Approval', 'Done', 'Awaiting NEA', 'Admin'),
(36, '30487656', '2020-05-27 10:20:07', 'Attestation Approval', 'Done', 'Awaiting NEA', 'Admin'),
(37, '30486756', '2020-06-08 15:44:17', 'Registration Approved', 'Done', 'Awaiting Minor Medical', 'Admin');

-- --------------------------------------------------------

--
-- Table structure for table `applications_approval_workflow`
--

CREATE TABLE `applications_approval_workflow` (
  `ID` bigint(20) NOT NULL,
  `IDNumber` bigint(20) NOT NULL,
  `Fullname` bigint(20) NOT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `applications_approval_workflow`
--

INSERT INTO `applications_approval_workflow` (`ID`, `IDNumber`, `Fullname`, `Status`, `Approver`, `Remarks`, `Created_By`, `Approved_At`, `Created_At`) VALUES
(1, 30487656, 0, 'Approved', 'Admin', 'nnn', 'Admin', '2020-05-26 14:03:29', '2020-05-26 14:03:29'),
(2, 30486756, 0, 'Approved', 'Admin', 'welcome', 'Admin', '2020-06-08 15:44:16', '2020-06-08 15:44:16');

-- --------------------------------------------------------

--
-- Table structure for table `approvalmodules`
--

CREATE TABLE `approvalmodules` (
  `ID` int(5) NOT NULL,
  `ModuleCode` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Create_at` datetime NOT NULL,
  `Update_at` datetime DEFAULT NULL,
  `Deleted` tinyint(1) NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `UpdatedBy` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MaxApprovals` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB AVG_ROW_LENGTH=2730 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `approvalmodules`
--

INSERT INTO `approvalmodules` (`ID`, `ModuleCode`, `Name`, `Create_at`, `Update_at`, `Deleted`, `CreatedBy`, `UpdatedBy`, `Category`, `MaxApprovals`) VALUES
(1, 'REG', 'Applications Approval', '2019-08-21 17:58:50', NULL, 0, '', NULL, 'Hr Pool', 1),
(2, 'MNR', 'Minor Medical Approval', '2019-08-21 17:58:50', NULL, 0, '', NULL, 'Medical', 1),
(3, 'DCI', 'DCI Approval', '2019-08-21 17:58:50', NULL, 0, '', NULL, 'Extenal Services', 1),
(4, 'PST', 'Passport Approval', '2019-08-21 17:58:50', NULL, 0, '', NULL, 'Extenal Services', 1),
(5, 'MJR', 'Major Medical Approval', '2019-08-21 17:58:50', NULL, 0, '', NULL, 'Medical', 1),
(6, 'CNT', 'Contract Processing Approval', '2019-08-21 17:58:50', NULL, 0, '', NULL, 'Employment Request', 1),
(7, 'ATN', 'Attestation Approval', '2019-08-21 17:58:50', NULL, 0, '', NULL, 'Employment Request', 1),
(8, 'TKN', 'Ticketing Approval', '2019-08-21 17:58:50', NULL, 0, '', NULL, 'Others', 1),
(9, 'VSA', 'Visa Approval', '2019-08-21 17:58:50', NULL, 0, '', NULL, 'Extenal Services', 1),
(10, 'FNL', 'Final Medical Approval ', '2019-08-21 17:58:50', NULL, 0, '', NULL, 'Medical', 1),
(11, 'TRG', 'Training Approval', '2019-08-21 17:58:50', NULL, 0, '', NULL, 'Others', 1),
(12, 'TVG', 'Travelling Approval', '2019-08-21 17:58:50', NULL, 0, '', NULL, 'Others', 1),
(13, 'NEA', 'NEA Approval', '2019-08-21 17:58:50', NULL, 0, '', NULL, 'Employment Request', 1);

-- --------------------------------------------------------

--
-- Table structure for table `approvers`
--

CREATE TABLE `approvers` (
  `ID` int(5) NOT NULL,
  `Username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ModuleCode` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Mandatory` tinyint(1) NOT NULL DEFAULT 0,
  `Active` tinyint(1) DEFAULT NULL,
  `Create_at` datetime NOT NULL,
  `Update_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `UpdatedBy` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `DeletedBY` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted_At` datetime(6) DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=682 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `approvers`
--

INSERT INTO `approvers` (`ID`, `Username`, `ModuleCode`, `Mandatory`, `Active`, `Create_at`, `Update_at`, `CreatedBy`, `UpdatedBy`, `Deleted`, `DeletedBY`, `Deleted_At`) VALUES
(1, 'Admin', 'REG', 0, 1, '2020-05-08 11:57:01', NULL, 'Admin', 'Admin', 0, NULL, NULL),
(2, 'Admin', 'MNR', 0, 1, '2020-05-12 20:31:37', NULL, 'Admin', 'Admin', 0, NULL, NULL),
(3, 'kavethe', 'MNR', 0, 1, '2020-05-12 20:31:44', NULL, 'Admin', NULL, 0, NULL, NULL),
(4, 'Admin', 'DCI', 0, 1, '2020-05-14 13:16:42', NULL, 'Admin', NULL, 0, NULL, NULL),
(5, 'Admin', 'PST', 0, 1, '2020-05-14 13:20:59', NULL, 'Admin', 'Admin', 0, NULL, NULL),
(6, 'Admin', 'MJR', 0, 1, '2020-05-14 13:23:31', NULL, 'Admin', NULL, 0, NULL, NULL),
(7, 'Admin', 'VSA', 0, 1, '2020-05-16 09:44:39', NULL, 'Admin', NULL, 0, NULL, NULL),
(8, 'Admin', 'CNT', 0, 1, '2020-05-16 09:45:07', NULL, 'Admin', NULL, 0, NULL, NULL),
(9, 'Admin', 'FNL', 0, 1, '2020-05-22 13:07:26', NULL, 'Admin', NULL, 0, NULL, NULL),
(10, 'Admin', 'TRG', 0, 1, '2020-05-22 15:09:47', NULL, 'Admin', NULL, 0, NULL, NULL),
(11, 'Admin', 'TKN', 0, 1, '2020-05-22 21:16:42', NULL, 'Admin', NULL, 0, NULL, NULL),
(12, 'cheruiyot', 'ATN', 0, 0, '2020-05-26 11:43:47', NULL, 'Admin', 'Admin', 0, NULL, NULL),
(13, 'Admin', 'ATN', 0, 1, '2020-05-26 11:43:51', NULL, 'Admin', NULL, 0, NULL, NULL),
(14, 'Admin', 'NEA', 0, 1, '2020-05-26 11:44:08', NULL, 'Admin', NULL, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `attestation`
--

CREATE TABLE `attestation` (
  `ID` int(11) NOT NULL,
  `Number` int(11) DEFAULT NULL,
  `DOS` datetime DEFAULT NULL,
  `Clearance_status` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Clearance_Date` datetime DEFAULT NULL,
  `Cost` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL,
  `UpdatedBy` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Approve_at` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attestation`
--

INSERT INTO `attestation` (`ID`, `Number`, `DOS`, `Clearance_status`, `Clearance_Date`, `Cost`, `Status`, `Created_at`, `CreatedBy`, `Updated_at`, `UpdatedBy`, `Deleted`, `Approve_at`) VALUES
(2, 30487656, '2020-05-27 00:00:00', 'Cleared', '2020-05-27 00:00:00', '0', 'Approved', '2020-05-27 10:06:45', '0', '0000-00-00 00:00:00', '0', 0, '2020-05-27 10:20:07');

-- --------------------------------------------------------

--
-- Table structure for table `attestationapprovalcontacts`
--

CREATE TABLE `attestationapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attestationapprovalcontacts`
--

INSERT INTO `attestationapprovalcontacts` (`Name`, `Email`, `Mobile`, `Msg`, `IDNumber`) VALUES
('Kelvin Chemey', 'kserem20@gmail.com', '+254753710324', 'Applicant', '30487656');

-- --------------------------------------------------------

--
-- Table structure for table `attestation_approval_workflow`
--

CREATE TABLE `attestation_approval_workflow` (
  `ID` bigint(20) NOT NULL,
  `Number` bigint(20) NOT NULL,
  `Fullname` bigint(20) NOT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attestation_approval_workflow`
--

INSERT INTO `attestation_approval_workflow` (`ID`, `Number`, `Fullname`, `Status`, `Approver`, `Remarks`, `Created_By`, `Approved_At`, `Created_At`) VALUES
(1, 30487656, 0, 'Approved', 'Admin', 'kelvin', 'Admin', '2020-05-27 10:20:07', '2020-05-27 10:20:07');

-- --------------------------------------------------------

--
-- Table structure for table `audittrails`
--

CREATE TABLE `audittrails` (
  `AuditID` bigint(20) NOT NULL,
  `Date` datetime NOT NULL,
  `Username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Description` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Category` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `IpAddress` bigint(20) NOT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audittrails`
--

INSERT INTO `audittrails` (`AuditID`, `Date`, `Username`, `Description`, `Category`, `IpAddress`) VALUES
(1, '2020-05-07 15:32:26', 'kelivin', 'Added new Applicant:505050550', 'Add', 0),
(2, '2020-05-07 15:48:23', 'kelivin', 'Added new Applicant:78990988', 'Add', 0),
(3, '2020-05-07 15:48:47', 'Admin', 'Added new Document for application: 78990988', 'Add', 0),
(4, '2020-05-08 10:15:17', 'Admin', 'Changed User Photo for user: Admin', 'Update', 0),
(5, '2020-05-08 10:15:24', 'Admin', 'Updated  User with username: Admin', 'Update', 0),
(6, '2020-05-08 11:14:31', 'Admin', 'Added new User with username:giioip', 'Add', 0),
(7, '2020-05-08 11:35:52', '788', 'Added new Applicant:30487656', 'Add', 0),
(8, '2020-05-08 11:41:18', 'Admin', 'Added new Applicant:60707', 'Add', 0),
(9, '2020-05-08 11:43:00', 'Admin', 'Added new Applicant:60707', 'Add', 0),
(10, '2020-05-08 11:51:45', 'Admin', 'Added new Applicant:33765648', 'Add', 0),
(11, '2020-05-08 11:57:02', 'Admin', '0', 'Add', 0),
(12, '2020-05-08 11:57:02', 'Admin', '0', 'Add', 0),
(13, '2020-05-08 11:57:04', 'Admin', 'Updated Maximum Approvals for ModuleREG', 'Add', 0),
(14, '2020-05-11 08:48:50', 'Admin', 'Added new Applicant:34487656', 'Add', 0),
(15, '2020-05-11 08:49:03', 'Admin', 'Added new User with username:University og nairobi ', 'Add', 0),
(16, '2020-05-11 08:49:13', 'Admin', 'Added new User with username:john tenai', 'Add', 0),
(17, '2020-05-11 08:49:29', 'Admin', 'Added new Next of kin  with name:john tenai', 'Add', 0),
(18, '2020-05-11 08:50:01', 'Admin', 'Added new Siblings name:mary', 'Add', 0),
(19, '2020-05-11 08:50:30', 'Admin', 'Added new Document for application: 34487656', 'Add', 0),
(20, '2020-05-11 08:50:35', 'Admin', 'Added new Document for application: 34487656', 'Add', 0),
(21, '2020-05-11 09:50:48', 'Admin', 'Approved Application: 34487656', 'Approval', 0),
(22, '2020-05-11 11:11:49', 'Admin', 'Approved Application: 34487656', 'Approval', 0),
(23, '2020-05-11 11:16:54', 'Admin', 'Added new Applicant:45678909', 'Add', 0),
(24, '2020-05-11 11:17:21', 'Admin', 'Approved Application: 45678909', 'Approval', 0),
(25, '2020-05-11 11:34:09', 'Admin', 'Approved Application: 34487656', 'Approval', 0),
(26, '2020-05-11 11:36:08', 'Admin', 'Approved Application: 45678909', 'Approval', 0),
(27, '2020-05-11 12:03:29', 'Admin', 'Added new Applicant:30487656', 'Add', 0),
(28, '2020-05-11 12:52:03', 'Admin', ' Declined Application: 30487656', 'Approval', 0),
(29, '2020-05-11 12:59:09', 'Admin', ' Declined Application: 33765648', 'Approval', 0),
(30, '2020-05-11 13:07:16', 'Admin', ' Declined Application: 30487656', 'Approval', 0),
(31, '2020-05-11 13:08:21', 'Admin', ' Declined Application: 33765648', 'Approval', 0),
(32, '2020-05-11 13:08:58', 'Admin', ' Declined Application: 34487656', 'Approval', 0),
(33, '2020-05-11 13:09:51', 'Admin', ' Declined Application: 45678909', 'Approval', 0),
(34, '2020-05-11 19:58:12', 'Admin', 'Added new Applicant:30487656', 'Add', 0),
(35, '2020-05-11 19:58:24', 'Admin', 'Added new User with username:University og nairobi ', 'Add', 0),
(36, '2020-05-11 19:58:35', 'Admin', 'Added new User with username:john tenai', 'Add', 0),
(37, '2020-05-11 19:59:10', 'Admin', 'Approved Application: 30487656', 'Approval', 0),
(38, '2020-05-12 09:37:03', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(39, '2020-05-12 09:38:17', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(40, '2020-05-12 09:38:29', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(41, '2020-05-12 09:38:53', 'Admin', 'Updated Role with iD: 4and name:Assign Group Access', 'Update', 0),
(42, '2020-05-12 10:09:18', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(43, '2020-05-12 10:17:37', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(44, '2020-05-12 10:17:45', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(45, '2020-05-12 10:19:59', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(46, '2020-05-12 10:20:15', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(47, '2020-05-12 10:22:15', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(48, '2020-05-12 10:26:53', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(49, '2020-05-12 10:27:02', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(50, '2020-05-12 10:27:07', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(51, '2020-05-12 10:28:45', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(52, '2020-05-12 10:29:32', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(53, '2020-05-12 10:29:46', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(54, '2020-05-12 10:29:56', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(55, '2020-05-12 10:30:11', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(56, '2020-05-12 10:30:20', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(57, '2020-05-12 10:30:29', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(58, '2020-05-12 10:30:38', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(59, '2020-05-12 11:57:15', 'Admin', 'Added new Applicant:35733158', 'Add', 0),
(60, '2020-05-12 13:00:29', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(61, '2020-05-12 13:04:16', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(62, '2020-05-12 13:23:55', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(63, '2020-05-12 13:24:04', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(64, '2020-05-12 13:24:12', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(65, '2020-05-12 13:24:19', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(66, '2020-05-12 18:27:07', 'kavethe', 'Changed User Photo for user: kavethe', 'Update', 0),
(67, '2020-05-12 18:27:11', 'kavethe', 'Updated  User with username: kavethe', 'Update', 0),
(68, '2020-05-12 19:59:49', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(69, '2020-05-12 20:03:59', 'Admin', 'Approved Minor Medical : 30487656', 'Approval', 0),
(70, '2020-05-12 20:07:11', 'Admin', 'Approved Minor Medical : 30487656', 'Approval', 0),
(71, '2020-05-12 20:07:31', 'Admin', 'Approved Minor Medical : 30487656', 'Approval', 0),
(72, '2020-05-12 20:07:57', 'Admin', 'Approved Minor Medical : 30487656', 'Approval', 0),
(73, '2020-05-12 20:08:59', 'Admin', 'Approved Minor Medical : 30487656', 'Approval', 0),
(74, '2020-05-12 20:31:38', 'Admin', '0', 'Add', 0),
(75, '2020-05-12 20:31:39', 'Admin', '0', 'Add', 0),
(76, '2020-05-12 20:31:42', 'Admin', '0', 'Add', 0),
(77, '2020-05-12 20:31:44', 'Admin', '0', 'Add', 0),
(78, '2020-05-12 20:31:46', 'Admin', 'Updated Maximum Approvals for ModuleMNR', 'Add', 0),
(79, '2020-05-12 20:33:15', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(80, '2020-05-12 21:02:00', 'Admin', 'Added new Minor medical:35733158', 'Add', 0),
(81, '2020-05-12 22:07:35', 'Admin', 'Approved Registration: 35733158', 'Approval', 0),
(82, '2020-05-13 09:00:56', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(83, '2020-05-13 09:03:34', 'Admin', 'Approved Registration: 35733158', 'Approval', 0),
(84, '2020-05-13 09:11:00', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(85, '2020-05-13 09:11:22', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(86, '2020-05-13 09:33:45', 'Admin', 'Added new Minor medical:35733158', 'Add', 0),
(87, '2020-05-13 09:34:01', 'Admin', 'Approved Registration: 35733158', 'Approval', 0),
(88, '2020-05-13 09:50:10', 'Admin', 'Added new Applicant:30487656', 'Add', 0),
(89, '2020-05-13 09:50:43', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(90, '2020-05-13 09:53:29', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(91, '2020-05-13 09:53:48', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(92, '2020-05-13 10:28:57', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(93, '2020-05-13 10:29:59', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(94, '2020-05-13 11:06:44', 'Admin', 'Added new DCI Clearance:30487656', 'Add', 0),
(95, '2020-05-13 11:14:35', 'Admin', 'Deleted DCI Clearance  with ID: 9', 'Delete', 0),
(96, '2020-05-13 11:15:41', 'Admin', 'Added new DCI Clearance:30487656', 'Add', 0),
(97, '2020-05-13 11:18:14', '34', 'Update new DCI Clearance:30487656', 'update', 0),
(98, '2020-05-13 11:18:35', '34', 'Update new DCI Clearance:30487656', 'update', 0),
(99, '2020-05-13 11:18:43', '34', 'Update new DCI Clearance:30487656', 'update', 0),
(100, '2020-05-13 11:21:46', '34', 'Update new DCI Clearance:30487656', 'update', 0),
(101, '2020-05-13 11:21:58', '34', 'Update new DCI Clearance:30487656', 'update', 0),
(102, '2020-05-13 11:22:20', '34', 'Update new DCI Clearance:30487656', 'update', 0),
(103, '2020-05-13 11:25:17', '34', 'Update new DCI Clearance:30487656', 'update', 0),
(104, '2020-05-13 11:25:32', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(105, '2020-05-13 11:25:45', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(106, '2020-05-13 11:29:03', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(107, '2020-05-13 11:29:17', '34', 'Update new DCI Clearance:30487656', 'update', 0),
(108, '2020-05-13 11:33:12', '34', 'Update new DCI Clearance:30487656', 'update', 0),
(109, '2020-05-13 14:30:56', '34', 'Update new DCI Clearance:30487656', 'update', 0),
(110, '2020-05-13 14:36:21', 'Admin', 'Added passport processing:30487656', 'Add', 0),
(111, '2020-05-13 14:36:38', 'Admin', 'Update  Passport:30487656', 'update', 0),
(112, '2020-05-13 14:36:46', 'Admin', 'Update  Passport:30487656', 'update', 0),
(113, '2020-05-13 14:58:10', 'Admin', 'Added new training  with name:30487656', 'Add', 0),
(114, '2020-05-13 14:58:19', 'Admin', 'Update new training:30487656', 'update', 0),
(115, '2020-05-13 14:58:27', 'Admin', 'Update new training:30487656', 'update', 0),
(116, '2020-05-13 14:59:40', 'Admin', 'Update new training:30487656', 'update', 0),
(117, '2020-05-13 14:59:46', 'Admin', 'Update new training:30487656', 'update', 0),
(118, '2020-05-13 15:05:11', 'Admin', 'Update new Minor medical:30487656', 'update', 0),
(119, '2020-05-13 15:21:02', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(120, '2020-05-13 15:21:30', 'Admin', 'Update  Passport:30487656', 'update', 0),
(121, '2020-05-13 15:21:30', 'Admin', 'Update  Passport:30487656', 'update', 0),
(122, '2020-05-13 15:22:55', 'Admin', 'Update  Passport:30487656', 'update', 0),
(123, '2020-05-13 15:23:33', 'Admin', 'Deleted minor medical  with ID: 5', 'Delete', 0),
(124, '2020-05-14 09:11:36', 'Admin', 'Updated  user access of role for user: paul', 'Create', 0),
(125, '2020-05-14 09:11:38', 'Admin', 'Updated  user access of role for user: paul', 'Update', 0),
(126, '2020-05-14 09:11:47', 'Admin', 'Updated  User with username: paul', 'Update', 0),
(127, '2020-05-14 09:12:18', 'Admin', 'Deleted User with Username: paul', 'Delete', 0),
(128, '2020-05-14 09:12:40', 'Admin', '64', 'Create', 0),
(129, '2020-05-14 09:12:41', 'Admin', '84', 'Update', 0),
(130, '2020-05-14 09:12:45', 'Admin', '64', 'Update', 0),
(131, '2020-05-14 09:12:46', 'Admin', '84', 'Update', 0),
(132, '2020-05-14 09:12:48', 'Admin', '84', 'Update', 0),
(133, '2020-05-14 09:12:48', 'Admin', '84', 'Update', 0),
(134, '2020-05-14 09:12:50', 'Admin', '84', 'Update', 0),
(135, '2020-05-14 09:12:50', 'Admin', '94', 'Update', 0),
(136, '2020-05-14 09:12:52', 'Admin', '94', 'Update', 0),
(137, '2020-05-14 09:12:52', 'Admin', '94', 'Update', 0),
(138, '2020-05-14 09:12:54', 'Admin', '94', 'Update', 0),
(139, '2020-05-14 09:12:57', 'Admin', '174', 'Create', 0),
(140, '2020-05-14 09:12:58', 'Admin', '174', 'Update', 0),
(141, '2020-05-14 09:12:59', 'Admin', '174', 'Update', 0),
(142, '2020-05-14 09:13:00', 'Admin', '174', 'Update', 0),
(143, '2020-05-14 09:13:01', 'Admin', '174', 'Update', 0),
(144, '2020-05-14 09:13:01', 'Admin', '274', 'Create', 0),
(145, '2020-05-14 09:13:02', 'Admin', '274', 'Update', 0),
(146, '2020-05-14 09:13:11', 'Admin', '464', 'Create', 0),
(147, '2020-05-14 09:13:11', 'Admin', '464', 'Update', 0),
(148, '2020-05-14 09:13:14', 'Admin', '464', 'Update', 0),
(149, '2020-05-14 09:13:14', 'Admin', '464', 'Update', 0),
(150, '2020-05-14 09:13:18', 'Admin', '454', 'Create', 0),
(151, '2020-05-14 09:13:20', 'Admin', '454', 'Update', 0),
(152, '2020-05-14 09:13:21', 'Admin', '454', 'Update', 0),
(153, '2020-05-14 09:13:21', 'Admin', '454', 'Update', 0),
(154, '2020-05-14 09:13:23', 'Admin', '454', 'Update', 0),
(155, '2020-05-14 09:13:31', 'Admin', '234', 'Create', 0),
(156, '2020-05-14 09:13:32', 'Admin', '254', 'Create', 0),
(157, '2020-05-14 09:13:33', 'Admin', '234', 'Update', 0),
(158, '2020-05-14 09:13:34', 'Admin', '254', 'Update', 0),
(159, '2020-05-14 09:13:35', 'Admin', '234', 'Update', 0),
(160, '2020-05-14 09:13:36', 'Admin', '254', 'Update', 0),
(161, '2020-05-14 09:13:37', 'Admin', '234', 'Update', 0),
(162, '2020-05-14 09:13:38', 'Admin', '254', 'Update', 0),
(163, '2020-05-14 09:13:38', 'Admin', '234', 'Update', 0),
(164, '2020-05-14 09:13:39', 'Admin', '254', 'Update', 0),
(165, '2020-05-14 09:13:47', 'Admin', '194', 'Create', 0),
(166, '2020-05-14 09:13:49', 'Admin', '244', 'Create', 0),
(167, '2020-05-14 09:13:49', 'Admin', '194', 'Update', 0),
(168, '2020-05-14 09:13:50', 'Admin', '244', 'Update', 0),
(169, '2020-05-14 09:13:50', 'Admin', '194', 'Update', 0),
(170, '2020-05-14 09:13:51', 'Admin', '244', 'Update', 0),
(171, '2020-05-14 09:13:53', 'Admin', '244', 'Update', 0),
(172, '2020-05-14 09:13:54', 'Admin', '194', 'Update', 0),
(173, '2020-05-14 09:13:54', 'Admin', '194', 'Update', 0),
(174, '2020-05-14 09:13:56', 'Admin', '244', 'Update', 0),
(175, '2020-05-14 09:14:05', 'Admin', 'Updated UserGroup with iD: 4', 'Update', 0),
(176, '2020-05-14 11:58:52', 'Admin', 'Added new DCI Clearance:30487656', 'Add', 0),
(177, '2020-05-14 11:59:24', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(178, '2020-05-14 11:59:55', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(179, '2020-05-14 12:00:29', 'Admin', 'Added passport processing:30487656', 'Add', 0),
(180, '2020-05-14 12:01:26', 'Admin', 'Approved Passport: 30487656', 'Approval', 0),
(181, '2020-05-14 12:02:02', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(182, '2020-05-14 12:03:02', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(183, '2020-05-14 13:16:44', 'Admin', '0', 'Add', 0),
(184, '2020-05-14 13:16:45', 'Admin', 'Updated Maximum Approvals for ModuleDCI', 'Add', 0),
(185, '2020-05-14 13:17:24', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(186, '2020-05-14 13:21:00', 'Admin', '0', 'Add', 0),
(187, '2020-05-14 13:21:01', 'Admin', 'Updated Maximum Approvals for ModulePST', 'Add', 0),
(188, '2020-05-14 13:21:02', 'Admin', '0', 'Add', 0),
(189, '2020-05-14 13:21:38', 'Admin', 'Approved Passport: 30487656', 'Approval', 0),
(190, '2020-05-14 13:23:31', 'Admin', '0', 'Add', 0),
(191, '2020-05-14 13:23:32', 'Admin', 'Updated Maximum Approvals for ModuleMJR', 'Add', 0),
(192, '2020-05-14 13:33:45', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(193, '2020-05-14 16:02:20', '', 'Update new DCI Clearance:30487656', 'update', 0),
(194, '2020-05-14 16:34:18', 'Admin', 'Added new Applicant:30476567', 'Add', 0),
(195, '2020-05-14 16:37:59', 'Admin', 'Added new Minor medical:30476567', 'Add', 0),
(196, '2020-05-14 17:18:32', 'Admin', 'Approved Registration: 30476567', 'Approval', 0),
(197, '2020-05-14 17:21:01', 'Admin', 'Added new Applicant:715760571', 'Add', 0),
(198, '2020-05-14 17:28:39', 'Admin', 'Added new DCI Clearance:715760571', 'Add', 0),
(199, '2020-05-14 17:32:29', 'Admin', 'Added passport processing:715760571', 'Add', 0),
(200, '2020-05-14 17:34:40', 'Admin', 'Added passport processing:30476567', 'Add', 0),
(201, '2020-05-14 17:35:28', 'Admin', 'Added new Minor medical:715760571', 'Add', 0),
(202, '2020-05-15 09:23:06', 'Admin', 'Approved Registration: 30476567', 'Approval', 0),
(203, '2020-05-15 09:24:13', 'Admin', 'Approved DCI: 715760571', 'Approval', 0),
(204, '2020-05-15 09:24:54', 'Admin', 'Approved Passport: 715760571', 'Approval', 0),
(205, '2020-05-15 09:25:28', 'Admin', 'Approved Registration: 715760571', 'Approval', 0),
(206, '2020-05-15 09:26:20', 'Admin', 'Added new Minor medical:30476567', 'Add', 0),
(207, '2020-05-15 09:26:44', 'Admin', 'Approved DCI: 715760571', 'Approval', 0),
(208, '2020-05-15 09:26:53', 'Admin', 'Approved DCI: 30476567', 'Approval', 0),
(209, '2020-05-15 09:28:51', 'Admin', 'Update  Passport:715760571', 'update', 0),
(210, '2020-05-15 09:34:06', 'Admin', 'Added new Minor medical:715760571', 'Add', 0),
(211, '2020-05-15 09:35:09', 'Admin', 'Approved Registration: 715760571', 'Approval', 0),
(212, '2020-05-15 09:37:52', 'Admin', 'Added new DCI Clearance:30476567', 'Add', 0),
(213, '2020-05-15 09:38:12', 'Admin', 'Approved DCI: 30476567', 'Approval', 0),
(214, '2020-05-15 09:43:50', '34', 'Update new DCI Clearance:30476567', 'update', 0),
(215, '2020-05-15 09:44:50', '34', 'Update new DCI Clearance:30476567', 'update', 0),
(216, '2020-05-15 09:46:12', 'Admin', 'Update  Passport:30476567', 'update', 0),
(217, '2020-05-15 10:18:52', 'Admin', 'Added new Applicant:2147483647', 'Add', 0),
(218, '2020-05-15 10:19:12', 'Admin', 'Approved Registration: 2147483647', 'Approval', 0),
(219, '2020-05-15 10:24:37', 'Admin', 'Added new Minor medical:2147483647', 'Add', 0),
(220, '2020-05-15 10:25:39', 'Admin', 'Added new Minor medical:2147483647', 'Add', 0),
(221, '2020-05-15 10:26:21', 'Admin', 'Approved Registration: 2147483647', 'Approval', 0),
(222, '2020-05-15 10:27:22', 'Admin', 'Added new DCI Clearance:2147483647', 'Add', 0),
(223, '2020-05-15 10:27:54', 'Admin', 'Approved DCI: 2147483647', 'Approval', 0),
(224, '2020-05-15 10:29:18', 'Admin', 'Added new Applicant:459697979', 'Add', 0),
(225, '2020-05-15 10:29:37', 'Admin', 'Approved Registration: 459697979', 'Approval', 0),
(226, '2020-05-15 10:58:56', 'Admin', 'Added new Applicant:30595696', 'Add', 0),
(227, '2020-05-15 10:59:12', 'Admin', 'Approved Registration: 30595696', 'Approval', 0),
(228, '2020-05-16 09:44:01', 'Admin', '0', 'Add', 0),
(229, '2020-05-16 09:44:02', 'Admin', '0', 'Add', 0),
(230, '2020-05-16 09:44:04', 'Admin', 'Updated Maximum Approvals for ModulePST', 'Add', 0),
(231, '2020-05-16 09:44:07', 'Admin', '0', 'Add', 0),
(232, '2020-05-16 09:44:08', 'Admin', '0', 'Add', 0),
(233, '2020-05-16 09:44:11', 'Admin', 'Updated Maximum Approvals for ModulePST', 'Add', 0),
(234, '2020-05-16 09:44:16', 'Admin', '0', 'Add', 0),
(235, '2020-05-16 09:44:18', 'Admin', 'Updated Maximum Approvals for ModulePST', 'Add', 0),
(236, '2020-05-16 09:44:40', 'Admin', '0', 'Add', 0),
(237, '2020-05-16 09:44:42', 'Admin', 'Updated Maximum Approvals for ModuleVSA', 'Add', 0),
(238, '2020-05-16 09:45:08', 'Admin', '0', 'Add', 0),
(239, '2020-05-16 09:45:10', 'Admin', 'Updated Maximum Approvals for ModuleCNT', 'Add', 0),
(240, '2020-05-16 12:43:51', '34', 'Update new DCI Clearance:30487656', 'update', 0),
(241, '2020-05-17 11:57:38', 'Admin', 'Generated hearing Notice for Application: 30487656', 'Add', 0),
(242, '2020-05-17 15:17:13', 'Admin', 'Generated hearing Notice for Application: 30487656', 'Add', 0),
(243, '2020-05-17 15:19:39', 'Admin', 'Generated hearing Notice for Application: 30476567', 'Add', 0),
(244, '2020-05-17 20:20:06', 'Admin', 'Generated hearing Notice for Application: 30476567', 'Add', 0),
(245, '2020-05-18 11:36:48', 'Admin', 'Added new   contract with  IDnumber:30487656', 'Add', 0),
(246, '2020-05-18 13:53:56', 'Admin', 'Added new training  with name:30487656', 'Add', 0),
(247, '2020-05-18 13:54:38', '0', 'Update new NEAA:30487656', 'update', 0),
(248, '2020-05-18 13:54:47', 'Admin', 'Deleted NEAA  with ID: 4', 'Delete', 0),
(249, '2020-05-18 13:55:13', 'Admin', 'Added new training  with name:30595696', 'Add', 0),
(250, '2020-05-18 13:55:44', 'Admin', 'Added new training  with name:30487656', 'Add', 0),
(251, '2020-05-18 19:38:02', 'Admin', 'Added new training  with name:30487656', 'Add', 0),
(252, '2020-05-18 19:38:22', 'Admin', 'Added new training  with name:459697979', 'Add', 0),
(253, '2020-05-18 19:38:31', 'Admin', 'Deleted NEAA  with ID: 6', 'Delete', 0),
(254, '2020-05-18 19:38:44', 'Admin', 'Added new training  with name:30487656', 'Add', 0),
(255, '2020-05-18 20:32:49', 'Admin', 'Added new Applicant:30564567', 'Add', 0),
(256, '2020-05-18 20:33:07', 'Admin', 'Added new User with username:University og nairobi ', 'Add', 0),
(257, '2020-05-18 20:33:18', 'Admin', 'Added new User with username:john tenai', 'Add', 0),
(258, '2020-05-18 20:33:29', 'Admin', 'Added new Next of kin  with name:tyui', 'Add', 0),
(259, '2020-05-18 20:33:38', 'Admin', 'Added new Siblings name:mary', 'Add', 0),
(260, '2020-05-18 20:34:19', 'Admin', 'Added new Document for application: 30564567', 'Add', 0),
(261, '2020-05-18 20:34:22', 'Admin', 'Added new Document for application: 30564567', 'Add', 0),
(262, '2020-05-18 20:34:25', 'Admin', 'Added new Document for application: 30564567', 'Add', 0),
(263, '2020-05-18 20:34:25', 'Admin', 'Added new Document for application: 30564567', 'Add', 0),
(264, '2020-05-18 20:34:27', 'Admin', 'Added new Document for application: 30564567', 'Add', 0),
(265, '2020-05-18 20:34:28', 'Admin', 'Added new Document for application: 30564567', 'Add', 0),
(266, '2020-05-18 20:34:35', 'Admin', 'Added new Document for application: 30564567', 'Add', 0),
(267, '2020-05-18 20:34:35', 'Admin', 'Added new Document for application: 30564567', 'Add', 0),
(268, '2020-05-18 20:34:44', 'Admin', 'Added new Document for application: 30564567', 'Add', 0),
(269, '2020-05-18 20:36:04', 'Admin', 'Approved Registration: 30564567', 'Approval', 0),
(270, '2020-05-18 21:13:01', 'Admin', 'Added new Applicant:4567894', 'Add', 0),
(271, '2020-05-18 21:13:24', 'Admin', 'Added new Document for application: 4567894', 'Add', 0),
(272, '2020-05-18 21:13:26', 'Admin', 'Added new Document for application: 4567894', 'Add', 0),
(273, '2020-05-19 09:25:51', 'Admin', 'Update new Contract processing:30487656', 'update', 0),
(274, '2020-05-19 11:05:37', 'Admin', 'Approved Registration: 4567894', 'Approval', 0),
(275, '2020-05-19 17:17:31', '0', 'Update new NEAA:30487656', 'update', 0),
(276, '2020-05-19 19:48:55', 'Admin', 'Added new User with username:cheruiyot', 'Add', 0),
(277, '2020-05-19 19:51:17', 'Admin', '444', 'Create', 0),
(278, '2020-05-19 19:51:18', 'Admin', '444', 'Update', 0),
(279, '2020-05-19 19:51:19', 'Admin', '444', 'Update', 0),
(280, '2020-05-19 19:51:21', 'Admin', '444', 'Update', 0),
(281, '2020-05-19 19:51:22', 'Admin', '444', 'Update', 0),
(282, '2020-05-19 19:51:25', 'Admin', '114', 'Create', 0),
(283, '2020-05-19 19:51:26', 'Admin', '114', 'Update', 0),
(284, '2020-05-19 19:51:26', 'Admin', '114', 'Update', 0),
(285, '2020-05-19 19:51:27', 'Admin', '114', 'Update', 0),
(286, '2020-05-19 19:51:28', 'Admin', '114', 'Update', 0),
(287, '2020-05-19 19:51:31', 'Admin', 'Updated UserGroup with iD: 4', 'Update', 0),
(288, '2020-05-19 20:09:32', 'Admin', 'Added new Applicant:30487656', 'Add', 0),
(289, '2020-05-19 20:09:50', 'Admin', 'Added new User with username:University og nairobi ', 'Add', 0),
(290, '2020-05-19 20:10:02', 'Admin', 'Added new User with username:john tenai', 'Add', 0),
(291, '2020-05-19 20:10:30', 'Admin', 'Added new Next of kin  with name:john tenai', 'Add', 0),
(292, '2020-05-19 20:10:50', 'Admin', 'Added new Siblings name:mary', 'Add', 0),
(293, '2020-05-19 20:11:26', 'Admin', 'Added new Document for application: 30487656', 'Add', 0),
(294, '2020-05-22 11:20:27', '0', 'Added Ticketing:30487656', 'Add', 0),
(295, '2020-05-22 11:49:36', 'Admin', 'Added new   contract with  IDnumber:30487656', 'Add', 0),
(296, '2020-05-22 11:49:56', 'Admin', 'Approved Contract Processing: 30487656', 'Approval', 0),
(297, '2020-05-22 11:51:46', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(298, '2020-05-22 11:52:02', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(299, '2020-05-22 11:56:48', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(300, '2020-05-22 11:57:30', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(301, '2020-05-22 12:02:32', 'Admin', 'Deleted contract processing  with ID: 7', 'Delete', 0),
(302, '2020-05-22 12:03:07', 'Admin', 'Added new VISA Processing with  IDnumber:30487656', 'Add', 0),
(303, '2020-05-22 12:03:24', 'Admin', 'Approved Visa: 30487656', 'Approval', 0),
(304, '2020-05-22 12:50:09', '0', 'Added new   Final medical with  IDnumber:30487656', 'Add', 0),
(305, '2020-05-22 12:53:57', 'Admin', 'Approved Final Medical: 30487656', 'Approval', 0),
(306, '2020-05-22 12:54:10', 'Admin', 'Approved Final Medical: 30487656', 'Approval', 0),
(307, '2020-05-22 12:54:18', 'Admin', 'Approved Final Medical: 30487656', 'Approval', 0),
(308, '2020-05-22 13:03:58', '0', 'Added new   Final medical with  IDnumber:30487656', 'Add', 0),
(309, '2020-05-22 13:04:10', '0', 'Added new   Final medical with  IDnumber:30487656', 'Add', 0),
(310, '2020-05-22 13:07:27', 'Admin', '0', 'Add', 0),
(311, '2020-05-22 13:07:29', 'Admin', 'Updated Maximum Approvals for ModuleFNL', 'Add', 0),
(312, '2020-05-22 13:07:34', 'Admin', 'Updated Maximum Approvals for ModuleFNL', 'Add', 0),
(313, '2020-05-22 13:11:19', '0', 'Added new   Final medical with  IDnumber:30487656', 'Add', 0),
(314, '2020-05-22 13:11:49', '0', 'Added new   Final medical with  IDnumber:30487656', 'Add', 0),
(315, '2020-05-22 13:15:33', '0', 'Added new   Final medical with  IDnumber:30487656', 'Add', 0),
(316, '2020-05-22 13:17:11', 'Admin', 'Approved Final Medical: 30487656', 'Approval', 0),
(317, '2020-05-22 13:17:11', 'Admin', 'Approved Final Medical: 30487656', 'Approval', 0),
(318, '2020-05-22 13:18:47', 'Admin', 'Declined Application: 30487656', 'dci decline', 0),
(319, '2020-05-22 13:18:48', 'Admin', 'Declined Application: 30487656', 'dci decline', 0),
(320, '2020-05-22 13:24:57', '0', 'Added new   Final medical with  IDnumber:30487656', 'Add', 0),
(321, '2020-05-22 13:28:13', 'Admin', 'Approved Final Medical: 30487656', 'Approval', 0),
(322, '2020-05-22 14:11:53', '0', 'Added new   Final medical with  IDnumber:30487656', 'Add', 0),
(323, '2020-05-22 14:12:29', 'Admin', 'Approved Final Medical: 30487656', 'Approval', 0),
(324, '2020-05-22 15:01:03', 'Admin', 'Added new training  with name:30487656', 'Add', 0),
(325, '2020-05-22 15:06:19', 'Admin', 'Added new training  with name:30487656', 'Add', 0),
(326, '2020-05-22 15:07:52', 'Admin', 'Approved Training: 30487656', 'Approval', 0),
(327, '2020-05-22 15:08:08', 'Admin', 'Approved Training: 30487656', 'Approval', 0),
(328, '2020-05-22 15:09:48', 'Admin', '0', 'Add', 0),
(329, '2020-05-22 15:09:49', 'Admin', 'Updated Maximum Approvals for ModuleTRG', 'Add', 0),
(330, '2020-05-22 15:10:23', 'Admin', 'Approved Training: 30487656', 'Approval', 0),
(331, '2020-05-22 17:09:54', 'Admin', 'Added new   contract with  IDnumber:30487656', 'Add', 0),
(332, '2020-05-22 20:10:14', 'Admin', 'Deleted minor medical  with ID: 1', 'Delete', 0),
(333, '2020-05-22 21:15:29', '0', 'Added Ticketing:30487656', 'Add', 0),
(334, '2020-05-22 21:16:22', 'Admin', 'Approved Visa: 30487656', 'Approval', 0),
(335, '2020-05-22 21:16:42', 'Admin', '0', 'Add', 0),
(336, '2020-05-22 21:16:44', 'Admin', 'Updated Maximum Approvals for ModuleTKN', 'Add', 0),
(337, '2020-05-22 21:18:21', '0', 'Added Ticketing:30487656', 'Add', 0),
(338, '2020-05-22 21:19:36', 'Admin', 'Approved Visa: 30487656', 'Approval', 0),
(339, '2020-05-22 22:00:29', 'Admin', 'Added new Travelling  with name:30487656', 'Add', 0),
(340, '2020-05-22 22:05:00', 'Admin', 'Added new Travelling  with name:30487656', 'Add', 0),
(341, '2020-05-22 22:05:32', 'Admin', 'Approved Travel: 30487656', 'Approval', 0),
(342, '2020-05-23 11:29:34', 'Admin', 'Declined Contract processing: 30487656', 'Contract Processing decline', 0),
(343, '2020-05-24 15:21:30', 'Admin', 'Added new Applicant:34567858', 'Add', 0),
(344, '2020-05-24 15:22:13', 'Admin', ' Declined Application: 30487656', 'Approval', 0),
(345, '2020-05-24 15:32:54', 'Admin', ' Declined Application: 34567858', 'Approval', 0),
(346, '2020-05-24 16:00:54', 'Admin', 'Added new Applicant:30567897', 'Add', 0),
(347, '2020-05-24 16:01:25', 'Admin', ' Declined Application: 30567897', 'Approval', 0),
(348, '2020-05-24 16:03:03', 'Admin', ' Declined Application: 34567858', 'Approval', 0),
(349, '2020-05-25 08:43:34', 'Admin', 'Approved Registration: 34567858', 'Approval', 0),
(350, '2020-05-25 09:30:37', 'Admin', 'Added new Applicant:33487656', 'Add', 0),
(351, '2020-05-25 09:31:46', 'Admin', 'Approved Registration: 33487656', 'Approval', 0),
(352, '2020-05-26 09:49:31', 'Admin', 'Added new Applicant:3546786', 'Add', 0),
(353, '2020-05-26 09:55:12', 'Admin', 'Added new Minor medical:33487656', 'Add', 0),
(354, '2020-05-26 10:13:50', 'Admin', 'Added new DCI Clearance:33487656', 'Add', 0),
(355, '2020-05-26 11:12:38', 'Admin', 'Added new Minor medical:33487656', 'Add', 0),
(356, '2020-05-26 11:13:13', 'Admin', 'Added passport processing:33487656', 'Add', 0),
(357, '2020-05-26 11:29:26', 'Admin', 'Added new   contract with  IDnumber:33487656', 'Add', 0),
(358, '2020-05-26 11:32:55', 'Admin', 'Added new training  with name:33487656', 'Add', 0),
(359, '2020-05-26 11:35:05', 'Admin', 'Deleted training  with ID: 2', 'Delete', 0),
(360, '2020-05-26 11:36:02', 'Admin', 'Added new training  with name:33487656', 'Add', 0),
(361, '2020-05-26 11:39:40', 'Admin', 'Added new training  with name:33487656', 'Add', 0),
(362, '2020-05-26 11:41:42', 'Admin', 'Deleted NEAA  with ID: 4', 'Delete', 0),
(363, '2020-05-26 11:42:18', 'Admin', 'Added new training  with name:3546786', 'Add', 0),
(364, '2020-05-26 11:43:47', 'Admin', '0', 'Add', 0),
(365, '2020-05-26 11:43:50', 'Admin', '0', 'Add', 0),
(366, '2020-05-26 11:43:52', 'Admin', '0', 'Add', 0),
(367, '2020-05-26 11:43:53', 'Admin', 'Updated Maximum Approvals for ModuleATN', 'Add', 0),
(368, '2020-05-26 11:44:08', 'Admin', '0', 'Add', 0),
(369, '2020-05-26 11:44:10', 'Admin', 'Updated Maximum Approvals for ModuleNEA', 'Add', 0),
(370, '2020-05-26 11:46:03', 'Admin', 'Added new training  with name:33487656', 'Add', 0),
(371, '2020-05-26 11:50:55', '0', 'Added new   VISA Processing with  IDnumber:33487656', 'Add', 0),
(372, '2020-05-26 11:53:40', 'Admin', 'Added new VISA Processing with  IDnumber:33487656', 'Add', 0),
(373, '2020-05-26 11:55:36', '0', 'Added new   Final medical with  IDnumber:33487656', 'Add', 0),
(374, '2020-05-26 11:55:56', '0', 'Added Ticketing:33487656', 'Add', 0),
(375, '2020-05-26 11:57:48', 'Admin', 'Added new Travelling  with name:33487656', 'Add', 0),
(376, '2020-05-26 12:38:23', 'Admin', 'Approved Registration: 3546786', 'Approval', 0),
(377, '2020-05-26 12:56:29', 'Admin', 'Added new Applicant:30487656', 'Add', 0),
(378, '2020-05-26 12:56:53', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(379, '2020-05-26 13:35:43', 'Admin', 'Updated  User with username: Admin', 'Update', 0),
(380, '2020-05-26 13:35:48', 'Admin', 'Updated  User with username: Admin', 'Update', 0),
(381, '2020-05-26 13:44:16', 'Admin', 'Added new Applicant:30487656', 'Add', 0),
(382, '2020-05-26 13:44:36', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(383, '2020-05-26 13:45:56', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(384, '2020-05-26 13:54:05', 'Admin', 'Added new Applicant:30487656', 'Add', 0),
(385, '2020-05-26 13:54:24', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(386, '2020-05-26 14:01:59', 'Admin', 'Added new Applicant:30487656', 'Add', 0),
(387, '2020-05-26 14:03:30', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(388, '2020-05-26 15:17:06', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(389, '2020-05-26 15:21:48', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(390, '2020-05-26 15:26:40', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(391, '2020-05-26 15:27:06', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(392, '2020-05-26 15:32:35', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(393, '2020-05-26 15:33:01', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(394, '2020-05-26 15:40:18', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(395, '2020-05-26 15:40:39', 'Admin', 'Approved Registration: 30487656', 'Approval', 0),
(396, '2020-05-26 16:11:41', 'Admin', 'Added new DCI Clearance:30487656', 'Add', 0),
(397, '2020-05-26 16:12:35', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(398, '2020-05-26 16:20:36', 'Admin', 'Added new DCI Clearance:30487656', 'Add', 0),
(399, '2020-05-26 16:22:22', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(400, '2020-05-26 17:32:01', 'Admin', 'Added new DCI Clearance:30487656', 'Add', 0),
(401, '2020-05-26 17:32:25', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(402, '2020-05-26 17:59:35', 'Admin', 'Added new DCI Clearance:30487656', 'Add', 0),
(403, '2020-05-26 17:59:49', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(404, '2020-05-26 18:03:45', 'Admin', 'Added new DCI Clearance:30487656', 'Add', 0),
(405, '2020-05-26 18:06:32', 'Admin', 'Added new DCI Clearance:30487656', 'Add', 0),
(406, '2020-05-26 18:06:47', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(407, '2020-05-26 18:07:50', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(408, '2020-05-26 18:21:50', 'Admin', 'Added new   contract with  IDnumber:30487656', 'Add', 0),
(409, '2020-05-26 18:22:09', 'Admin', 'Approved Contract Processing: 30487656', 'Approval', 0),
(410, '2020-05-26 18:22:48', 'Admin', 'Approved Contract Processing: 30487656', 'Approval', 0),
(411, '2020-05-26 21:09:14', 'Admin', 'Deleted DCI Clearance  with ID: 1', 'Delete', 0),
(412, '2020-05-26 21:10:28', 'Admin', 'Added new DCI Clearance:30487656', 'Add', 0),
(413, '2020-05-26 21:10:52', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(414, '2020-05-27 08:56:13', 'Admin', 'Added new Minor medical:30487656', 'Add', 0),
(415, '2020-05-27 08:56:39', 'Admin', 'Approved DCI: 30487656', 'Approval', 0),
(416, '2020-05-27 09:09:51', 'Admin', 'Added new training  with name:30487656', 'Add', 0),
(417, '2020-05-27 09:11:47', 'Admin', 'Approved nea: 30487656', 'Approval', 0),
(418, '2020-05-27 09:14:12', 'Admin', 'Added new   contract with  IDnumber:30487656', 'Add', 0),
(419, '2020-05-27 09:14:28', 'Admin', 'Approved Contract Processing: 30487656', 'Approval', 0),
(420, '2020-05-27 09:32:38', 'Admin', 'Deleted Passport Processing   with iD: 1', 'Delete', 0),
(421, '2020-05-27 09:34:55', 'Admin', 'Added passport processing:30487656', 'Add', 0),
(422, '2020-05-27 09:35:13', 'Admin', 'Approved Passport: 30487656', 'Approval', 0),
(423, '2020-05-27 09:39:31', 'Admin', 'Added new VISA Processing with  IDnumber:30487656', 'Add', 0),
(424, '2020-05-27 09:40:03', 'Admin', 'Approved Visa: 30487656', 'Approval', 0),
(425, '2020-05-27 09:40:35', 'Admin', 'Approved Visa: 30487656', 'Approval', 0),
(426, '2020-05-27 09:40:50', 'Admin', 'Approved Visa: 30487656', 'Approval', 0),
(427, '2020-05-27 09:48:46', '0', 'Added new   VISA Processing with  IDnumber:30487656', 'Add', 0),
(428, '2020-05-27 10:06:45', '0', 'Added new   VISA Processing with  IDnumber:30487656', 'Add', 0),
(429, '2020-05-27 10:20:07', 'Admin', 'Approved Attestation: 30487656', 'Approval', 0),
(430, '2020-05-27 10:27:36', 'Admin', 'Deleted Ticketing  with ID: 1', 'Delete', 0),
(431, '2020-05-27 10:28:22', '0', 'Added Ticketing:30487656', 'Add', 0),
(432, '2020-05-27 10:28:35', 'Admin', 'Approved Visa: 30487656', 'Approval', 0),
(433, '2020-05-27 10:30:10', 'Admin', 'Approved Visa: 30487656', 'Approval', 0),
(434, '2020-05-27 10:30:40', 'Admin', 'Approved Visa: 30487656', 'Approval', 0),
(435, '2020-05-27 10:39:23', '0', 'Added new   Final medical with  IDnumber:30487656', 'Add', 0),
(436, '2020-05-27 10:40:20', 'Admin', 'Approved Final Medical: 30487656', 'Approval', 0),
(437, '2020-05-27 10:41:58', 'Admin', 'Added new Travelling  with name:30487656', 'Add', 0),
(438, '2020-05-27 10:43:20', 'Admin', 'Approved Travel: 30487656', 'Approval', 0),
(439, '2020-05-27 10:44:05', 'Admin', 'Approved Travel: 30487656', 'Approval', 0),
(440, '2020-06-02 14:50:20', 'Admin', 'Updated  User with username: Admin', 'Update', 0),
(441, '2020-06-02 14:50:34', 'Admin', 'Changed User Photo for user: Admin', 'Update', 0),
(442, '2020-06-02 21:39:18', 'Admin', 'Updated  User with username: Admin', 'Update', 0),
(443, '2020-06-08 09:39:51', 'Admin', 'Changed User Photo for user: Admin', 'Update', 0),
(444, '2020-06-08 09:39:55', 'Admin', 'Updated  User with username: Admin', 'Update', 0),
(445, '2020-06-08 14:36:07', 'Admin', 'Changed User Photo for user: Admin', 'Update', 0),
(446, '2020-06-08 14:36:10', 'Admin', 'Updated  User with username: Admin', 'Update', 0),
(447, '2020-06-08 15:16:49', 'Admin', 'Added new Applicant:30486756', 'Add', 0),
(448, '2020-06-08 15:38:49', 'Admin', 'Added new Minor medical:30486756', 'Add', 0),
(449, '2020-06-08 15:44:17', 'Admin', 'Approved Registration: 30486756', 'Approval', 0),
(450, '2020-06-08 20:01:34', 'Admin', 'Added new DCI Clearance:30486756', 'Add', 0),
(451, '2020-06-08 20:03:28', 'Admin', 'Added passport processing:30486756', 'Add', 0),
(452, '2020-06-08 20:03:58', 'Admin', 'Added new   contract with  IDnumber:30487656', 'Add', 0),
(453, '2020-06-10 15:07:59', 'Admin', 'Added new User with username:vokechem', 'Add', 0);

-- --------------------------------------------------------

--
-- Table structure for table `configurations`
--

CREATE TABLE `configurations` (
  `ID` bigint(20) NOT NULL,
  `Code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `PhysicalAdress` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Street` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PoBox` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PostalCode` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Town` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Telephone1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Telephone2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Fax` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Website` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PIN` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Logo` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NextPE` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `NextComm` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `NextSupplier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '1',
  `NextMember` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `NextProcMeth` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `NextStdDoc` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `NextApplication` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `NextRev` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `Created_At` datetime DEFAULT NULL,
  `Updated_At` datetime DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Updated_By` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Deleted` tinyint(4) NOT NULL,
  `Deleted_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NextPEType` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `NextMemberType` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `NextFeeCode` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `NextTenderType` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `Year` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PeResponseDays` int(11) DEFAULT 5,
  `CaseClosingDate` int(11) DEFAULT 21
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contract`
--

CREATE TABLE `contract` (
  `ID` int(11) NOT NULL,
  `Number` int(11) DEFAULT NULL,
  `Contract_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Cost` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EmployerName` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EmployerID` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EmployerContact` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EmployerAddress` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VisaNumber` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ContractNumber` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL,
  `UpdateBy` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Approve_at` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `contract`
--

INSERT INTO `contract` (`ID`, `Number`, `Contract_status`, `Cost`, `EmployerName`, `EmployerID`, `EmployerContact`, `EmployerAddress`, `VisaNumber`, `ContractNumber`, `Status`, `Created_at`, `CreatedBy`, `Updated_at`, `UpdateBy`, `Deleted`, `Approve_at`) VALUES
(1, 30487656, 'Issued', '0', 'mm', 'nn', 'mm', 'mm', 'mm', 'mm', 'Approved', '2020-05-27 09:14:12', 'Admin', '0000-00-00 00:00:00', '0', 0, '2020-05-27 09:14:28'),
(2, 30487656, 'Issued', '0', 'mm', 'nn', 'mm', 'mm', 'mm', 'mm', 'Pending Approval', '2020-06-08 20:03:57', 'Admin', '0000-00-00 00:00:00', '0', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `contractapprovalcontacts`
--

CREATE TABLE `contractapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `contractapprovalcontacts`
--

INSERT INTO `contractapprovalcontacts` (`Name`, `Email`, `Mobile`, `Msg`, `IDNumber`) VALUES
('kelvin chemey', 'kelvinchemey@gmail.com', '+254700392599', 'Applicant', '30487656'),
('Kelvin Chemey', 'kserem20@gmail.com', '+254753710324', 'Applicant', '30487656');

-- --------------------------------------------------------

--
-- Table structure for table `contract_approval_workflow`
--

CREATE TABLE `contract_approval_workflow` (
  `ID` bigint(20) NOT NULL,
  `Number` bigint(20) NOT NULL,
  `Fullname` bigint(20) NOT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `contract_approval_workflow`
--

INSERT INTO `contract_approval_workflow` (`ID`, `Number`, `Fullname`, `Status`, `Approver`, `Remarks`, `Created_By`, `Approved_At`, `Created_At`) VALUES
(1, 30487656, 0, 'Approved', 'Admin', 'yuu', 'Admin', '2020-05-27 09:14:28', '2020-05-27 09:14:28');

-- --------------------------------------------------------

--
-- Table structure for table `counties`
--

CREATE TABLE `counties` (
  `ID` bigint(20) NOT NULL,
  `Code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_At` datetime DEFAULT NULL,
  `Updated_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Deleted_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=348 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `counties`
--

INSERT INTO `counties` (`ID`, `Code`, `Name`, `Created_At`, `Created_By`, `Updated_At`, `Updated_By`, `Deleted`, `Deleted_By`) VALUES
(1, '001', 'MOMBASA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(2, '002', 'KWALE', '0000-00-00 00:00:00', 'Admin', '2019-10-04 10:07:32', 'Admin', 0, 'Admin'),
(3, '003', 'KILIFI', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(4, '004', 'TANARIVER', '0000-00-00 00:00:00', 'Admin', '2019-08-27 17:17:05', 'Admin', 0, 'Admin'),
(5, '005', 'LAMU', '0000-00-00 00:00:00', 'Admin', '2019-08-27 17:11:58', NULL, 0, 'Admin'),
(6, '006', 'TAITA TAVETA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(7, '007', 'GARISSA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(8, '008', 'WAJIR', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(9, '009', 'MANDERA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(10, '010', 'MARSABIT', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(11, '011', 'ISIOLO', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(12, '012', 'MERU', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(13, '013', 'THARAKA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(14, '014', 'EMBU', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(15, '015', 'KITUI', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(16, '016', 'MACHAKOS', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(17, '017', 'MAKUENI', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(18, '018', 'NYANDARUA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(19, '019', 'NYERI', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(20, '020', 'KIRINYAGA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(21, '021', 'MURANGA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(22, '022', 'KIAMBU', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(23, '023', 'TURKANA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(24, '024', 'WEST POKOT', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(25, '025', 'SAMBURU', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(26, '026', 'TRANS-NZOIA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(27, '027', 'UASIN GISHU', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(28, '028', 'ELGEYO MARAKWET', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(29, '029', 'NANDI', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(30, '030', 'BARINGO', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(31, '031', 'LAIKIPIA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(32, '032', 'NAKURU', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(33, '033', 'NAROK', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(34, '034', 'KAJIADO', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(35, '035', 'BOMET', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(36, '036', 'KERICHO', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(37, '037', 'KAKAMEGA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(38, '038', 'VIHIGA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(39, '039', 'BUNGOMA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(40, '040', 'BUSIA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(41, '041', 'SIAYA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(42, '042', 'KISUMU', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(43, '043', 'HOMA BAY', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(44, '044', 'MIGORI', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(45, '045', 'KISII', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(46, '046', 'NYAMIRA', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin'),
(47, '047', 'NAIROBI', '0000-00-00 00:00:00', 'Admin', '0000-00-00 00:00:00', 'Admin', 0, 'Admin');

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `ID` bigint(20) NOT NULL,
  `Code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_At` datetime DEFAULT NULL,
  `Updated_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Deleted_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=348 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`ID`, `Code`, `Name`, `Created_At`, `Created_By`, `Updated_At`, `Updated_By`, `Deleted`, `Deleted_By`) VALUES
(1, '254', 'Kenya', '2020-04-07 21:11:16', 'Admin', '2020-04-07 21:11:16', 'Admin', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `dci`
--

CREATE TABLE `dci` (
  `ID` int(11) NOT NULL,
  `Number` int(11) DEFAULT NULL,
  `DOT` datetime DEFAULT NULL,
  `Certificate_status` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DOC` datetime DEFAULT NULL,
  `Cost` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CostIncurred` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Processing` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL,
  `UpdatedBy` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Approve_at` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=6553 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `dci`
--

INSERT INTO `dci` (`ID`, `Number`, `DOT`, `Certificate_status`, `DOC`, `Cost`, `CostIncurred`, `Processing`, `Status`, `Created_at`, `CreatedBy`, `Updated_at`, `UpdatedBy`, `Deleted`, `Approve_at`) VALUES
(1, 30487656, '2020-05-12 00:00:00', 'Collected', '2020-05-26 00:00:00', '1050', '34', 'job Majuu', 'Approved', '2020-05-26 21:10:28', 'Admin', '0000-00-00 00:00:00', '0', 0, '2020-05-26 21:10:52'),
(2, 30486756, '2020-06-16 00:00:00', 'Collected', '2020-06-16 00:00:00', '1050', '34', 'job Majuu', 'Pending Approval', '2020-06-08 20:01:33', 'Admin', '0000-00-00 00:00:00', '0', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `dciapprovalcontacts`
--

CREATE TABLE `dciapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `dciapprovalcontacts`
--

INSERT INTO `dciapprovalcontacts` (`Name`, `Email`, `Mobile`, `Msg`, `IDNumber`) VALUES
('kelvin chemey', 'kelvinchemey@gmail.com', '+254700392599', 'Applicant', '30487656'),
('Kelvin Chemey', 'kserem20@gmail.com', '+254753710324', 'Applicant', '30487656');

-- --------------------------------------------------------

--
-- Table structure for table `dcibuffer`
--

CREATE TABLE `dcibuffer` (
  `Fullname` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DOT` date DEFAULT NULL,
  `Certificate_status` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DOC` date DEFAULT NULL,
  `Processing` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Cost` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `dcibuffer`
--

INSERT INTO `dcibuffer` (`Fullname`, `IDNumber`, `Number`, `DOT`, `Certificate_status`, `DOC`, `Processing`, `Cost`, `Created_at`) VALUES
('martina Kalunde', '34564577', '34564577', '2020-04-14', 'Collected', '2020-04-07', 'job Majuu', '1050', '2020-04-11'),
('martina Kalunde', '34564577', '34564577', '2020-04-14', 'Collected', '2020-04-07', 'job Majuu', '1050', '2020-04-11');

-- --------------------------------------------------------

--
-- Table structure for table `dci_approval_workflow`
--

CREATE TABLE `dci_approval_workflow` (
  `ID` bigint(20) NOT NULL,
  `Number` bigint(20) NOT NULL,
  `Fullname` bigint(20) NOT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `dci_approval_workflow`
--

INSERT INTO `dci_approval_workflow` (`ID`, `Number`, `Fullname`, `Status`, `Approver`, `Remarks`, `Created_By`, `Approved_At`, `Created_At`) VALUES
(1, 30487656, 0, 'Approved', 'Admin', 'kelvin', 'Admin', '2020-05-26 21:10:52', '2020-05-26 21:10:52');

-- --------------------------------------------------------

--
-- Table structure for table `educationaldetails`
--

CREATE TABLE `educationaldetails` (
  `ID` int(11) NOT NULL,
  `IDNumber` int(11) DEFAULT NULL,
  `Institution` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Period` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Decription` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `UpdateBy` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Update_at` datetime DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2730 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `educationaldetails`
--

INSERT INTO `educationaldetails` (`ID`, `IDNumber`, `Institution`, `Period`, `Decription`, `Created_at`, `CreatedBy`, `UpdateBy`, `Update_at`, `Deleted`) VALUES
(1, 30487656, 'University og nairobi ', '2018', 'computer science', '2020-05-19 20:09:50', 'Admin', '0', '0000-00-00 00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `finalapprovalcontacts`
--

CREATE TABLE `finalapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `finalapprovalcontacts`
--

INSERT INTO `finalapprovalcontacts` (`Name`, `Email`, `Mobile`, `Msg`, `IDNumber`) VALUES
('Kelvin Chemey', 'kserem20@gmail.com', '+254753710324', 'Applicant', '30487656');

-- --------------------------------------------------------

--
-- Table structure for table `finalmedical`
--

CREATE TABLE `finalmedical` (
  `ID` int(11) NOT NULL,
  `Number` int(11) DEFAULT NULL,
  `MedicalFacility` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DOM` datetime DEFAULT NULL,
  `MedicalResult` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Cost` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Type` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RepeatCost` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Other` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL,
  `UpdatedBy` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Approve_at` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `finalmedical`
--

INSERT INTO `finalmedical` (`ID`, `Number`, `MedicalFacility`, `DOM`, `MedicalResult`, `Cost`, `Type`, `RepeatCost`, `Other`, `Status`, `Created_at`, `CreatedBy`, `Updated_at`, `UpdatedBy`, `Deleted`, `Approve_at`) VALUES
(1, 30487656, 'Chaudhry', '2020-05-27 00:00:00', 'Pass', '4000', 'New', '', '67', 'Approved', '2020-05-27 10:39:23', '0', '0000-00-00 00:00:00', '0', 0, '2020-05-27 10:40:20');

-- --------------------------------------------------------

--
-- Table structure for table `final_approval_workflow`
--

CREATE TABLE `final_approval_workflow` (
  `ID` bigint(20) NOT NULL,
  `Number` bigint(20) NOT NULL,
  `Fullname` bigint(20) NOT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `final_approval_workflow`
--

INSERT INTO `final_approval_workflow` (`ID`, `Number`, `Fullname`, `Status`, `Approver`, `Remarks`, `Created_By`, `Approved_At`, `Created_At`) VALUES
(1, 30487656, 0, 'Approved', 'Admin', '788', 'Admin', '2020-05-27 10:40:20', '2020-05-27 10:40:20');

-- --------------------------------------------------------

--
-- Table structure for table `groupaccess`
--

CREATE TABLE `groupaccess` (
  `UserGroupID` bigint(20) NOT NULL,
  `RoleID` bigint(20) NOT NULL,
  `Edit` tinyint(1) NOT NULL,
  `Remove` tinyint(1) NOT NULL,
  `AddNew` tinyint(1) NOT NULL,
  `View` tinyint(1) NOT NULL,
  `Export` tinyint(1) NOT NULL,
  `UpdateBy` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CreateBy` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CreatedAt` datetime NOT NULL,
  `UpdatedAt` datetime NOT NULL,
  `Deleted` tinyint(1) NOT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=142 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `groupaccess`
--

INSERT INTO `groupaccess` (`UserGroupID`, `RoleID`, `Edit`, `Remove`, `AddNew`, `View`, `Export`, `UpdateBy`, `CreateBy`, `CreatedAt`, `UpdatedAt`, `Deleted`) VALUES
(1, 1, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:49:25', '2020-04-07 19:49:32', 0),
(1, 2, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:49:22', '2020-04-07 19:49:32', 0),
(1, 3, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:49:19', '2020-04-07 19:49:31', 0),
(1, 4, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:49:08', '2020-04-07 19:49:13', 0),
(1, 5, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:49:03', '2020-04-07 19:49:06', 0),
(1, 6, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-23 15:47:49', '2020-04-07 19:49:50', 0),
(1, 7, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:49:51', '2020-04-07 19:50:17', 0),
(1, 8, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-23 15:47:50', '2020-04-07 19:49:48', 0),
(1, 9, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:50:29', '2020-04-07 19:50:54', 0),
(1, 10, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:50:55', '2020-04-07 19:50:59', 0),
(1, 11, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:51:00', '2020-04-07 19:51:06', 0),
(1, 12, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-23 15:47:51', '2020-04-07 19:49:48', 0),
(1, 13, 1, 1, 1, 1, 1, 'kelvin', 'kelvin', '2020-04-30 10:32:51', '2020-04-30 10:32:57', 0),
(1, 14, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:48:57', '2020-04-07 19:49:01', 0),
(1, 16, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:51:07', '2020-04-07 19:51:10', 0),
(1, 17, 1, 1, 1, 1, 1, 'kelvin', 'kelvin', '2020-04-30 10:32:57', '2020-04-30 10:33:04', 0),
(1, 18, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 11:15:25', '2020-04-30 11:15:42', 0),
(1, 19, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 11:15:44', '2020-04-30 11:15:48', 0),
(1, 20, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 11:15:25', '2020-04-30 11:15:40', 0),
(1, 21, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 11:16:24', '2020-04-30 11:16:28', 0),
(1, 22, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 11:15:27', '2020-04-30 11:15:40', 0),
(1, 23, 1, 1, 1, 1, 1, 'Admin', 'kelvin', '2020-04-30 10:33:57', '2020-04-30 10:43:43', 0),
(1, 24, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 11:15:49', '2020-04-30 11:15:52', 0),
(1, 25, 1, 1, 1, 1, 1, 'Admin', 'kelvin', '2020-04-30 10:34:01', '2020-04-30 10:43:44', 0),
(1, 26, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:49:53', '2020-04-07 19:50:18', 0),
(1, 27, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-03 11:17:55', '2020-04-07 19:49:47', 0),
(1, 28, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 10:43:38', '2020-04-30 10:43:46', 0),
(1, 29, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 10:43:46', '2020-04-30 10:43:50', 0),
(1, 30, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 10:44:07', '2020-04-30 10:44:11', 0),
(1, 31, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 10:44:12', '2020-04-30 10:44:16', 0),
(1, 32, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-03 11:17:59', '2020-04-30 11:15:59', 0),
(1, 33, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 11:16:00', '2020-04-30 11:16:18', 0),
(1, 34, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-19 10:35:50', '2020-04-30 11:16:00', 0),
(1, 35, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 11:16:02', '2020-04-30 11:16:17', 0),
(1, 36, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 11:16:02', '2020-04-30 11:16:16', 0),
(1, 37, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:49:55', '2020-04-07 19:50:19', 0),
(1, 38, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-07 19:49:57', '2020-04-07 19:50:27', 0),
(1, 39, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 11:16:04', '2020-04-30 11:16:15', 0),
(1, 40, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 11:16:33', '2020-04-30 11:16:40', 0),
(1, 41, 1, 1, 1, 1, 1, 'kelvin', 'kelvin', '2020-04-30 10:33:09', '2020-04-30 10:33:13', 0),
(1, 42, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 11:16:33', '2020-04-30 11:16:40', 0),
(1, 43, 1, 1, 1, 1, 1, 'kelvin', 'kelvin', '2020-04-30 10:33:06', '2020-04-30 10:33:18', 0),
(1, 44, 1, 1, 1, 1, 1, 'kelvin', 'kelvin', '2020-04-30 10:33:22', '2020-04-30 10:33:26', 0),
(1, 45, 1, 1, 1, 1, 1, 'kelvin', 'kelvin', '2020-04-30 10:33:27', '2020-04-30 10:33:33', 0),
(1, 46, 1, 1, 1, 1, 1, 'kelvin', 'kelvin', '2020-04-30 10:33:35', '2020-04-30 10:33:37', 0),
(1, 47, 1, 1, 1, 1, 1, 'kelvin', 'kelvin', '2020-04-30 10:33:39', '2020-04-30 10:33:42', 0),
(1, 48, 1, 1, 1, 1, 1, 'kelvin', 'kelvin', '2020-04-30 10:33:48', '2020-04-30 10:33:53', 0),
(2, 8, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:35:45', '2020-03-31 09:35:49', 0),
(2, 9, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:36:04', '2020-03-31 09:36:08', 0),
(2, 10, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-23 15:48:04', '2020-03-23 15:48:10', 0),
(2, 11, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:36:14', '2020-03-31 09:36:21', 0),
(2, 16, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:36:21', '2020-03-31 09:36:26', 0),
(2, 17, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:36:31', '2020-03-31 09:36:37', 0),
(2, 18, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:36:39', '2020-03-31 09:36:43', 0),
(2, 19, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:36:43', '2020-03-31 09:36:47', 0),
(2, 20, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:36:48', '2020-03-31 09:36:53', 0),
(2, 21, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:36:56', '2020-03-31 09:37:01', 0),
(2, 22, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:37:05', '2020-03-31 09:37:09', 0),
(2, 23, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:37:10', '2020-03-31 09:37:14', 0),
(2, 24, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:37:15', '2020-03-31 09:37:21', 0),
(2, 25, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:37:23', '2020-03-31 09:37:26', 0),
(2, 26, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:35:57', '2020-03-31 09:36:01', 0),
(2, 28, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:37:28', '2020-03-31 09:37:35', 0),
(2, 29, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:37:35', '2020-03-31 09:37:38', 0),
(2, 30, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:37:41', '2020-03-31 09:37:47', 0),
(2, 31, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:37:48', '2020-03-31 09:37:55', 0),
(4, 6, 0, 0, 0, 0, 0, 'Admin', 'Admin', '2020-05-14 09:12:40', '2020-05-14 09:12:45', 0),
(4, 8, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:43:50', '2020-05-14 09:12:49', 0),
(4, 9, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:38:37', '2020-05-14 09:12:53', 0),
(4, 10, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:38:39', '2020-03-31 09:38:47', 0),
(4, 11, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:51:25', '2020-05-19 19:51:28', 0),
(4, 17, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-14 09:12:57', '2020-05-14 09:13:00', 0),
(4, 19, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-14 09:13:47', '2020-05-14 09:13:54', 0),
(4, 23, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-14 09:13:31', '2020-05-14 09:13:38', 0),
(4, 24, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-14 09:13:48', '2020-05-14 09:13:56', 0),
(4, 25, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-14 09:13:32', '2020-05-14 09:13:39', 0),
(4, 27, 0, 0, 0, 0, 0, 'Admin', 'Admin', '2020-05-14 09:13:01', '2020-05-14 09:13:02', 0),
(4, 28, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:38:54', '2020-03-31 09:39:09', 0),
(4, 29, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:38:53', '2020-03-31 09:39:10', 0),
(4, 30, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:38:51', '2020-03-31 09:39:11', 0),
(4, 31, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:38:50', '2020-03-31 09:39:12', 0),
(4, 43, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 15:25:37', '2020-04-30 15:25:40', 0),
(4, 44, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:51:17', '2020-05-19 19:51:22', 0),
(4, 45, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-14 09:13:18', '2020-05-14 09:13:22', 0),
(4, 46, 0, 0, 0, 0, 0, 'Admin', 'Admin', '2020-05-14 09:13:10', '2020-05-14 09:13:14', 0),
(4, 47, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 15:25:29', '2020-04-30 15:25:34', 0),
(5, 8, 0, 0, 0, 0, 0, 'Admin', 'Admin', '2020-03-31 09:39:32', '2020-04-30 15:24:22', 0),
(5, 9, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 15:24:24', '2020-04-30 15:24:27', 0),
(5, 11, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:39:41', '2020-04-30 15:24:40', 0),
(5, 16, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:39:42', '2020-04-30 15:24:41', 0),
(5, 17, 0, 0, 0, 0, 0, 'Admin', 'Admin', '2020-03-31 09:39:43', '2020-04-30 15:24:17', 0),
(5, 44, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 15:24:30', '2020-04-30 15:24:35', 0),
(5, 45, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-04-30 15:24:55', '2020-04-30 15:25:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `major`
--

CREATE TABLE `major` (
  `ID` int(11) NOT NULL,
  `Number` int(11) DEFAULT NULL,
  `MedicalFacility` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MedicalResults` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DOM` datetime DEFAULT NULL,
  `MCertificate` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DOC` datetime DEFAULT NULL,
  `Cost` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Type` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RepeatCost` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Others` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL,
  `UpdatedBy` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Approve_at` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=5461 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `major`
--

INSERT INTO `major` (`ID`, `Number`, `MedicalFacility`, `MedicalResults`, `DOM`, `MCertificate`, `DOC`, `Cost`, `Type`, `RepeatCost`, `Others`, `Status`, `Created_at`, `CreatedBy`, `Updated_at`, `UpdatedBy`, `Deleted`, `Approve_at`) VALUES
(1, 30487656, 'Crescent Medical', 'Pass', '2020-05-12 00:00:00', 'Issued', '2020-05-20 00:00:00', '4000', 'New', '', '', 'Approved', '2020-05-22 11:56:47', 'Admin', '0000-00-00 00:00:00', '0', 1, '2020-05-27 08:56:39'),
(2, 33487656, 'Dr. Martina', 'Pass', '2020-05-20 00:00:00', 'Issued', '2020-05-13 00:00:00', '4000', 'New', '', '', 'Pending Approval', '2020-05-26 11:12:38', 'Admin', '2020-05-26 11:13:29', 'Admin', 0, NULL),
(3, 30487656, 'Chaudhry', 'Pass', '2020-05-12 00:00:00', 'Issued', '2020-05-19 00:00:00', '4000', 'New', '', '', 'Approved', '2020-05-27 08:56:12', 'Admin', '0000-00-00 00:00:00', '0', 0, '2020-05-27 08:56:39');

-- --------------------------------------------------------

--
-- Table structure for table `majorapprovalcontacts`
--

CREATE TABLE `majorapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `majorapprovalcontacts`
--

INSERT INTO `majorapprovalcontacts` (`Name`, `Email`, `Mobile`, `Msg`, `IDNumber`) VALUES
('kelvin chemey', 'kelvinchemey@gmail.com', '+254700392599', 'Applicant', '30487656'),
('Kelvin Chemey', 'kserem20@gmail.com', '+254753710324', 'Applicant', '30487656');

-- --------------------------------------------------------

--
-- Table structure for table `major_approval_workflow`
--

CREATE TABLE `major_approval_workflow` (
  `ID` bigint(20) NOT NULL,
  `Number` bigint(20) NOT NULL,
  `Fullname` bigint(20) NOT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `major_approval_workflow`
--

INSERT INTO `major_approval_workflow` (`ID`, `Number`, `Fullname`, `Status`, `Approver`, `Remarks`, `Created_By`, `Approved_At`, `Created_At`) VALUES
(1, 30487656, 0, 'Approved', 'Admin', 'nnn', 'Admin', '2020-05-22 11:57:29', '2020-05-22 11:57:29'),
(2, 30487656, 0, 'Approved', 'Admin', 'welcome back', 'Admin', '2020-05-27 08:56:38', '2020-05-27 08:56:38'),
(3, 30487656, 0, 'Approved', 'Admin', 'welcome back', 'Admin', '2020-05-27 08:56:38', '2020-05-27 08:56:38');

-- --------------------------------------------------------

--
-- Table structure for table `medicalfacility`
--

CREATE TABLE `medicalfacility` (
  `MedID` int(11) NOT NULL,
  `Name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Description` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `Createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL,
  `UpdatedBy` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `medicalfacility`
--

INSERT INTO `medicalfacility` (`MedID`, `Name`, `Description`, `Created_at`, `Createdby`, `Updated_at`, `UpdatedBy`, `Deleted`) VALUES
(1, 'Crescent Medical', 'Crescent Medical', '2020-03-25 18:30:24', 'Admin', '0000-00-00 00:00:00', '0', 0),
(2, 'Chaudhry', 'Chaudhry', '2020-03-25 18:30:55', 'Admin', '0000-00-00 00:00:00', '0', 0),
(3, 'Dr. Martina', 'kisumu', '2020-04-03 11:39:25', 'Admin', '0000-00-00 00:00:00', '0', 0);

-- --------------------------------------------------------

--
-- Table structure for table `medicalform`
--

CREATE TABLE `medicalform` (
  `ID` int(11) NOT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DateGenerated` datetime DEFAULT NULL,
  `DateSent` datetime DEFAULT NULL,
  `Path` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Filename` varchar(105) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=4096 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `medicalform`
--

INSERT INTO `medicalform` (`ID`, `IDNumber`, `DateGenerated`, `DateSent`, `Path`, `Filename`, `Created_By`) VALUES
(5, '30487656', '2020-05-17 11:57:37', NULL, 'MedicalForms/', '30487656.pdf', 'Admin'),
(6, '30487656', '2020-05-17 15:17:12', NULL, 'MedicalForms/', '30487656.pdf', 'Admin'),
(7, '30476567', '2020-05-17 15:19:39', NULL, 'MedicalForms/', '30476567.pdf', 'Admin'),
(8, NULL, '2020-05-17 19:59:42', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(9, NULL, '2020-05-17 20:00:56', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(10, NULL, '2020-05-17 20:03:12', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(11, NULL, '2020-05-17 20:03:33', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(12, NULL, '2020-05-17 20:03:34', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(13, NULL, '2020-05-17 20:05:15', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(14, NULL, '2020-05-17 20:08:41', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(15, NULL, '2020-05-17 20:12:31', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(16, NULL, '2020-05-17 20:15:53', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(17, NULL, '2020-05-17 20:16:07', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(18, NULL, '2020-05-17 20:17:00', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(19, NULL, '2020-05-17 20:17:07', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(20, NULL, '2020-05-17 20:17:07', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(21, NULL, '2020-05-17 20:18:13', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(22, NULL, '2020-05-17 20:19:09', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(23, '30476567', '2020-05-17 20:20:05', NULL, 'MedicalForms/', '30476567.pdf', 'Admin'),
(24, NULL, '2020-05-17 20:20:51', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(25, NULL, '2020-05-17 20:24:14', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin'),
(26, NULL, '2020-05-17 20:25:38', NULL, 'MedicalForms/', 'undefined.pdf', 'Admin');

-- --------------------------------------------------------

--
-- Table structure for table `minorapprovalcontacts`
--

CREATE TABLE `minorapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `minorapprovalcontacts`
--

INSERT INTO `minorapprovalcontacts` (`Name`, `Email`, `Mobile`, `Msg`, `IDNumber`) VALUES
('kelvin chemey', 'kelvinchemey@gmail.com', '+254700392599', 'Applicant', '30487656'),
('Kelvin Chemey', 'kserem20@gmail.com', '254700392599', 'Applicant', '30487656');

-- --------------------------------------------------------

--
-- Table structure for table `minormedical`
--

CREATE TABLE `minormedical` (
  `ID` int(11) NOT NULL,
  `Number` int(11) DEFAULT NULL,
  `DOM` datetime DEFAULT NULL,
  `MedicalFacility` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Result` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Cost` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Type` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RepeatCost` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Others` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `UpdateBy` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Approve_at` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `minormedical`
--

INSERT INTO `minormedical` (`ID`, `Number`, `DOM`, `MedicalFacility`, `Result`, `Cost`, `Type`, `RepeatCost`, `Others`, `Status`, `Created_at`, `CreatedBy`, `UpdateBy`, `Updated_at`, `Deleted`, `Approve_at`) VALUES
(1, 30487656, '2020-05-12 00:00:00', 'Crescent Medical', 'Pass', '500', 'New', '', '89', 'Approved', '2020-05-26 15:40:17', 'Admin', '0', '0000-00-00 00:00:00', 0, '2020-05-26 15:40:39'),
(2, 30486756, '2020-06-17 00:00:00', 'Chaudhry', 'Pass', '500', 'New', '', '78', 'Pending Approval', '2020-06-08 15:38:49', 'Admin', '0', '0000-00-00 00:00:00', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `minormedicalapprovalcontacts`
--

CREATE TABLE `minormedicalapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `minormedicalbuffer`
--

CREATE TABLE `minormedicalbuffer` (
  `Fullname` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DOM` date DEFAULT NULL,
  `MedicalFacility` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Cost` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `minormedicalbuffer`
--

INSERT INTO `minormedicalbuffer` (`Fullname`, `IDNumber`, `Number`, `DOM`, `MedicalFacility`, `Type`, `Cost`, `Created_at`) VALUES
('Kelvin Chemey', '30487656', '30487656', '2020-05-12', 'Crescent Medical', 'New', '500', '2020-05-26 15:40:17'),
('Kelvin Chemey', '30486756', '30486756', '2020-06-17', 'Chaudhry', 'New', '500', '2020-06-08 15:38:49');

-- --------------------------------------------------------

--
-- Table structure for table `minormedical_approval_workflow`
--

CREATE TABLE `minormedical_approval_workflow` (
  `ID` bigint(20) NOT NULL,
  `Number` bigint(20) NOT NULL,
  `Fullname` bigint(20) NOT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `minormedical_approval_workflow`
--

INSERT INTO `minormedical_approval_workflow` (`ID`, `Number`, `Fullname`, `Status`, `Approver`, `Remarks`, `Created_By`, `Approved_At`, `Created_At`) VALUES
(1, 30487656, 0, 'Approved', 'Admin', 'yuuu', 'Admin', '2020-05-26 15:40:39', '2020-05-26 15:40:39');

-- --------------------------------------------------------

--
-- Table structure for table `neaa`
--

CREATE TABLE `neaa` (
  `ID` int(11) NOT NULL,
  `Number` int(11) DEFAULT NULL,
  `DOS` datetime DEFAULT NULL,
  `Approved_Status` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DOA` datetime DEFAULT NULL,
  `Reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RDate` datetime DEFAULT NULL,
  `Status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL,
  `UpdatedBy` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Approve_at` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=10922 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `neaa`
--

INSERT INTO `neaa` (`ID`, `Number`, `DOS`, `Approved_Status`, `DOA`, `Reason`, `RDate`, `Status`, `Created_at`, `CreatedBy`, `Updated_at`, `UpdatedBy`, `Deleted`, `Approve_at`) VALUES
(1, 33487656, '2020-05-26 00:00:00', 'Approved', NULL, '', '0000-00-00 00:00:00', 'Pending Approval', '2020-05-26 11:46:03', 'Admin', '0000-00-00 00:00:00', '0', 0, NULL),
(2, 30487656, '2020-05-11 00:00:00', 'Approved', NULL, '', '0000-00-00 00:00:00', 'Approved', '2020-05-27 09:09:50', 'Admin', '0000-00-00 00:00:00', '0', 0, '2020-05-27 09:11:47');

-- --------------------------------------------------------

--
-- Table structure for table `neaapprovalcontacts`
--

CREATE TABLE `neaapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `neaapprovalcontacts`
--

INSERT INTO `neaapprovalcontacts` (`Name`, `Email`, `Mobile`, `Msg`, `IDNumber`) VALUES
('kelvin chemey', 'kelvinchemey@gmail.com', '+254700392599', 'Applicant', '30487656'),
('Kelvin Chemey', 'kserem20@gmail.com', '+254753710324', 'Applicant', '30487656');

-- --------------------------------------------------------

--
-- Table structure for table `neaa_approval_workflow`
--

CREATE TABLE `neaa_approval_workflow` (
  `ID` bigint(20) NOT NULL,
  `Number` bigint(20) NOT NULL,
  `Fullname` bigint(20) NOT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `neaa_approval_workflow`
--

INSERT INTO `neaa_approval_workflow` (`ID`, `Number`, `Fullname`, `Status`, `Approver`, `Remarks`, `Created_By`, `Approved_At`, `Created_At`) VALUES
(1, 30487656, 0, 'Approved', 'Admin', 'tyy', 'Admin', '2020-05-27 09:11:47', '2020-05-27 09:11:47');

-- --------------------------------------------------------

--
-- Table structure for table `nextofkin`
--

CREATE TABLE `nextofkin` (
  `ID` int(11) NOT NULL,
  `IDNumber` int(11) DEFAULT NULL,
  `KinName` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `KRelationship` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CurrentResident` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Contact` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2730 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nextofkin`
--

INSERT INTO `nextofkin` (`ID`, `IDNumber`, `KinName`, `KRelationship`, `CurrentResident`, `Contact`, `Created_at`, `CreatedBy`, `Deleted`) VALUES
(1, 30487656, 'john tenai', 'Mother', 'ngando', '080000000', '2020-05-19 20:10:30', 'Admin', 0);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `ID` int(11) NOT NULL,
  `Username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Category` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Description` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Created_At` datetime NOT NULL,
  `DueDate` datetime NOT NULL,
  `Status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`ID`, `Username`, `Category`, `Description`, `Created_At`, `DueDate`, `Status`, `IDNumber`) VALUES
(1, 'Admin', 'DCI Approval', 'DCI pending approval', '2020-05-26 21:10:28', '2020-05-31 21:10:28', 'Resolved', ''),
(2, 'Admin', 'Major Medical Approval', 'Major pending approval', '2020-05-27 08:56:13', '2020-05-30 08:56:13', 'Resolved', '30487656'),
(3, 'Admin', 'NEA Approval', 'NEA pending approval', '2020-05-27 09:09:51', '2020-06-01 09:09:51', 'Resolved', '30487656'),
(4, 'Admin', 'Contract Processing Approval', 'Contract pending approval', '2020-05-27 09:14:12', '2020-06-01 09:14:12', 'Resolved', ''),
(5, 'Admin', 'Passport Approval', 'Passport pending approval', '2020-05-27 09:34:55', '2020-06-10 09:34:55', 'Resolved', ''),
(6, 'Admin', 'Visa Approval', 'Visa pending approval', '2020-05-27 09:39:31', '2020-06-01 09:39:31', 'Resolved', '30487656'),
(8, 'Admin', 'Attestation Approval', 'Attestation pending approval', '2020-05-27 10:06:45', '2020-06-01 10:06:45', 'Resolved', '30487656'),
(9, 'Admin', 'Ticketing Approval', 'Ticketing pending approval', '2020-05-27 10:28:22', '2020-06-01 10:28:22', 'Resolved', '30487656'),
(10, 'Admin', 'Final Medical Approval ', 'Final Medical pending approval', '2020-05-27 10:39:23', '2020-06-01 10:39:23', 'Resolved', '30487656'),
(11, 'Admin', 'Travelling Approval', 'Travel pending approval', '2020-05-27 10:41:57', '2020-06-01 10:41:57', 'Resolved', '30487656'),
(12, 'Admin', 'Applications Approval', 'Applications pending approval', '2020-06-08 15:16:49', '2020-06-11 15:16:49', 'Resolved', '30486756'),
(13, 'Admin', 'Minor Medical Approval', 'MinorMedical pending approval', '2020-06-08 15:38:49', '2020-06-11 15:38:49', 'Not Resolved', ''),
(14, 'kavethe', 'Minor Medical Approval', 'MinorMedical pending approval', '2020-06-08 15:38:49', '2020-06-11 15:38:49', 'Not Resolved', ''),
(16, 'Admin', 'DCI Approval', 'DCI pending approval', '2020-06-08 20:01:34', '2020-06-13 20:01:34', 'Not Resolved', ''),
(17, 'Admin', 'Passport Approval', 'Passport pending approval', '2020-06-08 20:03:28', '2020-06-22 20:03:28', 'Not Resolved', ''),
(18, 'Admin', 'Contract Processing Approval', 'Contract pending approval', '2020-06-08 20:03:57', '2020-06-13 20:03:57', 'Not Resolved', '');

-- --------------------------------------------------------

--
-- Table structure for table `parents`
--

CREATE TABLE `parents` (
  `ID` int(11) NOT NULL,
  `IDNumber` int(11) DEFAULT NULL,
  `Name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ParentID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Relationship` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `parents`
--

INSERT INTO `parents` (`ID`, `IDNumber`, `Name`, `ParentID`, `Relationship`, `Created_at`, `CreatedBy`, `Deleted`) VALUES
(1, 30487656, 'john tenai', '30487656', 'Father', '2020-05-19 20:10:02', 'Admin', 0);

-- --------------------------------------------------------

--
-- Table structure for table `passport`
--

CREATE TABLE `passport` (
  `ID` int(11) NOT NULL,
  `Number` int(11) DEFAULT NULL,
  `POD` datetime DEFAULT NULL,
  `Tracking_Number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Passport_Status` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Passport_Collection_Date` datetime DEFAULT NULL,
  `PassPortNumber` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PassportOption` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Cost` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CostIncurred` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Location` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL,
  `CreatedBy` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL,
  `UpdatedBy` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Approve_at` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `passport`
--

INSERT INTO `passport` (`ID`, `Number`, `POD`, `Tracking_Number`, `Passport_Status`, `Status`, `Passport_Collection_Date`, `PassPortNumber`, `PassportOption`, `Cost`, `CostIncurred`, `Location`, `Created_At`, `CreatedBy`, `Updated_at`, `UpdatedBy`, `Deleted`, `Approve_at`) VALUES
(1, 30487656, '2020-05-12 00:00:00', '677', 'Approved', 'Collected', '2020-05-13 00:00:00', 'NNNN', 'New', '777', '777', 'Nairobi', '2020-05-27 09:34:55', 'Admin', '0000-00-00 00:00:00', '0', 0, '2020-05-27 09:35:13'),
(2, 30486756, '2020-06-15 00:00:00', '677', 'Pending Approval', 'Collected', '2020-06-16 00:00:00', 'NNNN', 'New', '777', '777', 'Nairobi', '2020-06-08 20:03:28', 'Admin', '0000-00-00 00:00:00', '0', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `passportapprovalcontacts`
--

CREATE TABLE `passportapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `passportapprovalcontacts`
--

INSERT INTO `passportapprovalcontacts` (`Name`, `Email`, `Mobile`, `Msg`, `IDNumber`) VALUES
('kelvin chemey', 'kelvinchemey@gmail.com', '+254700392599', 'Applicant', '30487656'),
('Kelvin Chemey', 'kserem20@gmail.com', '+254753710324', 'Applicant', '30487656');

-- --------------------------------------------------------

--
-- Table structure for table `passportbuffer`
--

CREATE TABLE `passportbuffer` (
  `Fullname` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `POD` date DEFAULT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Passport_Collection_Date` date DEFAULT NULL,
  `PassPortNumber` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Cost` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PassportOption` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Location` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `passportbuffer`
--

INSERT INTO `passportbuffer` (`Fullname`, `IDNumber`, `Number`, `POD`, `Status`, `Passport_Collection_Date`, `PassPortNumber`, `Cost`, `PassportOption`, `Location`, `Created_at`) VALUES
('martina Kalunde', '34564577', '34564577', '2020-04-14', 'Issued', '2020-04-07', '7890-', '4606', 'New', 'nairobi', '2020-04-11 13:52:49'),
('martina Kalunde', '34564577', '34564577', '2020-04-14', 'Issued', '2020-04-07', '7890-', '4606', 'New', 'nairobi', '2020-04-11 13:52:49');

-- --------------------------------------------------------

--
-- Table structure for table `passport_approval_workflow`
--

CREATE TABLE `passport_approval_workflow` (
  `ID` bigint(20) NOT NULL,
  `Number` bigint(20) NOT NULL,
  `Fullname` bigint(20) NOT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `passport_approval_workflow`
--

INSERT INTO `passport_approval_workflow` (`ID`, `Number`, `Fullname`, `Status`, `Approver`, `Remarks`, `Created_By`, `Approved_At`, `Created_At`) VALUES
(1, 30487656, 0, 'Approved', 'Admin', 'nn', 'Admin', '2020-05-27 09:35:13', '2020-05-27 09:35:13');

-- --------------------------------------------------------

--
-- Table structure for table `processing`
--

CREATE TABLE `processing` (
  `ItemID` int(11) NOT NULL,
  `ItemName` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `questionnaire`
--

CREATE TABLE `questionnaire` (
  `ID` int(11) DEFAULT NULL,
  `Number` int(11) DEFAULT NULL,
  `WorkAbroad` tinyint(1) DEFAULT NULL,
  `RelativeWorkAbroad` tinyint(1) DEFAULT NULL,
  `AccusedOfCrime` tinyint(1) DEFAULT NULL,
  `TravellingForWork` tinyint(1) DEFAULT NULL,
  `DeniedVisa` tinyint(1) DEFAULT NULL,
  `Accident` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `registration`
--

CREATE TABLE `registration` (
  `IDNumber` int(11) NOT NULL,
  `Fullname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Gender` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Phone` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DOB` datetime DEFAULT NULL,
  `Email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Country` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `County` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Village` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Religion` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Marital` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Height` float DEFAULT NULL,
  `Weight` float DEFAULT NULL,
  `photo` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FullPhoto` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BirthCer` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Husband` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `HusbandMobile` int(11) DEFAULT NULL,
  `HusbandID` int(11) DEFAULT NULL,
  `Languages` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Skills` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Classify` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Agent` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Job` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL,
  `Updated_by` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Approve_at` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=3276 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `registration`
--

INSERT INTO `registration` (`IDNumber`, `Fullname`, `Gender`, `Phone`, `DOB`, `Email`, `Country`, `County`, `Village`, `Religion`, `Marital`, `Height`, `Weight`, `photo`, `FullPhoto`, `BirthCer`, `Husband`, `HusbandMobile`, `HusbandID`, `Languages`, `Skills`, `Classify`, `Agent`, `Job`, `Status`, `Created_at`, `CreatedBy`, `Updated_at`, `Updated_by`, `Deleted`, `Approve_at`) VALUES
(30486756, 'Kelvin Chemey', 'Male', '25700392599', '2020-06-16 00:00:00', 'kelvinchemey@gmail.c', 'Kenya', 'KWALE', 'olaare', 'Islam', 'Single', 561, 78, '', '', '7878', '', 0, 0, 'ertyuj', '788', 'Refferal', 'james', 'kelivin', 'Approved', '2020-06-08 15:16:49', 'Admin', '0000-00-00 00:00:00', '0', 0, '2020-06-08 15:44:17'),
(30487656, 'Kelvin Chemey', 'Male', '+254753710324', '2020-05-26 00:00:00', 'kserem20@gmail.com', 'Kenya', 'MOMBASA', 'olaare', 'Christianity', 'Single', 561, 788, '', '', '789', '', 0, 0, 'ertyuj', 'Developers', 'Walkin', '', 'kelivin', 'Approved', '2020-05-26 14:01:58', 'Admin', '0000-00-00 00:00:00', '0', 0, '2020-05-26 14:03:30');

-- --------------------------------------------------------

--
-- Table structure for table `registrationapprovalworkflow`
--

CREATE TABLE `registrationapprovalworkflow` (
  `ID` int(11) NOT NULL,
  `IDNUMber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `UserName` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Role` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_At` datetime DEFAULT NULL,
  `Updated_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=1638 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `registrationdocuments`
--

CREATE TABLE `registrationdocuments` (
  `ID` bigint(20) NOT NULL,
  `IDNumber` int(100) NOT NULL,
  `DocName` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Description` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `registrationdocuments`
--

INSERT INTO `registrationdocuments` (`ID`, `IDNumber`, `DocName`, `Description`, `Path`, `Created_At`, `Created_By`, `Deleted`) VALUES
(1, 34487656, '', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-11 08:50:30', 'Admin', 0),
(2, 34487656, '1589176232122-covid(2).pdf', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-11 08:50:34', 'Admin', 0),
(3, 30564567, '1589823256743-RMS Attestation Clearance.pdf', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-18 20:34:18', 'Admin', 0),
(4, 30564567, '1589823256743-RMS Attestation Clearance.pdf', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-18 20:34:21', 'Admin', 0),
(5, 30564567, '1589823256743-RMS Attestation Clearance.pdf', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-18 20:34:25', 'Admin', 0),
(6, 30564567, '1589823256743-RMS Attestation Clearance.pdf', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-18 20:34:25', 'Admin', 0),
(7, 30564567, '1589823256743-RMS Attestation Clearance.pdf', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-18 20:34:26', 'Admin', 0),
(8, 30564567, '1589823267090-RMS Attestation Clearance.pdf', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-18 20:34:28', 'Admin', 0),
(9, 30564567, '1589823273121-RMS Attestation Clearance.pdf', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-18 20:34:33', 'Admin', 0),
(10, 30564567, '1589823273121-RMS Attestation Clearance.pdf', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-18 20:34:35', 'Admin', 0),
(11, 30564567, '1589823283584-RMS Attestation Clearance.pdf', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-18 20:34:44', 'Admin', 0),
(12, 4567894, '1589825602736-Login.png', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-18 21:13:24', 'Admin', 0),
(13, 4567894, '1589825602736-Login.png', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-18 21:13:26', 'Admin', 0),
(14, 30487656, '1589908284880-covid(1).pdf', 'kelvin chemey', 'http://127.0.0.1:3001/Document', '2020-05-19 20:11:26', 'Admin', 0);

-- --------------------------------------------------------

--
-- Table structure for table `requesthandledbuffer`
--

CREATE TABLE `requesthandledbuffer` (
  `IDNumber` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Phone` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `County` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Fullname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=3276 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `requesthandledbuffer`
--

INSERT INTO `requesthandledbuffer` (`IDNumber`, `Phone`, `DOB`, `Created_at`, `County`, `Fullname`) VALUES
('30487656', '345678000', '2020-04-14', '2020-04-05 14:39:43', 'KILIFI', 'Kim kirwa'),
('33487656', '700392599', '2020-04-15', '2020-04-01 15:03:04', 'KWALE', 'kelvin chemey'),
('34564577', '724083037', '1984-08-29', '2020-04-03 20:42:11', 'Nairobi', 'martina Kalunde'),
('35487656', '70494949', '2020-04-22', '2020-04-10 15:46:58', 'KWALE', 'Kim kirwa'),
('38487656', '788900000', '2020-04-14', '2020-04-10 20:42:18', 'KWALE', 'Kim kirwa'),
('30487656', '254700392599', '2020-05-26', '2020-05-26 14:01:58', 'MOMBASA', 'Kelvin Chemey'),
('30487656', '345678000', '2020-04-14', '2020-04-05 14:39:43', 'KILIFI', 'Kim kirwa'),
('33487656', '700392599', '2020-04-15', '2020-04-01 15:03:04', 'KWALE', 'kelvin chemey'),
('34564577', '724083037', '1984-08-29', '2020-04-03 20:42:11', 'Nairobi', 'martina Kalunde'),
('35487656', '70494949', '2020-04-22', '2020-04-10 15:46:58', 'KWALE', 'Kim kirwa'),
('38487656', '788900000', '2020-04-14', '2020-04-10 20:42:18', 'KWALE', 'Kim kirwa');

-- --------------------------------------------------------

--
-- Table structure for table `requesthandledbuffer1`
--

CREATE TABLE `requesthandledbuffer1` (
  `IDNumber` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Phone` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `County` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Fullname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `requesthandledbuffer1`
--

INSERT INTO `requesthandledbuffer1` (`IDNumber`, `Phone`, `DOB`, `Created_at`, `County`, `Fullname`) VALUES
('30486756', '25700392599', '2020-06-16', '2020-06-08 15:16:49', 'KWALE', 'Kelvin Chemey'),
('30487656', '+254753710324', '2020-05-26', '2020-05-26 14:01:58', 'MOMBASA', 'Kelvin Chemey');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `RoleID` bigint(20) NOT NULL,
  `RoleName` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RoleDescription` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `UpdateBy` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CreateBy` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CreatedAt` datetime NOT NULL,
  `UpdatedAt` datetime NOT NULL,
  `Deleted` tinyint(1) NOT NULL,
  `Category` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=341 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`RoleID`, `RoleName`, `RoleDescription`, `UpdateBy`, `CreateBy`, `CreatedAt`, `UpdatedAt`, `Deleted`, `Category`) VALUES
(1, 'System Users', 'System Users ', 'Admin', 'user', '2019-06-27 17:30:15', '2020-03-17 09:12:02', 0, 'Admin'),
(2, 'Roles', 'Security roles', 'user', 'user', '2019-06-27 17:30:36', '2019-06-27 17:30:36', 0, 'Admin'),
(3, 'Security Groups', 'Security groups', 'user', 'user', '2019-06-27 17:31:08', '2019-06-27 17:31:08', 0, 'Admin'),
(4, 'Assign Group Access', 'Assign Group Access', 'Admin', 'user', '2019-06-27 17:31:29', '2020-05-12 09:38:52', 0, 'Admin'),
(5, 'Audit Trails', 'Audit Trails', 'user', 'user', '2019-06-27 17:31:57', '2019-06-27 17:31:57', 0, 'Admin'),
(6, 'System Administration', 'System Administration', 'Admin', 'Admin', '2019-07-26 12:02:56', '2019-07-26 12:02:56', 0, 'Menus'),
(7, 'Fees Settings', 'Fees Settings', 'Admin', 'Admin', '2019-07-26 12:03:16', '2019-07-26 12:03:16', 0, 'Systemparameteres'),
(8, 'Recruitment', 'Recruitment', 'Admin', 'Admin', '2019-07-26 12:03:33', '2019-07-26 12:03:33', 0, 'Menus'),
(9, 'Hr Pool', 'Hr Pool', 'Admin', 'Admin', '2019-07-26 12:03:57', '2019-07-26 12:03:57', 0, 'Menus'),
(10, 'Minor Medical', 'Minor Medical', 'Admin', 'Admin', '2019-07-26 12:04:10', '2019-07-26 12:04:10', 0, 'Medical'),
(11, 'DCI Clearance', 'DCI Clearance', 'Admin', 'Admin', '2019-07-26 12:04:23', '2019-07-26 12:04:23', 0, 'Administration'),
(12, 'Reports', 'Reports', 'Admin', 'Admin', '2019-07-26 12:04:36', '2019-07-26 12:04:36', 0, 'Menus'),
(13, 'Dashboard', 'DashBoards', 'Admin', 'Admin', '2019-07-26 15:19:29', '2019-07-26 15:19:29', 0, 'Menus'),
(14, 'Assign User Access', 'Assign User Access', 'Admin', 'Admin', '2019-07-29 11:03:54', '2019-07-29 11:03:57', 0, 'Admin'),
(15, 'System Configurations', 'System Configurations', 'Admin', 'Admin', '2019-07-29 14:07:47', '2019-07-29 14:07:47', 0, NULL),
(16, 'Passport processing', 'Passport Processing', 'Admin', 'Admin', '2019-07-31 16:59:11', '2019-07-31 16:59:11', 0, 'Administration'),
(17, 'Training', 'Training', 'Admin', 'Admin', '2019-08-01 10:21:59', '2019-08-01 10:21:59', 0, 'Menus'),
(18, 'Contract Processing', 'Contract Processing', 'Admin', 'Admin', '2019-08-01 10:25:18', '2019-08-01 10:25:18', 0, 'Employement'),
(19, 'Major Medical', 'Major Medical', 'Admin', 'Admin', '2019-08-01 10:49:11', '2019-08-01 10:49:11', 0, 'Medical'),
(20, 'NEAA', 'NEAA', 'Admin', 'Admin', '2019-08-01 11:41:30', '2019-08-01 11:41:30', 0, 'Employement'),
(21, 'Visa Prcoessing', 'Visa Prcoessing', 'Admin', 'Admin', '2019-08-01 13:32:48', '2019-08-01 13:32:48', 0, 'Administration'),
(22, 'Attestation', 'Attestation', 'Admin', 'Admin', '2019-08-05 14:06:38', '2019-08-05 14:06:38', 0, 'Employement'),
(23, 'Ticketing', 'Ticketing', 'Admin', 'Admin', '2019-08-05 14:44:33', '2019-08-05 14:44:33', 0, 'Recruitment'),
(24, 'Final Medical', 'Final Medical', 'Admin', 'Admin', '2019-08-06 14:20:29', '2019-08-06 14:20:29', 0, 'Medical'),
(25, 'Travelling', 'Travelling', 'Admin', 'Admin', '2019-08-06 14:34:26', '2019-08-06 14:34:26', 0, 'Recruitment'),
(26, 'Facility', 'Facility', 'Admin', 'Admin', '2019-08-06 14:34:26', '2019-08-06 14:34:26', 0, 'Systemparameteres'),
(27, 'System parameteres', 'System parameteres', 'Admin', 'Admin', '2019-08-06 14:34:26', '2019-08-06 14:34:26', 0, 'Menus'),
(28, 'Educational', 'Educational details', 'Admin', 'Admin', '2020-03-18 08:48:19', '2020-03-18 08:48:19', 0, 'Recruitment'),
(29, 'Parent', 'parent ', 'Admin', 'Admin', '2020-03-18 09:49:45', '2020-03-18 09:49:45', 0, 'Recruitment'),
(30, 'NextOFKin', 'NextOFKin', 'Admin', 'Admin', '2020-03-18 10:08:57', '2020-03-18 10:08:57', 0, 'Recruitment'),
(31, 'Siblings', 'Siblings', 'Admin', 'Admin', '2020-03-19 15:20:39', '2020-03-19 15:20:39', 0, 'Recruitment'),
(32, 'Monthly', 'Monthly registration', 'Admin', 'Admin', '2020-04-02 14:31:58', '2020-04-02 14:31:58', 0, 'Analytics'),
(33, 'Custom Reports', 'Custom Reports', 'Admin', 'Admin', '2020-04-02 14:32:25', '2020-04-02 14:32:25', 0, 'Reports'),
(34, 'Total Cost', 'Total Cost', 'Admin', 'Admin', '2020-04-02 14:33:20', '2020-04-02 14:33:20', 0, 'Analytics'),
(35, 'Travelled Applicant', 'Travelled Applicants', 'Admin', 'Admin', '2020-04-02 14:34:10', '2020-04-02 14:34:10', 0, 'Reports'),
(36, 'Applicants Profile', 'Applicants Profile', 'Admin', 'Admin', '2020-04-02 14:34:35', '2020-04-02 14:34:35', 0, 'Reports'),
(37, 'Country', 'Country', 'Admin', 'Admin', '2020-04-07 16:30:29', '2020-04-07 16:30:29', 0, 'Systemparameteres'),
(38, 'County', 'County', 'Admin', 'Admin', '2020-04-07 16:30:57', '2020-04-07 16:30:57', 0, 'Systemparameteres'),
(39, 'Daily Report', 'Daily Report', 'Admin', 'Admin', '2020-04-15 13:08:55', '2020-04-15 13:08:55', 0, 'Reports'),
(40, 'Weekly Report', 'Weekly Report', 'Admin', 'Admin', '2020-04-15 13:09:26', '2020-04-15 13:09:26', 0, 'Reports'),
(41, 'Analytics', 'Analytics', 'Admin', 'Admin', '2020-04-18 13:02:43', '2020-04-18 13:02:43', 0, 'Menus'),
(42, 'Registration Reports', 'Registration Reports', 'Admin', 'Admin', '2020-04-18 13:03:13', '2020-04-18 13:03:13', 0, 'Reports'),
(43, 'Employement', 'Employement', 'Admin', 'Admin', '2020-04-29 19:23:17', '2020-04-29 19:23:17', 0, 'Menus'),
(44, 'Registration', 'Registration', 'Admin', 'Admin', '2020-04-29 19:23:47', '2020-04-29 19:23:47', 0, 'HrPool'),
(45, 'Administration', 'Administration', 'Admin', 'Admin', '2020-04-29 19:24:17', '2020-04-29 19:24:17', 0, 'Menus'),
(46, 'Travel', 'Travel', 'Admin', 'Admin', '2020-04-29 19:24:36', '2020-04-29 19:24:36', 0, 'Menus'),
(47, 'Medical', 'Medical', 'Admin', 'Admin', '2020-04-29 19:25:17', '2020-04-29 19:25:17', 0, 'Menus'),
(48, 'Airlines', 'Airlines', 'Admin', 'Admin', '2020-04-29 19:25:42', '2020-04-29 19:25:42', 0, 'Systemparameteres'),
(48, 'Approvers', 'Approvers', 'Admin', 'Admin', '2020-05-04 10:15:53', '2020-05-04 10:15:53', 0, 'Admin');

-- --------------------------------------------------------

--
-- Table structure for table `siblings`
--

CREATE TABLE `siblings` (
  `ID` int(11) NOT NULL,
  `IDNumber` int(11) DEFAULT NULL,
  `SiblingName` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Sex` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Age` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `Created_by` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=3276 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `siblings`
--

INSERT INTO `siblings` (`ID`, `IDNumber`, `SiblingName`, `Sex`, `Age`, `Created_at`, `Created_by`, `Deleted`) VALUES
(1, 30487656, 'mary', 'male', '67', '2020-05-19 20:10:50', 'Admin', 0);

-- --------------------------------------------------------

--
-- Table structure for table `smsdetails`
--

CREATE TABLE `smsdetails` (
  `ID` int(11) NOT NULL,
  `UserName` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `URL` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Key` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `smsdetails`
--

INSERT INTO `smsdetails` (`ID`, `UserName`, `URL`, `Key`) VALUES
(1, 'yonney', 'http://api.infobip.com/sms/1/text/query?', 'H83wqK9yfDH$dF4');

-- --------------------------------------------------------

--
-- Table structure for table `smtpdetails`
--

CREATE TABLE `smtpdetails` (
  `ID` int(11) NOT NULL,
  `Host` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Port` int(255) DEFAULT NULL,
  `Sender` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `smtpdetails`
--

INSERT INTO `smtpdetails` (`ID`, `Host`, `Port`, `Sender`, `Password`) VALUES
(1, 'smtp.gmail.com', 465, 'rmsjobmajuu20@gmail.com', 'Job@2020');

-- --------------------------------------------------------

--
-- Table structure for table `ticketapprovalcontacts`
--

CREATE TABLE `ticketapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ticketapprovalcontacts`
--

INSERT INTO `ticketapprovalcontacts` (`Name`, `Email`, `Mobile`, `Msg`, `IDNumber`) VALUES
('Kelvin Chemey', 'kserem20@gmail.com', '+254753710324', 'Applicant', '30487656');

-- --------------------------------------------------------

--
-- Table structure for table `ticketing`
--

CREATE TABLE `ticketing` (
  `ID` int(11) NOT NULL,
  `Number` int(11) DEFAULT NULL,
  `Ticket_status` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Flight_Date` datetime DEFAULT NULL,
  `Destination` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Airline` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Cost` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL,
  `UpdatedBy` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Approve_at` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=16384 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ticketing`
--

INSERT INTO `ticketing` (`ID`, `Number`, `Ticket_status`, `Flight_Date`, `Destination`, `Airline`, `Cost`, `Status`, `Created_at`, `CreatedBy`, `Updated_at`, `UpdatedBy`, `Deleted`, `Approve_at`) VALUES
(1, 30487656, 'Booked', '2020-05-11 00:00:00', '5666', '566', '777', 'Approved', '2020-05-27 10:28:22', '0', '0000-00-00 00:00:00', '0', 0, '2020-05-27 10:30:40');

-- --------------------------------------------------------

--
-- Table structure for table `ticketing_approval_workflow`
--

CREATE TABLE `ticketing_approval_workflow` (
  `ID` bigint(20) NOT NULL,
  `Number` bigint(20) NOT NULL,
  `Fullname` bigint(20) NOT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ticketing_approval_workflow`
--

INSERT INTO `ticketing_approval_workflow` (`ID`, `Number`, `Fullname`, `Status`, `Approver`, `Remarks`, `Created_By`, `Approved_At`, `Created_At`) VALUES
(1, 30487656, 0, 'Approved', 'Admin', 'mmm', 'Admin', '2020-05-27 10:28:35', '2020-05-27 10:28:35'),
(2, 30487656, 0, 'Approved', 'Admin', 'mmmnnn', 'Admin', '2020-05-27 10:30:10', '2020-05-27 10:30:10'),
(3, 30487656, 0, 'Approved', 'Admin', 'mmmnnn', 'Admin', '2020-05-27 10:30:40', '2020-05-27 10:30:40');

-- --------------------------------------------------------

--
-- Table structure for table `training`
--

CREATE TABLE `training` (
  `ID` int(11) NOT NULL,
  `Number` int(11) DEFAULT NULL,
  `COM` datetime DEFAULT NULL,
  `EOM` datetime DEFAULT NULL,
  `Training_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Transcript_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DOF` datetime DEFAULT NULL,
  `Cost` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL,
  `Updatedby` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Approve_at` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=4681 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `training`
--

INSERT INTO `training` (`ID`, `Number`, `COM`, `EOM`, `Training_status`, `Transcript_status`, `DOF`, `Cost`, `Status`, `Created_at`, `CreatedBy`, `Updated_at`, `Updatedby`, `Deleted`, `Approve_at`) VALUES
(1, 33487656, '2020-05-26 00:00:00', '2020-05-26 00:00:00', 'completed', 'issued', '2020-05-26 00:00:00', '0', 'Pending Approval', '2020-05-26 11:36:02', 'Admin', '0000-00-00 00:00:00', '0', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `trainingapprovalcontacts`
--

CREATE TABLE `trainingapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `trainingapprovalcontacts`
--

INSERT INTO `trainingapprovalcontacts` (`Name`, `Email`, `Mobile`, `Msg`, `IDNumber`) VALUES
('kelvin chemey', 'kelvinchemey20@gmail.com', '0700392598', 'Applicant', '30487656'),
('Kelvin Chemey', 'kserem20@gmail.com', '700392599', 'Applicant', '30487656');

-- --------------------------------------------------------

--
-- Table structure for table `training_approval_workflow`
--

CREATE TABLE `training_approval_workflow` (
  `ID` bigint(20) NOT NULL,
  `Number` bigint(20) NOT NULL,
  `Fullname` bigint(20) NOT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `training_approval_workflow`
--

INSERT INTO `training_approval_workflow` (`ID`, `Number`, `Fullname`, `Status`, `Approver`, `Remarks`, `Created_By`, `Approved_At`, `Created_At`) VALUES
(6, 30487656, 0, 'Approved', 'Admin', '67', 'Admin', '2020-05-22 15:07:52', '2020-05-22 15:07:52'),
(7, 30487656, 0, 'Approved', 'Admin', 'nn', 'Admin', '2020-05-22 15:08:08', '2020-05-22 15:08:08'),
(8, 30487656, 0, 'Approved', 'Admin', 'hhh', 'Admin', '2020-05-22 15:10:23', '2020-05-22 15:10:23');

-- --------------------------------------------------------

--
-- Table structure for table `travelapprovalcontacts`
--

CREATE TABLE `travelapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `travelapprovalcontacts`
--

INSERT INTO `travelapprovalcontacts` (`Name`, `Email`, `Mobile`, `Msg`, `IDNumber`) VALUES
('kelvin chemey', 'kelvinchemey@gmail.com', '+254700392599', 'Applicant', '30487656'),
('Kelvin Chemey', 'kserem20@gmail.com', '+254753710324', 'Applicant', '30487656');

-- --------------------------------------------------------

--
-- Table structure for table `travelling`
--

CREATE TABLE `travelling` (
  `ID` int(11) NOT NULL,
  `Number` int(11) DEFAULT NULL,
  `DOT` datetime DEFAULT NULL,
  `Status` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Cost` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approve_Status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Update_at` datetime DEFAULT NULL,
  `UpdateBy` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Approve_at` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=4096 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `travelling`
--

INSERT INTO `travelling` (`ID`, `Number`, `DOT`, `Status`, `Cost`, `Approve_Status`, `Created_at`, `CreatedBy`, `Update_at`, `UpdateBy`, `Deleted`, `Approve_at`) VALUES
(1, 33487656, '2020-05-27 00:00:00', 'Travelled', '777', 'Pending Approval', '2020-05-26 11:57:48', 'Admin', '0000-00-00 00:00:00', '0', 0, NULL),
(2, 30487656, '2020-05-27 00:00:00', 'Travelled', '777', 'Approved', '2020-05-27 10:41:57', 'Admin', '0000-00-00 00:00:00', '0', 0, '2020-05-27 10:44:05');

-- --------------------------------------------------------

--
-- Table structure for table `travelling_approval_workflow`
--

CREATE TABLE `travelling_approval_workflow` (
  `ID` bigint(20) NOT NULL,
  `Number` bigint(20) NOT NULL,
  `Fullname` bigint(20) NOT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `travelling_approval_workflow`
--

INSERT INTO `travelling_approval_workflow` (`ID`, `Number`, `Fullname`, `Status`, `Approver`, `Remarks`, `Created_By`, `Approved_At`, `Created_At`) VALUES
(6, 30487656, 0, 'Approved', 'Admin', 'nn', 'Admin', '2020-05-22 22:05:31', '2020-05-22 22:05:31'),
(7, 30487656, 0, 'Approved', 'Admin', 'uii', 'Admin', '2020-05-27 10:43:20', '2020-05-27 10:43:20'),
(8, 30487656, 0, 'Approved', 'Admin', 'uiiyyy', 'Admin', '2020-05-27 10:44:05', '2020-05-27 10:44:05');

-- --------------------------------------------------------

--
-- Table structure for table `useraccess`
--

CREATE TABLE `useraccess` (
  `Username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RoleID` bigint(20) NOT NULL,
  `Edit` tinyint(1) NOT NULL,
  `Remove` tinyint(1) NOT NULL,
  `AddNew` tinyint(1) NOT NULL,
  `View` tinyint(1) NOT NULL,
  `Export` tinyint(1) NOT NULL,
  `UpdateBy` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CreateBy` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CreatedAt` datetime NOT NULL,
  `UpdatedAt` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=141 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `useraccess`
--

INSERT INTO `useraccess` (`Username`, `RoleID`, `Edit`, `Remove`, `AddNew`, `View`, `Export`, `UpdateBy`, `CreateBy`, `CreatedAt`, `UpdatedAt`) VALUES
('Admin', 1, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-26 15:18:25', '2019-08-09 16:01:32'),
('Admin', 2, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-26 15:18:24', '2019-08-09 15:38:47'),
('Admin', 3, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-26 15:18:23', '2019-08-09 18:09:49'),
('Admin', 4, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-26 15:18:24', '2019-07-29 11:28:25'),
('Admin', 5, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-19 11:22:29', '2019-08-09 16:38:25'),
('Admin', 6, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-26 15:18:17', '2019-08-02 13:09:00'),
('Admin', 7, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-26 15:18:19', '2019-07-31 10:58:56'),
('Admin', 8, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-26 15:05:31', '2019-07-29 11:28:22'),
('Admin', 9, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-26 15:18:20', '2019-07-29 11:28:22'),
('Admin', 10, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-26 15:04:53', '2019-07-29 11:28:21'),
('Admin', 11, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-26 15:18:21', '2019-07-29 11:28:21'),
('Admin', 12, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-26 15:18:22', '2019-07-29 11:28:20'),
('Admin', 13, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-29 09:48:29', '2019-07-29 11:28:19'),
('Admin', 14, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-29 09:48:29', '2019-07-29 11:28:18'),
('Admin', 15, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-29 14:08:14', '2019-07-29 14:08:19'),
('Admin', 16, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-07-31 16:59:50', '2019-08-09 18:09:44'),
('Admin', 17, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-08-01 10:22:26', '2019-08-09 17:45:49'),
('Admin', 18, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-08-01 10:25:44', '2019-08-09 18:09:43'),
('Admin', 19, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-08-01 10:49:28', '2019-08-09 18:09:44'),
('Admin', 20, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-08-01 11:41:52', '2019-08-09 18:09:43'),
('Admin', 21, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-08-01 13:33:23', '2019-08-09 18:09:38'),
('Admin', 22, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-08-05 14:07:10', '2019-08-09 18:09:39'),
('Admin', 23, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-08-05 14:44:54', '2019-08-09 17:49:19'),
('Admin', 24, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-08-06 14:20:47', '2019-08-09 18:09:46'),
('Admin', 25, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-08-06 14:34:44', '2019-08-09 17:01:47'),
('Admin', 26, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-08-09 11:42:49', '2019-08-09 18:09:40'),
('Admin', 27, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-08-11 10:47:35', '2019-08-11 10:47:40'),
('Admin', 28, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-08-23 12:02:10', '2019-08-23 12:02:16'),
('Admin', 29, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-09-09 09:48:24', '2019-09-09 09:48:35'),
('Admin', 30, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-09-11 10:47:01', '2019-09-11 14:47:21'),
('Admin', 31, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-09-11 11:13:28', '2019-09-11 11:13:36'),
('Admin', 32, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-09-12 09:48:01', '2019-09-12 09:48:09'),
('Admin', 33, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-09-13 10:05:26', '2019-09-13 10:05:33'),
('Admin', 34, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-09-17 09:41:59', '2019-09-17 09:42:09'),
('Admin', 35, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-09-18 10:04:33', '2019-09-18 10:04:41'),
('Admin', 36, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-09-23 14:29:07', '2019-09-23 14:29:16'),
('Admin', 37, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-09-24 15:03:48', '2019-09-24 15:03:56'),
('Admin', 38, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-09-27 12:21:38', '2019-09-27 12:21:47'),
('Admin', 39, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-10-01 11:03:50', '2019-10-01 13:43:56'),
('Admin', 40, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-10-09 10:57:28', '2019-10-09 10:57:35'),
('Admin', 41, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-10-15 17:09:35', '2019-10-15 17:09:42'),
('Admin', 42, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-10-29 10:06:01', '2019-10-29 10:06:04'),
('Admin', 43, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2019-11-07 15:56:34', '2019-11-07 15:56:44'),
('Admin', 44, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:47:23', '2020-03-31 09:47:23'),
('Admin', 45, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:47:23', '2020-03-31 09:47:23'),
('Admin', 46, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:47:23', '2020-03-31 09:47:23'),
('Admin', 47, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:47:23', '2020-03-31 09:47:23'),
('Admin', 48, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-03-31 09:47:23', '2020-03-31 09:47:23'),
('cheruiyot', 6, 0, 0, 0, 0, 0, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 8, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 9, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 10, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 17, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 19, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 23, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 24, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 25, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 27, 0, 0, 0, 0, 0, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 28, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 29, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 30, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 31, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 43, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 45, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 46, 0, 0, 0, 0, 0, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('cheruiyot', 47, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-05-19 19:48:55', '2020-05-19 19:48:55'),
('kavethe', 9, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-04-30 15:29:39', '2020-05-02 22:04:11'),
('kavethe', 11, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-04-30 15:30:07', '2020-05-02 22:04:11'),
('kavethe', 16, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-04-30 15:30:07', '2020-05-02 22:04:11'),
('kavethe', 17, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 18, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 19, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 20, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 21, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 22, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 23, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 24, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 25, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 26, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 28, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 29, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 30, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 31, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-03-31 09:47:23', '2020-05-02 22:04:11'),
('kavethe', 44, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-04-30 15:29:58', '2020-05-02 22:04:11'),
('kavethe', 45, 1, 1, 1, 1, 1, 'kavethe', 'Admin', '2020-04-30 15:29:39', '2020-05-02 22:04:11'),
('kelvin', 1, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 2, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 3, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 4, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 5, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 6, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 7, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 8, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 9, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 10, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 11, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 12, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 14, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 16, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 26, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 27, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 32, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 34, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 37, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('kelvin', 38, 0, 0, 0, 0, 0, 'kelvin', 'Admin', '2020-04-30 10:31:44', '2020-06-10 15:06:02'),
('paul', 8, 1, 1, 1, 1, 1, 'paul', 'Admin', '2020-03-31 09:44:09', '2020-05-14 09:12:10'),
('paul', 9, 1, 1, 1, 1, 1, 'paul', 'Admin', '2020-03-31 09:41:28', '2020-05-14 09:12:10'),
('paul', 10, 1, 1, 1, 1, 1, 'paul', 'Admin', '2020-03-31 09:41:28', '2020-05-14 09:12:10'),
('paul', 28, 1, 1, 1, 1, 1, 'paul', 'Admin', '2020-03-31 09:41:28', '2020-05-14 09:12:10'),
('paul', 29, 1, 1, 1, 1, 1, 'paul', 'Admin', '2020-03-31 09:41:28', '2020-05-14 09:12:10'),
('paul', 30, 1, 1, 1, 1, 1, 'paul', 'Admin', '2020-03-31 09:41:28', '2020-05-14 09:12:10'),
('paul', 31, 1, 1, 1, 1, 1, 'paul', 'Admin', '2020-03-31 09:41:28', '2020-05-14 09:12:10'),
('paul', 43, 1, 1, 1, 1, 1, 'paul', 'Admin', '2020-05-14 09:11:35', '2020-05-14 09:12:10'),
('vokechem', 6, 0, 0, 0, 0, 0, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 8, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 9, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 10, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 11, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 17, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 19, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 23, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 24, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 25, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 27, 0, 0, 0, 0, 0, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 28, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 29, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 30, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 31, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 43, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 44, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 45, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 46, 0, 0, 0, 0, 0, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59'),
('vokechem', 47, 1, 1, 1, 1, 1, 'Admin', 'Admin', '2020-06-10 15:07:59', '2020-06-10 15:07:59');

-- --------------------------------------------------------

--
-- Table structure for table `usergroups`
--

CREATE TABLE `usergroups` (
  `UserGroupID` bigint(20) NOT NULL,
  `Name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Description` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CreatedAt` datetime NOT NULL,
  `UpdatedAt` datetime NOT NULL,
  `Deleted` tinyint(1) NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `UpdatedBy` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `usergroups`
--

INSERT INTO `usergroups` (`UserGroupID`, `Name`, `Description`, `CreatedAt`, `UpdatedAt`, `Deleted`, `CreatedBy`, `UpdatedBy`) VALUES
(1, 'Admin', 'System Administrators ', '2019-06-13 14:54:49', '2020-04-30 11:16:56', 0, '', 'Admin'),
(2, 'Clerks', 'Clerks', '2019-06-25 10:10:12', '2020-03-31 09:38:02', 0, 'admin', 'Admin'),
(4, 'Portal users', 'Portal Users', '2019-08-16 16:47:04', '2020-05-19 19:51:31', 0, 'Admin', 'Admin'),
(5, 'Officers', 'Officers', '2019-08-27 17:47:15', '2020-04-30 15:29:02', 0, 'Admin', 'Admin'),
(6, 'Finance', 'Finance/Accounts', '2019-11-13 14:33:37', '2019-11-13 14:33:37', 0, 'Admin', 'Admin'),
(7, 'BOARD ROOM !', 'BOARD ROOM !', '2019-09-11 10:47:44', '2019-09-11 10:47:44', 1, 'Admin', 'Admin');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `Name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Email` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Create_at` datetime NOT NULL,
  `Update_at` datetime DEFAULT NULL,
  `Login_at` datetime DEFAULT NULL,
  `Deleted` tinyint(1) NOT NULL,
  `IsActive` tinyint(1) DEFAULT NULL,
  `IsEmailverified` tinyint(1) DEFAULT NULL,
  `ActivationCode` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ResetPassword` char(38) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `UserGroupID` bigint(20) DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `UpdatedBy` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Photo` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Category` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Signature` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDnumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Gender` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DOB` datetime DEFAULT NULL,
  `ChangePassword` tinyint(1) DEFAULT NULL,
  `Board` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB AVG_ROW_LENGTH=1170 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`Name`, `Username`, `Email`, `Password`, `Phone`, `Create_at`, `Update_at`, `Login_at`, `Deleted`, `IsActive`, `IsEmailverified`, `ActivationCode`, `ResetPassword`, `UserGroupID`, `CreatedBy`, `UpdatedBy`, `Photo`, `Category`, `Signature`, `IDnumber`, `Gender`, `DOB`, `ChangePassword`, `Board`) VALUES
('kelvin chemey', 'Admin', 'kelvinchemey@gmail.com', '$2b$10$W5YQ2FfNM3pc7poT7Blpz.Rws/nb6zHPo88EU0C1O0BEIWbrssWH6', '+254700392599', '2019-07-12 15:50:56', '2020-06-08 14:36:10', '2019-07-12 15:50:56', 0, 1, 1, 'QDrts', '', 1, 'kim', 'Admin', '1591616166779-kelvin.png', 'System_User', '1565251011001-signature.jpg', '31547833', 'Male', '1994-12-31 00:00:00', NULL, 1),
('kelvin cheruiyot', 'cheruiyot', 'kserem@gmail.com', '$2a$10$OEQx2/tDIaqc005OCQXE5unqhT8pDtariQAwWUBUlZbRJ0mrsyFQu', '0780000000', '2020-05-19 19:48:55', NULL, NULL, 0, 1, 0, 'Fp8eR', NULL, 4, 'Admin', NULL, 'default.png', 'System_User', '', '30678978', 'Male', '2020-05-27 00:00:00', 1, 1),
('kavethe', 'kavethe', 'kavethe@gmail.com', '$2a$10$yjcRPMdaW0gc9I1IgzJp2uUl.JvRFuTSrlI9ZsDL0bYdyr12Ku1TS', '07004959990', '2020-03-31 09:47:23', '2020-05-12 18:27:11', NULL, 0, 1, 0, 'yn6Bj', NULL, 5, 'Admin', 'kavethe', '1589297226337-skim2.jpg', 'System_User', '', '303030330', 'Male', '2020-03-17 00:00:00', 1, 0),
('Kelvin  chemey', 'kelvin', 'kelvinchemey44@gmail.com', '$2a$10$zylrmKQMOay2fOZTZPemJO476MKvrezbhXQnSQQm.XrLS6HeuoGfm', '0771635492', '2020-04-30 10:31:44', NULL, NULL, 0, 1, 0, 'qH1gI', NULL, 1, 'Admin', NULL, 'default.png', 'System_User', '1565251011001-signature.jpg', '2147483647', 'Male', '2020-04-15 00:00:00', 1, 1),
('chemei', 'kserem', 'kserem20@gmail.com', '$2a$10$1.6IQKyqQ6NN1CfXu3hq9ujFRnF3a0suOQ1iptPjyXXvclP/gyI/O', '0700392599', '2020-03-24 22:09:05', NULL, NULL, 1, 1, 0, 'y1lm9', NULL, 5, 'Admin', NULL, 'default.png', 'System_User', '1565251011001-signature.jpg', '340506060', 'Male', '2020-03-09 00:00:00', 1, 1),
('paul ', 'paul', 'paul@gmail.com', '$2a$10$km/7smwUDOV6.nPnLedH3.Qudw7/RDubO1YiXXmx40eOiQCZ.9xXK', '0703925999', '2020-03-31 09:41:28', '2020-05-14 09:11:47', NULL, 1, 0, 0, 'MO1w0', NULL, 4, 'Admin', 'Admin', 'default.png', 'System_User', '', '230403040', 'Male', '2004-05-10 00:00:00', 1, 0),
('kelvin chemey', 'vokechem', 'kserem2@gmail.com', '$2a$10$0N8ScIvw04Td57WO9/zBcOQyDNY/XosTshM61WTwZDdpsEtx9up/a', '254753710324', '2020-06-10 15:07:59', NULL, NULL, 0, 1, 0, 'PxqAs', NULL, 4, 'Admin', NULL, 'default.png', 'System_User', '1565251011001-signature.jpg', '36678978', 'Male', '2020-06-24 00:00:00', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `visa`
--

CREATE TABLE `visa` (
  `ID` int(11) NOT NULL,
  `Number` int(11) DEFAULT NULL,
  `VAD` datetime DEFAULT NULL,
  `VID` datetime DEFAULT NULL,
  `Status` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Cost` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Visa_Status` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL,
  `UpdatedBy` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Deleted` tinyint(1) DEFAULT NULL,
  `Approve_at` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=5461 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `visa`
--

INSERT INTO `visa` (`ID`, `Number`, `VAD`, `VID`, `Status`, `Cost`, `Visa_Status`, `Created_at`, `CreatedBy`, `Updated_at`, `UpdatedBy`, `Deleted`, `Approve_at`) VALUES
(1, 33487656, '2020-05-26 00:00:00', '2020-05-26 00:00:00', 'Issued', '0', 'Pending Approval', '2020-05-26 11:53:40', 'Admin', '0000-00-00 00:00:00', '0', 0, NULL),
(2, 30487656, '2020-05-20 00:00:00', '2020-05-27 00:00:00', 'Issued', '0', 'Approved', '2020-05-27 09:39:31', 'Admin', '0000-00-00 00:00:00', '0', 0, '2020-05-27 09:40:50');

-- --------------------------------------------------------

--
-- Table structure for table `visaapprovalcontacts`
--

CREATE TABLE `visaapprovalcontacts` (
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Msg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IDNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `visaapprovalcontacts`
--

INSERT INTO `visaapprovalcontacts` (`Name`, `Email`, `Mobile`, `Msg`, `IDNumber`) VALUES
('kelvin chemey', 'kelvinchemey@gmail.com', '+254700392599', 'Applicant', '30487656'),
('Kelvin Chemey', 'kserem20@gmail.com', '+254753710324', 'Applicant', '30487656');

-- --------------------------------------------------------

--
-- Table structure for table `visa_approval_workflow`
--

CREATE TABLE `visa_approval_workflow` (
  `ID` bigint(20) NOT NULL,
  `Number` bigint(20) NOT NULL,
  `Fullname` bigint(20) NOT NULL,
  `Status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created_By` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Approved_At` datetime DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=2340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `visa_approval_workflow`
--

INSERT INTO `visa_approval_workflow` (`ID`, `Number`, `Fullname`, `Status`, `Approver`, `Remarks`, `Created_By`, `Approved_At`, `Created_At`) VALUES
(1, 30487656, 0, 'Approved', 'Admin', 'dgjhj', 'Admin', '2020-05-27 09:40:03', '2020-05-27 09:40:03'),
(2, 30487656, 0, 'Approved', 'Admin', 'dgjhj', 'Admin', '2020-05-27 09:40:34', '2020-05-27 09:40:34'),
(3, 30487656, 0, 'Approved', 'Admin', 'dgjhj', 'Admin', '2020-05-27 09:40:50', '2020-05-27 09:40:50');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `applicationsequence`
--
ALTER TABLE `applicationsequence`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `applications_approval_workflow`
--
ALTER TABLE `applications_approval_workflow`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ID` (`ID`);

--
-- Indexes for table `approvalmodules`
--
ALTER TABLE `approvalmodules`
  ADD PRIMARY KEY (`ID`,`ModuleCode`);

--
-- Indexes for table `approvers`
--
ALTER TABLE `approvers`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `attestation`
--
ALTER TABLE `attestation`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `attestation_approval_workflow`
--
ALTER TABLE `attestation_approval_workflow`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `audittrails`
--
ALTER TABLE `audittrails`
  ADD PRIMARY KEY (`AuditID`);

--
-- Indexes for table `configurations`
--
ALTER TABLE `configurations`
  ADD PRIMARY KEY (`ID`,`Code`),
  ADD KEY `Configurations_createduser` (`Created_By`),
  ADD KEY `Configurations_Updateduser` (`Updated_By`),
  ADD KEY `Configurations_Users` (`Deleted_By`);

--
-- Indexes for table `contract`
--
ALTER TABLE `contract`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `contract_approval_workflow`
--
ALTER TABLE `contract_approval_workflow`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `counties`
--
ALTER TABLE `counties`
  ADD PRIMARY KEY (`ID`,`Code`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`ID`,`Code`);

--
-- Indexes for table `dci`
--
ALTER TABLE `dci`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Number` (`Number`);

--
-- Indexes for table `dci_approval_workflow`
--
ALTER TABLE `dci_approval_workflow`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `educationaldetails`
--
ALTER TABLE `educationaldetails`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `finalmedical`
--
ALTER TABLE `finalmedical`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Number` (`Number`);

--
-- Indexes for table `final_approval_workflow`
--
ALTER TABLE `final_approval_workflow`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `groupaccess`
--
ALTER TABLE `groupaccess`
  ADD PRIMARY KEY (`UserGroupID`,`RoleID`),
  ADD KEY `groupaccess_ibfk_3` (`RoleID`);

--
-- Indexes for table `major`
--
ALTER TABLE `major`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `major_approval_workflow`
--
ALTER TABLE `major_approval_workflow`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `medicalfacility`
--
ALTER TABLE `medicalfacility`
  ADD PRIMARY KEY (`MedID`);

--
-- Indexes for table `medicalform`
--
ALTER TABLE `medicalform`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `minormedical`
--
ALTER TABLE `minormedical`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Number` (`Number`);

--
-- Indexes for table `minormedical_approval_workflow`
--
ALTER TABLE `minormedical_approval_workflow`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `neaa`
--
ALTER TABLE `neaa`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `neaa_approval_workflow`
--
ALTER TABLE `neaa_approval_workflow`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `nextofkin`
--
ALTER TABLE `nextofkin`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `parents`
--
ALTER TABLE `parents`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `passport`
--
ALTER TABLE `passport`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Number` (`Number`);

--
-- Indexes for table `passport_approval_workflow`
--
ALTER TABLE `passport_approval_workflow`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `processing`
--
ALTER TABLE `processing`
  ADD PRIMARY KEY (`ItemID`);

--
-- Indexes for table `registration`
--
ALTER TABLE `registration`
  ADD PRIMARY KEY (`IDNumber`),
  ADD UNIQUE KEY `IDNumber` (`IDNumber`),
  ADD UNIQUE KEY `Phone` (`Phone`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indexes for table `registrationapprovalworkflow`
--
ALTER TABLE `registrationapprovalworkflow`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `registrationdocuments`
--
ALTER TABLE `registrationdocuments`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`RoleID`,`RoleName`);

--
-- Indexes for table `siblings`
--
ALTER TABLE `siblings`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `smsdetails`
--
ALTER TABLE `smsdetails`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `smtpdetails`
--
ALTER TABLE `smtpdetails`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `ticketing`
--
ALTER TABLE `ticketing`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `ticketing_approval_workflow`
--
ALTER TABLE `ticketing_approval_workflow`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `training`
--
ALTER TABLE `training`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Number` (`Number`);

--
-- Indexes for table `training_approval_workflow`
--
ALTER TABLE `training_approval_workflow`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `travelling`
--
ALTER TABLE `travelling`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `travelling_approval_workflow`
--
ALTER TABLE `travelling_approval_workflow`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `useraccess`
--
ALTER TABLE `useraccess`
  ADD PRIMARY KEY (`Username`,`RoleID`),
  ADD KEY `useraccess_ibfk_2` (`CreateBy`),
  ADD KEY `useraccess_ibfk_3` (`UpdateBy`);

--
-- Indexes for table `usergroups`
--
ALTER TABLE `usergroups`
  ADD PRIMARY KEY (`UserGroupID`),
  ADD UNIQUE KEY `Name` (`Name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`Username`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `MobileNo` (`Phone`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD UNIQUE KEY `IDNo` (`IDnumber`),
  ADD KEY `users_ibfk_1` (`UserGroupID`);

--
-- Indexes for table `visa`
--
ALTER TABLE `visa`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Number` (`Number`);

--
-- Indexes for table `visa_approval_workflow`
--
ALTER TABLE `visa_approval_workflow`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `applicationsequence`
--
ALTER TABLE `applicationsequence`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `applications_approval_workflow`
--
ALTER TABLE `applications_approval_workflow`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `approvalmodules`
--
ALTER TABLE `approvalmodules`
  MODIFY `ID` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `approvers`
--
ALTER TABLE `approvers`
  MODIFY `ID` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `attestation`
--
ALTER TABLE `attestation`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `attestation_approval_workflow`
--
ALTER TABLE `attestation_approval_workflow`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `audittrails`
--
ALTER TABLE `audittrails`
  MODIFY `AuditID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=454;

--
-- AUTO_INCREMENT for table `configurations`
--
ALTER TABLE `configurations`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `contract`
--
ALTER TABLE `contract`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `contract_approval_workflow`
--
ALTER TABLE `contract_approval_workflow`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `counties`
--
ALTER TABLE `counties`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `dci`
--
ALTER TABLE `dci`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `dci_approval_workflow`
--
ALTER TABLE `dci_approval_workflow`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `educationaldetails`
--
ALTER TABLE `educationaldetails`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `finalmedical`
--
ALTER TABLE `finalmedical`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `final_approval_workflow`
--
ALTER TABLE `final_approval_workflow`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `major`
--
ALTER TABLE `major`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `major_approval_workflow`
--
ALTER TABLE `major_approval_workflow`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `medicalfacility`
--
ALTER TABLE `medicalfacility`
  MODIFY `MedID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `medicalform`
--
ALTER TABLE `medicalform`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `minormedical`
--
ALTER TABLE `minormedical`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `minormedical_approval_workflow`
--
ALTER TABLE `minormedical_approval_workflow`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `neaa`
--
ALTER TABLE `neaa`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `neaa_approval_workflow`
--
ALTER TABLE `neaa_approval_workflow`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nextofkin`
--
ALTER TABLE `nextofkin`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `parents`
--
ALTER TABLE `parents`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `passport`
--
ALTER TABLE `passport`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `passport_approval_workflow`
--
ALTER TABLE `passport_approval_workflow`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `processing`
--
ALTER TABLE `processing`
  MODIFY `ItemID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `registrationapprovalworkflow`
--
ALTER TABLE `registrationapprovalworkflow`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `registrationdocuments`
--
ALTER TABLE `registrationdocuments`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `RoleID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT for table `siblings`
--
ALTER TABLE `siblings`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `smsdetails`
--
ALTER TABLE `smsdetails`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `smtpdetails`
--
ALTER TABLE `smtpdetails`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `ticketing`
--
ALTER TABLE `ticketing`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `ticketing_approval_workflow`
--
ALTER TABLE `ticketing_approval_workflow`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `training`
--
ALTER TABLE `training`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `training_approval_workflow`
--
ALTER TABLE `training_approval_workflow`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `travelling`
--
ALTER TABLE `travelling`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `travelling_approval_workflow`
--
ALTER TABLE `travelling_approval_workflow`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `usergroups`
--
ALTER TABLE `usergroups`
  MODIFY `UserGroupID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `visa`
--
ALTER TABLE `visa`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `visa_approval_workflow`
--
ALTER TABLE `visa_approval_workflow`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `groupaccess`
--
ALTER TABLE `groupaccess`
  ADD CONSTRAINT `groupaccess_ibfk_1` FOREIGN KEY (`UserGroupID`) REFERENCES `usergroups` (`UserGroupID`),
  ADD CONSTRAINT `groupaccess_ibfk_2` FOREIGN KEY (`RoleID`) REFERENCES `roles` (`RoleID`),
  ADD CONSTRAINT `groupaccess_ibfk_3` FOREIGN KEY (`RoleID`) REFERENCES `roles` (`RoleID`);

--
-- Constraints for table `useraccess`
--
ALTER TABLE `useraccess`
  ADD CONSTRAINT `useraccess_ibfk_1` FOREIGN KEY (`Username`) REFERENCES `users` (`Username`),
  ADD CONSTRAINT `useraccess_ibfk_2` FOREIGN KEY (`CreateBy`) REFERENCES `users` (`Username`),
  ADD CONSTRAINT `useraccess_ibfk_3` FOREIGN KEY (`UpdateBy`) REFERENCES `users` (`Username`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
