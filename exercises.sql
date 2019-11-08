-- 1. List each employee first name, last name and supervisor status along with their department name. Order by 
-- department name, then by employee last name, and finally by employee first name.
SELECT e.FirstName, e.LastName, e.IsSupervisor,
		d.Name
FROM Employee e LEFT JOIN Department d on d.Id = e.DepartmentId
ORDER BY d.Name, e.LastName, e.FirstName;


-- 2. List each department ordered by budget amount with the highest first.
SELECT Id, Name, Budget
FROM Department
ORDER BY Budget DESC;


-- 3. List each department name along with any employees (full name) in that department who are supervisors.
SELECT d.Name, e.FirstName, e.LastName, e.IsSupervisor
FROM Department d LEFT JOIN Employee e ON e.DepartmentId = d.Id
WHERE e.IsSupervisor = 1;


-- 4. List each department name along with a count of employees in each department.
SELECT d.Name, COUNT(*) as 'NumEmployees'
FROM Department d LEFT JOIN Employee e ON e.DepartmentId = d.Id
GROUP BY d.Name;


-- 5. Write a single update statement to increase each department's budget by 20%.
SELECT * FROM Department

UPDATE Department
SET Department.Budget = Department.Budget * 1.2;

SELECT * FROM Department


-- 6. List the employee full names for employees who are not signed up for any training programs.
SELECT e.FirstName, e.LastName
FROM Employee e LEFT JOIN EmployeeTraining et ON et.EmployeeId = e.Id
WHERE NOT EXISTS (
	SELECT et.EmployeeId FROM EmployeeTraining et WHERE e.Id = et.EmployeeId);



-- 7.List the employee full names for employees who are signed up for at least one training 
-- program and include the number of training programs they are signed up for.
SELECT e.FirstName, e.LastName, e.Id, COUNT(*) as 'NumCourses'
FROM Employee e LEFT JOIN EmployeeTraining et ON et.EmployeeId = e.Id
WHERE et.EmployeeId IS NOT NULL
GROUP BY e.FirstName, e.LastName, e.Id


-- 8. List all training programs along with the count employees who have signed up for each.
SELECT tp.Id, tp.Name, tp.StartDate, COUNT(*) as 'NumEmployees'
FROM EmployeeTraining as et LEFT JOIN TrainingProgram tp ON tp.Id = et.TrainingProgramId
GROUP BY tp.Id, tp.Name, tp.StartDate;


-- 9. List all training programs who have no more seats available.
SELECT tp.Id, tp.Name, tp.StartDate, tp.MaxAttendees, COUNT(*) as 'NumEmployees'
FROM TrainingProgram tp LEFT JOIN EmployeeTraining et ON et.TrainingProgramId = tp.Id
GROUP BY tp.Id, tp.Name, tp.StartDate, tp.MaxAttendees
HAVING COUNT(*) = tp.MaxAttendees;


-- 10. List all future training programs ordered by start date with the earliest date first.
SELECT tp.Id, tp.Name, tp.StartDate, tp.MaxAttendees
FROM TrainingProgram tp
WHERE tp.StartDate > GETDATE()

-- 11. Assign a few employees to training programs of your choice.
--INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (7, 12);
--INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (9, 13);
--INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (10, 14);



-- 12. List the top 3 most popular training programs. (For this question, consider each record in the 
-- training program table to be a UNIQUE training program).
SELECT TOP 3 tp.Id, COUNT(*) as 'NumEmployees'
FROM TrainingProgram tp INNER JOIN EmployeeTraining et ON tp.Id = et.TrainingProgramId
GROUP BY tp.Id
ORDER BY COUNT(*) DESC


-- 13. List the top 3 most popular training programs. (For this question consider training programs 
-- with the same name to be the SAME training program).
SELECT TOP 3 tp.Name, COUNT(*) as 'NumEmployees'
FROM TrainingProgram tp INNER JOIN EmployeeTraining et ON tp.Id = et.TrainingProgramId
GROUP BY tp.Name
ORDER BY COUNT(*) DESC


