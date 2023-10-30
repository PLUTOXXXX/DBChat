##Mysql Sample Database 
####github link:https://github.com/datacharmer/test_db
---
### 1 Introduction
This document describes the **Employees sample database**.

The Employees sample database was developed by Patrick Crews and Giuseppe Maxia and provides a combination of a large base of data (approximately 160MB) spread over six separate tables and consisting of 4 million records in total. The structure is compatible with a wide range of storage engine types. Through an included data file, support for partitioned tables is also provided.

In addition to the base data, the Employees database also includes a suite of tests that can be executed across the test data to ensure the integrity of the data that you have loaded. This should help ensure the quality of the data during initial load, and can be used after usage to ensure that no changes have been made to the database during testing.

### 2 Installation and Validating the Employee Data
The Employees database is available from Employees DB on GitHub. You can download a prepackaged archive of the data, or access the information through Git.

To use the Zip archive package, download the archive and unpack it using WinZip or another tool that can read .zip files, then change location into the unpacked package directory. For example, using unzip, execute these commands:

    unzip test_db-master.zip 
    cd test_db-master/

The Employees database is compatible with several different storage engines, with the InnoDB engine enabled by default. Edit the employees.sql file and adjust the comments to choose a different storage engine:


    set storage_engine = InnoDB;
    -- set storage_engine = MyISAM;
    -- set storage_engine = Falcon;
    -- set storage_engine = PBXT;
    -- set storage_engine = Maria;

To import the data into your MySQL instance, load the data through the mysql command-line tool:

    mysql -t < employees.sql

You can validate the Employee data using two methods, md5 and sha. Two SQL scripts are provided for this purpose, test_employees_sha.sql and test_employees_md5.sql. To run the tests, use mysql:

    time mysql -t < test_employees_sha.sql
    time mysql -t < test_employees_md5.sql

### 3 Employees Structure
The following diagram provides an overview of the structure of the Employees sample database.

<img decoding="async" src="D:\Study\MSBD\5001 Data Analytics\GroupProject\TestDB\employees-schema.png" width="90%">