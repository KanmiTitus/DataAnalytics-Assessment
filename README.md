# DataAnalytics-Assessment

## Olasunkanmi's submission for Cowrywise SQL proficiency data analyst assessment.

## Per-Question Explanations and Challenges: 

* *My thought process and problem-solving approach followed a high-level perspective. I started by exploring the database to understand all the data points, not just in relation to the questions, but also with broader context in mind. I combined this with the mini data dictionary and explanations of key fields provided in the assessment brief.*

* *From there, I broke each solution down into smaller blocks. I wrote the query from the basics, tested it, and iterated by gradually adding each piece of logic until I met all the requirements for accuracy and the desired output.*

### Assessment_Q1

* My approach started with identifying where all the required output was housed and how to join the tables to get accurate results.
The complexity came with how to count distinct plans using 1 as a data point under "is_a_fund" and "is_a_regular_savings". I introduced a CASE statement and used "confirmed_amount > 0" in my WHERE clause to filter for funded accounts, since "confirmed_amount" represents actual inflow.

* For ease of comprehension and business decision-making across any department, I chose to output the total deposit in *Naira*.
Finally, I used an aggregate `CASE` statement in the `HAVING` clause after grouping to filter for at least one funded account. This ensured I addressed all the requirements of the question and delivered the desired and accurate output.


### Assessment_Q2

* My approach to this question was from the ground up. I started by writing a query that gave us the aggregate table of all transactions per customer, as well as the earliest and latest transaction dates in "YY-MM" format. I structured this as a CTE (Common Table Expression), thinking about query optimization, since we’re working with large tables, it made sense to build a base dataset first. This way, any follow_up logic wouldn’t have to query the large base tables repeatedly. It improved query execution and output time.

* Next, I wrote a query to calculate inactive months using `DATE_FORMAT` to format dates as year-month, `PERIOD_DIFF` (specific to MySQL), and `GREATEST() to calculate `the highest duration. From this, I could derive the frequency of transactions per month.

* **Challenge**: I initially used SQL dialects like `DATE_PART`, but MySQL’s IntelliSense flagged unrecognized functions. I quickly checked online and learned MySQL-specific alternatives to get the desired results.

* Finally, I wrote the output query using a `CASE()` statement to classify transaction frequency as outlined in the brief, then counted users in each category and calculated the average transactions per month, grouping accordingly to deliver the final result.


### Assessment_Q3

* Initially, I thought a subquery might be needed, but as I began writing the query and addressing the question requirements one by one, everything came together in a single query.
* I selected all required outputs and used a `CASE()` statement to handle the classification for "Savings" and "Investment", represented as 1 under "is_regular_savings" and "is_a_fund". I got the last transaction date using a simple `MAX()` function. To calculate inactivity in days, I subtracted the last transaction date from the current date using `CURDATE()` and `DATEDIFF()`.

* The data came from both "savings_savingsaccount" and "plans_plan", and I used a `LEFT JOIN` to ensure no information was lost. I also filtered based on a subtle but important requirement, checking for "active" accounts. I interpreted this as accounts that had any inflow ("confirmed_amount > 0").

* In the `WHERE` clause, I covered both savings and investment using the `OR` operator, grouped by all non-aggregated fields, and used the `HAVING` clause to filter for accounts inactive for over a year (365 days).

* I didn’t face any major difficulties here reading the question thoroughly helped me break it down into a straightforward logical flow.

### Assessment_Q4

* Writing an optimized query for this was quite straightforward, especially after learning about MySQL-specific time functions in the previous questions.
* I used the `SELECT` statement to output all desired values and used the `CONCAT` function to format the name field as shown in the example output.

* To calculate tenure in months since sign-up, I used `PERIOD_DIFF(DATE_FORMAT(...))` on "date_joined" from the "users_customuser" table and the current date. I then calculated the "estimated_clv" using the formula provided in the brief.

* Finally, I grouped the result by customer and ordered by "estimated_clv" in descending order.

