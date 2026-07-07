--Print customer Id, customer name and average account_balance maintained by each customer for all  of his/her accounts in the bank.(8 Rows)
select b.customer_id, b.customer_name,avg(d.Balance_amount) as average_account_amonut
from BANK_CUSTOMER as b
join Bank_Account_Details as d
on b.customer_id=d.customer_id
group by b.customer_id, b.customer_name
order by average_account_amonut ;
--Print customer_id , account_number and balance_amount , condition that if balance_amount is nil then assign transaction_amount  
--for account_type = "Credit Card"(4 Rows)
select d.customer_id,d.account_number,t.Transaction_amount as balance_amount
from Bank_Account_Details d
join BANK_ACCOUNT_TRANSACTION t
on d.account_number=t.account_number
where d.Balance_amount=0 and d.account_type = 'credit Card'
--Print account_number and balance_amount , transaction_amount,Transaction_Date from Bank_Account_Details and bank_account_transaction
--for all the transactions occurred during march,2020 and april, 2020(12 Rows)
select d.account_number,d.balance_amount,t.transaction_amount,t.Transaction_Date
from Bank_Account_Details as d
join BANK_ACCOUNT_TRANSACTION as t
on d.account_number=t.account_number
where t.Transaction_Date between '2020-03-01' and '2020-04-30'

--Print all of the customer id, account number,  balance_amount, transaction_amount , Transaction_Date  from bank_customer,
--Bank_Account_Details and bank_account_transaction tables where excluding all of their transactions in march, 2020  month (22 Rows)
select a.customer_id,d.account_number,d.balance_amount,t.transaction_amount,t.Transaction_Date
from bank_customer a
left join Bank_Account_Details as d on a.customer_id=d.customer_id
left join BANK_ACCOUNT_TRANSACTION t on d.Account_Number=t.Account_Number
where t.Transaction_Date not between '2020-03-01' and '2020-03-31' or t.Transaction_Date is null

--Print only the customer id, account_number, balance_amount,transaction_amount ,transaction_date who did transactions during the
--first quarter. Do not display the accounts if they have not done any transactions in the first quarter.(16 Rows)
select d.customer_id,d.account_number,d.balance_amount,t.transaction_amount,t.Transaction_Date
from Bank_Account_Details as d
join BANK_ACCOUNT_TRANSACTION t
on d.Account_Number=t.Account_Number
where t.Transaction_Date between '2020-01-01' and '2020-03-31'

--Print account_number, Event and Customer_message from BANK_CUSTOMER_MESSAGES and Bank_Account_Details to display an “Adhoc" 
--Event for all customers who have  “SAVINGS" account_type account.(8 Rows)
alter table BANK_CUSTOMER_MESSAGES --creating surrogate key
add cus_id int identity(1,1)
alter table Bank_Account_Details
add cus_id int
update Bank_Account_Details --updating vaalues
set cus_id=
case 
when account_type='SAVINGS' then 1
else 2
end

select d.account_number,m.Event,m.Customer_message
from Bank_Account_Details d
join BANK_CUSTOMER_MESSAGES m
on d.cus_id=m.cus_id
where account_type='savings'

--Print all Customer_id, Account_Number, Account_type, and display deducted balance_amount by  subtracting only negative
--transaction_amounts for Relationship_type ="P" ( P - means  Primary , S - means Secondary ) .(27 Rows)
select d.Customer_id, d.Account_Number, d.Account_type,(t.transaction_amount + d.balance_amount) as balance_amount
from Bank_Account_Details as d
join BANK_ACCOUNT_TRANSACTION as t
on d.account_number=t.account_number
where d.Relationship_type='p'

select d.Relationship_type,d.Account_Number,t.Account_Number
from Bank_Account_Details as d
left join BANK_ACCOUNT_TRANSACTION as t
on d.account_number=t.account_number
where d.Relationship_type='p'

--a) Display records of All Accounts , their Account_types, the transaction amount.
select d.Account_Number,d.Account_type ,sum(t.transaction_amount) as transaction_amount
from Bank_Account_Details as d
left join BANK_ACCOUNT_TRANSACTION as t
on d.account_number=t.account_number
group by d.Account_Number,d.Account_type



--Along with first step, Display other columns with corresponding linking account number, account types (15 Rows)

with a as (select d.Account_Number,d.Account_type ,sum(t.transaction_amount) as transaction_amount
from Bank_Account_Details as d
 left join BANK_ACCOUNT_TRANSACTION as t
on d.account_number=t.account_number
group by d.Account_Number,d.Account_type)

select a.Account_Number,a.Account_type , a.transaction_amount,t.linking_account_number
from a 
join Bank_Account_Relationship_Details t
on a.Account_Number=t.Account_Number

--After retrieving all records of accounts and their linked accounts, display the   transaction amount of accounts appeared
--in another column.(26 Rows)
select t.transaction_amount
from Bank_Account_Relationship_Details d
join BANK_ACCOUNT_TRANSACTION t
on d.account_number=t.account_number

select count(transaction_amount)
from BANK_ACCOUNT_TRANSACTION

--Display all saving account holders have “Add-on Credit Cards" and “Credit cards" 
SELECT 
    s.Customer_id
FROM Bank_Account_Details s
JOIN Bank_Account_Relationship_Details c
ON s.Account_Number=c.Linking_Account_Number
JOIN Bank_Account_Relationship_Details ac
ON c.Account_Number=ac.Linking_Account_Number
WHERE
s.Account_type='SAVINGS'
AND c.Account_type='Credit Card'
AND ac.Account_type='Add-on Credit Card';


SELECT
    s.Account_Number AS Savings_Account,
    SUM(t.Transaction_amount) AS Total_Credit_Transactions
FROM Bank_Account_Relationship_Details r
JOIN Bank_Account_Details s
ON r.Linking_Account_Number=s.Account_Number
JOIN BANK_ACCOUNT_TRANSACTION t
ON r.Account_Number=t.Account_Number
WHERE
s.Account_type='SAVINGS'
AND r.Account_type='Credit Card'
GROUP BY
s.Account_Number;




