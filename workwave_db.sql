-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 25, 2024 at 02:34 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `workwave_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_activate_account` (IN `p_activation_token` VARCHAR(255))   BEGIN
	SELECT * FROM
	users 
	WHERE
	activation_token = p_activation_token;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_application` (IN `p_project_id` INT(11), IN `p_user_id` INT(11), IN `p_application_details` TEXT, IN `p_portfolio_url` VARCHAR(255))   BEGIN
    INSERT INTO freelancer_applications (
        project_id,
        user_id,
        application_details,
        portfolio_url,
        application_status_id
    )
    VALUES (
        p_project_id,
        p_user_id,
        p_application_details,
        p_portfolio_url,
        1 
    );
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_projects` (IN `p_user_id` INT(11), IN `p_project_title` VARCHAR(255), IN `p_project_category` VARCHAR(255), IN `p_project_description` TEXT, IN `p_project_objective` TEXT)   BEGIN
    INSERT INTO client_projects (
        user_id,
        project_title,
        project_category_id,
        project_description,
		project_objective
    )
    VALUES (
        p_user_id,
        p_project_title,
        p_project_category,
        p_project_description,
		p_project_objective
    );
	SELECT * FROM v_project_details WHERE id = LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_user_experience` (IN `p_user_id` INT(11), IN `p_job_title` VARCHAR(255), IN `p_company_name` VARCHAR(255), IN `p_duration` VARCHAR(255))   BEGIN
	INSERT INTO freelancer_experiences (user_id, job_title, company_name, duration) VALUES (p_user_id, p_job_title, p_company_name, p_duration);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_deduct_connects` (IN `p_deduction` INT(11), IN `p_user_id` INT(11))   BEGIN
    UPDATE freelancer_connects
    SET connects = connects - p_deduction
    WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_application` (IN `p_project_id` INT(11), IN `p_user_id` INT(11))   BEGIN
    DELETE FROM freelancer_applications
    WHERE project_id = p_project_id AND user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_client_projects` (IN `p_project_id` INT(11), IN `p_user_id` INT(11))   BEGIN
    DELETE FROM client_projects
    WHERE 
        id = p_project_id
        AND user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_users_skills` (IN `p_user_id` INT(11))   BEGIN
DELETE FROM freelancer_skills WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_user_experience` (IN `p_user_experience_id` INT(11), IN `p_user_id` INT(11))   BEGIN
	DELETE FROM freelancer_experiences WHERE id = p_user_experience_id AND user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_project_comments` (IN `p_project_id` INT(11), IN `p_user_id` INT(11), IN `p_comment` TEXT)   INSERT INTO project_comments (project_id, user_id, comment) VALUES (p_project_id, p_user_id, p_comment)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_user_skills` (IN `p_user_id` INT(11), IN `P_skill_id` INT(11))   BEGIN
	INSERT INTO freelancer_skills (user_id, skill_id) VALUES (p_user_id, P_skill_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_refund_connects` (IN `p_project_connect_cost` INT(11), IN `p_user_id` INT(11))   BEGIN
    UPDATE freelancer_connects
    SET connects = connects + p_project_connect_cost
    WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_signup_users` (IN `p_first_name` VARCHAR(50), IN `p_last_name` VARCHAR(50), IN `p_birthdate` DATE, IN `p_gender` VARCHAR(21), IN `p_city` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_password_hash` VARCHAR(255), IN `p_activation_token` VARCHAR(255), IN `p_role` VARCHAR(255))   BEGIN
	IF p_first_name = '' OR p_last_name = '' OR p_birthdate = '' OR p_gender = '' OR p_city = '' OR p_email = '' OR p_password_hash = ''
    THEN
    SELECT 'please fillup all fields' as error_message;
	ELSE
	INSERT INTO users(users.first_name, users.last_name, users.birthdate, users.gender_id, users.city, users.email, users.password_hash, users.activation_token, users.role_id)
	VALUES (p_first_name, p_last_name, p_birthdate, p_gender, p_city, p_email, p_password_hash, p_activation_token, p_role);
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_submit_project_file` (IN `p_submission_url` VARCHAR(255), IN `p_submission_status_id` INT(11), IN `p_project_id` INT(11), IN `p_user_id` INT(11))   UPDATE freelancer_project_submissions 
  SET 
  submission_url = p_submission_url, 
  submission_status_id = p_submission_status_id
  WHERE project_id = p_project_id 
  AND user_id = p_user_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_terminate_freelancer` (IN `p_user_id` INT(11), IN `p_project_id` INT(11))   BEGIN
UPDATE freelancer_applications 
              SET application_status_id = 3 
              WHERE user_id = p_user_id 
              AND project_id = p_project_id;
DELETE FROM freelancer_project_submissions
              WHERE project_id = p_project_id 
              AND user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_activation_token` (IN `p_user_id` INT(11))   BEGIN
	UPDATE users
	SET
	activation_token = NULL
	WHERE
	id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_application_status` (IN `p_status` INT(11), IN `p_application_id` INT(11))   BEGIN
    UPDATE freelancer_applications
    SET application_status_id = p_status
    WHERE id = p_application_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_client_projects` (IN `p_project_title` VARCHAR(255), IN `p_project_category` VARCHAR(255), IN `p_project_description` TEXT, IN `p_project_objective` TEXT, IN `p_project_status` VARCHAR(50), IN `p_project_id` INT(11), IN `p_user_id` INT(11))   BEGIN
    UPDATE client_projects
    SET 
        project_title = p_project_title,
        project_category_id = p_project_category,
        project_description = p_project_description,
	    project_objective = p_project_objective,
        project_status_id = p_project_status
    WHERE 
        id = p_project_id
        AND user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_deactivation` (IN `p_deactivation_duration` VARCHAR(255), IN `p_user_id` INT(11))   BEGIN
	UPDATE users SET
	deactivation_duration = p_deactivation_duration,
	status_id = "2"
	WHERE 
	id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_freelancer_application_status` (IN `p_application_id` INT(11))   BEGIN
    UPDATE freelancer_applications
    SET application_status_id = '2'
    WHERE id = p_application_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_freelancer_project_submissions` (IN `p_submission_status_id` INT(11), IN `p_id` INT(11))   UPDATE freelancer_project_submissions SET submission_status_id = p_submission_status_id  WHERE id = p_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_notification` (IN `p_notification_id` INT(11))   UPDATE notifications SET is_read = 1 WHERE id = p_notification_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_reset_token` (IN `p_reset_token` VARCHAR(255), IN `p_email` VARCHAR(255))   BEGIN
	UPDATE users 
    SET reset_token = p_reset_token,
		reset_token_expiry = DATE_ADD(NOW(), INTERVAL 30 MINUTE)
    WHERE email = p_email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_user_experience` (IN `p_job_title` VARCHAR(255), IN `p_company_name` VARCHAR(255), IN `p_duration` VARCHAR(255), IN `p_user_experience_id` INT(11), IN `p_user_id` INT(11))   BEGIN
	UPDATE freelancer_experiences 
              SET job_title = p_job_title, company_name = p_company_name, duration = p_duration 
              WHERE id = p_user_experience_id AND user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_user_last_login_date` (IN `p_user_id` INT(11))   UPDATE users
    SET last_login_date = NOW()
    WHERE id = p_user_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_user_password` (IN `p_password_hash` VARCHAR(255), IN `p_user_id` INT(11))   BEGIN
UPDATE users 
SET password_hash = p_password_hash, 
reset_token = NULL 
WHERE id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_user_profile` (IN `p_user_id` INT(11), IN `p_first_name` VARCHAR(255), IN `p_last_name` VARCHAR(255), IN `p_job_title_id` INT(11), IN `p_gender` VARCHAR(255), IN `p_mobile_number` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_city` VARCHAR(255), IN `p_language` VARCHAR(255), IN `p_language_2nd` VARCHAR(255))   BEGIN
    UPDATE users
    SET 
        first_name = p_first_name,
        last_name = p_last_name,
        job_title_id = p_job_title_id,
        gender_id = p_gender,
        mobile_number = p_mobile_number,
        email = p_email,
        city = p_city,
        language = p_language,
        language_2nd = p_language_2nd
    WHERE 
        id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_user_profile_picture` (IN `p_profile_picture_url` VARCHAR(255), IN `p_user_id` INT(11))   BEGIN
	UPDATE users 
	SET
		users.profile_picture_url = p_profile_picture_url
	WHERE
		users.id = p_user_id;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `f_capitalize_each_word` (`input` TEXT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE output TEXT;
    DECLARE i INT DEFAULT 1;

    SET output = LOWER(input);

    WHILE i <= CHAR_LENGTH(output) DO
        IF i = 1 OR SUBSTRING(output, i - 1, 1) = ' ' THEN
            SET output = INSERT(output, i, 1, UPPER(SUBSTRING(output, i, 1)));
        END IF;
        SET i = i + 1;
    END WHILE;

    RETURN output;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `client_projects`
--

CREATE TABLE `client_projects` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `project_title` varchar(255) NOT NULL,
  `project_category_id` int(11) NOT NULL,
  `project_description` text DEFAULT NULL,
  `project_objective` text DEFAULT NULL,
  `project_status_id` int(11) NOT NULL DEFAULT 1,
  `project_connect_cost` int(11) DEFAULT 10,
  `project_merit_worth` int(11) DEFAULT 10,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client_projects`
--

INSERT INTO `client_projects` (`id`, `user_id`, `project_title`, `project_category_id`, `project_description`, `project_objective`, `project_status_id`, `project_connect_cost`, `project_merit_worth`, `created_at`, `updated_at`) VALUES
(123, 60, 'Fisch Project', 8, 'Make a Fish Model', 'Fish Model', 2, 10, 10, '2024-12-22 11:59:41', '2024-12-22 13:12:19'),
(124, 60, 'Ocean Cleanup', 8, 'Design a solution for cleaning oceans', 'Ocean Cleanup Model', 2, 15, 15, '2024-12-22 12:05:00', '2024-12-22 13:14:17'),
(125, 60, 'Smart Garden', 5, 'Create a smart garden system', 'Automated Garden System', 1, 20, 20, '2024-12-22 12:10:00', '2024-12-22 13:08:10'),
(126, 60, 'Solar Panel Installation', 3, 'Design and install solar panels', 'Solar Panel System', 2, 25, 25, '2024-12-22 12:15:00', '2024-12-23 12:41:05'),
(127, 61, 'Ai Development', 4, 'Develop an AI-based recommendation system', 'AI-based Recommendation Engine', 2, 30, 30, '2024-12-22 12:20:00', '2024-12-22 13:12:21'),
(128, 61, 'Mobile App Design', 6, 'Design a mobile app for e-commerce', 'E-commerce Mobile Application', 1, 25, 25, '2024-12-22 12:25:00', '2024-12-22 13:08:10'),
(129, 61, 'Website Redesign', 2, 'Redesign a corporate website', 'Corporate Website Redesign', 1, 20, 20, '2024-12-22 12:30:00', '2024-12-22 13:08:10'),
(130, 61, 'Data Analysis', 14, 'Analyze sales data and create reports', 'Sales Data Analysis and Reporting', 1, 35, 35, '2024-12-22 12:35:00', '2024-12-22 13:08:10'),
(131, 61, 'Cloud Storage Solution', 3, 'Develop a cloud storage platform', 'Cloud Storage System Development', 2, 40, 40, '2024-12-22 12:40:00', '2024-12-22 13:16:12'),
(132, 62, 'E-commerce Website', 2, 'Build a fully functional e-commerce website', 'E-commerce Website Development', 1, 30, 30, '2024-12-22 12:45:00', '2024-12-22 13:08:10'),
(133, 62, 'Ai Chatbot Development', 4, 'Develop an AI-powered chatbot for customer service', 'AI Chatbot Development', 2, 40, 40, '2024-12-22 13:00:00', '2024-12-22 13:14:09'),
(134, 62, 'Ai Development', 4, 'Develop an AI-based recommendation system', 'AI-based Recommendation Engine', 1, 30, 30, '2024-12-22 13:05:00', '2024-12-22 13:08:10'),
(135, 62, 'Mobile App Design', 6, 'Design a mobile app for e-commerce', 'E-commerce Mobile Application', 1, 25, 25, '2024-12-22 13:10:00', '2024-12-22 13:08:10'),
(136, 62, 'Website Redesign', 2, 'Redesign a corporate website', 'Corporate Website Redesign', 2, 20, 20, '2024-12-22 13:15:00', '2024-12-22 13:10:21'),
(137, 63, 'Blockchain Development', 4, 'Develop a blockchain-based solution', 'Blockchain System Development', 1, 50, 50, '2024-12-22 12:50:00', '2024-12-22 13:08:10'),
(138, 63, 'Virtual Reality Simulation', 5, 'Develop a virtual reality simulation for training', 'Virtual Reality System Development', 1, 60, 60, '2024-12-22 13:20:00', '2024-12-22 13:07:32'),
(139, 63, 'Data Analysis', 7, 'Analyze sales data and create reports', 'Sales Data Analysis and Reporting', 1, 35, 35, '2024-12-22 13:25:00', '2024-12-22 13:07:28'),
(140, 63, 'Mobile App Development', 6, 'Create a mobile app for social media', 'Social Media Mobile App', 2, 30, 30, '2024-12-22 13:30:00', '2024-12-22 13:16:16'),
(141, 63, 'Cloud Storage Solution', 3, 'Develop a cloud storage platform', 'Cloud Storage System Development', 2, 40, 40, '2024-12-22 13:35:00', '2024-12-22 13:09:33'),
(142, 64, 'Mobile Game Development', 6, 'Create a mobile game app', 'Mobile Game Development', 1, 25, 25, '2024-12-22 12:55:00', '2024-12-22 12:55:00'),
(143, 64, 'Web Application Development', 2, 'Develop a web-based application for education', 'Education Web Application', 1, 30, 30, '2024-12-22 13:40:00', '2024-12-22 13:40:00'),
(144, 64, 'Seo Optimization', 3, 'Optimize a website for search engines', 'SEO Services for Website', 1, 20, 20, '2024-12-22 13:45:00', '2024-12-22 13:45:00'),
(145, 64, 'Social Media Marketing', 7, 'Create a social media marketing campaign', 'Social Media Marketing for Brand', 2, 25, 25, '2024-12-22 13:50:00', '2024-12-22 13:09:30'),
(146, 64, 'Video Production', 5, 'Create a promotional video for a product', 'Product Promotional Video', 2, 35, 35, '2024-12-22 13:55:00', '2024-12-22 13:10:17');

--
-- Triggers `client_projects`
--
DELIMITER $$
CREATE TRIGGER `tr_after_delete_client_project` AFTER DELETE ON `client_projects` FOR EACH ROW BEGIN
    INSERT INTO client_project_audit (
        project_id, user_id, action_type,
        old_project_title, old_project_category_id,
        old_project_description, old_project_objective, old_project_connect_cost, old_project_merit_worth
    )
    VALUES (
        OLD.id, OLD.user_id, 'DELETE',
        OLD.project_title, OLD.project_category_id,
        OLD.project_description, OLD.project_objective, OLD.project_connect_cost, OLD.project_merit_worth
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_after_insert_client_project` AFTER INSERT ON `client_projects` FOR EACH ROW BEGIN
    INSERT INTO client_project_audit (
        project_id, 
        user_id, 
        action_type,
        new_project_title, 
        new_project_category_id, 
        new_project_description,
        new_project_objective,
        new_project_connect_cost, 
        new_project_merit_worth
    )
    VALUES (
        NEW.id, NEW.user_id, 'INSERT',
        NEW.project_title, 
        NEW.project_category_id, 	NEW.project_description,
        NEW.project_objective,
        NEW.project_connect_cost, NEW.project_merit_worth
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_after_update_client_project` AFTER UPDATE ON `client_projects` FOR EACH ROW BEGIN
    INSERT INTO client_project_audit (
        project_id, 
        user_id, 
        action_type,
        old_project_title, 
        new_project_title,
        old_project_category_id,
        new_project_category_id,
        old_project_description,
        new_project_description,
        old_project_objective, 
        new_project_objective,
        old_project_connect_cost,
        new_project_connect_cost,
        old_project_merit_worth, 
        new_project_merit_worth
    )
    VALUES (
        OLD.id, OLD.user_id, 'UPDATE',
        OLD.project_title, 
        NEW.project_title,
        OLD.project_category_id,
        NEW.project_category_id,
        OLD.project_description,
        NEW.project_description,
        OLD.project_objective,
        NEW.project_objective,
        OLD.project_connect_cost,
        NEW.project_connect_cost,
        OLD.project_merit_worth, 
        NEW.project_merit_worth
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_capitalize_project_title_before_insert` BEFORE INSERT ON `client_projects` FOR EACH ROW BEGIN
    SET NEW.project_title = f_capitalize_each_word(NEW.project_title);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_capitalize_project_title_before_update` BEFORE UPDATE ON `client_projects` FOR EACH ROW BEGIN
    SET NEW.project_title = f_capitalize_each_word(NEW.project_title);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `client_project_audit`
--

CREATE TABLE `client_project_audit` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action_type` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `action_timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `old_project_title` varchar(255) DEFAULT NULL,
  `new_project_title` varchar(255) DEFAULT NULL,
  `old_project_category_id` int(11) DEFAULT NULL,
  `new_project_category_id` int(11) DEFAULT NULL,
  `old_project_description` text DEFAULT NULL,
  `new_project_description` text DEFAULT NULL,
  `old_project_objective` text DEFAULT NULL,
  `new_project_objective` text DEFAULT NULL,
  `old_project_connect_cost` int(11) DEFAULT NULL,
  `new_project_connect_cost` int(11) DEFAULT NULL,
  `old_project_merit_worth` int(11) DEFAULT NULL,
  `new_project_merit_worth` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client_project_audit`
--

INSERT INTO `client_project_audit` (`id`, `project_id`, `user_id`, `action_type`, `action_timestamp`, `old_project_title`, `new_project_title`, `old_project_category_id`, `new_project_category_id`, `old_project_description`, `new_project_description`, `old_project_objective`, `new_project_objective`, `old_project_connect_cost`, `new_project_connect_cost`, `old_project_merit_worth`, `new_project_merit_worth`) VALUES
(62, 141, 63, 'INSERT', '2024-12-22 12:08:37', NULL, 'Cloud Storage Solution', NULL, 3, NULL, 'Develop a cloud storage platform', NULL, 'Cloud Storage System Development', NULL, 40, NULL, 40),
(63, 142, 64, 'INSERT', '2024-12-22 12:08:37', NULL, 'Mobile Game Development', NULL, 6, NULL, 'Create a mobile game app', NULL, 'Mobile Game Development', NULL, 25, NULL, 25),
(64, 143, 64, 'INSERT', '2024-12-22 12:08:37', NULL, 'Web Application Development', NULL, 2, NULL, 'Develop a web-based application for education', NULL, 'Education Web Application', NULL, 30, NULL, 30),
(65, 144, 64, 'INSERT', '2024-12-22 12:08:37', NULL, 'Seo Optimization', NULL, 3, NULL, 'Optimize a website for search engines', NULL, 'SEO Services for Website', NULL, 20, NULL, 20),
(66, 145, 64, 'INSERT', '2024-12-22 12:08:37', NULL, 'Social Media Marketing', NULL, 7, NULL, 'Create a social media marketing campaign', NULL, 'Social Media Marketing for Brand', NULL, 25, NULL, 25),
(67, 146, 64, 'INSERT', '2024-12-22 12:08:37', NULL, 'Video Production', NULL, 5, NULL, 'Create a promotional video for a product', NULL, 'Product Promotional Video', NULL, 35, NULL, 35),
(68, 146, 64, 'UPDATE', '2024-12-22 12:22:35', 'Video Production', 'Video Production', 5, 5, 'Create a promotional video for a product', 'Create a promotional video for a product', 'Product Promotional Video', 'Product Promotional Video', 35, 35, 35, 35),
(69, 123, 60, 'UPDATE', '2024-12-22 12:30:16', 'Fisch Project', 'Fisch Project', 8, 8, 'Make a Fish Model', 'Make a Fish Model', 'Fish Model', 'Fish Model', 10, 10, 10, 10),
(70, 123, 60, 'UPDATE', '2024-12-22 12:37:23', 'Fisch Project', 'Fisch Project', 8, 8, 'Make a Fish Model', 'Make a Fish Model', 'Fish Model', 'Fish Model', 10, 10, 10, 10),
(71, 124, 60, 'UPDATE', '2024-12-22 12:37:27', 'Ocean Cleanup', 'Ocean Cleanup', 8, 8, 'Design a solution for cleaning oceans', 'Design a solution for cleaning oceans', 'Ocean Cleanup Model', 'Ocean Cleanup Model', 15, 15, 15, 15),
(72, 125, 60, 'UPDATE', '2024-12-22 12:38:18', 'Smart Garden', 'Smart Garden', 5, 5, 'Create a smart garden system', 'Create a smart garden system', 'Automated Garden System', 'Automated Garden System', 20, 20, 20, 20),
(73, 126, 60, 'UPDATE', '2024-12-22 12:38:18', 'Solar Panel Installation', 'Solar Panel Installation', 3, 3, 'Design and install solar panels', 'Design and install solar panels', 'Solar Panel System', 'Solar Panel System', 25, 25, 25, 25),
(74, 127, 61, 'UPDATE', '2024-12-22 12:38:18', 'Ai Development', 'Ai Development', 4, 4, 'Develop an AI-based recommendation system', 'Develop an AI-based recommendation system', 'AI-based Recommendation Engine', 'AI-based Recommendation Engine', 30, 30, 30, 30),
(75, 128, 61, 'UPDATE', '2024-12-22 12:38:18', 'Mobile App Design', 'Mobile App Design', 6, 6, 'Design a mobile app for e-commerce', 'Design a mobile app for e-commerce', 'E-commerce Mobile Application', 'E-commerce Mobile Application', 25, 25, 25, 25),
(76, 129, 61, 'UPDATE', '2024-12-22 12:38:18', 'Website Redesign', 'Website Redesign', 2, 2, 'Redesign a corporate website', 'Redesign a corporate website', 'Corporate Website Redesign', 'Corporate Website Redesign', 20, 20, 20, 20),
(77, 130, 61, 'UPDATE', '2024-12-22 12:38:18', 'Data Analysis', 'Data Analysis', 14, 14, 'Analyze sales data and create reports', 'Analyze sales data and create reports', 'Sales Data Analysis and Reporting', 'Sales Data Analysis and Reporting', 35, 35, 35, 35),
(78, 131, 61, 'UPDATE', '2024-12-22 12:38:18', 'Cloud Storage Solution', 'Cloud Storage Solution', 3, 3, 'Develop a cloud storage platform', 'Develop a cloud storage platform', 'Cloud Storage System Development', 'Cloud Storage System Development', 40, 40, 40, 40),
(79, 132, 62, 'UPDATE', '2024-12-22 12:38:18', 'E-commerce Website', 'E-commerce Website', 2, 2, 'Build a fully functional e-commerce website', 'Build a fully functional e-commerce website', 'E-commerce Website Development', 'E-commerce Website Development', 30, 30, 30, 30),
(80, 133, 62, 'UPDATE', '2024-12-22 12:38:18', 'Ai Chatbot Development', 'Ai Chatbot Development', 4, 4, 'Develop an AI-powered chatbot for customer service', 'Develop an AI-powered chatbot for customer service', 'AI Chatbot Development', 'AI Chatbot Development', 40, 40, 40, 40),
(81, 134, 62, 'UPDATE', '2024-12-22 12:38:18', 'Ai Development', 'Ai Development', 4, 4, 'Develop an AI-based recommendation system', 'Develop an AI-based recommendation system', 'AI-based Recommendation Engine', 'AI-based Recommendation Engine', 30, 30, 30, 30),
(82, 135, 62, 'UPDATE', '2024-12-22 12:38:18', 'Mobile App Design', 'Mobile App Design', 6, 6, 'Design a mobile app for e-commerce', 'Design a mobile app for e-commerce', 'E-commerce Mobile Application', 'E-commerce Mobile Application', 25, 25, 25, 25),
(83, 136, 62, 'UPDATE', '2024-12-22 12:38:18', 'Website Redesign', 'Website Redesign', 2, 2, 'Redesign a corporate website', 'Redesign a corporate website', 'Corporate Website Redesign', 'Corporate Website Redesign', 20, 20, 20, 20),
(84, 137, 63, 'UPDATE', '2024-12-22 12:38:18', 'Blockchain Development', 'Blockchain Development', 4, 4, 'Develop a blockchain-based solution', 'Develop a blockchain-based solution', 'Blockchain System Development', 'Blockchain System Development', 50, 50, 50, 50),
(85, 138, 63, 'UPDATE', '2024-12-22 12:38:18', 'Virtual Reality Simulation', 'Virtual Reality Simulation', 5, 5, 'Develop a virtual reality simulation for training', 'Develop a virtual reality simulation for training', 'Virtual Reality System Development', 'Virtual Reality System Development', 60, 60, 60, 60),
(86, 139, 63, 'UPDATE', '2024-12-22 12:38:18', 'Data Analysis', 'Data Analysis', 7, 7, 'Analyze sales data and create reports', 'Analyze sales data and create reports', 'Sales Data Analysis and Reporting', 'Sales Data Analysis and Reporting', 35, 35, 35, 35),
(87, 140, 63, 'UPDATE', '2024-12-22 12:38:18', 'Mobile App Development', 'Mobile App Development', 6, 6, 'Create a mobile app for social media', 'Create a mobile app for social media', 'Social Media Mobile App', 'Social Media Mobile App', 30, 30, 30, 30),
(88, 124, 60, 'UPDATE', '2024-12-22 12:53:01', 'Ocean Cleanup', 'Ocean Cleanup', 8, 8, 'Design a solution for cleaning oceans', 'Design a solution for cleaning oceans', 'Ocean Cleanup Model', 'Ocean Cleanup Model', 15, 15, 15, 15),
(89, 125, 60, 'UPDATE', '2024-12-22 12:53:04', 'Smart Garden', 'Smart Garden', 5, 5, 'Create a smart garden system', 'Create a smart garden system', 'Automated Garden System', 'Automated Garden System', 20, 20, 20, 20),
(90, 126, 60, 'UPDATE', '2024-12-22 12:53:07', 'Solar Panel Installation', 'Solar Panel Installation', 3, 3, 'Design and install solar panels', 'Design and install solar panels', 'Solar Panel System', 'Solar Panel System', 25, 25, 25, 25),
(91, 127, 61, 'UPDATE', '2024-12-22 12:53:10', 'Ai Development', 'Ai Development', 4, 4, 'Develop an AI-based recommendation system', 'Develop an AI-based recommendation system', 'AI-based Recommendation Engine', 'AI-based Recommendation Engine', 30, 30, 30, 30),
(92, 128, 61, 'UPDATE', '2024-12-22 12:53:13', 'Mobile App Design', 'Mobile App Design', 6, 6, 'Design a mobile app for e-commerce', 'Design a mobile app for e-commerce', 'E-commerce Mobile Application', 'E-commerce Mobile Application', 25, 25, 25, 25),
(93, 129, 61, 'UPDATE', '2024-12-22 12:53:16', 'Website Redesign', 'Website Redesign', 2, 2, 'Redesign a corporate website', 'Redesign a corporate website', 'Corporate Website Redesign', 'Corporate Website Redesign', 20, 20, 20, 20),
(94, 130, 61, 'UPDATE', '2024-12-22 12:53:19', 'Data Analysis', 'Data Analysis', 14, 14, 'Analyze sales data and create reports', 'Analyze sales data and create reports', 'Sales Data Analysis and Reporting', 'Sales Data Analysis and Reporting', 35, 35, 35, 35),
(95, 131, 61, 'UPDATE', '2024-12-22 12:53:28', 'Cloud Storage Solution', 'Cloud Storage Solution', 3, 3, 'Develop a cloud storage platform', 'Develop a cloud storage platform', 'Cloud Storage System Development', 'Cloud Storage System Development', 40, 40, 40, 40),
(96, 132, 62, 'UPDATE', '2024-12-22 12:53:31', 'E-commerce Website', 'E-commerce Website', 2, 2, 'Build a fully functional e-commerce website', 'Build a fully functional e-commerce website', 'E-commerce Website Development', 'E-commerce Website Development', 30, 30, 30, 30),
(97, 133, 62, 'UPDATE', '2024-12-22 12:53:37', 'Ai Chatbot Development', 'Ai Chatbot Development', 4, 4, 'Develop an AI-powered chatbot for customer service', 'Develop an AI-powered chatbot for customer service', 'AI Chatbot Development', 'AI Chatbot Development', 40, 40, 40, 40),
(98, 134, 62, 'UPDATE', '2024-12-22 12:53:39', 'Ai Development', 'Ai Development', 4, 4, 'Develop an AI-based recommendation system', 'Develop an AI-based recommendation system', 'AI-based Recommendation Engine', 'AI-based Recommendation Engine', 30, 30, 30, 30),
(99, 135, 62, 'UPDATE', '2024-12-22 12:53:43', 'Mobile App Design', 'Mobile App Design', 6, 6, 'Design a mobile app for e-commerce', 'Design a mobile app for e-commerce', 'E-commerce Mobile Application', 'E-commerce Mobile Application', 25, 25, 25, 25),
(100, 136, 62, 'UPDATE', '2024-12-22 12:53:45', 'Website Redesign', 'Website Redesign', 2, 2, 'Redesign a corporate website', 'Redesign a corporate website', 'Corporate Website Redesign', 'Corporate Website Redesign', 20, 20, 20, 20),
(101, 137, 63, 'UPDATE', '2024-12-22 12:53:48', 'Blockchain Development', 'Blockchain Development', 4, 4, 'Develop a blockchain-based solution', 'Develop a blockchain-based solution', 'Blockchain System Development', 'Blockchain System Development', 50, 50, 50, 50),
(102, 138, 63, 'UPDATE', '2024-12-22 12:53:50', 'Virtual Reality Simulation', 'Virtual Reality Simulation', 5, 5, 'Develop a virtual reality simulation for training', 'Develop a virtual reality simulation for training', 'Virtual Reality System Development', 'Virtual Reality System Development', 60, 60, 60, 60),
(103, 139, 63, 'UPDATE', '2024-12-22 12:53:52', 'Data Analysis', 'Data Analysis', 7, 7, 'Analyze sales data and create reports', 'Analyze sales data and create reports', 'Sales Data Analysis and Reporting', 'Sales Data Analysis and Reporting', 35, 35, 35, 35),
(104, 140, 63, 'UPDATE', '2024-12-22 12:53:55', 'Mobile App Development', 'Mobile App Development', 6, 6, 'Create a mobile app for social media', 'Create a mobile app for social media', 'Social Media Mobile App', 'Social Media Mobile App', 30, 30, 30, 30),
(105, 141, 63, 'UPDATE', '2024-12-22 12:53:58', 'Cloud Storage Solution', 'Cloud Storage Solution', 3, 3, 'Develop a cloud storage platform', 'Develop a cloud storage platform', 'Cloud Storage System Development', 'Cloud Storage System Development', 40, 40, 40, 40),
(106, 146, 64, 'UPDATE', '2024-12-22 13:07:15', 'Video Production', 'Video Production', 5, 5, 'Create a promotional video for a product', 'Create a promotional video for a product', 'Product Promotional Video', 'Product Promotional Video', 35, 35, 35, 35),
(107, 141, 63, 'UPDATE', '2024-12-22 13:07:20', 'Cloud Storage Solution', 'Cloud Storage Solution', 3, 3, 'Develop a cloud storage platform', 'Develop a cloud storage platform', 'Cloud Storage System Development', 'Cloud Storage System Development', 40, 40, 40, 40),
(108, 140, 63, 'UPDATE', '2024-12-22 13:07:25', 'Mobile App Development', 'Mobile App Development', 6, 6, 'Create a mobile app for social media', 'Create a mobile app for social media', 'Social Media Mobile App', 'Social Media Mobile App', 30, 30, 30, 30),
(109, 139, 63, 'UPDATE', '2024-12-22 13:07:28', 'Data Analysis', 'Data Analysis', 7, 7, 'Analyze sales data and create reports', 'Analyze sales data and create reports', 'Sales Data Analysis and Reporting', 'Sales Data Analysis and Reporting', 35, 35, 35, 35),
(110, 138, 63, 'UPDATE', '2024-12-22 13:07:32', 'Virtual Reality Simulation', 'Virtual Reality Simulation', 5, 5, 'Develop a virtual reality simulation for training', 'Develop a virtual reality simulation for training', 'Virtual Reality System Development', 'Virtual Reality System Development', 60, 60, 60, 60),
(111, 123, 60, 'UPDATE', '2024-12-22 13:08:10', 'Fisch Project', 'Fisch Project', 8, 8, 'Make a Fish Model', 'Make a Fish Model', 'Fish Model', 'Fish Model', 10, 10, 10, 10),
(112, 124, 60, 'UPDATE', '2024-12-22 13:08:10', 'Ocean Cleanup', 'Ocean Cleanup', 8, 8, 'Design a solution for cleaning oceans', 'Design a solution for cleaning oceans', 'Ocean Cleanup Model', 'Ocean Cleanup Model', 15, 15, 15, 15),
(113, 125, 60, 'UPDATE', '2024-12-22 13:08:10', 'Smart Garden', 'Smart Garden', 5, 5, 'Create a smart garden system', 'Create a smart garden system', 'Automated Garden System', 'Automated Garden System', 20, 20, 20, 20),
(114, 126, 60, 'UPDATE', '2024-12-22 13:08:10', 'Solar Panel Installation', 'Solar Panel Installation', 3, 3, 'Design and install solar panels', 'Design and install solar panels', 'Solar Panel System', 'Solar Panel System', 25, 25, 25, 25),
(115, 127, 61, 'UPDATE', '2024-12-22 13:08:10', 'Ai Development', 'Ai Development', 4, 4, 'Develop an AI-based recommendation system', 'Develop an AI-based recommendation system', 'AI-based Recommendation Engine', 'AI-based Recommendation Engine', 30, 30, 30, 30),
(116, 128, 61, 'UPDATE', '2024-12-22 13:08:10', 'Mobile App Design', 'Mobile App Design', 6, 6, 'Design a mobile app for e-commerce', 'Design a mobile app for e-commerce', 'E-commerce Mobile Application', 'E-commerce Mobile Application', 25, 25, 25, 25),
(117, 129, 61, 'UPDATE', '2024-12-22 13:08:10', 'Website Redesign', 'Website Redesign', 2, 2, 'Redesign a corporate website', 'Redesign a corporate website', 'Corporate Website Redesign', 'Corporate Website Redesign', 20, 20, 20, 20),
(118, 130, 61, 'UPDATE', '2024-12-22 13:08:10', 'Data Analysis', 'Data Analysis', 14, 14, 'Analyze sales data and create reports', 'Analyze sales data and create reports', 'Sales Data Analysis and Reporting', 'Sales Data Analysis and Reporting', 35, 35, 35, 35),
(119, 131, 61, 'UPDATE', '2024-12-22 13:08:10', 'Cloud Storage Solution', 'Cloud Storage Solution', 3, 3, 'Develop a cloud storage platform', 'Develop a cloud storage platform', 'Cloud Storage System Development', 'Cloud Storage System Development', 40, 40, 40, 40),
(120, 132, 62, 'UPDATE', '2024-12-22 13:08:10', 'E-commerce Website', 'E-commerce Website', 2, 2, 'Build a fully functional e-commerce website', 'Build a fully functional e-commerce website', 'E-commerce Website Development', 'E-commerce Website Development', 30, 30, 30, 30),
(121, 133, 62, 'UPDATE', '2024-12-22 13:08:10', 'Ai Chatbot Development', 'Ai Chatbot Development', 4, 4, 'Develop an AI-powered chatbot for customer service', 'Develop an AI-powered chatbot for customer service', 'AI Chatbot Development', 'AI Chatbot Development', 40, 40, 40, 40),
(122, 134, 62, 'UPDATE', '2024-12-22 13:08:10', 'Ai Development', 'Ai Development', 4, 4, 'Develop an AI-based recommendation system', 'Develop an AI-based recommendation system', 'AI-based Recommendation Engine', 'AI-based Recommendation Engine', 30, 30, 30, 30),
(123, 135, 62, 'UPDATE', '2024-12-22 13:08:10', 'Mobile App Design', 'Mobile App Design', 6, 6, 'Design a mobile app for e-commerce', 'Design a mobile app for e-commerce', 'E-commerce Mobile Application', 'E-commerce Mobile Application', 25, 25, 25, 25),
(124, 136, 62, 'UPDATE', '2024-12-22 13:08:10', 'Website Redesign', 'Website Redesign', 2, 2, 'Redesign a corporate website', 'Redesign a corporate website', 'Corporate Website Redesign', 'Corporate Website Redesign', 20, 20, 20, 20),
(125, 137, 63, 'UPDATE', '2024-12-22 13:08:10', 'Blockchain Development', 'Blockchain Development', 4, 4, 'Develop a blockchain-based solution', 'Develop a blockchain-based solution', 'Blockchain System Development', 'Blockchain System Development', 50, 50, 50, 50),
(126, 138, 63, 'UPDATE', '2024-12-22 13:08:10', 'Virtual Reality Simulation', 'Virtual Reality Simulation', 5, 5, 'Develop a virtual reality simulation for training', 'Develop a virtual reality simulation for training', 'Virtual Reality System Development', 'Virtual Reality System Development', 60, 60, 60, 60),
(127, 139, 63, 'UPDATE', '2024-12-22 13:08:10', 'Data Analysis', 'Data Analysis', 7, 7, 'Analyze sales data and create reports', 'Analyze sales data and create reports', 'Sales Data Analysis and Reporting', 'Sales Data Analysis and Reporting', 35, 35, 35, 35),
(128, 140, 63, 'UPDATE', '2024-12-22 13:08:10', 'Mobile App Development', 'Mobile App Development', 6, 6, 'Create a mobile app for social media', 'Create a mobile app for social media', 'Social Media Mobile App', 'Social Media Mobile App', 30, 30, 30, 30),
(129, 141, 63, 'UPDATE', '2024-12-22 13:08:10', 'Cloud Storage Solution', 'Cloud Storage Solution', 3, 3, 'Develop a cloud storage platform', 'Develop a cloud storage platform', 'Cloud Storage System Development', 'Cloud Storage System Development', 40, 40, 40, 40),
(130, 142, 64, 'UPDATE', '2024-12-22 13:08:10', 'Mobile Game Development', 'Mobile Game Development', 6, 6, 'Create a mobile game app', 'Create a mobile game app', 'Mobile Game Development', 'Mobile Game Development', 25, 25, 25, 25),
(131, 143, 64, 'UPDATE', '2024-12-22 13:08:10', 'Web Application Development', 'Web Application Development', 2, 2, 'Develop a web-based application for education', 'Develop a web-based application for education', 'Education Web Application', 'Education Web Application', 30, 30, 30, 30),
(132, 144, 64, 'UPDATE', '2024-12-22 13:08:10', 'Seo Optimization', 'Seo Optimization', 3, 3, 'Optimize a website for search engines', 'Optimize a website for search engines', 'SEO Services for Website', 'SEO Services for Website', 20, 20, 20, 20),
(133, 145, 64, 'UPDATE', '2024-12-22 13:08:10', 'Social Media Marketing', 'Social Media Marketing', 7, 7, 'Create a social media marketing campaign', 'Create a social media marketing campaign', 'Social Media Marketing for Brand', 'Social Media Marketing for Brand', 25, 25, 25, 25),
(134, 146, 64, 'UPDATE', '2024-12-22 13:08:10', 'Video Production', 'Video Production', 5, 5, 'Create a promotional video for a product', 'Create a promotional video for a product', 'Product Promotional Video', 'Product Promotional Video', 35, 35, 35, 35),
(135, 145, 64, 'UPDATE', '2024-12-22 13:09:30', 'Social Media Marketing', 'Social Media Marketing', 7, 7, 'Create a social media marketing campaign', 'Create a social media marketing campaign', 'Social Media Marketing for Brand', 'Social Media Marketing for Brand', 25, 25, 25, 25),
(136, 141, 63, 'UPDATE', '2024-12-22 13:09:33', 'Cloud Storage Solution', 'Cloud Storage Solution', 3, 3, 'Develop a cloud storage platform', 'Develop a cloud storage platform', 'Cloud Storage System Development', 'Cloud Storage System Development', 40, 40, 40, 40),
(137, 146, 64, 'UPDATE', '2024-12-22 13:10:17', 'Video Production', 'Video Production', 5, 5, 'Create a promotional video for a product', 'Create a promotional video for a product', 'Product Promotional Video', 'Product Promotional Video', 35, 35, 35, 35),
(138, 136, 62, 'UPDATE', '2024-12-22 13:10:21', 'Website Redesign', 'Website Redesign', 2, 2, 'Redesign a corporate website', 'Redesign a corporate website', 'Corporate Website Redesign', 'Corporate Website Redesign', 20, 20, 20, 20),
(139, 123, 60, 'UPDATE', '2024-12-22 13:12:19', 'Fisch Project', 'Fisch Project', 8, 8, 'Make a Fish Model', 'Make a Fish Model', 'Fish Model', 'Fish Model', 10, 10, 10, 10),
(140, 127, 61, 'UPDATE', '2024-12-22 13:12:21', 'Ai Development', 'Ai Development', 4, 4, 'Develop an AI-based recommendation system', 'Develop an AI-based recommendation system', 'AI-based Recommendation Engine', 'AI-based Recommendation Engine', 30, 30, 30, 30),
(141, 133, 62, 'UPDATE', '2024-12-22 13:14:09', 'Ai Chatbot Development', 'Ai Chatbot Development', 4, 4, 'Develop an AI-powered chatbot for customer service', 'Develop an AI-powered chatbot for customer service', 'AI Chatbot Development', 'AI Chatbot Development', 40, 40, 40, 40),
(142, 124, 60, 'UPDATE', '2024-12-22 13:14:17', 'Ocean Cleanup', 'Ocean Cleanup', 8, 8, 'Design a solution for cleaning oceans', 'Design a solution for cleaning oceans', 'Ocean Cleanup Model', 'Ocean Cleanup Model', 15, 15, 15, 15),
(143, 131, 61, 'UPDATE', '2024-12-22 13:16:12', 'Cloud Storage Solution', 'Cloud Storage Solution', 3, 3, 'Develop a cloud storage platform', 'Develop a cloud storage platform', 'Cloud Storage System Development', 'Cloud Storage System Development', 40, 40, 40, 40),
(144, 140, 63, 'UPDATE', '2024-12-22 13:16:16', 'Mobile App Development', 'Mobile App Development', 6, 6, 'Create a mobile app for social media', 'Create a mobile app for social media', 'Social Media Mobile App', 'Social Media Mobile App', 30, 30, 30, 30),
(145, 147, 60, 'INSERT', '2024-12-23 12:38:40', NULL, 'Test', NULL, 29, NULL, 'test', NULL, 'test', NULL, 10, NULL, 10),
(146, 147, 60, 'UPDATE', '2024-12-23 12:41:02', 'Test', 'Test', 29, 29, 'test', 'test', 'test', 'test', 10, 10, 10, 10),
(147, 126, 60, 'UPDATE', '2024-12-23 12:41:05', 'Solar Panel Installation', 'Solar Panel Installation', 3, 3, 'Design and install solar panels', 'Design and install solar panels', 'Solar Panel System', 'Solar Panel System', 25, 25, 25, 25),
(148, 147, 60, 'DELETE', '2024-12-25 01:32:28', 'Test', NULL, 29, NULL, 'test', NULL, 'test', NULL, 10, NULL, 10, NULL),
(149, 141, 63, 'UPDATE', '2024-12-25 01:32:56', 'Cloud Storage Solution', 'Cloud Storage Solution', 3, 3, 'Develop a cloud storage platform', 'Develop a cloud storage platform', 'Cloud Storage System Development', 'Cloud Storage System Development', 40, 40, 40, 40),
(150, 146, 64, 'UPDATE', '2024-12-25 01:33:00', 'Video Production', 'Video Production', 5, 5, 'Create a promotional video for a product', 'Create a promotional video for a product', 'Product Promotional Video', 'Product Promotional Video', 35, 35, 35, 35),
(151, 136, 62, 'UPDATE', '2024-12-25 01:33:03', 'Website Redesign', 'Website Redesign', 2, 2, 'Redesign a corporate website', 'Redesign a corporate website', 'Corporate Website Redesign', 'Corporate Website Redesign', 20, 20, 20, 20),
(152, 127, 61, 'UPDATE', '2024-12-25 01:33:09', 'Ai Development', 'Ai Development', 4, 4, 'Develop an AI-based recommendation system', 'Develop an AI-based recommendation system', 'AI-based Recommendation Engine', 'AI-based Recommendation Engine', 30, 30, 30, 30),
(153, 133, 62, 'UPDATE', '2024-12-25 01:33:12', 'Ai Chatbot Development', 'Ai Chatbot Development', 4, 4, 'Develop an AI-powered chatbot for customer service', 'Develop an AI-powered chatbot for customer service', 'AI Chatbot Development', 'AI Chatbot Development', 40, 40, 40, 40),
(154, 131, 61, 'UPDATE', '2024-12-25 01:33:18', 'Cloud Storage Solution', 'Cloud Storage Solution', 3, 3, 'Develop a cloud storage platform', 'Develop a cloud storage platform', 'Cloud Storage System Development', 'Cloud Storage System Development', 40, 40, 40, 40),
(155, 140, 63, 'UPDATE', '2024-12-25 01:33:24', 'Mobile App Development', 'Mobile App Development', 6, 6, 'Create a mobile app for social media', 'Create a mobile app for social media', 'Social Media Mobile App', 'Social Media Mobile App', 30, 30, 30, 30);

-- --------------------------------------------------------

--
-- Table structure for table `client_project_status`
--

CREATE TABLE `client_project_status` (
  `id` int(11) NOT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client_project_status`
--

INSERT INTO `client_project_status` (`id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Hiring', '2024-12-22 11:59:07', '2024-12-23 12:18:41'),
(2, 'In Progress', '2024-12-22 11:59:07', '2024-12-23 12:18:53'),
(3, 'Completed', '2024-12-22 11:59:07', '2024-12-23 12:18:57');

-- --------------------------------------------------------

--
-- Table structure for table `completed_projects_audit`
--

CREATE TABLE `completed_projects_audit` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `project_title` varchar(255) DEFAULT NULL,
  `project_category_id` int(11) DEFAULT NULL,
  `project_description` text DEFAULT NULL,
  `project_objective` text DEFAULT NULL,
  `project_status_id` int(11) DEFAULT NULL,
  `project_connect_cost` int(11) DEFAULT NULL,
  `project_merit_worth` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `month_collected` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_applications`
--

CREATE TABLE `freelancer_applications` (
  `id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `application_details` text NOT NULL,
  `portfolio_url` varchar(255) DEFAULT NULL,
  `application_status_id` int(11) NOT NULL DEFAULT 1,
  `application_date` datetime NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_applications`
--

INSERT INTO `freelancer_applications` (`id`, `project_id`, `user_id`, `application_details`, `portfolio_url`, `application_status_id`, `application_date`, `created_at`, `updated_at`) VALUES
(131, 145, 50, 'apply', 'https://www.google.com', 2, '2024-12-22 21:04:43', '2024-12-22 13:04:43', '2024-12-22 13:09:30'),
(132, 141, 50, 'apply', 'https://www.google.com', 2, '2024-12-22 21:08:59', '2024-12-22 13:08:59', '2024-12-25 01:32:56'),
(133, 146, 51, 'apply', 'https://www.google.com', 2, '2024-12-22 21:09:43', '2024-12-22 13:09:43', '2024-12-25 01:33:00'),
(134, 136, 51, 'apply', 'https://www.google.com', 2, '2024-12-22 21:10:09', '2024-12-22 13:10:09', '2024-12-25 01:33:03'),
(135, 123, 52, 'apply', 'https://www.google.com', 3, '2024-12-22 21:11:59', '2024-12-22 13:11:59', '2024-12-25 01:33:06'),
(136, 127, 52, 'apply', 'https://www.google.com', 2, '2024-12-22 21:12:13', '2024-12-22 13:12:13', '2024-12-25 01:33:09'),
(137, 133, 53, 'apply', 'https://www.google.com', 2, '2024-12-22 21:13:33', '2024-12-22 13:13:33', '2024-12-25 01:33:12'),
(138, 124, 53, 'apply', 'https://www.google.com', 3, '2024-12-22 21:14:01', '2024-12-22 13:14:01', '2024-12-25 01:33:15'),
(139, 131, 54, 'apply', 'https://www.google.com', 2, '2024-12-22 21:15:47', '2024-12-22 13:15:47', '2024-12-25 01:33:18'),
(140, 140, 54, 'apply', 'https://www.google.com', 2, '2024-12-22 21:16:02', '2024-12-22 13:16:02', '2024-12-25 01:33:24');

--
-- Triggers `freelancer_applications`
--
DELIMITER $$
CREATE TRIGGER `tr_after_application_status_update` AFTER UPDATE ON `freelancer_applications` FOR EACH ROW IF NEW.application_status_id = '2' THEN
        UPDATE client_projects
        SET project_status_id = '2'
        WHERE id = NEW.project_id;
 END IF
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_after_application_status_update_notification` AFTER UPDATE ON `freelancer_applications` FOR EACH ROW BEGIN
    DECLARE project_name VARCHAR(255);
    DECLARE notification_message VARCHAR(255);

    IF NEW.application_status_id IN (2, 3) THEN

        SELECT project_title INTO project_name
        FROM v_project_details
        WHERE id = NEW.project_id;

        IF NEW.application_status_id = 2 THEN
            SET notification_message = CONCAT('Your application for ', project_name, ' has been accepted.');
        ELSEIF NEW.application_status_id = 3 THEN
            SET notification_message = CONCAT('Your application for ', project_name, ' has been rejected.');
        END IF;


        INSERT INTO notifications (project_id, user_id, type, message, is_read, created_at, updated_at)
        VALUES (NEW.project_id, NEW.user_id, 1, notification_message, 0, NOW(), NOW());
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_after_application_status_update_submission_creation` AFTER UPDATE ON `freelancer_applications` FOR EACH ROW BEGIN
    IF NEW.application_status_id = 2 AND OLD.application_status_id != 2 THEN
        

        INSERT INTO freelancer_project_submissions (
            project_id,
            user_id,
            submission_url,
            submission_status_id,
            created_at,
            updated_at
        ) VALUES (
            NEW.project_id,  
            NEW.user_id,          
            NULL,     
            '1',   
            NOW(),      
            NOW()     
        );

    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_after_freelancer_application_insert_notification` AFTER INSERT ON `freelancer_applications` FOR EACH ROW BEGIN

    DECLARE project_name VARCHAR(255);
    DECLARE notification_message VARCHAR(255);
    DECLARE project_owner_id INT;

    SELECT project_title, project_owner INTO project_name, project_owner_id
    FROM v_project_details
    WHERE id = NEW.project_id;

    SET notification_message = CONCAT('A new application has been submitted for your project: ', project_name);

    INSERT INTO notifications (project_id, application_id, user_id, type, message, is_read, created_at, updated_at)
    VALUES (NEW.project_id, NEW.id, project_owner_id, 1, notification_message, 0, NOW(), NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_freelancer_applications_delete` BEFORE DELETE ON `freelancer_applications` FOR EACH ROW INSERT INTO freelancer_applications_audit (
        application_id,
        project_id,
        user_id,
        old_application_details,
        new_application_details,
        old_portfolio_url,
        new_portfolio_url,
        old_application_status_id,
        new_application_status_id,
        old_application_date,
        new_application_date,
        action_timestamp,
        action_type
    )
    VALUES (
        OLD.id,
        OLD.project_id,
        OLD.user_id,
        OLD.application_details,
        NULL,
        OLD.portfolio_url,
        NULL,
        OLD.application_status_id,
        NULL,
        OLD.application_date,
        NULL,
        NOW(), 
        'DELETE'
    )
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_freelancer_applications_insert` AFTER INSERT ON `freelancer_applications` FOR EACH ROW BEGIN
    INSERT INTO freelancer_applications_audit (
        application_id,
        project_id,
        user_id,
        old_application_details,
        new_application_details,
        old_portfolio_url,
        new_portfolio_url,
        old_application_status_id,
        new_application_status_id,
        old_application_date,
        new_application_date,
        action_timestamp,
        action_type
    )
    VALUES (
        NEW.id,
        NEW.project_id,
        NEW.user_id,
        NULL, 
        NEW.application_details,
        NULL,
        NEW.portfolio_url,
        NULL,
        NEW.application_status_id,
        NULL,
        NEW.application_date,
        NOW(),
        'INSERT'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_freelancer_applications_update` AFTER UPDATE ON `freelancer_applications` FOR EACH ROW BEGIN
    INSERT INTO freelancer_applications_audit (
        application_id,
        project_id,
        user_id,
        old_application_details,
        new_application_details,
        old_portfolio_url,
        new_portfolio_url,
        old_application_status_id,
        new_application_status_id,
        old_application_date,
        new_application_date,
        action_timestamp,
        action_type
    )
    VALUES (
        OLD.id,
        NEW.project_id,
        NEW.user_id,
        OLD.application_details,
        NEW.application_details,
        OLD.portfolio_url,
        NEW.portfolio_url,
        OLD.application_status_id,
        NEW.application_status_id,
        OLD.application_date,
        NEW.application_date,
        NOW(),
        'UPDATE'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_applications_audit`
--

CREATE TABLE `freelancer_applications_audit` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action_type` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `action_timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `old_application_details` text DEFAULT NULL,
  `new_application_details` text DEFAULT NULL,
  `old_portfolio_url` varchar(255) DEFAULT NULL,
  `new_portfolio_url` varchar(255) DEFAULT NULL,
  `old_application_status_id` int(11) DEFAULT NULL,
  `new_application_status_id` int(11) DEFAULT NULL,
  `old_application_date` datetime DEFAULT NULL,
  `new_application_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_applications_audit`
--

INSERT INTO `freelancer_applications_audit` (`id`, `application_id`, `project_id`, `user_id`, `action_type`, `action_timestamp`, `old_application_details`, `new_application_details`, `old_portfolio_url`, `new_portfolio_url`, `old_application_status_id`, `new_application_status_id`, `old_application_date`, `new_application_date`) VALUES
(38, 116, 126, 57, 'UPDATE', '2024-12-22 12:38:18', 'Expert in solar technology. I can design and install solar panels for your project.', 'Expert in solar technology. I can design and install solar panels for your project.', 'http://myportfolio.com/57', 'http://myportfolio.com/57', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(39, 117, 127, 56, 'UPDATE', '2024-12-22 12:38:18', 'Passionate about AI development. Let’s work together on the AI recommendation system.', 'Passionate about AI development. Let’s work together on the AI recommendation system.', 'http://myportfolio.com/56', 'http://myportfolio.com/56', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(40, 118, 128, 56, 'UPDATE', '2024-12-22 12:38:18', 'Skilled in designing mobile apps. Ready to create the e-commerce app for you.', 'Skilled in designing mobile apps. Ready to create the e-commerce app for you.', 'http://myportfolio.com/56', 'http://myportfolio.com/56', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(41, 119, 129, 55, 'UPDATE', '2024-12-22 12:38:18', 'Experienced in website redesigns. I look forward to working on your corporate website project.', 'Experienced in website redesigns. I look forward to working on your corporate website project.', 'http://myportfolio.com/55', 'http://myportfolio.com/55', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(42, 120, 130, 55, 'UPDATE', '2024-12-22 12:38:18', 'Data analysis is my specialty. I can help with sales data analysis and reporting.', 'Data analysis is my specialty. I can help with sales data analysis and reporting.', 'http://myportfolio.com/55', 'http://myportfolio.com/55', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(43, 121, 131, 54, 'UPDATE', '2024-12-22 12:38:18', 'Expert in cloud storage solutions. Ready to develop the cloud platform for your needs.', 'Expert in cloud storage solutions. Ready to develop the cloud platform for your needs.', 'http://myportfolio.com/54', 'http://myportfolio.com/54', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(44, 122, 132, 54, 'UPDATE', '2024-12-22 12:38:18', 'I can develop a fully functional e-commerce website, making it easy for you to sell your products.', 'I can develop a fully functional e-commerce website, making it easy for you to sell your products.', 'http://myportfolio.com/54', 'http://myportfolio.com/54', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(45, 123, 133, 53, 'UPDATE', '2024-12-22 12:38:18', 'Experienced in AI-based systems, I can develop an AI-powered chatbot for customer service.', 'Experienced in AI-based systems, I can develop an AI-powered chatbot for customer service.', 'http://myportfolio.com/53', 'http://myportfolio.com/53', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(46, 124, 134, 53, 'UPDATE', '2024-12-22 12:38:18', 'Proficient in AI development, I am interested in helping with the AI-based recommendation system.', 'Proficient in AI development, I am interested in helping with the AI-based recommendation system.', 'http://myportfolio.com/53', 'http://myportfolio.com/53', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(47, 125, 135, 52, 'UPDATE', '2024-12-22 12:38:18', 'Skilled in mobile app development. Let’s design your mobile e-commerce app for better business.', 'Skilled in mobile app development. Let’s design your mobile e-commerce app for better business.', 'http://myportfolio.com/52', 'http://myportfolio.com/52', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(48, 126, 136, 52, 'UPDATE', '2024-12-22 12:38:18', 'Experienced in redesigning websites. I would love to help with your corporate website project.', 'Experienced in redesigning websites. I would love to help with your corporate website project.', 'http://myportfolio.com/52', 'http://myportfolio.com/52', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(49, 127, 137, 51, 'UPDATE', '2024-12-22 12:38:18', 'Proficient in blockchain development. Let’s create a secure blockchain solution for your project.', 'Proficient in blockchain development. Let’s create a secure blockchain solution for your project.', 'http://myportfolio.com/51', 'http://myportfolio.com/51', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(50, 128, 138, 51, 'UPDATE', '2024-12-22 12:38:18', 'Experienced in virtual reality systems. Ready to develop a VR simulation for your training program.', 'Experienced in virtual reality systems. Ready to develop a VR simulation for your training program.', 'http://myportfolio.com/51', 'http://myportfolio.com/51', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(51, 129, 139, 50, 'UPDATE', '2024-12-22 12:38:18', 'I specialize in data analysis and can help analyze sales data and create reports.', 'I specialize in data analysis and can help analyze sales data and create reports.', 'http://myportfolio.com/50', 'http://myportfolio.com/50', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(52, 130, 140, 50, 'UPDATE', '2024-12-22 12:38:18', 'Proficient in mobile app development, I can help create your social media mobile app.', 'Proficient in mobile app development, I can help create your social media mobile app.', 'http://myportfolio.com/50', 'http://myportfolio.com/50', 1, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(53, 113, 124, 58, 'UPDATE', '2024-12-22 12:53:01', 'I am skilled in creating 3D models and can help you with the fish model design.', 'I am skilled in creating 3D models and can help you with the fish model design.', 'http://myportfolio.com/58', 'http://myportfolio.com/58', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(54, 114, 125, 58, 'UPDATE', '2024-12-22 12:53:04', 'Experienced in environmental solutions. I can contribute to ocean cleanup projects effectively.', 'Experienced in environmental solutions. I can contribute to ocean cleanup projects effectively.', 'http://myportfolio.com/58', 'http://myportfolio.com/58', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(55, 115, 126, 57, 'UPDATE', '2024-12-22 12:53:07', 'Proficient in creating automated garden systems. I am excited about the smart garden project.', 'Proficient in creating automated garden systems. I am excited about the smart garden project.', 'http://myportfolio.com/57', 'http://myportfolio.com/57', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(56, 116, 127, 57, 'UPDATE', '2024-12-22 12:53:10', 'Expert in solar technology. I can design and install solar panels for your project.', 'Expert in solar technology. I can design and install solar panels for your project.', 'http://myportfolio.com/57', 'http://myportfolio.com/57', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(57, 117, 128, 56, 'UPDATE', '2024-12-22 12:53:13', 'Passionate about AI development. Let’s work together on the AI recommendation system.', 'Passionate about AI development. Let’s work together on the AI recommendation system.', 'http://myportfolio.com/56', 'http://myportfolio.com/56', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(58, 118, 129, 56, 'UPDATE', '2024-12-22 12:53:16', 'Skilled in designing mobile apps. Ready to create the e-commerce app for you.', 'Skilled in designing mobile apps. Ready to create the e-commerce app for you.', 'http://myportfolio.com/56', 'http://myportfolio.com/56', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(59, 119, 130, 55, 'UPDATE', '2024-12-22 12:53:19', 'Experienced in website redesigns. I look forward to working on your corporate website project.', 'Experienced in website redesigns. I look forward to working on your corporate website project.', 'http://myportfolio.com/55', 'http://myportfolio.com/55', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(60, 120, 131, 55, 'UPDATE', '2024-12-22 12:53:28', 'Data analysis is my specialty. I can help with sales data analysis and reporting.', 'Data analysis is my specialty. I can help with sales data analysis and reporting.', 'http://myportfolio.com/55', 'http://myportfolio.com/55', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(61, 121, 132, 54, 'UPDATE', '2024-12-22 12:53:31', 'Expert in cloud storage solutions. Ready to develop the cloud platform for your needs.', 'Expert in cloud storage solutions. Ready to develop the cloud platform for your needs.', 'http://myportfolio.com/54', 'http://myportfolio.com/54', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(62, 122, 133, 54, 'UPDATE', '2024-12-22 12:53:37', 'I can develop a fully functional e-commerce website, making it easy for you to sell your products.', 'I can develop a fully functional e-commerce website, making it easy for you to sell your products.', 'http://myportfolio.com/54', 'http://myportfolio.com/54', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(63, 123, 134, 53, 'UPDATE', '2024-12-22 12:53:39', 'Experienced in AI-based systems, I can develop an AI-powered chatbot for customer service.', 'Experienced in AI-based systems, I can develop an AI-powered chatbot for customer service.', 'http://myportfolio.com/53', 'http://myportfolio.com/53', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(64, 124, 135, 53, 'UPDATE', '2024-12-22 12:53:43', 'Proficient in AI development, I am interested in helping with the AI-based recommendation system.', 'Proficient in AI development, I am interested in helping with the AI-based recommendation system.', 'http://myportfolio.com/53', 'http://myportfolio.com/53', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(65, 125, 136, 52, 'UPDATE', '2024-12-22 12:53:45', 'Skilled in mobile app development. Let’s design your mobile e-commerce app for better business.', 'Skilled in mobile app development. Let’s design your mobile e-commerce app for better business.', 'http://myportfolio.com/52', 'http://myportfolio.com/52', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(66, 126, 137, 52, 'UPDATE', '2024-12-22 12:53:48', 'Experienced in redesigning websites. I would love to help with your corporate website project.', 'Experienced in redesigning websites. I would love to help with your corporate website project.', 'http://myportfolio.com/52', 'http://myportfolio.com/52', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(67, 127, 138, 51, 'UPDATE', '2024-12-22 12:53:50', 'Proficient in blockchain development. Let’s create a secure blockchain solution for your project.', 'Proficient in blockchain development. Let’s create a secure blockchain solution for your project.', 'http://myportfolio.com/51', 'http://myportfolio.com/51', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(68, 128, 139, 51, 'UPDATE', '2024-12-22 12:53:52', 'Experienced in virtual reality systems. Ready to develop a VR simulation for your training program.', 'Experienced in virtual reality systems. Ready to develop a VR simulation for your training program.', 'http://myportfolio.com/51', 'http://myportfolio.com/51', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(69, 129, 140, 50, 'UPDATE', '2024-12-22 12:53:55', 'I specialize in data analysis and can help analyze sales data and create reports.', 'I specialize in data analysis and can help analyze sales data and create reports.', 'http://myportfolio.com/50', 'http://myportfolio.com/50', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(70, 130, 141, 50, 'UPDATE', '2024-12-22 12:53:58', 'Proficient in mobile app development, I can help create your social media mobile app.', 'Proficient in mobile app development, I can help create your social media mobile app.', 'http://myportfolio.com/50', 'http://myportfolio.com/50', 2, 2, '2024-12-22 20:32:18', '2024-12-22 20:32:18'),
(71, 108, 146, 59, 'DELETE', '2024-12-22 12:59:49', 'I am experienced in View Production .', NULL, 'http://portfolio.com/VideoProduction', NULL, 2, NULL, '2024-12-22 20:22:15', NULL),
(72, 112, 123, 59, 'DELETE', '2024-12-22 12:59:50', 'I have experience in web development and am eager to contribute to this project.', NULL, 'http://myportfolio.com', NULL, 2, NULL, '2024-12-22 20:29:51', NULL),
(73, 113, 124, 58, 'DELETE', '2024-12-22 12:59:50', 'I am skilled in creating 3D models and can help you with the fish model design.', NULL, 'http://myportfolio.com/58', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(74, 114, 125, 58, 'DELETE', '2024-12-22 12:59:50', 'Experienced in environmental solutions. I can contribute to ocean cleanup projects effectively.', NULL, 'http://myportfolio.com/58', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(75, 115, 126, 57, 'DELETE', '2024-12-22 12:59:50', 'Proficient in creating automated garden systems. I am excited about the smart garden project.', NULL, 'http://myportfolio.com/57', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(76, 116, 127, 57, 'DELETE', '2024-12-22 12:59:50', 'Expert in solar technology. I can design and install solar panels for your project.', NULL, 'http://myportfolio.com/57', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(77, 117, 128, 56, 'DELETE', '2024-12-22 12:59:50', 'Passionate about AI development. Let’s work together on the AI recommendation system.', NULL, 'http://myportfolio.com/56', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(78, 118, 129, 56, 'DELETE', '2024-12-22 12:59:50', 'Skilled in designing mobile apps. Ready to create the e-commerce app for you.', NULL, 'http://myportfolio.com/56', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(79, 119, 130, 55, 'DELETE', '2024-12-22 12:59:50', 'Experienced in website redesigns. I look forward to working on your corporate website project.', NULL, 'http://myportfolio.com/55', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(80, 120, 131, 55, 'DELETE', '2024-12-22 12:59:50', 'Data analysis is my specialty. I can help with sales data analysis and reporting.', NULL, 'http://myportfolio.com/55', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(81, 121, 132, 54, 'DELETE', '2024-12-22 12:59:50', 'Expert in cloud storage solutions. Ready to develop the cloud platform for your needs.', NULL, 'http://myportfolio.com/54', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(82, 122, 133, 54, 'DELETE', '2024-12-22 12:59:50', 'I can develop a fully functional e-commerce website, making it easy for you to sell your products.', NULL, 'http://myportfolio.com/54', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(83, 123, 134, 53, 'DELETE', '2024-12-22 12:59:50', 'Experienced in AI-based systems, I can develop an AI-powered chatbot for customer service.', NULL, 'http://myportfolio.com/53', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(84, 124, 135, 53, 'DELETE', '2024-12-22 12:59:50', 'Proficient in AI development, I am interested in helping with the AI-based recommendation system.', NULL, 'http://myportfolio.com/53', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(85, 125, 136, 52, 'DELETE', '2024-12-22 12:59:50', 'Skilled in mobile app development. Let’s design your mobile e-commerce app for better business.', NULL, 'http://myportfolio.com/52', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(86, 126, 137, 52, 'DELETE', '2024-12-22 12:59:50', 'Experienced in redesigning websites. I would love to help with your corporate website project.', NULL, 'http://myportfolio.com/52', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(87, 127, 138, 51, 'DELETE', '2024-12-22 12:59:50', 'Proficient in blockchain development. Let’s create a secure blockchain solution for your project.', NULL, 'http://myportfolio.com/51', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(88, 128, 139, 51, 'DELETE', '2024-12-22 12:59:50', 'Experienced in virtual reality systems. Ready to develop a VR simulation for your training program.', NULL, 'http://myportfolio.com/51', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(89, 129, 140, 50, 'DELETE', '2024-12-22 12:59:50', 'I specialize in data analysis and can help analyze sales data and create reports.', NULL, 'http://myportfolio.com/50', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(90, 130, 141, 50, 'DELETE', '2024-12-22 12:59:50', 'Proficient in mobile app development, I can help create your social media mobile app.', NULL, 'http://myportfolio.com/50', NULL, 2, NULL, '2024-12-22 20:32:18', NULL),
(91, 131, 145, 50, 'INSERT', '2024-12-22 13:04:43', NULL, 'apply', NULL, 'https://www.google.com', NULL, 1, NULL, '2024-12-22 21:04:43'),
(92, 132, 141, 50, 'INSERT', '2024-12-22 13:08:59', NULL, 'apply', NULL, '', NULL, 1, NULL, '2024-12-22 21:08:59'),
(93, 131, 145, 50, 'UPDATE', '2024-12-22 13:09:30', 'apply', 'apply', 'https://www.google.com', 'https://www.google.com', 1, 2, '2024-12-22 21:04:43', '2024-12-22 21:04:43'),
(94, 132, 141, 50, 'UPDATE', '2024-12-22 13:09:33', 'apply', 'apply', '', '', 1, 2, '2024-12-22 21:08:59', '2024-12-22 21:08:59'),
(95, 133, 146, 51, 'INSERT', '2024-12-22 13:09:43', NULL, 'apply', NULL, '', NULL, 1, NULL, '2024-12-22 21:09:43'),
(96, 134, 136, 51, 'INSERT', '2024-12-22 13:10:09', NULL, 'apply', NULL, '', NULL, 1, NULL, '2024-12-22 21:10:09'),
(97, 133, 146, 51, 'UPDATE', '2024-12-22 13:10:17', 'apply', 'apply', '', '', 1, 2, '2024-12-22 21:09:43', '2024-12-22 21:09:43'),
(98, 134, 136, 51, 'UPDATE', '2024-12-22 13:10:21', 'apply', 'apply', '', '', 1, 2, '2024-12-22 21:10:09', '2024-12-22 21:10:09'),
(99, 135, 123, 52, 'INSERT', '2024-12-22 13:11:59', NULL, 'apply', NULL, '', NULL, 1, NULL, '2024-12-22 21:11:59'),
(100, 136, 127, 52, 'INSERT', '2024-12-22 13:12:13', NULL, 'apply', NULL, '', NULL, 1, NULL, '2024-12-22 21:12:13'),
(101, 135, 123, 52, 'UPDATE', '2024-12-22 13:12:19', 'apply', 'apply', '', '', 1, 2, '2024-12-22 21:11:59', '2024-12-22 21:11:59'),
(102, 136, 127, 52, 'UPDATE', '2024-12-22 13:12:21', 'apply', 'apply', '', '', 1, 2, '2024-12-22 21:12:13', '2024-12-22 21:12:13'),
(103, 137, 133, 53, 'INSERT', '2024-12-22 13:13:33', NULL, 'apply', NULL, '', NULL, 1, NULL, '2024-12-22 21:13:33'),
(104, 138, 124, 53, 'INSERT', '2024-12-22 13:14:01', NULL, 'apply', NULL, '', NULL, 1, NULL, '2024-12-22 21:14:01'),
(105, 137, 133, 53, 'UPDATE', '2024-12-22 13:14:09', 'apply', 'apply', '', '', 1, 2, '2024-12-22 21:13:33', '2024-12-22 21:13:33'),
(106, 138, 124, 53, 'UPDATE', '2024-12-22 13:14:17', 'apply', 'apply', '', '', 1, 2, '2024-12-22 21:14:01', '2024-12-22 21:14:01'),
(107, 139, 131, 54, 'INSERT', '2024-12-22 13:15:47', NULL, 'apply', NULL, '', NULL, 1, NULL, '2024-12-22 21:15:47'),
(108, 140, 140, 54, 'INSERT', '2024-12-22 13:16:02', NULL, 'apply', NULL, '', NULL, 1, NULL, '2024-12-22 21:16:02'),
(109, 139, 131, 54, 'UPDATE', '2024-12-22 13:16:12', 'apply', 'apply', '', '', 1, 2, '2024-12-22 21:15:47', '2024-12-22 21:15:47'),
(110, 140, 140, 54, 'UPDATE', '2024-12-22 13:16:16', 'apply', 'apply', '', '', 1, 2, '2024-12-22 21:16:02', '2024-12-22 21:16:02'),
(111, 141, 126, 53, 'INSERT', '2024-12-23 09:33:30', NULL, 'Sana matanggap', NULL, 'https://www.google.com/', NULL, 1, NULL, '2024-12-23 17:33:30'),
(112, 142, 147, 51, 'INSERT', '2024-12-23 12:40:39', NULL, 'test', NULL, 'https://getbootstrap.com/docs/5.0/forms/validation/', NULL, 1, NULL, '2024-12-23 20:40:39'),
(113, 142, 147, 51, 'UPDATE', '2024-12-23 12:41:02', 'test', 'test', 'https://getbootstrap.com/docs/5.0/forms/validation/', 'https://getbootstrap.com/docs/5.0/forms/validation/', 1, 2, '2024-12-23 20:40:39', '2024-12-23 20:40:39'),
(114, 141, 126, 53, 'UPDATE', '2024-12-23 12:41:05', 'Sana matanggap', 'Sana matanggap', 'https://www.google.com/', 'https://www.google.com/', 1, 2, '2024-12-23 17:33:30', '2024-12-23 17:33:30'),
(115, 138, 124, 53, 'UPDATE', '2024-12-23 12:58:52', 'apply', 'apply', '', '', 2, 3, '2024-12-22 21:14:01', '2024-12-22 21:14:01'),
(116, 141, 126, 53, 'UPDATE', '2024-12-23 12:58:58', 'Sana matanggap', 'Sana matanggap', 'https://www.google.com/', 'https://www.google.com/', 2, 3, '2024-12-23 17:33:30', '2024-12-23 17:33:30'),
(117, 142, 147, 51, 'UPDATE', '2024-12-23 12:59:07', 'test', 'test', 'https://getbootstrap.com/docs/5.0/forms/validation/', 'https://getbootstrap.com/docs/5.0/forms/validation/', 2, 3, '2024-12-23 20:40:39', '2024-12-23 20:40:39'),
(118, 135, 123, 52, 'UPDATE', '2024-12-23 12:59:25', 'apply', 'apply', '', '', 2, 3, '2024-12-22 21:11:59', '2024-12-22 21:11:59'),
(119, 141, 126, 53, 'DELETE', '2024-12-25 01:32:46', 'Sana matanggap', NULL, 'https://www.google.com/', NULL, 3, NULL, '2024-12-23 17:33:30', NULL),
(120, 132, 141, 50, 'UPDATE', '2024-12-25 01:32:56', 'apply', 'apply', '', 'https://www.google.com', 2, 2, '2024-12-22 21:08:59', '2024-12-22 21:08:59'),
(121, 133, 146, 51, 'UPDATE', '2024-12-25 01:33:00', 'apply', 'apply', '', 'https://www.google.com', 2, 2, '2024-12-22 21:09:43', '2024-12-22 21:09:43'),
(122, 134, 136, 51, 'UPDATE', '2024-12-25 01:33:03', 'apply', 'apply', '', 'https://www.google.com', 2, 2, '2024-12-22 21:10:09', '2024-12-22 21:10:09'),
(123, 135, 123, 52, 'UPDATE', '2024-12-25 01:33:06', 'apply', 'apply', '', 'https://www.google.com', 3, 3, '2024-12-22 21:11:59', '2024-12-22 21:11:59'),
(124, 136, 127, 52, 'UPDATE', '2024-12-25 01:33:09', 'apply', 'apply', '', 'https://www.google.com', 2, 2, '2024-12-22 21:12:13', '2024-12-22 21:12:13'),
(125, 137, 133, 53, 'UPDATE', '2024-12-25 01:33:12', 'apply', 'apply', '', 'https://www.google.com', 2, 2, '2024-12-22 21:13:33', '2024-12-22 21:13:33'),
(126, 138, 124, 53, 'UPDATE', '2024-12-25 01:33:15', 'apply', 'apply', '', 'https://www.google.com', 3, 3, '2024-12-22 21:14:01', '2024-12-22 21:14:01'),
(127, 139, 131, 54, 'UPDATE', '2024-12-25 01:33:18', 'apply', 'apply', '', 'https://www.google.com', 2, 2, '2024-12-22 21:15:47', '2024-12-22 21:15:47'),
(128, 140, 140, 54, 'UPDATE', '2024-12-25 01:33:24', 'apply', 'apply', '', 'https://www.google.com', 2, 2, '2024-12-22 21:16:02', '2024-12-22 21:16:02');

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_application_status`
--

CREATE TABLE `freelancer_application_status` (
  `id` int(11) NOT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_application_status`
--

INSERT INTO `freelancer_application_status` (`id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Pending', '2024-12-22 12:17:17', '2024-12-23 12:19:36'),
(2, 'Accepted', '2024-12-22 12:17:17', '2024-12-23 12:19:41'),
(3, 'Rejected', '2024-12-22 12:17:17', '2024-12-23 12:19:45');

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_connects`
--

CREATE TABLE `freelancer_connects` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `connects` int(11) DEFAULT 100,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_connects`
--

INSERT INTO `freelancer_connects` (`id`, `user_id`, `connects`, `created_at`, `updated_at`) VALUES
(12, 50, 35, '2024-12-22 11:17:59', '2024-12-22 13:08:59'),
(13, 51, 35, '2024-12-22 11:18:51', '2024-12-23 12:40:39'),
(14, 52, 60, '2024-12-22 11:19:36', '2024-12-22 13:12:13'),
(15, 53, 20, '2024-12-22 11:22:45', '2024-12-23 09:33:30'),
(16, 54, 30, '2024-12-22 11:23:26', '2024-12-22 13:16:02'),
(17, 55, 100, '2024-12-22 11:24:33', '2024-12-22 11:24:33'),
(18, 56, 100, '2024-12-22 11:25:28', '2024-12-22 11:25:28'),
(19, 57, 100, '2024-12-22 11:26:23', '2024-12-22 11:26:23'),
(20, 58, 100, '2024-12-22 11:27:47', '2024-12-22 11:27:47'),
(21, 59, 65, '2024-12-22 11:28:41', '2024-12-22 12:22:15');

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_experiences`
--

CREATE TABLE `freelancer_experiences` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `job_title` varchar(255) NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `duration` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_experiences`
--

INSERT INTO `freelancer_experiences` (`id`, `user_id`, `job_title`, `company_name`, `duration`, `created_at`, `updated_at`) VALUES
(13, 50, 'Web Developer', 'Tech Solutions', '2015-2018', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(14, 50, 'Front-End Developer', 'Design Pros', '2018-2020', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(15, 50, 'Project Manager', 'Innovative Tech', '2020-2023', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(16, 51, 'AI Developer', 'AI Innovations', '2018-2020', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(17, 51, 'Machine Learning Engineer', 'Future AI', '2020-2022', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(18, 51, 'Data Scientist', 'DataX', '2022-2024', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(19, 52, 'Mobile App Developer', 'App Creators', '2016-2020', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(20, 52, 'Software Engineer', 'Tech Innovators', '2020-2022', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(21, 52, 'UI/UX Designer', 'Creative Minds', '2022-2024', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(22, 53, 'Blockchain Developer', 'Blockchain Enterprises', '2019-2020', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(23, 53, 'Smart Contract Developer', 'Crypto Solutions', '2020-2021', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(24, 53, 'Blockchain Consultant', 'Tech Consultancy', '2021-2023', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(25, 54, 'Cloud Engineer', 'Cloud Systems', '2015-2020', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(26, 54, 'DevOps Engineer', 'Cloud Operations', '2020-2022', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(27, 54, 'Cloud Architect', 'Tech Architects', '2022-2024', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(28, 55, 'Data Analyst', 'Data Insights', '2018-2020', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(29, 55, 'Business Intelligence Analyst', 'BI Solutions', '2020-2022', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(30, 55, 'Data Engineer', 'Data Technologies', '2022-2024', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(31, 56, 'Solar Panel Technician', 'Green Tech', '2016-2019', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(32, 56, 'Renewable Energy Consultant', 'Eco Energy', '2019-2021', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(33, 56, 'Project Manager', 'Sustainable Tech', '2021-2023', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(34, 57, 'Smart Garden Engineer', 'Eco Systems', '2019-2020', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(35, 57, 'IoT Engineer', 'Green Innovators', '2020-2022', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(36, 57, 'Sustainability Consultant', 'Eco Solutions', '2022-2024', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(37, 58, '3D Modeler', 'Creative Studios', '2015-2019', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(38, 58, 'Animation Artist', 'Digital Arts', '2019-2021', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(39, 58, 'Visual Designer', 'Studio Visions', '2021-2023', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(40, 59, 'Project Manager', 'Innovation Co.', '2014-2020', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(41, 59, 'Operations Manager', 'Tech Ventures', '2020-2022', '2024-12-22 12:35:44', '2024-12-22 12:35:44'),
(42, 59, 'Business Development Manager', 'Growth Enterprises', '2022-2024', '2024-12-22 12:35:44', '2024-12-22 12:35:44');

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_merits`
--

CREATE TABLE `freelancer_merits` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `merits` int(10) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_merits`
--

INSERT INTO `freelancer_merits` (`id`, `user_id`, `merits`, `created_at`, `updated_at`) VALUES
(11, 50, 0, '2024-12-22 11:17:59', '2024-12-22 11:17:59'),
(12, 51, 0, '2024-12-22 11:18:51', '2024-12-22 11:18:51'),
(13, 52, 0, '2024-12-22 11:19:36', '2024-12-22 11:19:36'),
(14, 53, 20, '2024-12-22 11:22:45', '2024-12-23 09:30:06'),
(15, 54, 0, '2024-12-22 11:23:26', '2024-12-22 11:23:26'),
(16, 55, 0, '2024-12-22 11:24:33', '2024-12-22 11:24:33'),
(17, 56, 0, '2024-12-22 11:25:28', '2024-12-22 11:25:28'),
(18, 57, 0, '2024-12-22 11:26:23', '2024-12-22 11:26:23'),
(19, 58, 0, '2024-12-22 11:27:47', '2024-12-22 11:27:47'),
(20, 59, 0, '2024-12-22 11:28:41', '2024-12-22 11:28:41');

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_project_submissions`
--

CREATE TABLE `freelancer_project_submissions` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `submission_url` varchar(255) DEFAULT NULL,
  `submission_status_id` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_project_submissions`
--

INSERT INTO `freelancer_project_submissions` (`id`, `project_id`, `user_id`, `submission_url`, `submission_status_id`, `created_at`, `updated_at`) VALUES
(60, 145, 50, NULL, 1, '2024-12-22 13:09:30', '2024-12-22 13:09:30'),
(61, 141, 50, NULL, 1, '2024-12-22 13:09:33', '2024-12-22 13:09:33'),
(62, 146, 51, '../../dist/php/uploads/project_files/676951f167be0_Tables - Database Diagram.png', 2, '2024-12-22 13:10:17', '2024-12-23 12:05:05'),
(63, 136, 51, '../../dist/php/uploads/project_files/67695547efdea_WorkWave_Screenshot_VideoPresentation.png', 2, '2024-12-22 13:10:21', '2024-12-23 12:19:19'),
(65, 127, 52, NULL, 1, '2024-12-22 13:12:21', '2024-12-22 13:12:21'),
(66, 133, 53, '../../dist/php/uploads/project_files/67692d11f0b1b_67692c43efa35_WorkWave_Screenshot_VideoPresentation.png', 3, '2024-12-22 13:14:09', '2024-12-23 09:30:06'),
(68, 131, 54, NULL, 1, '2024-12-22 13:16:12', '2024-12-22 13:16:12'),
(69, 140, 54, NULL, 1, '2024-12-22 13:16:16', '2024-12-22 13:16:16');

--
-- Triggers `freelancer_project_submissions`
--
DELIMITER $$
CREATE TRIGGER `tr_after_delete_freelancer_project_submissions` AFTER DELETE ON `freelancer_project_submissions` FOR EACH ROW BEGIN
    INSERT INTO freelancer_project_submissions_audit  (
        application_id, project_id, user_id,
        old_submission_url, old_submission_status_id, old_created_at, old_updated_at,
        action_type
    )
    VALUES (
        OLD.id, OLD.project_id, OLD.user_id,
        OLD.submission_url, OLD.submission_status_id, OLD.created_at, OLD.updated_at,
        'DELETE'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_after_insert_freelancer_project_submissions` AFTER INSERT ON `freelancer_project_submissions` FOR EACH ROW BEGIN
    INSERT INTO freelancer_project_submissions_audit (
        application_id, project_id, user_id,
        new_submission_url, new_submission_status_id, new_created_at, new_updated_at,
        action_type
    )
    VALUES (
        NEW.id, NEW.project_id, NEW.user_id,
        NEW.submission_url, NEW.submission_status_id, NEW.created_at, NEW.updated_at,
        'INSERT'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_after_status_update_merit` AFTER UPDATE ON `freelancer_project_submissions` FOR EACH ROW BEGIN
    IF NEW.submission_status_id = 3 AND OLD.submission_status_id != 3 THEN  
        UPDATE `freelancer_merits`
        SET `merits` = `merits` + 10
        WHERE `user_id` = (SELECT `user_id` FROM `v_freelancer_submissions` WHERE `id` = NEW.id);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_after_submission_status_update_notification` AFTER UPDATE ON `freelancer_project_submissions` FOR EACH ROW BEGIN
    DECLARE project_name VARCHAR(255);
    DECLARE notification_message VARCHAR(255);

    IF NEW.submission_status_id IN (3, 4) THEN

        SELECT project_title INTO project_name
        FROM v_project_details
        WHERE id = NEW.project_id;

        IF NEW.submission_status_id = 3 THEN
            SET notification_message = 'Submission Accepted';
        ELSEIF NEW.submission_status_id = 4 THEN
            SET notification_message = 'Submission Rejected';
        END IF;

        INSERT INTO notifications (project_id, user_id, type, message, is_read, created_at, updated_at)
        VALUES (NEW.project_id, NEW.user_id, 2, notification_message, 0, NOW(), NOW());
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_after_submission_url_update_notification` AFTER UPDATE ON `freelancer_project_submissions` FOR EACH ROW BEGIN
    DECLARE project_name VARCHAR(255);
    DECLARE project_owner_id INT(11);
    DECLARE notification_message VARCHAR(255);

    IF (OLD.submission_url IS NULL OR OLD.submission_url = '') 
       OR OLD.submission_url <> NEW.submission_url THEN

        SELECT project_owner, project_title INTO project_owner_id, project_name
        FROM v_project_details
        WHERE id = NEW.project_id;

        SET notification_message = CONCAT('New submission for your project "', project_name, '" has been submitted.');

        INSERT INTO notifications (project_id, user_id, type, message, is_read, created_at, updated_at)
        VALUES (NEW.project_id, project_owner_id, 2, notification_message, 0, NOW(), NOW());
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_after_update_freelancer_project_submissions` AFTER UPDATE ON `freelancer_project_submissions` FOR EACH ROW BEGIN
    INSERT INTO freelancer_project_submissions_audit  (
        application_id, project_id, user_id,
        old_submission_url, new_submission_url,
        old_submission_status_id, new_submission_status_id,
        old_updated_at, new_updated_at,
        action_type
    )
    VALUES (
        OLD.id, OLD.project_id, OLD.user_id,
        OLD.submission_url, NEW.submission_url,
        OLD.submission_status_id, NEW.submission_status_id,
        OLD.updated_at, NEW.updated_at,
        'UPDATE'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_project_submissions_audit`
--

CREATE TABLE `freelancer_project_submissions_audit` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action_type` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `action_timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `old_submission_url` varchar(255) DEFAULT NULL,
  `new_submission_url` varchar(255) DEFAULT NULL,
  `old_submission_status_id` int(11) DEFAULT NULL,
  `new_submission_status_id` int(11) DEFAULT NULL,
  `old_created_at` timestamp NULL DEFAULT NULL,
  `new_created_at` timestamp NULL DEFAULT NULL,
  `old_updated_at` timestamp NULL DEFAULT NULL,
  `new_updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_project_submissions_audit`
--

INSERT INTO `freelancer_project_submissions_audit` (`id`, `application_id`, `project_id`, `user_id`, `action_type`, `action_timestamp`, `old_submission_url`, `new_submission_url`, `old_submission_status_id`, `new_submission_status_id`, `old_created_at`, `new_created_at`, `old_updated_at`, `new_updated_at`) VALUES
(47, 45, 126, 57, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(48, 46, 127, 56, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(49, 47, 128, 56, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(50, 48, 129, 55, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(51, 49, 130, 55, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(52, 50, 131, 54, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(53, 51, 132, 54, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(54, 52, 133, 53, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(55, 53, 134, 53, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(56, 54, 135, 52, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(57, 55, 136, 52, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(58, 56, 137, 51, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(59, 57, 138, 51, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(60, 58, 139, 50, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(61, 59, 140, 50, 'DELETE', '2024-12-22 13:00:25', NULL, NULL, 1, NULL, '2024-12-22 12:38:18', NULL, '2024-12-22 12:38:18', NULL),
(62, 60, 145, 50, 'INSERT', '2024-12-22 13:09:30', NULL, NULL, NULL, 1, NULL, '2024-12-22 13:09:30', NULL, '2024-12-22 13:09:30'),
(63, 61, 141, 50, 'INSERT', '2024-12-22 13:09:33', NULL, NULL, NULL, 1, NULL, '2024-12-22 13:09:33', NULL, '2024-12-22 13:09:33'),
(64, 62, 146, 51, 'INSERT', '2024-12-22 13:10:17', NULL, NULL, NULL, 1, NULL, '2024-12-22 13:10:17', NULL, '2024-12-22 13:10:17'),
(65, 63, 136, 51, 'INSERT', '2024-12-22 13:10:21', NULL, NULL, NULL, 1, NULL, '2024-12-22 13:10:21', NULL, '2024-12-22 13:10:21'),
(66, 64, 123, 52, 'INSERT', '2024-12-22 13:12:19', NULL, NULL, NULL, 1, NULL, '2024-12-22 13:12:19', NULL, '2024-12-22 13:12:19'),
(67, 65, 127, 52, 'INSERT', '2024-12-22 13:12:21', NULL, NULL, NULL, 1, NULL, '2024-12-22 13:12:21', NULL, '2024-12-22 13:12:21'),
(68, 66, 133, 53, 'INSERT', '2024-12-22 13:14:09', NULL, NULL, NULL, 1, NULL, '2024-12-22 13:14:09', NULL, '2024-12-22 13:14:09'),
(69, 67, 124, 53, 'INSERT', '2024-12-22 13:14:17', NULL, NULL, NULL, 1, NULL, '2024-12-22 13:14:17', NULL, '2024-12-22 13:14:17'),
(70, 68, 131, 54, 'INSERT', '2024-12-22 13:16:12', NULL, NULL, NULL, 1, NULL, '2024-12-22 13:16:12', NULL, '2024-12-22 13:16:12'),
(71, 69, 140, 54, 'INSERT', '2024-12-22 13:16:16', NULL, NULL, NULL, 1, NULL, '2024-12-22 13:16:16', NULL, '2024-12-22 13:16:16'),
(72, 67, 124, 53, 'UPDATE', '2024-12-23 09:24:19', NULL, '../../dist/php/uploads/project_files/67692c43efa35_WorkWave_Screenshot_VideoPresentation.png', 1, 2, NULL, NULL, '2024-12-22 13:14:17', '2024-12-23 09:24:19'),
(73, 67, 124, 53, 'UPDATE', '2024-12-23 09:24:45', '../../dist/php/uploads/project_files/67692c43efa35_WorkWave_Screenshot_VideoPresentation.png', '../../dist/php/uploads/project_files/67692c43efa35_WorkWave_Screenshot_VideoPresentation.png', 2, 3, NULL, NULL, '2024-12-23 09:24:19', '2024-12-23 09:24:45'),
(74, 66, 133, 53, 'UPDATE', '2024-12-23 09:27:45', NULL, '../../dist/php/uploads/project_files/67692d11f0b1b_67692c43efa35_WorkWave_Screenshot_VideoPresentation.png', 1, 2, NULL, NULL, '2024-12-22 13:14:09', '2024-12-23 09:27:45'),
(75, 66, 133, 53, 'UPDATE', '2024-12-23 09:30:06', '../../dist/php/uploads/project_files/67692d11f0b1b_67692c43efa35_WorkWave_Screenshot_VideoPresentation.png', '../../dist/php/uploads/project_files/67692d11f0b1b_67692c43efa35_WorkWave_Screenshot_VideoPresentation.png', 2, 3, NULL, NULL, '2024-12-23 09:27:45', '2024-12-23 09:30:06'),
(76, 62, 146, 51, 'UPDATE', '2024-12-23 12:05:05', NULL, '../../dist/php/uploads/project_files/676951f167be0_Tables - Database Diagram.png', 1, 2, NULL, NULL, '2024-12-22 13:10:17', '2024-12-23 12:05:05'),
(77, 63, 136, 51, 'UPDATE', '2024-12-23 12:19:19', NULL, '../../dist/php/uploads/project_files/67695547efdea_WorkWave_Screenshot_VideoPresentation.png', 1, 2, NULL, NULL, '2024-12-22 13:10:21', '2024-12-23 12:19:19'),
(78, 70, 147, 51, 'INSERT', '2024-12-23 12:41:02', NULL, NULL, NULL, 1, NULL, '2024-12-23 12:41:02', NULL, '2024-12-23 12:41:02'),
(79, 71, 126, 53, 'INSERT', '2024-12-23 12:41:05', NULL, NULL, NULL, 1, NULL, '2024-12-23 12:41:05', NULL, '2024-12-23 12:41:05'),
(80, 67, 124, 53, 'DELETE', '2024-12-23 12:58:52', '../../dist/php/uploads/project_files/67692c43efa35_WorkWave_Screenshot_VideoPresentation.png', NULL, 3, NULL, '2024-12-22 13:14:17', NULL, '2024-12-23 09:24:45', NULL),
(81, 71, 126, 53, 'DELETE', '2024-12-23 12:58:58', NULL, NULL, 1, NULL, '2024-12-23 12:41:05', NULL, '2024-12-23 12:41:05', NULL),
(82, 70, 147, 51, 'DELETE', '2024-12-23 12:59:07', NULL, NULL, 1, NULL, '2024-12-23 12:41:02', NULL, '2024-12-23 12:41:02', NULL),
(83, 64, 123, 52, 'DELETE', '2024-12-23 12:59:25', NULL, NULL, 1, NULL, '2024-12-22 13:12:19', NULL, '2024-12-22 13:12:19', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_project_submissions_status`
--

CREATE TABLE `freelancer_project_submissions_status` (
  `id` int(11) NOT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_project_submissions_status`
--

INSERT INTO `freelancer_project_submissions_status` (`id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'pending', '2024-12-22 12:18:17', '2024-12-23 12:35:51'),
(2, 'for review', '2024-12-22 12:18:17', '2024-12-23 12:35:54'),
(3, 'accepted', '2024-12-22 12:18:17', '2024-12-23 12:35:38'),
(4, 'rejected', '2024-12-22 12:18:17', '2024-12-23 12:35:58');

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_skills`
--

CREATE TABLE `freelancer_skills` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `skill_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_skills`
--

INSERT INTO `freelancer_skills` (`id`, `user_id`, `skill_id`, `created_at`, `updated_at`) VALUES
(282, 59, 101, '2024-12-22 12:32:43', '2024-12-22 12:32:43'),
(283, 59, 103, '2024-12-22 12:32:43', '2024-12-22 12:32:43'),
(284, 58, 76, '2024-12-22 12:38:55', '2024-12-22 12:38:55'),
(285, 58, 77, '2024-12-22 12:38:55', '2024-12-22 12:38:55'),
(286, 57, 43, '2024-12-22 12:40:06', '2024-12-22 12:40:06'),
(287, 57, 41, '2024-12-22 12:40:06', '2024-12-22 12:40:06'),
(288, 55, 125, '2024-12-22 12:40:55', '2024-12-22 12:40:55'),
(289, 55, 126, '2024-12-22 12:40:55', '2024-12-22 12:40:55'),
(290, 56, 129, '2024-12-22 12:41:36', '2024-12-22 12:41:36'),
(291, 54, 23, '2024-12-22 12:42:16', '2024-12-22 12:42:16'),
(292, 54, 22, '2024-12-22 12:42:16', '2024-12-22 12:42:16'),
(293, 53, 56, '2024-12-22 12:42:55', '2024-12-22 12:42:55'),
(294, 53, 58, '2024-12-22 12:42:55', '2024-12-22 12:42:55'),
(295, 52, 55, '2024-12-22 12:43:21', '2024-12-22 12:43:21'),
(296, 52, 53, '2024-12-22 12:43:21', '2024-12-22 12:43:21'),
(297, 51, 65, '2024-12-22 12:43:56', '2024-12-22 12:43:56'),
(298, 51, 62, '2024-12-22 12:43:56', '2024-12-22 12:43:56'),
(301, 50, 77, '2024-12-22 13:04:17', '2024-12-22 13:04:17'),
(302, 50, 78, '2024-12-22 13:04:17', '2024-12-22 13:04:17'),
(303, 50, 65, '2024-12-22 13:04:17', '2024-12-22 13:04:17'),
(304, 50, 62, '2024-12-22 13:04:17', '2024-12-22 13:04:17');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `application_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `type` int(1) NOT NULL,
  `message` text DEFAULT NULL,
  `is_read` int(1) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `application_id`, `project_id`, `user_id`, `type`, `message`, `is_read`, `created_at`, `updated_at`) VALUES
(118, NULL, 129, 56, 1, 'Your application for Website Redesign has been accepted.', 0, '2024-12-22 12:53:16', '2024-12-22 12:53:16'),
(119, NULL, 130, 55, 1, 'Your application for Data Analysis has been accepted.', 0, '2024-12-22 12:53:19', '2024-12-22 12:53:19'),
(120, NULL, 131, 55, 1, 'Your application for Cloud Storage Solution has been accepted.', 0, '2024-12-22 12:53:28', '2024-12-22 12:53:28'),
(121, NULL, 132, 54, 1, 'Your application for E-commerce Website has been accepted.', 0, '2024-12-22 12:53:31', '2024-12-22 12:53:31'),
(122, NULL, 133, 54, 1, 'Your application for Ai Chatbot Development has been accepted.', 0, '2024-12-22 12:53:37', '2024-12-22 12:53:37'),
(123, NULL, 134, 53, 1, 'Your application for Ai Development has been accepted.', 0, '2024-12-22 12:53:39', '2024-12-22 12:53:39'),
(124, NULL, 135, 53, 1, 'Your application for Mobile App Design has been accepted.', 0, '2024-12-22 12:53:43', '2024-12-22 12:53:43'),
(125, NULL, 136, 52, 1, 'Your application for Website Redesign has been accepted.', 0, '2024-12-22 12:53:45', '2024-12-22 12:53:45'),
(126, NULL, 137, 52, 1, 'Your application for Blockchain Development has been accepted.', 0, '2024-12-22 12:53:48', '2024-12-22 12:53:48'),
(127, NULL, 138, 51, 1, 'Your application for Virtual Reality Simulation has been accepted.', 0, '2024-12-22 12:53:50', '2024-12-22 12:53:50'),
(128, NULL, 139, 51, 1, 'Your application for Data Analysis has been accepted.', 0, '2024-12-22 12:53:52', '2024-12-22 12:53:52'),
(129, NULL, 140, 50, 1, 'Your application for Mobile App Development has been accepted.', 0, '2024-12-22 12:53:55', '2024-12-22 12:53:55'),
(130, NULL, 141, 50, 1, 'Your application for Cloud Storage Solution has been accepted.', 0, '2024-12-22 12:53:58', '2024-12-22 12:53:58'),
(131, 131, 145, 64, 1, 'A new application has been submitted for your project: Social Media Marketing', 0, '2024-12-22 13:04:43', '2024-12-22 13:04:43'),
(132, 132, 141, 63, 1, 'A new application has been submitted for your project: Cloud Storage Solution', 0, '2024-12-22 13:08:59', '2024-12-22 13:08:59'),
(133, NULL, 145, 50, 1, 'Your application for Social Media Marketing has been accepted.', 0, '2024-12-22 13:09:30', '2024-12-22 13:09:30'),
(134, NULL, 141, 50, 1, 'Your application for Cloud Storage Solution has been accepted.', 0, '2024-12-22 13:09:33', '2024-12-22 13:09:33'),
(135, 133, 146, 64, 1, 'A new application has been submitted for your project: Video Production', 0, '2024-12-22 13:09:43', '2024-12-22 13:09:43'),
(136, 134, 136, 62, 1, 'A new application has been submitted for your project: Website Redesign', 0, '2024-12-22 13:10:09', '2024-12-22 13:10:09'),
(137, NULL, 146, 51, 1, 'Your application for Video Production has been accepted.', 1, '2024-12-22 13:10:17', '2024-12-23 12:49:54'),
(138, NULL, 136, 51, 1, 'Your application for Website Redesign has been accepted.', 0, '2024-12-22 13:10:21', '2024-12-22 13:10:21'),
(139, 135, 123, 60, 1, 'A new application has been submitted for your project: Fisch Project', 0, '2024-12-22 13:11:59', '2024-12-22 13:11:59'),
(140, 136, 127, 61, 1, 'A new application has been submitted for your project: Ai Development', 0, '2024-12-22 13:12:13', '2024-12-22 13:12:13'),
(141, NULL, 123, 52, 1, 'Your application for Fisch Project has been accepted.', 0, '2024-12-22 13:12:19', '2024-12-22 13:12:19'),
(142, NULL, 127, 52, 1, 'Your application for Ai Development has been accepted.', 0, '2024-12-22 13:12:21', '2024-12-22 13:12:21'),
(143, 137, 133, 62, 1, 'A new application has been submitted for your project: Ai Chatbot Development', 0, '2024-12-22 13:13:33', '2024-12-22 13:13:33'),
(144, 138, 124, 60, 1, 'A new application has been submitted for your project: Ocean Cleanup', 0, '2024-12-22 13:14:01', '2024-12-22 13:14:01'),
(145, NULL, 133, 53, 1, 'Your application for Ai Chatbot Development has been accepted.', 0, '2024-12-22 13:14:09', '2024-12-22 13:14:09'),
(146, NULL, 124, 53, 1, 'Your application for Ocean Cleanup has been accepted.', 0, '2024-12-22 13:14:17', '2024-12-22 13:14:17'),
(147, 139, 131, 61, 1, 'A new application has been submitted for your project: Cloud Storage Solution', 0, '2024-12-22 13:15:47', '2024-12-22 13:15:47'),
(148, 140, 140, 63, 1, 'A new application has been submitted for your project: Mobile App Development', 0, '2024-12-22 13:16:02', '2024-12-22 13:16:02'),
(149, NULL, 131, 54, 1, 'Your application for Cloud Storage Solution has been accepted.', 0, '2024-12-22 13:16:12', '2024-12-22 13:16:12'),
(150, NULL, 140, 54, 1, 'Your application for Mobile App Development has been accepted.', 0, '2024-12-22 13:16:16', '2024-12-22 13:16:16'),
(151, NULL, 124, 60, 2, 'New submission for your project \"Ocean Cleanup\" has been submitted.', 0, '2024-12-23 09:24:19', '2024-12-23 09:24:19'),
(152, NULL, 124, 53, 2, 'Submission Accepted', 0, '2024-12-23 09:24:45', '2024-12-23 09:24:45'),
(153, NULL, 133, 62, 2, 'New submission for your project \"Ai Chatbot Development\" has been submitted.', 0, '2024-12-23 09:27:45', '2024-12-23 09:27:45'),
(154, NULL, 133, 53, 2, 'Submission Accepted', 0, '2024-12-23 09:30:06', '2024-12-23 09:30:06'),
(156, NULL, 146, 64, 2, 'New submission for your project \"Video Production\" has been submitted.', 0, '2024-12-23 12:05:05', '2024-12-23 12:05:05'),
(157, NULL, 136, 62, 2, 'New submission for your project \"Website Redesign\" has been submitted.', 0, '2024-12-23 12:19:19', '2024-12-23 12:19:19'),
(160, NULL, 126, 53, 1, 'Your application for Solar Panel Installation has been accepted.', 0, '2024-12-23 12:41:05', '2024-12-23 12:41:05'),
(161, NULL, 124, 53, 1, 'Your application for Ocean Cleanup has been rejected.', 0, '2024-12-23 12:58:52', '2024-12-23 12:58:52'),
(162, NULL, 126, 53, 1, 'Your application for Solar Panel Installation has been rejected.', 0, '2024-12-23 12:58:58', '2024-12-23 12:58:58'),
(164, NULL, 123, 52, 1, 'Your application for Fisch Project has been rejected.', 0, '2024-12-23 12:59:25', '2024-12-23 12:59:25'),
(165, NULL, 141, 50, 1, 'Your application for Cloud Storage Solution has been accepted.', 0, '2024-12-25 01:32:56', '2024-12-25 01:32:56'),
(166, NULL, 146, 51, 1, 'Your application for Video Production has been accepted.', 0, '2024-12-25 01:33:00', '2024-12-25 01:33:00'),
(167, NULL, 136, 51, 1, 'Your application for Website Redesign has been accepted.', 0, '2024-12-25 01:33:03', '2024-12-25 01:33:03'),
(168, NULL, 123, 52, 1, 'Your application for Fisch Project has been rejected.', 0, '2024-12-25 01:33:06', '2024-12-25 01:33:06'),
(169, NULL, 127, 52, 1, 'Your application for Ai Development has been accepted.', 0, '2024-12-25 01:33:09', '2024-12-25 01:33:09'),
(170, NULL, 133, 53, 1, 'Your application for Ai Chatbot Development has been accepted.', 0, '2024-12-25 01:33:12', '2024-12-25 01:33:12'),
(171, NULL, 124, 53, 1, 'Your application for Ocean Cleanup has been rejected.', 0, '2024-12-25 01:33:15', '2024-12-25 01:33:15'),
(172, NULL, 131, 54, 1, 'Your application for Cloud Storage Solution has been accepted.', 0, '2024-12-25 01:33:18', '2024-12-25 01:33:18'),
(173, NULL, 140, 54, 1, 'Your application for Mobile App Development has been accepted.', 0, '2024-12-25 01:33:24', '2024-12-25 01:33:24');

-- --------------------------------------------------------

--
-- Table structure for table `project_comments`
--

CREATE TABLE `project_comments` (
  `id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `skills`
--

CREATE TABLE `skills` (
  `id` int(11) NOT NULL,
  `skill_name` varchar(255) NOT NULL,
  `skill_category_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `skills`
--

INSERT INTO `skills` (`id`, `skill_name`, `skill_category_id`, `created_at`, `updated_at`) VALUES
(1, 'Content Writing', 1, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(2, 'Copywriting', 1, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(3, 'Technical Writing', 1, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(4, 'Blog Writing', 1, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(5, 'Creative', 1, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(6, 'Multilingual Translation', 2, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(7, 'Subtitling', 2, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(8, 'Transcription', 2, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(9, 'Proofreading', 2, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(10, 'Editing', 2, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(11, 'Logo Design', 3, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(12, 'Branding Design', 3, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(13, 'Infographic Design', 3, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(14, 'Social Media Graphics', 3, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(15, 'Print Design', 3, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(16, 'Video Editing', 4, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(17, 'Motion Graphics', 4, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(18, '2D Animation', 4, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(19, '3D Animation', 4, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(20, 'Explainer Videos', 4, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(21, 'Wireframing', 5, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(22, 'Prototyping', 5, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(23, 'Mobile App Design', 5, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(24, 'Website Design', 5, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(25, 'User Testing', 5, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(26, 'Front-End Development', 6, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(27, 'Back-End Development', 6, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(28, 'Full-Stack Development', 6, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(29, 'CMS Development (WordPress, Joomla)', 6, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(30, 'E-Commerce Development', 6, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(31, 'iOS Development', 7, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(32, 'Android Development', 7, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(33, 'Flutter Development', 7, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(34, 'React Native Development', 7, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(35, 'Game App Development', 7, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(36, 'Python Development', 8, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(37, 'Java Development', 8, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(38, '.NET Development', 8, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(39, 'C++ Development', 8, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(40, 'API Development', 8, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(41, 'Social Media Marketing', 9, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(42, 'SEO (Search Engine Optimization)', 9, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(43, 'Content Marketing', 9, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(44, 'Email Marketing', 9, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(45, 'Affiliate Marketing', 9, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(46, 'Lead Generation', 10, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(47, 'CRM Management', 10, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(48, 'Cold Calling', 10, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(49, 'Sales Funnel Design', 10, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(50, 'Prospect Research', 10, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(51, 'PPC Campaigns', 11, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(52, 'Google Ads', 11, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(53, 'Facebook Ads', 11, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(54, 'LinkedIn Ads', 11, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(55, 'Display Advertising', 11, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(56, 'Email Management', 12, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(57, 'Calendar Management', 12, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(58, 'Travel Booking', 12, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(59, 'Social Media Assistance', 12, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(60, 'File Organization', 12, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(61, 'Typing', 13, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(62, 'Data Cleaning', 13, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(63, 'Online Research', 13, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(64, 'Spreadsheet Management', 13, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(65, 'CRM Data Input', 13, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(66, 'Chat Support', 14, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(67, 'Phone Support', 14, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(68, 'Ticket Management', 14, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(69, 'Complaint Resolution', 14, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(70, 'Technical Support', 14, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(71, 'Bookkeeping', 15, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(72, 'Payroll Management', 15, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(73, 'Financial Analysis', 15, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(74, 'Tax Preparation', 15, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(75, 'Budget Planning', 15, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(76, 'Business Strategy', 16, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(77, 'Market Research', 16, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(78, 'SWOT Analysis', 16, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(79, 'Operations Management', 16, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(80, 'Process Improvement', 16, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(81, 'Recruitment', 17, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(82, 'Onboarding', 17, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(83, 'Employee Training', 17, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(84, 'Performance Reviews', 17, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(85, 'HR Policies', 17, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(86, 'Hardware Troubleshooting', 18, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(87, 'Software Installation', 18, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(88, 'IT Helpdesk Support', 18, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(89, 'Network Setup', 18, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(90, 'Remote Assistance', 18, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(91, 'System Administration', 19, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(92, 'Cloud Computing', 19, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(93, 'VPN Setup', 19, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(94, 'Server Maintenance', 19, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(95, 'Cybersecurity', 19, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(96, 'CI/CD Pipelines', 20, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(97, 'Docker', 20, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(98, 'Kubernetes', 20, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(99, 'Automation Scripting', 20, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(100, 'Infrastructure as Code', 20, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(101, 'Civil Engineering', 21, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(102, 'Mechanical Engineering', 21, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(103, 'Electrical Engineering', 21, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(104, 'Structural Analysis', 21, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(105, 'Robotics Design', 21, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(106, 'Building Design', 22, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(107, 'CAD Drafting', 22, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(108, '3D Modeling', 22, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(109, 'Interior Design', 22, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(110, 'Landscape Architecture', 22, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(111, 'Product Design', 23, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(112, 'CNC Programming', 23, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(113, '3D Printing', 23, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(114, 'Materials Engineering', 23, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(115, 'Prototyping', 23, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(116, 'Life Coaching', 24, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(117, 'Career Counseling', 24, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(118, 'Parenting Advice', 24, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(119, 'Fitness Planning', 25, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(120, 'Nutrition Consulting', 25, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(121, 'Meditation Training', 25, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(122, 'Contract Drafting', 26, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(123, 'Intellectual Property Consulting', 26, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(124, 'Immigration Support', 26, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(125, 'Business Compliance Assistance', 27, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(126, 'Legal Research', 27, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(127, 'Data Cleaning', 28, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(128, 'Data Wrangling', 28, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(129, 'Big Data Analytics', 28, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(130, 'Predictive Analytics', 29, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(131, 'Machine Learning Model Development', 29, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(132, 'Data Visualization', 29, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(133, 'Game Testing', 30, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(134, 'Level Design', 30, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(135, 'Narrative Writing', 30, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(136, 'Game Monetization Strategy', 31, '2024-12-14 15:44:28', '2024-12-14 15:44:50'),
(137, 'Esports Coaching', 31, '2024-12-14 15:44:28', '2024-12-14 15:44:50');

-- --------------------------------------------------------

--
-- Table structure for table `skills_category`
--

CREATE TABLE `skills_category` (
  `id` int(11) NOT NULL,
  `category_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `skills_category`
--

INSERT INTO `skills_category` (`id`, `category_name`, `created_at`, `updated_at`) VALUES
(1, 'Writing', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(2, 'Translation', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(3, 'Graphic Design', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(4, 'Video and Animation', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(5, 'UI/UX Design', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(6, 'Web Development', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(7, 'Mobile Development', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(8, 'Software Development', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(9, 'Digital Marketing', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(10, 'Sales Support', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(11, 'Advertising', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(12, 'Virtual Assistance', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(13, 'Data Entry', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(14, 'Customer Support', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(15, 'Financial Skills', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(16, 'Business Consulting', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(17, 'Human Resources', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(18, 'IT Support', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(19, 'Networking', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(20, 'DevOps', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(21, 'Engineering', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(22, 'Architecture', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(23, 'Manufacturing', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(24, 'Coaching & Development', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(25, 'Health & Wellness', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(26, 'Contract & Documentation', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(27, 'Compliance & Research', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(28, 'Data Processing', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(29, 'Advanced Analytics', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(30, 'Game Development Support', '2024-12-09 12:05:20', '2024-12-09 12:05:20'),
(31, 'Monetization & Coaching', '2024-12-09 12:05:20', '2024-12-09 12:05:20');

-- --------------------------------------------------------

--
-- Table structure for table `top_categories_audit`
--

CREATE TABLE `top_categories_audit` (
  `id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `frequency` int(11) NOT NULL,
  `month_collected` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `birthdate` date NOT NULL,
  `gender_id` int(11) NOT NULL,
  `city` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mobile_number` varchar(13) NOT NULL,
  `nationality` varchar(255) NOT NULL,
  `language` varchar(255) NOT NULL,
  `language_2nd` varchar(255) DEFAULT NULL,
  `role_id` int(11) NOT NULL,
  `profile_picture_url` varchar(255) NOT NULL,
  `job_title_id` int(10) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `reset_token` int(6) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL,
  `activation_token` int(6) DEFAULT NULL,
  `last_login_date` datetime DEFAULT NULL,
  `deactivation_duration` datetime DEFAULT NULL,
  `status_id` int(11) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `birthdate`, `gender_id`, `city`, `email`, `mobile_number`, `nationality`, `language`, `language_2nd`, `role_id`, `profile_picture_url`, `job_title_id`, `password_hash`, `reset_token`, `reset_token_expiry`, `activation_token`, `last_login_date`, `deactivation_duration`, `status_id`, `created_at`, `updated_at`) VALUES
(50, 'John', 'Doe', '1999-11-11', 1, 'Calbayog City, Samar, Philippines', 'Freelancer_1@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 2, '../../dist/php/uploads/profile_pictures/676809a983bfe_unnamed (1).jpg', 21, '$2y$10$6a6FHlMPJDGxSAD3VhewQ.U4HkyTaHBFC/ihBzeU7Oj.T77g2kD.y', NULL, NULL, NULL, '2024-12-23 19:54:51', NULL, 1, '2024-12-22 11:17:59', '2024-12-23 11:54:51'),
(51, 'Jane ', 'Doe', '1999-11-11', 1, 'Caloocan, Metro Manila, Philippines', 'Freelancer_2@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 2, '../../dist/php/uploads/profile_pictures/67680987e13f0_unnamed (2).png', 1, '$2y$10$CqnjFKzfnUjlx.07mm0oXeUn4/cni1YymbdCPtGE1VITs5irkc28K', NULL, NULL, NULL, '2024-12-23 20:04:00', NULL, 1, '2024-12-22 11:18:51', '2024-12-23 12:04:00'),
(52, 'Ken', 'Villasquez', '1999-11-11', 1, 'Antipolo, Rizal, Philippines', 'Freelancer_3@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 2, '../../dist/php/uploads/profile_pictures/6768096325e67_unnamed (4).jpg', 2, '$2y$10$zQp21Vef6iArVR4Y9DnWwuCLM7n5CpxzbpuYjFWAMBHqKM4DsP3g.', NULL, NULL, NULL, '2024-12-22 21:11:47', NULL, 1, '2024-12-22 11:19:36', '2024-12-22 13:20:39'),
(53, 'Jelord', 'Nunezca', '1999-11-11', 1, 'Dumaguete, Negros Oriental, Philippines', 'Freelancer_4@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 2, '../../dist/php/uploads/profile_pictures/67680947c5afd_unnamed.jpg', 3, '$2y$10$s87HNQktayTuxTQ5Dd0mdejMaug5K2S4Ue2OTnoc2ILS5gVTUS7sm', NULL, NULL, NULL, '2024-12-23 19:58:10', NULL, 1, '2024-12-22 11:22:45', '2024-12-23 11:58:10'),
(54, 'Joshua ', 'Gonzales', '1999-11-11', 1, 'Calbayog City, Samar, Philippines', 'Freelancer_5@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 2, '../../dist/php/uploads/profile_pictures/6768092082a49_unnamed (7).jpg', 2, '$2y$10$Cns6jbVs6L8hGsf8DbhCh.F0VD26BnlkK6SJJyX8p6ULcX7jdYJpm', NULL, NULL, NULL, '2024-12-22 21:15:32', NULL, 1, '2024-12-22 11:23:26', '2024-12-22 13:20:39'),
(55, 'Hawkens', 'Queens', '1999-11-11', 2, 'Biri, Northern Samar, Philippines', 'Freelancer_6@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 2, '../../dist/php/uploads/profile_pictures/676808d2b7ed6_portrait-young-hispanic-professional-business-260nw-2510293403.webp', NULL, '$2y$10$n474YSatDWn4H1v6o5h3eOW/FAVXOqilxivnJA/5sT5C5MDWaNGqC', NULL, NULL, NULL, '2024-12-22 20:41:45', NULL, 1, '2024-12-22 11:24:33', '2024-12-22 13:20:39'),
(56, 'Josefina', 'Lahoylahoy', '1999-11-11', 2, 'Quezon City, Metro Manila, Philippines', 'Freelancer_7@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 2, '../../dist/php/uploads/profile_pictures/676808f34d357_unnamed (1).png', NULL, '$2y$10$EL7F1F9ljAp.4K9tbZVszemWRN67HSstAV.CvECxKz4RGNDBeBvr2', NULL, NULL, NULL, '2024-12-22 20:41:54', NULL, 1, '2024-12-22 11:25:28', '2024-12-22 13:20:39'),
(57, 'Richard', 'Salanio', '1999-11-11', 1, 'Quezon City, Metro Manila, Philippines', 'Freelancer_8@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 2, '../../dist/php/uploads/profile_pictures/67680889132e6_happy-mid-aged-business-man-600nw-2307212331.webp', NULL, '$2y$10$Ix9VLjcRORCFMqydbDTGcOioIXyK/En6zgYt3D1C/VDHsr1Tnj8yK', NULL, NULL, NULL, '2024-12-22 20:39:13', NULL, 1, '2024-12-22 11:26:23', '2024-12-22 13:20:39'),
(58, 'Alvin', 'Dave', '1999-11-11', 1, 'Bagumbang, Misamis Occidental, Philippines', 'Freelancer_9@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 2, '../../dist/php/uploads/profile_pictures/6768085a0b1a3_elegant-confident-fashionable-aged-business-person-mature-businessman-formal-wear-senior-man-grey-beard-hair-bearded-137982468.webp', NULL, '$2y$10$RcLqYppzV8Cbl/qjyMys0eujbpBwZ3BIUF8EzEZ6bkoBx/9JkonYe', NULL, NULL, NULL, '2024-12-22 20:36:23', NULL, 1, '2024-12-22 11:27:47', '2024-12-22 13:20:39'),
(59, 'Jireh Walter', 'Sodsod', '1999-11-11', 1, 'New Lucena, Iloilo, Philippines', 'Freelancer_10@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 2, '../../dist/php/uploads/profile_pictures/676806e58bf18_unnamed (5).jpg', 1, '$2y$10$qQYBAoo.oQz3gVXrcl7YgeP8HKwtIsK/UFcIrbaTQlShK0VY37I4e', NULL, NULL, NULL, '2024-12-22 21:21:39', NULL, 1, '2024-12-22 11:28:41', '2024-12-22 13:21:39'),
(60, 'Caleb', 'City', '1999-11-11', 2, 'Davao City, Davao del Sur, Philippines', 'Client_1@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 1, '../../dist/php/uploads/profile_pictures/67680a3e787ac_unnamed (6).jpg', 1, '$2y$10$txjiYPCEfTBCt/cdpfggwO/C2Mw7bNrjt8RJ8MAuwVqyrpfTW7qIq', NULL, NULL, NULL, '2024-12-23 20:38:13', NULL, 1, '2024-12-22 11:29:45', '2024-12-23 12:38:13'),
(61, 'Gion', 'Satoru', '1999-11-11', 2, 'Pasig, Metro Manila, Philippines', 'Client_2@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 1, '../../dist/php/uploads/profile_pictures/67681164980c5_images.jpg', 10, '$2y$10$2bs7cne0VBUxGi1pHIhqbO45QyoNkrVmYaFc3lHobWV0c134alsvy', NULL, NULL, NULL, '2024-12-22 21:23:09', NULL, 1, '2024-12-22 11:30:44', '2024-12-22 13:23:09'),
(62, 'Jhon ', 'Dred', '1999-11-11', 1, 'San Fernando, Pampanga, Philippines', 'Client_3@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 1, '../../dist/php/uploads/profile_pictures/67680e0393e40_console&p&bc6272b2d2a540bfb06581f5c2c8c701.webp', 18, '$2y$10$QFNtHYlZ8D4aEnkM7OqgKO9Piri/jeZa1XrrQlEDvcFwkVRX6puhC', NULL, NULL, NULL, '2024-12-23 17:29:48', NULL, 1, '2024-12-22 11:31:39', '2024-12-23 09:29:48'),
(63, 'Andrei', 'Paras', '1999-11-11', 1, 'Valenzuela, Metro Manila, Philippines', 'Client_4@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 1, '../../dist/php/uploads/profile_pictures/6768021c0640f_Untitled.jpg', 1, '$2y$10$KhxcWERSTUvY6tzWvBvAgObr7SZvHZyaSijHmmuob1k4a74NRDt26', NULL, NULL, NULL, '2024-12-22 21:17:57', NULL, 1, '2024-12-22 11:33:35', '2024-12-22 13:20:39'),
(64, 'Fisch', 'Nation', '1999-11-11', 2, 'Vigan City, Ilocos Sur, Philippines', 'Client_5@example.com', '09xxxxxxxxx', 'Filipino', 'Filipino', 'English', 1, '../../dist/php/uploads/profile_pictures/676812582e95e_images.jpg', 2, '$2y$10$i6cClbhP3MMns6N/5VTR.e4WUbRMVZNx8HCDKpEKrWKKz2BLefAJK', NULL, NULL, NULL, '2024-12-23 17:20:58', NULL, 1, '2024-12-22 11:34:13', '2024-12-23 09:20:58');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `tr_capitalize_first_name_before_insert` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE word_count INT;
    DECLARE word TEXT;
    DECLARE result TEXT DEFAULT '';

    SET word_count = LENGTH(NEW.first_name) - LENGTH(REPLACE(NEW.first_name, ' ', '')) + 1;

    WHILE i <= word_count DO
        SET word = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.first_name, ' ', i), ' ', -1));

        SET result = CONCAT(
            result,
            IF(result = '', '', ' '),
            CONCAT(UPPER(SUBSTRING(word, 1, 1)), LOWER(SUBSTRING(word FROM 2)))
        );

        SET i = i + 1;
    END WHILE;

    SET NEW.first_name = result;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_capitalize_first_name_before_update` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE word_count INT;
    DECLARE word TEXT;
    DECLARE result TEXT DEFAULT '';

    SET word_count = LENGTH(NEW.first_name) - LENGTH(REPLACE(NEW.first_name, ' ', '')) + 1;

    WHILE i <= word_count DO
        SET word = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.first_name, ' ', i), ' ', -1));

        SET result = CONCAT(
            result,
            IF(result = '', '', ' '), 
            CONCAT(UPPER(SUBSTRING(word, 1, 1)), LOWER(SUBSTRING(word FROM 2)))
        );

        SET i = i + 1; 
    END WHILE;

    SET NEW.first_name = result;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_capitalize_last_name_before_insert` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    SET NEW.last_name = CONCAT(
        UPPER(LEFT(NEW.last_name, 1)),
        LOWER(SUBSTRING(NEW.last_name, 2))
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_capitalize_last_name_before_update` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
    SET NEW.last_name = CONCAT(
        UPPER(LEFT(NEW.last_name, 1)),
        LOWER(SUBSTRING(NEW.last_name, 2))
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_freelancer_signup_merit_connects` AFTER INSERT ON `users` FOR EACH ROW IF NEW.role_id = '2' THEN
        INSERT INTO freelancer_connects (user_id, connects)
        VALUES (NEW.id, 100);
		INSERT INTO freelancer_merits (user_id, merits)
        VALUES (NEW.id, 0);
    END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users_gender`
--

CREATE TABLE `users_gender` (
  `id` int(11) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_gender`
--

INSERT INTO `users_gender` (`id`, `gender`, `created_at`, `updated_at`) VALUES
(1, 'Male', '2024-12-09 11:26:38', '2024-12-09 11:27:08'),
(2, 'Female', '2024-12-09 11:26:38', '2024-12-09 11:27:08'),
(3, 'Prefer not to say', '2024-12-09 11:26:38', '2024-12-09 11:27:08');

-- --------------------------------------------------------

--
-- Table structure for table `users_job_titles`
--

CREATE TABLE `users_job_titles` (
  `id` int(11) NOT NULL,
  `job_title` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_job_titles`
--

INSERT INTO `users_job_titles` (`id`, `job_title`, `created_at`, `updated_at`) VALUES
(1, 'Software Developer', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(2, '3D Artist', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(3, 'Database Administrator', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(4, 'Web Developer', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(5, 'UI/UX Designer', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(6, 'Mobile App Developer', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(7, 'Project Manager', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(8, 'Graphic Designer', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(9, 'System Administrator', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(10, 'Network Engineer', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(11, 'Product Manager', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(12, 'DevOps Engineer', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(13, 'Business Analyst', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(14, 'Content Writer', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(15, 'SEO Specialist', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(16, 'Cloud Solutions Architect', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(17, 'Game Developer', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(18, 'Cybersecurity Analyst', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(19, 'Data Scientist', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(20, 'Machine Learning Engineer', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(21, 'Artificial Intelligence Specialist', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(22, 'Software Engineer', '2024-12-09 12:07:31', '2024-12-09 12:07:44'),
(23, 'Marketing Specialist', '2024-12-09 12:07:31', '2024-12-09 12:07:44');

-- --------------------------------------------------------

--
-- Table structure for table `users_roles`
--

CREATE TABLE `users_roles` (
  `id` int(11) NOT NULL,
  `role` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_roles`
--

INSERT INTO `users_roles` (`id`, `role`, `created_at`, `updated_at`) VALUES
(1, 'Client', '2024-12-09 11:24:07', NULL),
(2, 'Freelancer', '2024-12-09 11:24:07', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users_status`
--

CREATE TABLE `users_status` (
  `id` int(11) NOT NULL,
  `status` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_status`
--

INSERT INTO `users_status` (`id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'active', '2024-12-09 11:37:58', '2024-12-09 11:37:58'),
(2, 'deactivated', '2024-12-09 11:37:58', '2024-12-10 00:55:48');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_accepted_freelancers`
-- (See below for the actual view)
--
CREATE TABLE `v_accepted_freelancers` (
`id` int(11)
,`first_name` varchar(50)
,`last_name` varchar(50)
,`email` varchar(255)
,`mobile_number` varchar(13)
,`profile_picture_url` varchar(255)
,`job_title` varchar(255)
,`project_owner` int(11)
,`project_title` varchar(255)
,`status` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_all_application`
-- (See below for the actual view)
--
CREATE TABLE `v_all_application` (
`id` int(11)
,`first_name` varchar(50)
,`last_name` varchar(50)
,`email` varchar(255)
,`mobile_number` varchar(13)
,`profile_picture_url` varchar(255)
,`job_title` varchar(255)
,`project_owner` int(11)
,`project_title` varchar(255)
,`application_date` timestamp
,`status` varchar(255)
,`merits` int(10)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_applications`
-- (See below for the actual view)
--
CREATE TABLE `v_applications` (
`id` int(11)
,`application_details` text
,`portfolio_url` varchar(255)
,`status` varchar(255)
,`application_date` datetime
,`created_at` timestamp
,`updated_at` timestamp
,`merits` int(10)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_applications_ids`
-- (See below for the actual view)
--
CREATE TABLE `v_applications_ids` (
`id` int(11)
,`project_id` int(11)
,`user_id` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_available_job_titles`
-- (See below for the actual view)
--
CREATE TABLE `v_available_job_titles` (
`id` int(11)
,`job_title` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_available_skills_category`
-- (See below for the actual view)
--
CREATE TABLE `v_available_skills_category` (
`id` int(11)
,`skills_category` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_clients`
-- (See below for the actual view)
--
CREATE TABLE `v_clients` (
`id` int(11)
,`first_name` varchar(50)
,`last_name` varchar(50)
,`birthdate` date
,`gender` varchar(50)
,`city` varchar(255)
,`email` varchar(255)
,`mobile_number` varchar(13)
,`nationality` varchar(255)
,`language` varchar(255)
,`job_title` varchar(255)
,`profile_picture_url` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_freelancers`
-- (See below for the actual view)
--
CREATE TABLE `v_freelancers` (
`id` int(11)
,`first_name` varchar(50)
,`last_name` varchar(50)
,`birthdate` date
,`gender` varchar(50)
,`city` varchar(255)
,`email` varchar(255)
,`mobile_number` varchar(13)
,`nationality` varchar(255)
,`language` varchar(255)
,`job_title` varchar(255)
,`profile_picture_url` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_freelancer_connects_and_merits`
-- (See below for the actual view)
--
CREATE TABLE `v_freelancer_connects_and_merits` (
`id` int(11)
,`freelancer` varchar(101)
,`merits` int(10)
,`connects` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_freelancer_experiences`
-- (See below for the actual view)
--
CREATE TABLE `v_freelancer_experiences` (
`id` int(11)
,`user_id` int(11)
,`job_title` varchar(255)
,`company_name` varchar(255)
,`duration` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_freelancer_submissions`
-- (See below for the actual view)
--
CREATE TABLE `v_freelancer_submissions` (
`id` int(11)
,`project_id` int(11)
,`user_id` int(11)
,`submission_url` varchar(255)
,`status` varchar(255)
,`created_at` timestamp
,`updated_at` timestamp
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_indemand_categories`
-- (See below for the actual view)
--
CREATE TABLE `v_indemand_categories` (
`project_category` varchar(255)
,`category_count` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_most_populated_job_title`
-- (See below for the actual view)
--
CREATE TABLE `v_most_populated_job_title` (
`job_title` varchar(255)
,`job_title_count` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_notifications`
-- (See below for the actual view)
--
CREATE TABLE `v_notifications` (
`id` int(11)
,`application_id` int(11)
,`project_id` int(11)
,`user_id` int(11)
,`type` int(1)
,`message` text
,`is_read` int(1)
,`created_at` timestamp
,`updated_at` timestamp
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_not_verified_emails`
-- (See below for the actual view)
--
CREATE TABLE `v_not_verified_emails` (
`email` varchar(255)
,`activation_token` int(6)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_project_comments`
-- (See below for the actual view)
--
CREATE TABLE `v_project_comments` (
`id` int(11)
,`project_id` int(11)
,`user_id` int(11)
,`comment` text
,`created_at` timestamp
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_project_completion_history`
-- (See below for the actual view)
--
CREATE TABLE `v_project_completion_history` (
`id` int(11)
,`application_id` int(11)
,`project_id` int(11)
,`user_id` int(11)
,`action_type` enum('INSERT','UPDATE','DELETE')
,`action_timestamp` timestamp
,`new_submission_url` varchar(255)
,`status` varchar(255)
,`created_at` timestamp
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_project_details`
-- (See below for the actual view)
--
CREATE TABLE `v_project_details` (
`id` int(11)
,`project_owner` int(11)
,`project_title` varchar(255)
,`project_category` varchar(255)
,`project_description` text
,`project_objective` text
,`project_status` varchar(255)
,`project_connect_cost` int(11)
,`project_merit_worth` int(11)
,`created_at` timestamp
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_skills_with_category`
-- (See below for the actual view)
--
CREATE TABLE `v_skills_with_category` (
`id` int(11)
,`skill` varchar(255)
,`category` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_users_with_reset_token`
-- (See below for the actual view)
--
CREATE TABLE `v_users_with_reset_token` (
`id` int(11)
,`full_name` varchar(101)
,`reset_token` int(6)
,`reset_token_expiry` datetime
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_user_credentials`
-- (See below for the actual view)
--
CREATE TABLE `v_user_credentials` (
`id` int(11)
,`email` varchar(255)
,`role` varchar(50)
,`password_hash` varchar(255)
,`activation_token` int(6)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_user_profile`
-- (See below for the actual view)
--
CREATE TABLE `v_user_profile` (
`id` int(11)
,`first_name` varchar(50)
,`last_name` varchar(50)
,`birthdate` date
,`gender` varchar(50)
,`city` varchar(255)
,`email` varchar(255)
,`mobile_number` varchar(13)
,`language` varchar(255)
,`language_2nd` varchar(255)
,`job_title` varchar(255)
,`profile_picture_url` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_user_skills`
-- (See below for the actual view)
--
CREATE TABLE `v_user_skills` (
`user_id` int(11)
,`skill_id` int(11)
,`skill_name` varchar(255)
,`category_name` varchar(255)
);

-- --------------------------------------------------------

--
-- Structure for view `v_accepted_freelancers`
--
DROP TABLE IF EXISTS `v_accepted_freelancers`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_accepted_freelancers`  AS SELECT `users`.`id` AS `id`, `users`.`first_name` AS `first_name`, `users`.`last_name` AS `last_name`, `users`.`email` AS `email`, `users`.`mobile_number` AS `mobile_number`, `users`.`profile_picture_url` AS `profile_picture_url`, `users_job_titles`.`job_title` AS `job_title`, `client_projects`.`user_id` AS `project_owner`, `client_projects`.`project_title` AS `project_title`, `freelancer_application_status`.`status` AS `status` FROM ((((`users` join `freelancer_applications` on(`users`.`id` = `freelancer_applications`.`user_id`)) join `client_projects` on(`freelancer_applications`.`project_id` = `client_projects`.`id`)) join `users_job_titles` on(`users`.`job_title_id` = `users_job_titles`.`id`)) join `freelancer_application_status` on(`freelancer_applications`.`application_status_id` = `freelancer_application_status`.`id`)) WHERE `freelancer_application_status`.`status` = 'accepted' ;

-- --------------------------------------------------------

--
-- Structure for view `v_all_application`
--
DROP TABLE IF EXISTS `v_all_application`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_all_application`  AS SELECT `freelancer_applications`.`id` AS `id`, `users`.`first_name` AS `first_name`, `users`.`last_name` AS `last_name`, `users`.`email` AS `email`, `users`.`mobile_number` AS `mobile_number`, `users`.`profile_picture_url` AS `profile_picture_url`, `users_job_titles`.`job_title` AS `job_title`, `client_projects`.`user_id` AS `project_owner`, `client_projects`.`project_title` AS `project_title`, `freelancer_applications`.`created_at` AS `application_date`, `freelancer_application_status`.`status` AS `status`, `freelancer_merits`.`merits` AS `merits` FROM (((((`users` join `freelancer_applications` on(`users`.`id` = `freelancer_applications`.`user_id`)) join `client_projects` on(`freelancer_applications`.`project_id` = `client_projects`.`id`)) left join `users_job_titles` on(`users`.`job_title_id` = `users_job_titles`.`id`)) join `freelancer_application_status` on(`freelancer_applications`.`application_status_id` = `freelancer_application_status`.`id`)) left join `freelancer_merits` on(`users`.`id` = `freelancer_merits`.`user_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_applications`
--
DROP TABLE IF EXISTS `v_applications`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_applications`  AS SELECT `freelancer_applications`.`id` AS `id`, `freelancer_applications`.`application_details` AS `application_details`, `freelancer_applications`.`portfolio_url` AS `portfolio_url`, `freelancer_application_status`.`status` AS `status`, `freelancer_applications`.`application_date` AS `application_date`, `freelancer_applications`.`created_at` AS `created_at`, `freelancer_applications`.`updated_at` AS `updated_at`, `freelancer_merits`.`merits` AS `merits` FROM ((`freelancer_applications` join `freelancer_application_status` on(`freelancer_applications`.`application_status_id` = `freelancer_application_status`.`id`)) left join `freelancer_merits` on(`freelancer_applications`.`user_id` = `freelancer_merits`.`user_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_applications_ids`
--
DROP TABLE IF EXISTS `v_applications_ids`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_applications_ids`  AS SELECT `freelancer_applications`.`id` AS `id`, `freelancer_applications`.`project_id` AS `project_id`, `freelancer_applications`.`user_id` AS `user_id` FROM `freelancer_applications` ;

-- --------------------------------------------------------

--
-- Structure for view `v_available_job_titles`
--
DROP TABLE IF EXISTS `v_available_job_titles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_available_job_titles`  AS SELECT `users_job_titles`.`id` AS `id`, `users_job_titles`.`job_title` AS `job_title` FROM `users_job_titles` ;

-- --------------------------------------------------------

--
-- Structure for view `v_available_skills_category`
--
DROP TABLE IF EXISTS `v_available_skills_category`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_available_skills_category`  AS SELECT DISTINCT `skills_category`.`id` AS `id`, `skills_category`.`category_name` AS `skills_category` FROM `skills_category` ORDER BY `skills_category`.`category_name` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `v_clients`
--
DROP TABLE IF EXISTS `v_clients`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_clients`  AS SELECT `users`.`id` AS `id`, `users`.`first_name` AS `first_name`, `users`.`last_name` AS `last_name`, `users`.`birthdate` AS `birthdate`, `users_gender`.`gender` AS `gender`, `users`.`city` AS `city`, `users`.`email` AS `email`, `users`.`mobile_number` AS `mobile_number`, `users`.`nationality` AS `nationality`, `users`.`language` AS `language`, `users_job_titles`.`job_title` AS `job_title`, `users`.`profile_picture_url` AS `profile_picture_url` FROM ((`users` join `users_gender` on(`users`.`gender_id` = `users_gender`.`id`)) left join `users_job_titles` on(`users`.`job_title_id` = `users_job_titles`.`id`)) WHERE `users`.`role_id` = 1 ;

-- --------------------------------------------------------

--
-- Structure for view `v_freelancers`
--
DROP TABLE IF EXISTS `v_freelancers`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_freelancers`  AS SELECT `users`.`id` AS `id`, `users`.`first_name` AS `first_name`, `users`.`last_name` AS `last_name`, `users`.`birthdate` AS `birthdate`, `users_gender`.`gender` AS `gender`, `users`.`city` AS `city`, `users`.`email` AS `email`, `users`.`mobile_number` AS `mobile_number`, `users`.`nationality` AS `nationality`, `users`.`language` AS `language`, `users_job_titles`.`job_title` AS `job_title`, `users`.`profile_picture_url` AS `profile_picture_url` FROM ((`users` join `users_gender` on(`users`.`gender_id` = `users_gender`.`id`)) left join `users_job_titles` on(`users`.`job_title_id` = `users_job_titles`.`id`)) WHERE `users`.`role_id` = 2 ;

-- --------------------------------------------------------

--
-- Structure for view `v_freelancer_connects_and_merits`
--
DROP TABLE IF EXISTS `v_freelancer_connects_and_merits`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_freelancer_connects_and_merits`  AS SELECT `users`.`id` AS `id`, concat(`users`.`first_name`,' ',`users`.`last_name`) AS `freelancer`, `freelancer_merits`.`merits` AS `merits`, `freelancer_connects`.`connects` AS `connects` FROM ((`users` join `freelancer_merits` on(`freelancer_merits`.`user_id` = `users`.`id`)) join `freelancer_connects` on(`freelancer_connects`.`user_id` = `users`.`id`)) WHERE `users`.`status_id` = 1 ;

-- --------------------------------------------------------

--
-- Structure for view `v_freelancer_experiences`
--
DROP TABLE IF EXISTS `v_freelancer_experiences`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_freelancer_experiences`  AS SELECT `freelancer_experiences`.`id` AS `id`, `freelancer_experiences`.`user_id` AS `user_id`, `freelancer_experiences`.`job_title` AS `job_title`, `freelancer_experiences`.`company_name` AS `company_name`, `freelancer_experiences`.`duration` AS `duration` FROM `freelancer_experiences` ;

-- --------------------------------------------------------

--
-- Structure for view `v_freelancer_submissions`
--
DROP TABLE IF EXISTS `v_freelancer_submissions`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_freelancer_submissions`  AS SELECT `freelancer_project_submissions`.`id` AS `id`, `freelancer_project_submissions`.`project_id` AS `project_id`, `freelancer_project_submissions`.`user_id` AS `user_id`, `freelancer_project_submissions`.`submission_url` AS `submission_url`, `freelancer_project_submissions_status`.`status` AS `status`, `freelancer_project_submissions`.`created_at` AS `created_at`, `freelancer_project_submissions`.`updated_at` AS `updated_at` FROM (`freelancer_project_submissions` join `freelancer_project_submissions_status` on(`freelancer_project_submissions_status`.`id` = `freelancer_project_submissions`.`submission_status_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_indemand_categories`
--
DROP TABLE IF EXISTS `v_indemand_categories`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_indemand_categories`  AS SELECT `v_project_details`.`project_category` AS `project_category`, count(`v_project_details`.`project_category`) AS `category_count` FROM `v_project_details` GROUP BY `v_project_details`.`project_category` ORDER BY count(`v_project_details`.`project_category`) DESC LIMIT 0, 3 ;

-- --------------------------------------------------------

--
-- Structure for view `v_most_populated_job_title`
--
DROP TABLE IF EXISTS `v_most_populated_job_title`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_most_populated_job_title`  AS SELECT `v_freelancers`.`job_title` AS `job_title`, count(`v_freelancers`.`job_title`) AS `job_title_count` FROM `v_freelancers` GROUP BY `v_freelancers`.`job_title` ORDER BY count(`v_freelancers`.`job_title`) DESC LIMIT 0, 3 ;

-- --------------------------------------------------------

--
-- Structure for view `v_notifications`
--
DROP TABLE IF EXISTS `v_notifications`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_notifications`  AS SELECT `notifications`.`id` AS `id`, `notifications`.`application_id` AS `application_id`, `notifications`.`project_id` AS `project_id`, `notifications`.`user_id` AS `user_id`, `notifications`.`type` AS `type`, `notifications`.`message` AS `message`, `notifications`.`is_read` AS `is_read`, `notifications`.`created_at` AS `created_at`, `notifications`.`updated_at` AS `updated_at` FROM `notifications` ;

-- --------------------------------------------------------

--
-- Structure for view `v_not_verified_emails`
--
DROP TABLE IF EXISTS `v_not_verified_emails`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_not_verified_emails`  AS SELECT `users`.`email` AS `email`, `users`.`activation_token` AS `activation_token` FROM `users` WHERE `users`.`activation_token` is not null ;

-- --------------------------------------------------------

--
-- Structure for view `v_project_comments`
--
DROP TABLE IF EXISTS `v_project_comments`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_project_comments`  AS SELECT `project_comments`.`id` AS `id`, `project_comments`.`project_id` AS `project_id`, `project_comments`.`user_id` AS `user_id`, `project_comments`.`comment` AS `comment`, `project_comments`.`created_at` AS `created_at` FROM `project_comments` ;

-- --------------------------------------------------------

--
-- Structure for view `v_project_completion_history`
--
DROP TABLE IF EXISTS `v_project_completion_history`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_project_completion_history`  AS SELECT `fpsa`.`id` AS `id`, `fpsa`.`application_id` AS `application_id`, `fpsa`.`project_id` AS `project_id`, `fpsa`.`user_id` AS `user_id`, `fpsa`.`action_type` AS `action_type`, `fpsa`.`action_timestamp` AS `action_timestamp`, `fpsa`.`new_submission_url` AS `new_submission_url`, `fss`.`status` AS `status`, `fpsa`.`new_updated_at` AS `created_at` FROM (`freelancer_project_submissions_audit` `fpsa` left join `freelancer_project_submissions_status` `fss` on(`fpsa`.`new_submission_status_id` = `fss`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_project_details`
--
DROP TABLE IF EXISTS `v_project_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_project_details`  AS SELECT `client_projects`.`id` AS `id`, `client_projects`.`user_id` AS `project_owner`, `client_projects`.`project_title` AS `project_title`, `skills_category`.`category_name` AS `project_category`, `client_projects`.`project_description` AS `project_description`, `client_projects`.`project_objective` AS `project_objective`, `client_project_status`.`status` AS `project_status`, `client_projects`.`project_connect_cost` AS `project_connect_cost`, `client_projects`.`project_merit_worth` AS `project_merit_worth`, `client_projects`.`created_at` AS `created_at` FROM ((`client_projects` join `skills_category` on(`client_projects`.`project_category_id` = `skills_category`.`id`)) join `client_project_status` on(`client_projects`.`project_status_id` = `client_project_status`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_skills_with_category`
--
DROP TABLE IF EXISTS `v_skills_with_category`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_skills_with_category`  AS SELECT `skills`.`id` AS `id`, `skills`.`skill_name` AS `skill`, `skills_category`.`category_name` AS `category` FROM (`skills` join `skills_category` on(`skills_category`.`id` = `skills`.`skill_category_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_users_with_reset_token`
--
DROP TABLE IF EXISTS `v_users_with_reset_token`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_users_with_reset_token`  AS SELECT `users`.`id` AS `id`, concat(`users`.`first_name`,' ',`users`.`last_name`) AS `full_name`, `users`.`reset_token` AS `reset_token`, `users`.`reset_token_expiry` AS `reset_token_expiry` FROM `users` WHERE `users`.`reset_token` is not null ;

-- --------------------------------------------------------

--
-- Structure for view `v_user_credentials`
--
DROP TABLE IF EXISTS `v_user_credentials`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_user_credentials`  AS SELECT `users`.`id` AS `id`, `users`.`email` AS `email`, `users_roles`.`role` AS `role`, `users`.`password_hash` AS `password_hash`, `users`.`activation_token` AS `activation_token` FROM (`users` join `users_roles` on(`users`.`role_id` = `users_roles`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_user_profile`
--
DROP TABLE IF EXISTS `v_user_profile`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_user_profile`  AS SELECT `users`.`id` AS `id`, `users`.`first_name` AS `first_name`, `users`.`last_name` AS `last_name`, `users`.`birthdate` AS `birthdate`, `users_gender`.`gender` AS `gender`, `users`.`city` AS `city`, `users`.`email` AS `email`, `users`.`mobile_number` AS `mobile_number`, `users`.`language` AS `language`, `users`.`language_2nd` AS `language_2nd`, `users_job_titles`.`job_title` AS `job_title`, `users`.`profile_picture_url` AS `profile_picture_url` FROM ((`users` join `users_gender` on(`users`.`gender_id` = `users_gender`.`id`)) left join `users_job_titles` on(`users`.`job_title_id` = `users_job_titles`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_user_skills`
--
DROP TABLE IF EXISTS `v_user_skills`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_user_skills`  AS SELECT `freelancer_skills`.`user_id` AS `user_id`, `freelancer_skills`.`skill_id` AS `skill_id`, `skills`.`skill_name` AS `skill_name`, `skills_category`.`category_name` AS `category_name` FROM ((`freelancer_skills` join `skills` on(`skills`.`id` = `freelancer_skills`.`skill_id`)) join `skills_category` on(`skills_category`.`id` = `skills`.`skill_category_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `client_projects`
--
ALTER TABLE `client_projects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `client_projects_ibfk_2` (`project_status_id`),
  ADD KEY `client_projects_ibfk_3` (`project_category_id`);

--
-- Indexes for table `client_project_audit`
--
ALTER TABLE `client_project_audit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `client_project_status`
--
ALTER TABLE `client_project_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `completed_projects_audit`
--
ALTER TABLE `completed_projects_audit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `freelancer_applications`
--
ALTER TABLE `freelancer_applications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `freelancer_applications_ibfk_3` (`application_status_id`);

--
-- Indexes for table `freelancer_applications_audit`
--
ALTER TABLE `freelancer_applications_audit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `freelancer_application_status`
--
ALTER TABLE `freelancer_application_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `freelancer_connects`
--
ALTER TABLE `freelancer_connects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `freelancer_experiences`
--
ALTER TABLE `freelancer_experiences`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user` (`user_id`);

--
-- Indexes for table `freelancer_merits`
--
ALTER TABLE `freelancer_merits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `freelancer_project_submissions`
--
ALTER TABLE `freelancer_project_submissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `submission_id` (`submission_status_id`),
  ADD KEY `submissiontouser` (`user_id`);

--
-- Indexes for table `freelancer_project_submissions_audit`
--
ALTER TABLE `freelancer_project_submissions_audit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `freelancer_project_submissions_status`
--
ALTER TABLE `freelancer_project_submissions_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `freelancer_skills`
--
ALTER TABLE `freelancer_skills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `skill_id` (`skill_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `applicationtonotification` (`application_id`),
  ADD KEY `projecttonotification` (`project_id`);

--
-- Indexes for table `project_comments`
--
ALTER TABLE `project_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `projecttouser` (`project_id`),
  ADD KEY `commenttouser` (`user_id`);

--
-- Indexes for table `skills`
--
ALTER TABLE `skills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`skill_category_id`);

--
-- Indexes for table `skills_category`
--
ALTER TABLE `skills_category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `top_categories_audit`
--
ALTER TABLE `top_categories_audit`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ResetToken` (`reset_token`),
  ADD UNIQUE KEY `activation_token_hash` (`activation_token`),
  ADD KEY `job_title_id` (`job_title_id`),
  ADD KEY `gender_id` (`gender_id`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `statis_id` (`status_id`);

--
-- Indexes for table `users_gender`
--
ALTER TABLE `users_gender`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_job_titles`
--
ALTER TABLE `users_job_titles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_roles`
--
ALTER TABLE `users_roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_status`
--
ALTER TABLE `users_status`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `client_projects`
--
ALTER TABLE `client_projects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=148;

--
-- AUTO_INCREMENT for table `client_project_audit`
--
ALTER TABLE `client_project_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=156;

--
-- AUTO_INCREMENT for table `client_project_status`
--
ALTER TABLE `client_project_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `completed_projects_audit`
--
ALTER TABLE `completed_projects_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `freelancer_applications`
--
ALTER TABLE `freelancer_applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=143;

--
-- AUTO_INCREMENT for table `freelancer_applications_audit`
--
ALTER TABLE `freelancer_applications_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;

--
-- AUTO_INCREMENT for table `freelancer_application_status`
--
ALTER TABLE `freelancer_application_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `freelancer_connects`
--
ALTER TABLE `freelancer_connects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `freelancer_experiences`
--
ALTER TABLE `freelancer_experiences`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `freelancer_merits`
--
ALTER TABLE `freelancer_merits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `freelancer_project_submissions`
--
ALTER TABLE `freelancer_project_submissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `freelancer_project_submissions_audit`
--
ALTER TABLE `freelancer_project_submissions_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT for table `freelancer_project_submissions_status`
--
ALTER TABLE `freelancer_project_submissions_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `freelancer_skills`
--
ALTER TABLE `freelancer_skills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=305;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=174;

--
-- AUTO_INCREMENT for table `project_comments`
--
ALTER TABLE `project_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `skills`
--
ALTER TABLE `skills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=138;

--
-- AUTO_INCREMENT for table `skills_category`
--
ALTER TABLE `skills_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `top_categories_audit`
--
ALTER TABLE `top_categories_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `users_gender`
--
ALTER TABLE `users_gender`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users_job_titles`
--
ALTER TABLE `users_job_titles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `users_roles`
--
ALTER TABLE `users_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users_status`
--
ALTER TABLE `users_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `client_projects`
--
ALTER TABLE `client_projects`
  ADD CONSTRAINT `client_projects_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `client_projects_ibfk_2` FOREIGN KEY (`project_status_id`) REFERENCES `client_project_status` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `client_projects_ibfk_3` FOREIGN KEY (`project_category_id`) REFERENCES `skills_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `freelancer_applications`
--
ALTER TABLE `freelancer_applications`
  ADD CONSTRAINT `freelancer_applications_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `client_projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `freelancer_applications_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `freelancer_applications_ibfk_3` FOREIGN KEY (`application_status_id`) REFERENCES `freelancer_application_status` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `freelancer_connects`
--
ALTER TABLE `freelancer_connects`
  ADD CONSTRAINT `freelancer_connects_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `freelancer_experiences`
--
ALTER TABLE `freelancer_experiences`
  ADD CONSTRAINT `user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `freelancer_merits`
--
ALTER TABLE `freelancer_merits`
  ADD CONSTRAINT `freelancer_merits_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `freelancer_project_submissions`
--
ALTER TABLE `freelancer_project_submissions`
  ADD CONSTRAINT `project_id` FOREIGN KEY (`project_id`) REFERENCES `client_projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `submission_id` FOREIGN KEY (`submission_status_id`) REFERENCES `freelancer_project_submissions_status` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `submissiontouser` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `freelancer_skills`
--
ALTER TABLE `freelancer_skills`
  ADD CONSTRAINT `skill_id` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `applicationtonotification` FOREIGN KEY (`application_id`) REFERENCES `freelancer_applications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `projecttonotification` FOREIGN KEY (`project_id`) REFERENCES `client_projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `project_comments`
--
ALTER TABLE `project_comments`
  ADD CONSTRAINT `commenttouser` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `projecttouser` FOREIGN KEY (`project_id`) REFERENCES `client_projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `skills`
--
ALTER TABLE `skills`
  ADD CONSTRAINT `category_id` FOREIGN KEY (`skill_category_id`) REFERENCES `skills_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `gender` FOREIGN KEY (`gender_id`) REFERENCES `users_gender` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `job_title_id` FOREIGN KEY (`job_title_id`) REFERENCES `users_job_titles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `role_id` FOREIGN KEY (`role_id`) REFERENCES `users_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `statis_id` FOREIGN KEY (`status_id`) REFERENCES `users_status` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `e_update_status` ON SCHEDULE EVERY 1 DAY STARTS '2024-10-24 14:14:08' ENDS '2025-11-11 14:14:08' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE users
SET deactivation_duration = NULL,
    status_id = '1'
WHERE deactivation_duration IS NOT NULL
  AND deactivation_duration <= NOW()$$

CREATE DEFINER=`root`@`localhost` EVENT `e_delete_rejected_applications` ON SCHEDULE EVERY 1 WEEK STARTS '2024-12-13 15:34:39' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    DELETE FROM freelancer_applications
    WHERE application_status_id = 3;
END$$

CREATE DEFINER=`root`@`localhost` EVENT `e_user_connects_rest` ON SCHEDULE EVERY 1 MONTH STARTS '2024-12-01 23:41:43' ENDS '2026-12-01 23:41:43' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    UPDATE freelancer_connects
    SET connects = 100;
END$$

CREATE DEFINER=`root`@`localhost` EVENT `e_delete_read_notifications` ON SCHEDULE EVERY 1 DAY STARTS '2024-12-01 22:37:44' ENDS '2025-12-01 22:37:44' ON COMPLETION NOT PRESERVE ENABLE DO DELETE FROM notifications
    WHERE is_read = 1$$

CREATE DEFINER=`root`@`localhost` EVENT `e_completed_projects` ON SCHEDULE EVERY 1 MONTH STARTS '2024-12-15 17:33:24' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    INSERT INTO completed_projects_audit (
        project_id,
        user_id,
        project_title,
        project_category_id,
        project_description,
        project_objective,
        project_status_id,
        project_connect_cost,
        project_merit_worth,
        created_at,
        updated_at,
        month_collected
    )
    SELECT 
        id AS project_id,
        user_id,
        project_title,
        project_category_id,
        project_description,
        project_objective,
        project_status_id,
        project_connect_cost,
        project_merit_worth,
        created_at,
        updated_at,
        DATE_FORMAT(NOW(), '%M') AS month_collected 
    FROM client_projects
    WHERE project_status_id = 3;
END$$

CREATE DEFINER=`root`@`localhost` EVENT `e_top_categories` ON SCHEDULE EVERY 1 MONTH STARTS '2024-12-15 17:39:19' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
   
    INSERT INTO top_categories_audit (category_id, frequency, month_collected, created_at)
    SELECT 
        project_category_id AS category_id,
        COUNT(project_category_id) AS frequency,
        DATE_FORMAT(NOW(), '%M') AS month_collected,
        NOW() AS created_at
    FROM client_projects
    GROUP BY project_category_id
    ORDER BY frequency DESC
    LIMIT 10;
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
