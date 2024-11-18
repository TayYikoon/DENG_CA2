--  Question 1 : Profit

USE SPAIDW2A0104

-- Query to get total profit per year and month

SELECT 
    MonthName,
    ISNULL([2021], 0) AS [2021],
    ISNULL([2022], 0) AS [2022],
    ISNULL([2023], 0) AS [2023]
FROM 
(
    SELECT 
        DATENAME(MONTH, DATEFROMPARTS(t.Year, t.Month, 1)) AS MonthName,
        t.Year,
        SUM(O.Price) AS total_profit
    FROM 
        OrderFacts O
    JOIN 
        Time t ON O.TimeSK = t.TimeSK
    GROUP BY 
        t.Year,
        t.Month
) AS SourceTable
PIVOT
(
    SUM(total_profit)
    FOR Year IN ([2021], [2022], [2023])
) AS PivotTable
ORDER BY 
    CASE MonthName
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'July' THEN 7
        WHEN 'August' THEN 8
        WHEN 'September' THEN 9
        WHEN 'October' THEN 10
        WHEN 'November' THEN 11
        WHEN 'December' THEN 12
    END;

 -- Observation + Explanations : --
 /*
 for the months: 
- From this, we can observe certain things. First, we can see that the most profit is always during December with a value of 55,113 in 2021, 112,816 in 2022 and 223,587 in 2023. We can also see that January does the worst in terms of profit gained, with 1,103 in 2021, 1,158 in 2022 and 3,031 in 2023. As compared to December, the total amount of profit earned in all 3 years in January is 5292 while that of December is 391516, which is which a whopping 7300% or 73 times more.
- Moreover, we can also observe a general trend where the profit seems to be a lot better during the end of the year (September, October, November, December) as compared to the start of the year (January, February, March, April).  This can be because of the seasonal variations where companies might purposely invest more in AI solutions before the holiday season to optimize sales and customer experience.
*/

-- Query to get average profit per model type

USE SPAIDW2A0104

SELECT 
    mt.ModelType AS model_name,
    SUM(O.Price) AS total_profit,
    AVG(O.Price) AS avg_profit_per_model
FROM 
    OrderFacts O
JOIN 
    Model m ON O.ModelSK = m.ModelSK
JOIN 
    ModelType mt ON m.ModelCode = mt.ModelCode
GROUP BY 
    mt.ModelType
ORDER BY 
    total_profit DESC;

 -- Observation + Explanations : --
 /*
 - Neural Network has the highest total profit, at 633,131. This is almost 5x the profit or 466.6% of the model with the second highest total profit, Support Vector Machine, at 111,736. This means that Neural Network has historically been the model that has earned the most profit for the company, since its start. As for the rest of the models, we can see that their total profits are around the same, with Random Forest being the lowest at 94,341. This shows that these models make around the same amount of sales
 - As for the average profit we can see that Neural Networks clearly has the highest profit, at 465, which is 114 more than the second best, Support Vector Machine at 351. As for the rest of the models, we can also observe that make around the same amount of sales, with most of their average profits being around the 350 mark.
 - INSIGHT: It is recommended that the company focus on providing promotions and incentives for the model types other than Neural Network, especially Support Vector Machine, to ensure that all model types are profitable.

 */


 --  Question 2 : Customers and Orders

-- Query to compare order model's average accuracy to average accuracies that customers require
SELECT 
    mt.ModelType AS "Order Model",
	AVG(m.Accuracy) AS "Average Accuracy",
	AVG(O.RequiredAcc) AS "Average Customer Required Accuracy"
FROM 
    OrderFacts OFT
JOIN 
    Model m ON OFT.ModelSK = m.ModelSK
JOIN
	[Order] O ON OFT.OrderSK = O.OrderSK
JOIN 
    ModelType mt ON m.ModelCode = mt.ModelCode
GROUP BY 
    mt.ModelType
ORDER BY 
    [Average Accuracy] DESC;

 -- Observation + Explanations : --
 /*
 - From this, we can see the Accuracies required by the customers as compared to the accuracies of the models given to the companies. We can observe that the average of the average accuracy seems to be around 85% while the average of the average customer required accuracy seems to be around 64.5%. From this, we can see that this company ensures that its customer's requirements are met and in fact does more to ensure that they exceed customer expectations. Instead of giving the customer an above average model with around 65% accuracy, this company ensures that all its customers receive a good model with around 80% accuracy. Moreover, this proves that the Company provides a higher quality of service, which could have been a reason as to why the company grew rapidly from 2021 to 2023. This is as they were able to attract more customers and retain current ones due to the quality of service they provide, which helped them distinguish themselves in the market.
 */

