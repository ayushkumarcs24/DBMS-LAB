create database BANK1;
show databases;
use BANK1;

create table BRANCH(branch_name varchar(255),
branch_city varchar(255),
 assets real,
 primary key(branch_name));

desc BRANCH;

create table BANKACCOUNT(
accno int, 
branch_name varchar(255), 
balance real,
primary key(accno),
foreign key(branch_name) references BRANCH(branch_name));

drop table if exists BANKACCOUNT;

desc BANKACCOUNT;

create table BANKCUSTOMER(
customer_name varchar(255),
customer_street varchar(255),
customer_city varchar(255),
primary key(customer_name)
);

desc BANKCUSTOMER;

CREATE TABLE DEPOSITER (
    customer_name VARCHAR(50),
    accno INT,
    PRIMARY KEY (customer_name, accno),
    FOREIGN KEY (customer_name) REFERENCES BankCustomer(customer_name),
    FOREIGN KEY (accno) REFERENCES BankAccount(accno)
);

drop table if exists DEPOSITER;

desc DEPOSITER;

CREATE TABLE LOAN (
    loan_number INT PRIMARY KEY,
    branch_name VARCHAR(50),
    amount REAL,
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

desc LOAN;

INSERT INTO BRANCH VALUES 
('SBI_ResidencyRoad', 'Bangalore', 50000000),
('ICICI_Koramangala', 'Bangalore', 30000000),
('HDFC_Indiranagar', 'Bangalore', 40000000),
('Axis_Jayanagar', 'Bangalore', 25000000),
('PNB_MGroad', 'Bangalore', 15000000);

INSERT INTO BANKACCOUNT VALUES 
(101, 'SBI_ResidencyRoad', 200000),
(102, 'SBI_ResidencyRoad', 150000),
(103, 'ICICI_Koramangala', 300000),
(104, 'HDFC_Indiranagar', 250000),
(105, 'Axis_Jayanagar', 100000);


INSERT INTO BANKCUSTOMER VALUES 
('Alice', '1st Main', 'Bangalore'),
('Bob', '2nd Cross', 'Bangalore'),
('Charlie', '3rd Block', 'Bangalore'),
('David', '4th Avenue', 'Bangalore'),
('Eva', '5th Street', 'Bangalore');

INSERT INTO DEPOSITER VALUES 
('Alice', 101),
('Alice', 102),  -- Alice has two accounts at the same branch
('Bob', 103),
('Charlie', 104),
('David', 105);

INSERT INTO LOAN VALUES 
(201, 'SBI_ResidencyRoad', 1000000),
(202, 'ICICI_Koramangala', 500000),
(203, 'HDFC_Indiranagar', 750000),
(204, 'Axis_Jayanagar', 300000),
(205, 'PNB_MGroad', 200000);


select * from LOAN;
select * from DEPOSITER;


SELECT branch_name, assets / 100000 AS "assets in lakhs"
FROM Branch;



SELECT d.customer_name
FROM Depositer d
JOIN BankAccount b ON d.accno = b.accno
GROUP BY d.customer_name, b.branch_name
HAVING COUNT(*) >= 2;

CREATE VIEW BranchLoanSummary AS
SELECT branch_name, SUM(amount) AS total_loan_amount
FROM Loan
GROUP BY branch_name;


SELECT * FROM BranchLoanSummary;

SELECT customer_name
FROM BANKCUSTOMER
WHERE customer_city = 'Bangalore';

select accno
from BANKACCOUNT
where balance > 100000;

select branch_name,assets
from BRANCH
group by branch_city;


SELECT bc.customer_name
FROM BANKCUSTOMER bc
WHERE NOT EXISTS (
    SELECT b.branch_name
    FROM BRANCH b
    WHERE b.branch_city = 'Bangalore'
    EXCEPT
    SELECT ba.branch_name
    FROM BANKACCOUNT ba
    JOIN DEPOSITER d ON ba.accno = d.accno
    WHERE d.customer_name = bc.customer_name
);


CREATE TABLE BORROWER (
    customer_name VARCHAR(50),
    loan_number INT,
    PRIMARY KEY (customer_name, loan_number),
    FOREIGN KEY (customer_name) REFERENCES BANKCUSTOMER(customer_name),
    FOREIGN KEY (loan_number) REFERENCES LOAN(loan_number)
);

SELECT DISTINCT br.customer_name
FROM BORROWER br
WHERE br.customer_name NOT IN (
    SELECT customer_name FROM DEPOSITER
);


SELECT DISTINCT d.customer_name
FROM DEPOSITER d
JOIN BANKACCOUNT ba ON d.accno = ba.accno
JOIN BORROWER br ON d.customer_name = br.customer_name
JOIN LOAN l ON br.loan_number = l.loan_number
WHERE ba.branch_name = l.branch_name
  AND ba.branch_name IN (
      SELECT branch_name FROM BRANCH WHERE branch_city = 'Bangalore'
  );
  
  SELECT branch_name
FROM BRANCH
WHERE assets > ALL (
    SELECT assets
    FROM BRANCH
    WHERE branch_city = 'Bangalore'
);

DELETE FROM BANKACCOUNT
WHERE branch_name IN (
    SELECT branch_name
    FROM BRANCH
    WHERE branch_city = 'Bombay'
);



UPDATE BANKACCOUNT
SET balance = balance * 1.05;


  