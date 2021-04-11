/*
QUEREY 1. 
Write a query to find the 5 oldest user
*/

SELECT 
    *
FROM
    users
ORDER BY created_at ASC
LIMIT 5;

/*
QUERY 2.
Write a query to find what day of the week do most users register on?
*/

SELECT 
    DAYNAME(created_at) AS day, COUNT(*) AS total
FROM
    users
GROUP BY 1
ORDER BY 2 DESC;
/*
NOTE:-
GROUP BY 1 , here "1" represents the formula [DATE_FORMAT(created_at,'%W')]
ORDER BY 2 DESC, here "2" represents the formula [COUNT(*)]
*/

/*
QUERY 3. 
Write a query to find the users name who have never posted a photo in their instagram
*/
SELECT 
    username
FROM
    users
	LEFT JOIN
    photos ON users.id = photos.user_id
WHERE
    photos.id IS NULL;
    
/*
QUERY 4.
Write a query to find the photo which has got the most likes in the Instagram
*/
SELECT 
    users.username,
    photos.id,
    photos.image_url,
    COUNT(*) AS Total_Likes
FROM 
    likes
        JOIN
    photos ON photos.id = likes.photo_id
        JOIN
    users ON users.id = likes.user_id
GROUP BY photos.id
ORDER BY Total_Likes DESC
LIMIT 1;
	
/*QUERY 5.
Write a query to find the value for total number of photos/total number of users=Average user post
*/
SELECT 
    ROUND(((SELECT 
                    COUNT(*)
                FROM
                    users) / (SELECT 
                    COUNT(*)
                FROM
                    photos)),
            2) AS 'AVERAGE USER POST';
            
/*
QUERY 6.
Write a query to find user ranking by postings higher to lower
*/
SELECT 
    users.username, COUNT(photos.image_url)
FROM
    users
        JOIN
    photos ON users.id = photos.user_id
GROUP BY users.id
ORDER BY 2 DESC;

/*
QUERY 7.
Write a query to find the Total Posts by users (longer versionof SELECT COUNT(*)FROM photos) 
*/
SELECT 
    SUM(user_posts.total_posts_by_user)
FROM
    (SELECT 
        users.username,
            COUNT(photos.image_url) AS total_posts_by_user
    FROM
        users
    JOIN photos ON users.id = photos.user_id
    GROUP BY users.id) AS user_posts;
    
/*
QUERY 8.
Write a query to find the total numbers of users who have posted at least one time */
SELECT 
    COUNT(DISTINCT (users.id)) AS total_number_of_users_with_at_least_one_post
FROM
    users
        JOIN
    photos ON users.id = photos.user_id;
    
/*
QUERY 9.
Write a query to find the top 5 commonly used hashtags
*/
SELECT 
    tag_name, COUNT(tag_name) AS total
FROM
    tags
        JOIN
    photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY total DESC;

/*
QUERY 10.
Write a query to find users who have liked every single photo on instagram
*/
SELECT 
    users.id, username, COUNT(users.id) AS total_likes_by_user
FROM
    users
        JOIN
    likes ON users.id = likes.user_id
GROUP BY users.id
HAVING total_likes_by_user = (SELECT 
        COUNT(*)
    FROM
        photos);
        
/*
QUERY 11.
Write a query to find total number of users who have never commented on a photo
*/

SELECT username,comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NULL;

SELECT COUNT(*) FROM
(SELECT username,comment_text
	FROM users
	LEFT JOIN comments ON users.id = comments.user_id
	GROUP BY users.id
	HAVING comment_text IS NULL) AS total_number_of_users_without_comments;
    
/*
QUERY 12.
Write a query to find the percentage of our users who have either never commented on a photo or have commented on every photo
*/

SELECT tableA.total_A AS 'Number Of Users who never commented',
		(tableA.total_A/(SELECT COUNT(*) FROM users))*100 AS '%',
		tableB.total_B AS 'Number of Users who commented on photos',
		(tableB.total_B/(SELECT COUNT(*) FROM users))*100 AS '%'
FROM
	(
		SELECT COUNT(*) AS total_A FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NULL) AS total_number_of_users_without_comments
	) AS tableA
	JOIN
	(
		SELECT COUNT(*) AS total_B FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NOT NULL) AS total_number_users_with_comments
	)AS tableB ;
    
    SELECT *FROM comments;
    /*people who have commented on every photo*/

    