-- Query to show total number of models ordered by each company, total money spent, and average and highest accuracy needed
SELECT 
    C.CompanyName,
    COUNT(F.ModelSK) AS TotalNumberOfModelsOrdered,
    SUM(F.Price) AS TotalAmountSpent,
    FORMAT(ROUND(AVG(O.RequiredAcc), 1), '0.#') AS AverageRequiredAccuracy,
    FORMAT(ROUND(MAX(O.RequiredAcc), 1), '0.#') AS HighestRequiredAccuracy
FROM 
    Customer C
LEFT JOIN 
    OrderFacts F ON C.CustomerSK = F.CustomerSK
LEFT JOIN 
    [Order] O ON F.OrderSK = O.OrderSK
GROUP BY 
    C.CompanyName
ORDER BY 
    TotalAmountSpent DESC

 -- Observation + Explanations : --
 /*
- The company who has spent the most money is Nu Company, with the total amount spent being 326,511, which is 145.6 % more spent as compared to the second company, Gamma Enterprises, which only spent 132,948. The company which spent the least amount of money is ABC Company. Which spent only 11,022. As for the total number of models ordered, we can see that Nu Company ordered 742 models which is more than 2x of how many models Gamma Enterprises ordered. Thus we can conclude that Nu Company is the most valuable customer. 
- As for Accuracy, we can see that all of the companies have around the same requirements. As for average, we can see that all the companies are in the ballpark of about 64% accuracy. As for highest accuracy, we can see that all the companies are in the ballpark of 77.8%. From this we can say that all the companies only required a model that performs better than average, rather than models close to perfection.
*/


--  Question 3 : Employees

-- Query to get number of orders fulfilled by each employee, along with their names, total profit and average profit
SELECT
	E.FirstName + ' ' + E.LastName AS 'Full Name',
	COUNT(O.OrderSK) AS 'Number Of Orders Fulfilled',
	SUM(O.Price) AS 'Total Profit',
	AVG(O.Price) AS 'Average Profit Per Model'
FROM 
	OrderFacts O
JOIN 
	Employee E ON O.EmployeeSK = E.EmployeeSK
GROUP BY
	E.FirstName,
	E.LastName
ORDER BY
	[Total Profit] DESC;

 -- Observation + Explanations : --
 /*
 - Mia Lewis has the highest amount of total orders fulfilled at 651 orders, and the highest total profit, at 295,219. This shows that Mia fulfilled more than 2.5x the number of orders as compared to Emily Scott and generated a profit which is 238.5% more what Emily generated, which is 87,203. As for the average profit per model, we can see the all the employees are in the range of 340 � 460, with Mia being the highest at 453, and Liam being the lowest at 340.
- Moreover, we can also notice that for some cases, an employee may have sold more models but made lesser profit. For example, Isabella Collins sold 141models, while Matthew Adams sold 139. Yet, Isabella�s total profit was 53,082, while Matthew�s was 54,726, which is more than 1,5k higher. This can be due to the type of models they sold as some models cost more than others, which can be seen by our queries from Question 1.
- INSIGHT: It is important for the company to provide incentives for employees to earn higher profits for the company, and they should start doing this.
*/

-- Query to show the average profit by each employee
SELECT 
    E.FirstName + ' ' + E.LastName AS 'Full Name',
    ROUND(SUM(CASE WHEN T.Year = 2023 THEN F.Price ELSE 0 END) / NULLIF(COUNT(DISTINCT CASE WHEN T.Year = 2023 THEN T.Year ELSE NULL END), 0), 2) AS '2023'
FROM 
    OrderFacts F
JOIN 
    Employee E ON F.EmployeeSK = E.EmployeeSK
JOIN 
    Time T ON F.TimeSK = T.TimeSK
GROUP BY 
    E.FirstName,
    E.LastName
ORDER BY 
    ROUND(SUM(CASE WHEN T.Year = 2023 THEN F.Price ELSE 0 END) / NULLIF(COUNT(DISTINCT CASE WHEN T.Year = 2023 THEN T.Year ELSE NULL END), 0), 2) ASC,
    E.LastName,
    E.FirstName;

 -- Observation + Explanations : --
 /*
- This query shows us the performance of each employee during 2023. We decided to use this query as the company thrived the most in 2023, with the highest amount of profits. Thus, this allowed us to see which employee contributed most or contributed little to the success of this company in 2023. Thus, from this, we can see that Mia Lewis definitely contributed the most. However, Liam Turner contributed extremely poorly, with only 11,661 contributed, which is 50% lesser than what the 2nd least contribution was, which is 23,280. Moreover, Liam was not anywhere close the average profit contributed by each employee, which seems to be around 27k. It is suggested that the company consults Liam on his poor performance and maybe provides him help as he may be struggling, to be able to see better results from him in the future.
*/