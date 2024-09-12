
--Create a new database (named Loans) in SQL Server 

  create database Loans

/*Import the 4 CSV files and generate 4 tables in the database. 
Ensure that the tables are named in a manner that is easy to understand,
and that the data type for each column is correctly specified (Refer to above section for more info).
In particular, ensure that the date format for the date columns are accurately defined (i.e., %Y-%m-%d).*/

  UPDATE [dbo].[Loan_Records_Data]
  SET transaction_date =Cast(convert(varchar, convert(date, transaction_date, 103), 112) as date)
  select * from dbo.Loan_Records_Data

--Write a query to print all the databases available in the SQL Server.

  select name from sys.databases

--Write a query to print the names of the tables from the Loans database
  
  USE Loans
  select * from sys.tables 
 
--Write a query to print 5 records in each table 

  select top 5 * from banker_data
  select top 5 * from customer_data
  select top 5 * from [dbo].[Home_Loan_Data]
  select top 5 * from [dbo].[Loan_Records_Data]

  