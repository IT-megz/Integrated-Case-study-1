/*  Q. Find the sum of the loan amounts ((i.e., property value x loan percent / 100) 
for each banker ID, excluding properties based in the cities of Dallas and Waco. 
The sum values should be rounded to nearest integer.*/

select banker_id,round(sum(property_value*loan_percent/100),0) as Loan_Amount 
from Home_Loan_Data as hl inner join 
Loan_Records_Data as lr on hl.loan_id=lr.loan_id where city not in ('Dallas','Waco')
 group by banker_id 
  

/*Create a stored procedure called `recent_joiners` that returns 
the ID, concatenated full name, date of birth, and join date of bankers 
who joined within the recent 2 years (as of 1 Sep 2022) 

Call the stored procedure `recent_joiners` you created above 
*/

CREATE PROCEDURE recent_joiners
AS
BEGIN
    SELECT
        banker_id AS ID,
        CONCAT(first_name, ' ', last_name) AS FullName,
        dob,
        date_joined
    FROM
        Banker_Data
    WHERE
        date_joined >= DATEADD(YEAR, -2, '2022-09-01')
END
EXEC recent_joiners

/* Find the number of Chinese customers with joint loans 
with property values less than $2.1 million, and served by female bankers.  */

SELECT COUNT(DISTINCT lr.customer_id) AS Number_of_Customers
FROM Loan_Records_Data AS lr
INNER JOIN customer_data AS c ON lr.customer_id=c.customer_id 
INNER JOIN Home_Loan_Data AS hl ON lr.loan_id = hl.loan_id
INNER JOIN Banker_Data AS b ON lr.banker_id = b.banker_id
WHERE
    c.nationality = 'China'
    AND hl.property_value < 2100000
    AND hl.joint_loan = 'Yes'
    AND b.gender = 'Female'

/*Find the ID and full name (first name concatenated with last name) of customers 
who were served by bankers aged below 30 (as of 1 Aug 2022)*/
 
 SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS Full_Name
FROM
    Customer_data AS c
INNER JOIN
    Loan_Records_Data AS lr ON c.customer_id = lr.customer_id
INNER JOIN
    Banker_Data AS b ON lr.banker_id = b.banker_id
WHERE
    DATEDIFF(YEAR, b.dob, '2022-08-01') < 30

/*Create a stored procedure called `city_and_above_loan_amt` that takes in 
two parameters (city_name, loan_amt_cutoff) that returns the
full details of customers with loans for properties in the 
input city and with loan amount greater than or equal to the input loan amount cutoff.  

Call the stored procedure `city_and_above_loan_amt` you created above, based on the city San Francisco and loan amount cutoff of $1.5 million  
*/
CREATE PROCEDURE city_and_above_loan_amt
    @city_name NVARCHAR(255),
    @loan_amt_cutoff DECIMAL(18, 2)
AS
BEGIN
    SELECT
        c.*,
        lr.*,
        hl.*
    FROM
        Customer_data AS c
    INNER JOIN
        Loan_Records_Data AS lr ON c.customer_id = lr.customer_id
    INNER JOIN
        Home_Loan_Data AS hl ON lr.loan_id = hl.loan_id
    WHERE
        hl.city = @city_name
        AND  (hl.property_value*hl.loan_percent/100)>= @loan_amt_cutoff;
END

-- Call the stored procedure with parameters
EXEC city_and_above_loan_amt @city_name = 'San Francisco', @loan_amt_cutoff = 1500000


/* Find the ID, first name and last name of customers with properties of 
value between $1.5 and $1.9 million, along with a new column 'tenure' that 
categorizes how long the customer has been with WBG. 

The 'tenure' column is based on the following logic:
Long: Joined before 1 Jan 2015
Mid: Joined on or after 1 Jan 2015, but before 1 Jan 2019
Short: Joined on or after 1 Jan 2019 */

 SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    hl.property_value,
    CASE
        WHEN c.customer_since < '2015-01-01' THEN 'Long'
        WHEN c.customer_since >= '2015-01-01' AND c.customer_since < '2019-01-01' THEN 'Mid'
        WHEN c.customer_since >= '2019-01-01' THEN 'Short'
    END AS tenure
FROM
    Customer_data as c 
	inner join Loan_Records_Data as lr ON c.customer_id = lr.customer_id
	inner join Home_Loan_Data as hl ON lr.loan_id = hl.loan_id
WHERE
    hl.property_value BETWEEN 1500000 AND 1900000

--Q. Find the number of bankers involved in loans where the loan amount is greater than the average loan amount. 
  
 SELECT COUNT(DISTINCT banker_id) AS Number_of_Bankers
 FROM Loan_Records_Data AS lr
 INNER JOIN Home_Loan_Data AS hl ON lr.loan_id = hl.loan_id
 WHERE (hl.property_value*hl.loan_percent/100) > (
    SELECT AVG(property_value*loan_percent/100)
    FROM Home_Loan_Data)


/* Create a view called `dallas_townhomes_gte_1m` 
 which returns all the details of loans involving properties of 
 townhome type, located in Dallas, and have loan amount of >$1 million*/

CREATE VIEW dallas_townhomes_gte_1m AS
SELECT
    lr.loan_id,
    lr.customer_id,
    lr.transaction_date,
    hl.property_type,
    hl.city + ',' + hl.country AS _Location_,
	hl.postal_code,
	hl.joint_loan,
	(hl.property_value*hl.loan_percent/100) as Loan_Amount

FROM
    Loan_Records_Data AS lr
INNER JOIN
    Home_Loan_Data AS hl ON lr.loan_id = hl.loan_id
WHERE
    hl.property_type = 'Townhome'
    AND hl.city = 'Dallas'
    AND (hl.property_value*hl.loan_percent/100) > 1000000

  select  * from dallas_townhomes_gte_1m



 /*Find the top 3 transaction dates (and corresponding loan amount sum)
 for which the sum of loan amount issued on that date is the highest. */

 select top 3 
 transaction_date,SUM(hl.property_value*hl.loan_percent/100) AS TotalLoanAmount 
 from Loan_Records_Data as lr inner join 
 Home_Loan_Data as hl on lr.loan_id=hl.loan_id group by transaction_date 
 order by TotalLoanAmount desc








