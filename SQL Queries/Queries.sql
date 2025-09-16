
-- 1. Give the count of all the comment on posts
SELECT Post.Post_ID, COUNT(Comment.Comment_ID) AS Comment_Count
FROM Post
LEFT JOIN Comment ON Post.Post_ID = Comment.Post_ID
GROUP BY Post.Post_ID;


-- 2. Find companies that offer job role for 'Data Analyst'.
SELECT * 
FROM (
    SELECT CIN_No, Vacancy 
    FROM Offered_Jobs 
    WHERE job_role = 'Data Analyst'
) AS t 
NATURAL JOIN company AS c
WHERE c.hiring_status = TRUE;


-- 3. Give top 3 users which have maximum endorsed on C++ skill.
SELECT * 
FROM (
    SELECT COUNT(endorsed_from) AS skill_endorsed_count, user_id 
    FROM (
        SELECT u.user_id 
        FROM User_Skill AS u 
        WHERE u.skill_name='C++'
    ) AS inst
    NATURAL JOIN Skill_Endorsed_By AS ss 
    WHERE ss.skill_name='C++' 
    GROUP BY user_id 
    ORDER BY COUNT(endorsed_from) DESC 
    LIMIT 3
) AS r 
NATURAL JOIN users;


-- 4. List all the certificates of 'USR008'.
SELECT * 
FROM certificates AS c 
WHERE user_id='USR008';


-- 5. List all the posts and comments on each post of userid = 'USR007'.
SELECT r2.post, user_name, r2.description 
FROM (
    SELECT r1.Description AS Post, com.User_ID AS Commenter, com.Description 
    FROM (
        SELECT * 
        FROM post AS pst 
        WHERE pst.user_id='USR007'
    ) AS r1
    JOIN Comment AS com ON r1.Post_ID=com.Post_ID
) AS r2 
JOIN users ON commenter = user_id;


-- 6. Retrieve the details of the group leaders for all groups where the user with USER ID 'USR001' is a member.
SELECT group_name, user_name AS leader_name, email_id, Phone_no 
FROM (
    SELECT user_id, t.group_id 
    FROM (
        SELECT group_ID 
        FROM group_members 
        WHERE user_ID = 'USR001'
    ) AS j 
    NATURAL JOIN group_members AS g
) AS t
WHERE t.is_leader = 'True'
NATURAL JOIN users 
NATURAL JOIN groups;


-- 7. Give the list of all 2nd level of connection of 'USR001'.
SELECT * 
FROM (
    (SELECT r.sent_by_uid 
     FROM (
        (SELECT sent_by_uid 
         FROM request 
         WHERE sent_to_uid='USR001' AND status='Accepted')
        UNION
        (SELECT sent_to_uid 
         FROM request 
         WHERE sent_by_uid='USR001' AND status='Accepted')
     ) AS t 
     JOIN request AS r 
     ON (r.sent_by_uid = t.sent_by_uid OR r.sent_to_uid = t.sent_by_uid) 
     AND r.status = 'Accepted')
    UNION
    (SELECT r12.sent_to_uid 
     FROM (
        (SELECT sent_by_uid 
         FROM request 
         WHERE sent_to_uid='USR001' AND status='Accepted')
        UNION
        (SELECT sent_to_uid 
         FROM request 
         WHERE sent_by_uid='USR001' AND status='Accepted')
     ) AS t12 
     JOIN request AS r12 
     ON (r12.sent_by_uid = t12.sent_by_uid OR r12.sent_to_uid = t12.sent_by_uid) 
     AND r12.status = 'Accepted')
) AS p
EXCEPT
(
    (SELECT sent_by_uid 
     FROM request 
     WHERE sent_to_uid='USR001' AND status='Accepted')
    UNION
    (SELECT sent_to_uid 
     FROM request 
     WHERE sent_by_uid='USR001' AND status='Accepted')
);


-- 8. List all the skills that user with user_ID 'USR001' have.
SELECT skill_name 
FROM (
    (SELECT skill_name 
     FROM (skill_from_edu NATURAL JOIN education) 
     WHERE user_id = 'USR001')
    UNION
    (SELECT skill_name 
     FROM (skill_from_exp NATURAL JOIN experience) 
     WHERE user_id = 'USR001')
    UNION
    (SELECT skill_name 
     FROM user_skill 
     WHERE user_id = 'USR001')
) AS c;


-- 9. Give all skills and number of users having that skill who have experience in 'Microsoft'.
SELECT c.skill_name, COUNT(c.skill_name) AS number_of_person_with_skill 
FROM (
    SELECT * 
    FROM (
        SELECT experience_id 
        FROM (experience NATURAL JOIN company)
        WHERE company_name = 'Microsoft'
    ) AS r1
    NATURAL JOIN skill_from_exp
) AS c 
GROUP BY skill_name 
ORDER BY COUNT(c.skill_name) DESC;


-- 10. Give the list of job_role, company_name and vacancy of the company who are currently hiring.
SELECT o.Job_Role, o.Job_Description, c.company_name, o.Vacancy 
FROM Offered_Jobs AS o 
JOIN Company AS c ON o.CIN_No=c.CIN_No
WHERE Hiring_Status='true';