-- 14. List all employees who do not have computers.
SELECT e.Id, e.FirstName, e.LastName
FROM Employee e LEFT JOIN ComputerEmployee ce ON e.Id = ce.EmployeeId
WHERE NOT EXISTS(SELECT ce.EmployeeId FROM ComputerEmployee ce WHERE e.Id = ce.EmployeeId)


-- 15. List all employees along with their current computer information make and manufacturer combined 
-- into a field entitled ComputerInfo. If they do not have a computer, this field should say "N/A".

SELECT e.Id, e.FirstName, e.LastName, CONCAT(ISNULL(c.Make, ''), ISNULL(c.Manufacturer, 'N/A')) as 'ComputerInfo'
FROM Employee e LEFT JOIN ComputerEmployee ce ON e.Id = ce.EmployeeId
				LEFT JOIN Computer c ON ce.ComputerId = c.Id

-- 16. List all computers that were purchased before July 2019 that are have not been decommissioned.
SELECT c.Id, c.Make, c.Manufacturer, c.PurchaseDate, c.DecomissionDate
FROM Computer c
WHERE c.PurchaseDate < '2019-07-01' AND c.DecomissionDate IS NULL;


-- 17. List all employees along with the total number of computers they have ever had.
SELECT e.Id, e.FirstName, e.LastName, COUNT(*) as 'NumComputers'
FROM Employee e INNER JOIN ComputerEmployee ce ON ce.EmployeeId = e.Id
GROUP BY e.Id, e.FirstName, e.LastName

-- 18. List the number of customers using each payment type
SELECT pt.Name, COUNT(*) as 'NumCustomers'
FROM PaymentType pt INNER JOIN Customer c on pt.CustomerId = c.Id
GROUP BY pt.Name

-- 19. List the 10 most expensive products and the names of the seller
SELECT TOP 10 p.Id, p.Price, p.Title, p.Description, c.Id, CONCAT(c.FirstName, ' ', c.LastName) as 'Seller'
FROM Product p LEFT JOIN Customer c ON p.CustomerId = c.Id
ORDER BY p.Price DESC

-- 20. List the 10 most purchased products and the names of the seller
SELECT TOP 10 p.Id, p.Title, p.Description, c.FirstName, c.LastName, COUNT(*) as 'NumSold'
FROM OrderProduct op LEFT JOIN Product p ON p.Id = op.ProductId
	LEFT JOIN Customer c on p.CustomerId = c.Id
GROUP BY p.Id, p.Title, p.Description, c.FirstName, c.LastName
ORDER BY NumSold DESC

-- 21. Find the name of the customer who has made the most purchases
--		*Customer that has purchased the most individual products
SELECT c.FirstName, c.LastName, COUNT(*) as 'NumPurchases'
FROM Customer c LEFT JOIN [Order] o ON o.CustomerId = c.Id
	LEFT JOIN OrderProduct op ON op.OrderId = o.Id
GROUP BY c.FirstName, c.LastName
ORDER BY NumPurchases DESC


-- 22. List the amount of total sales by product type
SELECT pt.Id, pt.Name, SUM(p.Price)
FROM ProductType pt LEFT JOIN Product p on p.ProductTypeId = pt.Id
	LEFT JOIN OrderProduct op ON op.ProductId = p.Id
GROUP BY pt.Id, pt.Name
ORDER BY pt.Id



-- 23. List the total amount made from all sellers
SELECT c.Id, c.FirstName, c.LastName, SUM(p.Price)
FROM Customer c INNER JOIN Product p on p.CustomerId = c.Id
	INNER JOIN OrderProduct op on op.ProductId = p.Id
GROUP BY c.Id, c.FirstName, c.LastName
ORDER BY SUM(p.Price) DESC





	

