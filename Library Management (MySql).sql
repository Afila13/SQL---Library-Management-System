# Library Management System (SQL Project)

CREATE DATABASE librarydb;
USE librarydb;

# Create Tables with Constraints
CREATE TABLE Authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
     VARrst_name varchar(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    price DECIMAL(6,2) CHECK(price > 0),
    author_id INT,
    UNIQUE (title),
    FOREIGN KEY (author_id) REFERENCES Authors1(author_id) ON DELETE CASCADE
);

CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Borrow (
    borrow_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    borrow_date DATE DEFAULT (CURRENT_DATE),
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES Members1(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books1(book_id) ON DELETE CASCADE
);

# Insert Data
INSERT INTO Authors (name, email) VALUES
('J.K. Rowling', 'jk@mail.com'),
('George Orwell', 'orwell@mail.com'),
('Agatha Christie', 'agatha@mail.com');

INSERT INTO Books (title, genre, price, author_id) VALUES
('Harry Potter', 'Fantasy', 500.00, 1),
('1984', 'Dystopian', 300.00, 2),
('Murder on the Orient Express', 'Mystery', 450.00, 3);

INSERT INTO Members (name, email) VALUES
('Alice', 'alice@mail.com'),
('Bob', 'bob@mail.com'),
('Sam', 'sam@mail.com');

INSERT INTO Borrow (member_id, book_id, borrow_date, return_date)
VALUES (1, 1, '2025-09-16', '2025-09-20');

UPDATE Borrow
SET return_date = '2025-09-20'
WHERE borrow_id = 1;

# Update Data
UPDATE Books
SET price = 550
WHERE title = 'Harry Potter';

SET SQL_SAFE_UPDATES = 0; --  while using del on safe_mode 

# Delete Data
DELETE FROM Members
WHERE name = 'Sam';

# WHERE Clause
SELECT * FROM Books
WHERE price > 400;

# ORDER BY
SELECT * FROM Books
ORDER BY price DESC;

# Aggregate Function
SELECT COUNT(*) AS total_books FROM Books;

# GROUP BY + HAVING
SELECT author_id, COUNT(*) AS book_count
FROM Books
GROUP BY author_id
HAVING COUNT(*) >= 2;

# WHERE with Aggregate
SELECT author_id, AVG(price) AS avg_price
FROM Books
GROUP BY author_id
HAVING AVG(price) > 400;

# Unique Column Example
SELECT DISTINCT genre FROM Books;
select distinct email from authors;
select distinct return_date from borrow;
select distinct name from members;

# Wildcard + LIMIT + OFFSET
-- Names starting with 'A'

SELECT * FROM Members
WHERE name LIKE 'A%';

-- First 2 rows
SELECT * FROM Books LIMIT 2;

-- Skip first 2 rows, show next 1
SELECT * FROM Books LIMIT 1 OFFSET 2;

# Joins
-- INNER JOIN
SELECT b.title, a.name AS author
FROM Books b
INNER JOIN Authors a ON b.author_id = a.author_id;

-- LEFT JOIN
SELECT m.name, b.title
FROM Members m
LEFT JOIN Borrow br ON m.member_id = br.member_id
LEFT JOIN Books b ON br.book_id = b.book_id;

-- SELF JOIN (Authors recommending other Authors)
SELECT a1.name AS Author1, a2.name AS Author2
FROM Authors a1
JOIN Authors a2 ON a1.author_id <> a2.author_id;

# DELIMITER + Stored Procedure
DELIMITER $$

CREATE PROCEDURE GetBooksByAuthor(IN authorName VARCHAR(100))
BEGIN
    SELECT b.title, b.genre, b.price
    FROM Books b
    JOIN Authors a ON b.author_id = a.author_id
    WHERE a.name = authorName;
END $$

DELIMITER ;

CALL GetBooksByAuthor('J.K. Rowling');

# TRIGGER
CREATE TABLE Borrow_Audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    borrow_id INT,
    action VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER after_borrow_insert
AFTER INSERT ON Borrow
FOR EACH ROW
BEGIN
    INSERT INTO Borrow_Audit (borrow_id, action)
    VALUES (NEW.borrow_id, 'Book Borrowed');
END $$

DELIMITER ;

# VIEW
CREATE VIEW BorrowedBooks AS
SELECT m.name AS member, b.title AS book, br.borrow_date, br.return_date
FROM Borrow br
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id;

-- Using the view
SELECT * FROM BorrowedBooks;










# Questions:
-- Sample Questions (based on your project)

-- Find all books with price greater than 400.

-- List all authors and the number of books they have written.

-- Show only unique genres of books.

-- Display the top 2 most expensive books.

-- Find members whose names start with ‘A’.

-- List all books borrowed by each member using JOIN.

-- Show all books written by “George Orwell” (use stored procedure).

-- Display average book price per author where avg > 400.

-- Insert a new borrow record → check Borrow_Audit table (trigger).

-- Show all borrowed books with member names using the BorrowedBooks view.

