--Q. Find the number of home loans issued in San Francisco

select count(loan_id) as No_loan_issued from Home_loan_data
where city = 'San Francisco'

/* Find the ID, first name, and last name of the top 2 bankers 
(and corresponding transaction count)
involved in the highest number of distinct loan records.*/

select top 2 b.banker_id,first_name,last_name,count(lr.banker_id) as highest_loan_records from banker_data  as b 
inner join loan_records_data  as lr 
on b.banker_id=lr.banker_id  group by b.banker_id,first_name,last_name  order by highest_loan_records desc 

 /* Q. Find the customer ID, first name, last name, and email of customers 
 whose email address contains the term 'amazon'.*/

 select  customer_id,first_name,last_name,email from customer_data where email like '%amazon%'

  /*Q. Find the maximum property value (using appropriate alias) of each property type,
 ordered by the maximum property value in descending order.*/


   select property_type,max(property_value) as highest_value_property from [dbo].[Home_Loan_Data]
   group by property_type order by highest_value_property desc

 --. Find the city name and the corresponding average property value (using appropriate alias)
--  for cities where the average property value is greater than $3,000,000.

select city,AVG(property_value) as av_property_rate from Home_Loan_Data
 group by city having  AVG(property_value)>3000000

/*Find the names of the top 3 cities 
(based on descending alphabetical order) and 
corresponding loan percent (in ascending order) with the lowest average loan percent.*/

SELECT top 3 city,AVG(loan_percent) AS average_loan_percent FROM  Home_loan_data
GROUP BY  city
ORDER BY city DESC, average_loan_percent ASC

SELECT top 3  city,AVG(loan_percent) AS average_loan_percent FROM  Home_loan_data
GROUP BY  city
ORDER BY  average_loan_percent ASC,city DESC


/*Q. Find the average age of male bankers (years, rounded to 1 decimal place) 
based on the date they joined WBG */

select round(avg(DATEDIFF(YEAR, date_joined, GETDATE())),1) as age from [dbo].[Banker_Data] 
  where gender='Male'

 /*  . Find the average age (at the point of loan transaction, in years and nearest integer) of female customers 
 who took a non-joint loan for townhomes.*/

SELECT avg(DATEDIFF(YEAR, customer_since, GETDATE())) as avg_age
FROM Customer_data AS c
INNER JOIN loan_records_data AS lr ON c.customer_id = lr.customer_id
INNER JOIN home_loan_data AS hl ON lr.loan_id = hl.loan_id where gender='Female' and joint_loan='No' and
property_type='Townhome'

--Q. Find the total number of different cities for which home loans have been issued. 

select count (distinct city) as Total_cities from Home_Loan_Data


/* Q. Find the average loan term for loans not for semi-detached and townhome property types, 
and are in the following list of cities: Sparks, Biloxi, Waco, Las Vegas, and Lansing.  (2 Marks)
*/

 select AVG(loan_term) as avg_loan_term from home_loan_data where property_type not in ('Semi-Detached','Townhome') and city
 in ('Sparks', 'Biloxi','Waco', 'Las Vegas','Lansing')