-- 11. Give the number of connections of all the users.
SELECT u2.user_name, r2.user_connections 
FROM (
    SELECT t.user_id, COUNT(t.user_id) AS user_connections 
    FROM (
        SELECT user_id 
        FROM users AS u 
        JOIN request AS r 
        ON ((u.user_id=r.sent_to_uid OR u.user_id=r.sent_by_uid) AND r.status='Accepted')
    ) AS t 
    GROUP BY t.user_id
) AS r2 
NATURAL JOIN users AS u2;


-- 12. Give details of users who have pursued their master and bachelor degree in the same college.
SELECT t3.user_name, t3.institute_name, t3.bachelor_degree, t3.bachelor_field_of_study, 
       t3.master_degree, t3.master_field_of_study 
FROM (
    (
        SELECT bach.user_id, bach.institute_id, bach.degree AS bachelor_degree, 
               bach.field_of_study AS bachelor_field_of_study,
               mast.degree AS master_degree, mast.field_of_study AS master_field_of_study
        FROM (
            SELECT * FROM education WHERE degree LIKE 'Bach%'
        ) AS bach
        JOIN (
            SELECT * FROM education WHERE degree LIKE 'Mast%'
        ) AS mast
        ON bach.user_id = mast.user_id AND bach.institute_id = mast.institute_id
    ) AS t 
    JOIN users AS u ON t.user_id = u.user_id
) AS t2 
JOIN institute AS inst ON t2.institute_id = inst.institute_id;


-- 13. Give the count of new user registrations within the past four years.
SELECT EXTRACT(YEAR FROM Registration_Date) AS registration_year, COUNT(*) AS new_user_count
FROM users
WHERE Registration_Date >= CURRENT_DATE - INTERVAL '4 YEAR'
GROUP BY registration_year
ORDER BY registration_year;


-- 14. Obtain a list of companies who are offering job roles and users who are looking for job roles where users and company are from the same city.
SELECT u.user_name, u.City, u.Country, o.Job_Role, c.Company_Name
FROM Looks_For AS lf
JOIN Users AS u ON lf.user_ID = u.user_ID
JOIN Offered_Jobs AS o ON lf.Job_Role = o.Job_Role AND lf.CIN_No = o.CIN_No
JOIN Company AS c ON o.CIN_No = c.CIN_No
WHERE u.City = c.City;


-- 15. How many pending request that are sent by the user with userid 'USR002'.
SELECT DISTINCT Users.user_name, Request.sent_date 
FROM Users 
JOIN Request ON Users.User_ID = Request.Sent_To_UID 
WHERE Request.Status = 'Pending'
AND Request.Sent_By_UID = 'USR002';


-- 16. Give top 5 users with most certificates.
SELECT Users.User_Name, COUNT(*) AS Certificate_Count
FROM Users
JOIN Certificates ON Users.User_ID = Certificates.User_ID
GROUP BY Users.User_Name
ORDER BY Certificate_Count DESC
LIMIT 5;


-- 17. List all users who have worked (have experience) for more than one company.
SELECT Users.User_Name, COUNT(DISTINCT Experience.CIN_No) AS Company_Count
FROM Users
JOIN Experience ON Users.User_ID = Experience.User_ID
GROUP BY Users.User_id
HAVING COUNT(DISTINCT Experience.CIN_No) > 1;


-- 18. List all users who have not posted any post yet.
SELECT Users.User_Name
FROM Users
LEFT JOIN Post ON Users.User_ID = Post.User_ID
WHERE Post.Post_ID IS NULL;


-- 19. Give all user who have posted post in last 6 month.
SELECT U.User_Name, P.description, P.Created_Date
FROM Users AS U
LEFT JOIN Post AS P ON U.User_ID = P.User_ID AND P.Created_Date >= CURRENT_DATE - INTERVAL '6 MONTH'
WHERE P.Post_ID IS NOT NULL;


-- 20. Give total vacancy for all the company.
SELECT C.Company_Name, SUM(Vacancy) AS Total_Vacancies
FROM Company C
JOIN Offered_Jobs AS OJ ON C.CIN_No = OJ.CIN_No
GROUP BY C.Company_Name;


-- 21. Give all the users who is not in any group.
SELECT U.User_Name
FROM Users U
LEFT JOIN Group_Members AS GM ON U.User_ID = GM.User_ID
WHERE GM.User_ID IS NULL;


-- 22. Give all the users who are in both group 'GRP001' and 'GRP003'.
SELECT U.User_Name
FROM Users U
JOIN Group_Members AS GM1 ON U.User_ID = GM1.User_ID AND GM1.Group_ID = 'GRP001'
JOIN Group_Members AS GM2 ON U.User_ID = GM2.User_ID AND GM2.Group_ID = 'GRP003';


-- 23. Give all the followers of 'MakeMyTrip' company.
SELECT Users.User_Name, Users.city, Users.country
FROM Users
JOIN Company_Followers ON Users.User_ID = Company_Followers.User_ID
JOIN Company ON Company_Followers.CIN_No = Company.CIN_No
WHERE Company.Company_Name = 'MakeMyTrip';


-- 24. List the count of comment on each post.
SELECT Post.Post_ID, Post.Description AS Post_Description, COUNT(Comment.Comment_ID) AS Comment_Count
FROM Post
LEFT JOIN Comment ON Post.Post_ID = Comment.Post_ID
GROUP BY Post.Post_ID
ORDER BY Comment_Count DESC;
