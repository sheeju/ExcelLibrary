#!/usr/bin/perl 

use strict;
use warnings;
use DBI;

my $dsn = "dbi:Pg:database=Library";
my $username = "venkatesan";
my $password = "1774";
my $dbh = DBI->connect($dsn,$username,$password,{RaiseError=>1});
my %sth;
my $query;

#--------------------- Enum Creation -----------------------------
$query = q!
			CREATE TYPE "EmpStatus" AS ENUM('Active','InActive','Disable');
		!;
$dbh->do($query);

$query = q!
			CREATE TYPE "EmpRole" AS ENUM('Admin','Employee');
		!;
$dbh->do($query);

$query = q!
			CREATE TYPE "BookStatus" AS ENUM('Available','Reading','Removed');
		!;

$dbh->do($query);

$query = q!
			CREATE TYPE "TransStatus" AS ENUM('Requested','Issued','Denied');
		!;

$dbh->do($query);

#------------------------- Table Createion -----------------------
$query = q!
			CREATE TABLE IF NOT EXISTS
			"Config"(
						"MaxAllowedDays" INTEGER, 
						"MaxAllowedBooks" INTEGER
					);

		 !;
$dbh->do($query);

$query = q!
			CREATE TABLE IF NOT EXISTS
			"Employee"(
						"Id" SERIAL PRIMARY kEY,
						"Name" VARCHAR(50),
						"Role" "EmpRole",
						"Email" VARCHAR(50),
						"Password" VARCHAR(40),
						"Status" "EmpStatus" DEFAULT 'InActive',
						"Token" VARCHAR(20),
						"CreatedBy" INTEGER,
						"CreatedOn" TIMESTAMP,
						"UpdatedBy" INTEGER,
						"UpdatedOn" TIMESTAMP
					);
		 !;
$dbh->do($query);

$query = q!
			CREATE TABLE IF NOT EXISTS
			"Book"(
					"Id" SERIAL PRIMARY kEY,
					"Name" VARCHAR(50),
					"Type" VARCHAR(30),
					"Author" VARCHAR(50),
					"NoOfCopies" INTEGER DEFAULT 1,
					"AddedBy" INTEGER,
					"AddedOn" TIMESTAMP,
					"UpdatedBy" INTEGER,
					"UpdatedOn" TIMESTAMP	
				);
		 !;
$dbh->do($query);

$query = q!
			CREATE TABLE IF NOT EXISTS
			"BookCopy"(
						"Id" SERIAL PRIMARY key,
						"BookId" INTEGER REFERENCES "Book"("Id"),
						"Status" "BookStatus" DEFAULT 'Available',
						"Remarks" VARCHAR(50)
					);

		 !;
$dbh->do($query);


$query = q!
			CREATE TABLE IF NOT EXISTS
			"Transaction"(
						"Id" SERIAL PRIMARY key,
						"BookId" INTEGER REFERENCES "Book"("Id"),
						"BookCopyId" INTEGER REFERENCES "BookCopy"("Id"),
						"EmployeeId" INTEGER REFERENCES "Employee"("Id"),
						"Status" "TransStatus",
						"RequestDate" TIMESTAMP,
					   	"IssuedDate" TIMESTAMP,
						"IssuedBy" INTEGER,
						"ExpectedReturnDate" TIMESTAMP,
						"ReturnedDate" TIMESTAMP,
						"RecivedBy" INTEGER,
						"UpdatedBy" INTEGER,
						"Comment" VARCHAR(50)
					);

		 !;
$dbh->do($query);

$query = q!
			CREATE TABLE IF NOT EXISTS
			"Comment"(
						"Id" SERIAL PRIMARY key,
						"Comment" TEXT,
						"BookId" INTEGER REFERENCES "Book"("Id"),
						"EmployeeId" INTEGER REFERENCES "Employee"("Id"),
						"CommentedDate" TIMESTAMP
					);
		 !;
$dbh->do($query);

#------------------------- Function for AddBookCopies -------------------------
$query = q!
			CREATE OR REPLACE FUNCTION "AddBookcopyfunc"() RETURNS TRIGGER AS $example_table$
				BEGIN
					FOR i IN 1 .. new."NoOfCopies" LOOP
						INSERT INTO "BookCopy"("BookId") VALUES (new."Id");
					END LOOP;
					RETURN NEW;
				END;
			$example_table$ LANGUAGE plpgsql;
		!;
$dbh->do($query);

#------------------------- Triger for Insert Book Copies -----------------------
$query = q! 
			CREATE TRIGGER "AddBookCopies" AFTER INSERT ON "Book" FOR EACH ROW EXECUTE PROCEDURE "AddBookcopyfunc"();
		!;
$dbh->do($query);





