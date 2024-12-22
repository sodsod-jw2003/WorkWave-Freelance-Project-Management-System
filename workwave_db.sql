-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 22, 2024 at 11:10 AM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_terminate_freelancer` (IN `p_user_id` INT(11), IN `p_project_id` INT(11))   UPDATE freelancer_applications 
              SET application_status_id = 3 
              WHERE user_id = p_user_id 
              AND project_id = p_user_id$$

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
(80, 44, 'Testing Project', 21, 'Testing', 'Testing', 2, 10, 10, '2024-12-19 04:30:41', '2024-12-19 04:31:20'),
(81, 44, 'Testing Project 2', 3, 'Testing 2', 'Testing 2', 2, 10, 10, '2024-12-19 04:36:48', '2024-12-19 04:37:10');

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
(1, 69, 44, 'INSERT', '2024-12-15 14:53:57', NULL, 'Networking Sample Project', NULL, 19, NULL, 'This project focuses on designing and implementing a robust and scalable networking solution for a growing organization. The goal is to develop a network infrastructure that ensures seamless communication between different departments, secure data transmission, and high availability. The project will involve configuring routers, switches, and firewalls, as well as establishing a reliable wireless network. Security protocols, network monitoring, and troubleshooting mechanisms will also be key components. The ultimate aim is to optimize the network performance while reducing downtime and ensuring data security.', NULL, 'Network Performance Metrics: A report on bandwidth usage, latency, and other performance indicators.', NULL, 10, NULL, 10),
(2, 69, 44, 'UPDATE', '2024-12-15 14:59:32', 'Networking Sample Project', 'Networking Sample Project', 19, 19, 'This project focuses on designing and implementing a robust and scalable networking solution for a growing organization. The goal is to develop a network infrastructure that ensures seamless communication between different departments, secure data transmission, and high availability. The project will involve configuring routers, switches, and firewalls, as well as establishing a reliable wireless network. Security protocols, network monitoring, and troubleshooting mechanisms will also be key components. The ultimate aim is to optimize the network performance while reducing downtime and ensuring data security.', 'This project focuses on designing and implementing a robust and scalable networking solution for a growing organization. The goal is to develop a network infrastructure that ensures seamless communication between different departments, secure data transmission, and high availability. The project will involve configuring routers, switches, and firewalls, as well as establishing a reliable wireless network. Security protocols, network monitoring, and troubleshooting mechanisms will also be key components. The ultimate aim is to optimize the network performance while reducing downtime and ensuring data security.', 'Network Performance Metrics: A report on bandwidth usage, latency, and other performance indicators.', 'Network Performance Metrics: A report on bandwidth usage, latency, and other performance indicators.', 10, 10, 10, 10),
(3, 70, 44, 'INSERT', '2024-12-15 15:54:03', NULL, 'Project Alpha', NULL, 15, NULL, 'Test Description', NULL, 'Test Objective', NULL, 10, NULL, 10),
(4, 70, 44, 'DELETE', '2024-12-15 15:56:10', 'Project Alpha', NULL, 15, NULL, 'Test Description', NULL, 'Test Objective', NULL, 10, NULL, 10, NULL),
(5, 71, 44, 'INSERT', '2024-12-15 16:00:23', NULL, 'Project Alpha', NULL, 29, NULL, 'Test Description', NULL, 'Test Objective', NULL, 10, NULL, 10),
(6, 71, 44, 'UPDATE', '2024-12-15 16:01:05', 'Project Alpha', 'Project Alpha', 29, 29, 'Test Description', 'Test Description', 'Test Objective', 'Test Objective', 10, 10, 10, 10),
(7, 72, 44, 'INSERT', '2024-12-15 19:05:02', NULL, 'Project Arki', NULL, 22, NULL, 'Test', NULL, 'Test', NULL, 10, NULL, 10),
(8, 73, 44, 'INSERT', '2024-12-15 19:05:20', NULL, 'Cs Data ', NULL, 14, NULL, 'Test', NULL, 'Test', NULL, 10, NULL, 10),
(9, 74, 44, 'INSERT', '2024-12-15 19:05:38', NULL, 'Project Beta', NULL, 22, NULL, 'Test', NULL, 'Test', NULL, 10, NULL, 10),
(10, 75, 44, 'INSERT', '2024-12-15 19:06:06', NULL, 'Project Build-er', NULL, 22, NULL, 'Test', NULL, 'Test', NULL, 10, NULL, 10),
(11, 76, 44, 'INSERT', '2024-12-15 19:06:30', NULL, 'Sc Project', NULL, 14, NULL, 'Test', NULL, 'Test', NULL, 10, NULL, 10),
(12, 77, 44, 'INSERT', '2024-12-19 03:14:09', NULL, 'Dasd', NULL, 11, NULL, 'sad', NULL, 'asd', NULL, 10, NULL, 10),
(13, 78, 44, 'INSERT', '2024-12-19 03:14:18', NULL, 'Asdas', NULL, 15, NULL, 'dasdas', NULL, 'dasdasdas', NULL, 10, NULL, 10),
(14, 78, 44, 'UPDATE', '2024-12-19 03:14:24', 'Asdas', 'Asdas', 15, 15, 'dasdas', 'dasdas', 'dasdasdas', 'dasdasdas', 10, 10, 10, 10),
(15, 79, 44, 'INSERT', '2024-12-19 03:18:06', NULL, 'Banana Bread', NULL, 29, NULL, 'asdsa', NULL, 'asda', NULL, 10, NULL, 10),
(16, 79, 44, 'UPDATE', '2024-12-19 03:18:57', 'Banana Bread', 'Banana Bread', 29, 29, 'asdsa', 'asdsa', 'asda', 'asda', 10, 10, 10, 10),
(17, 71, 44, 'UPDATE', '2024-12-19 04:16:06', 'Project Alpha', 'Project Alpha', 29, 29, 'Test Description', 'Test Description', 'Test Objective', 'Test Objective', 10, 10, 10, 10),
(18, 73, 44, 'UPDATE', '2024-12-19 04:19:11', 'Cs Data ', 'Cs Data ', 14, 14, 'Test', 'Test', 'Test', 'Test', 10, 10, 10, 10),
(19, 73, 44, 'UPDATE', '2024-12-19 04:21:56', 'Cs Data ', 'Cs Data ', 14, 14, 'Test', 'Test', 'Test', 'Test', 10, 10, 10, 10),
(20, 69, 44, 'UPDATE', '2024-12-19 04:24:22', 'Networking Sample Project', 'Networking Sample Project', 19, 19, 'This project focuses on designing and implementing a robust and scalable networking solution for a growing organization. The goal is to develop a network infrastructure that ensures seamless communication between different departments, secure data transmission, and high availability. The project will involve configuring routers, switches, and firewalls, as well as establishing a reliable wireless network. Security protocols, network monitoring, and troubleshooting mechanisms will also be key components. The ultimate aim is to optimize the network performance while reducing downtime and ensuring data security.', 'This project focuses on designing and implementing a robust and scalable networking solution for a growing organization. The goal is to develop a network infrastructure that ensures seamless communication between different departments, secure data transmission, and high availability. The project will involve configuring routers, switches, and firewalls, as well as establishing a reliable wireless network. Security protocols, network monitoring, and troubleshooting mechanisms will also be key components. The ultimate aim is to optimize the network performance while reducing downtime and ensuring data security.', 'Network Performance Metrics: A report on bandwidth usage, latency, and other performance indicators.', 'Network Performance Metrics: A report on bandwidth usage, latency, and other performance indicators.', 10, 10, 10, 10),
(21, 79, 44, 'DELETE', '2024-12-19 04:29:55', 'Banana Bread', NULL, 29, NULL, 'asdsa', NULL, 'asda', NULL, 10, NULL, 10, NULL),
(22, 78, 44, 'DELETE', '2024-12-19 04:29:56', 'Asdas', NULL, 15, NULL, 'dasdas', NULL, 'dasdasdas', NULL, 10, NULL, 10, NULL),
(23, 77, 44, 'DELETE', '2024-12-19 04:29:58', 'Dasd', NULL, 11, NULL, 'sad', NULL, 'asd', NULL, 10, NULL, 10, NULL),
(24, 76, 44, 'DELETE', '2024-12-19 04:30:00', 'Sc Project', NULL, 14, NULL, 'Test', NULL, 'Test', NULL, 10, NULL, 10, NULL),
(25, 75, 44, 'DELETE', '2024-12-19 04:30:01', 'Project Build-er', NULL, 22, NULL, 'Test', NULL, 'Test', NULL, 10, NULL, 10, NULL),
(26, 74, 44, 'DELETE', '2024-12-19 04:30:03', 'Project Beta', NULL, 22, NULL, 'Test', NULL, 'Test', NULL, 10, NULL, 10, NULL),
(27, 73, 44, 'DELETE', '2024-12-19 04:30:05', 'Cs Data ', NULL, 14, NULL, 'Test', NULL, 'Test', NULL, 10, NULL, 10, NULL),
(28, 72, 44, 'DELETE', '2024-12-19 04:30:07', 'Project Arki', NULL, 22, NULL, 'Test', NULL, 'Test', NULL, 10, NULL, 10, NULL),
(29, 71, 44, 'DELETE', '2024-12-19 04:30:08', 'Project Alpha', NULL, 29, NULL, 'Test Description', NULL, 'Test Objective', NULL, 10, NULL, 10, NULL),
(30, 69, 44, 'DELETE', '2024-12-19 04:30:12', 'Networking Sample Project', NULL, 19, NULL, 'This project focuses on designing and implementing a robust and scalable networking solution for a growing organization. The goal is to develop a network infrastructure that ensures seamless communication between different departments, secure data transmission, and high availability. The project will involve configuring routers, switches, and firewalls, as well as establishing a reliable wireless network. Security protocols, network monitoring, and troubleshooting mechanisms will also be key components. The ultimate aim is to optimize the network performance while reducing downtime and ensuring data security.', NULL, 'Network Performance Metrics: A report on bandwidth usage, latency, and other performance indicators.', NULL, 10, NULL, 10, NULL),
(31, 80, 44, 'INSERT', '2024-12-19 04:30:41', NULL, 'Testing Project', NULL, 21, NULL, 'Testing', NULL, 'Testing', NULL, 10, NULL, 10),
(32, 80, 44, 'UPDATE', '2024-12-19 04:31:20', 'Testing Project', 'Testing Project', 21, 21, 'Testing', 'Testing', 'Testing', 'Testing', 10, 10, 10, 10),
(33, 81, 44, 'INSERT', '2024-12-19 04:36:48', NULL, 'Testing Project 2', NULL, 3, NULL, 'Testing 2', NULL, 'Testing 2', NULL, 10, NULL, 10),
(34, 81, 44, 'UPDATE', '2024-12-19 04:37:10', 'Testing Project 2', 'Testing Project 2', 3, 3, 'Testing 2', 'Testing 2', 'Testing 2', 'Testing 2', 10, 10, 10, 10);

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
(1, 'Hiring', '2024-12-15 14:45:07', '2024-12-15 14:45:25'),
(2, 'In Progress', '2024-12-15 14:45:07', '2024-12-15 14:45:25'),
(3, 'Completed', '2024-12-15 14:45:07', '2024-12-15 14:45:25');

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
(104, 80, 45, 'Testing Application', '', 2, '2024-12-19 12:31:11', '2024-12-19 04:31:11', '2024-12-19 04:31:20'),
(105, 81, 45, 'Testing 2', '', 2, '2024-12-19 12:37:03', '2024-12-19 04:37:03', '2024-12-19 04:37:10');

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
(1, 99, 69, 45, 'INSERT', '2024-12-15 14:57:30', NULL, 'I want to apply for this job', NULL, 'http://localhost/WorkWave/pages/freelancer/project_application.php?id=69', NULL, 1, NULL, '2024-12-15 22:57:30'),
(2, 99, 69, 45, 'UPDATE', '2024-12-15 14:59:32', 'I want to apply for this job', 'I want to apply for this job', 'http://localhost/WorkWave/pages/freelancer/project_application.php?id=69', 'http://localhost/WorkWave/pages/freelancer/project_application.php?id=69', 1, 2, '2024-12-15 22:57:30', '2024-12-15 22:57:30'),
(3, 100, 71, 45, 'INSERT', '2024-12-15 16:00:44', NULL, 'Test Proposal', NULL, 'https://www.google.com/', NULL, 1, NULL, '2024-12-16 00:00:44'),
(4, 100, 71, 45, 'UPDATE', '2024-12-15 16:01:05', 'Test Proposal', 'Test Proposal', 'https://www.google.com/', 'https://www.google.com/', 1, 2, '2024-12-16 00:00:44', '2024-12-16 00:00:44'),
(5, 101, 77, 45, 'INSERT', '2024-12-19 03:23:41', NULL, 'asda', NULL, 'http://localhost/WorkWave/pages/freelancer/project_application.php?id=77', NULL, 1, NULL, '2024-12-19 11:23:41'),
(6, 102, 76, 45, 'INSERT', '2024-12-19 04:17:05', NULL, 'asdas', NULL, 'http://localhost/WorkWave/pages/freelancer/project_application.php?id=40', NULL, 1, NULL, '2024-12-19 12:17:05'),
(7, 103, 73, 45, 'INSERT', '2024-12-19 04:18:35', NULL, 'dasdas', NULL, '', NULL, 1, NULL, '2024-12-19 12:18:35'),
(8, 103, 73, 45, 'UPDATE', '2024-12-19 04:19:11', 'dasdas', 'dasdas', '', '', 1, 2, '2024-12-19 12:18:35', '2024-12-19 12:18:35'),
(9, 104, 80, 45, 'INSERT', '2024-12-19 04:31:11', NULL, 'Testing Application', NULL, '', NULL, 1, NULL, '2024-12-19 12:31:11'),
(10, 104, 80, 45, 'UPDATE', '2024-12-19 04:31:20', 'Testing Application', 'Testing Application', '', '', 1, 2, '2024-12-19 12:31:11', '2024-12-19 12:31:11'),
(11, 105, 81, 45, 'INSERT', '2024-12-19 04:37:03', NULL, 'Testing 2', NULL, '', NULL, 1, NULL, '2024-12-19 12:37:03'),
(12, 105, 81, 45, 'UPDATE', '2024-12-19 04:37:10', 'Testing 2', 'Testing 2', '', '', 1, 2, '2024-12-19 12:37:03', '2024-12-19 12:37:03');

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
(1, 'pending', '2024-12-09 13:41:39', '2024-12-09 13:41:39'),
(2, 'accepted', '2024-12-09 13:41:39', '2024-12-11 10:46:43'),
(3, 'rejected', '2024-12-09 13:41:39', '2024-12-09 13:41:39');

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
(10, 45, 30, '2024-12-15 14:54:46', '2024-12-19 04:37:03'),
(11, 46, 100, '2024-12-15 21:23:38', '2024-12-15 21:23:38');

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
(1, 45, 'Software Developer', 'Apple Inc.', '2019-2024', '2024-12-15 14:56:49', '2024-12-15 14:56:49');

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
(9, 45, 30, '2024-12-15 14:54:46', '2024-12-19 04:24:22'),
(10, 46, 0, '2024-12-15 21:23:38', '2024-12-15 21:23:38');

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
(38, 80, 45, '../../dist/php/uploads/project_files/6763a261736bb_screen1.PNG', 2, '2024-12-19 04:31:20', '2024-12-19 04:34:41'),
(39, 81, 45, '../../dist/php/uploads/project_files/6763a30b939f0_Capture1.PNG', 2, '2024-12-19 04:37:10', '2024-12-19 04:37:31');

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
(1, 35, 69, 45, 'INSERT', '2024-12-15 14:59:32', NULL, NULL, NULL, 1, NULL, '2024-12-15 14:59:32', NULL, '2024-12-15 14:59:32'),
(2, 35, 69, 45, 'UPDATE', '2024-12-15 15:17:25', NULL, '../../dist/php/uploads/project_files/675ef3058cffd_unnamed (1) (1).png', 1, 2, NULL, NULL, '2024-12-15 14:59:32', '2024-12-15 15:17:25'),
(3, 36, 71, 45, 'INSERT', '2024-12-15 16:01:05', NULL, NULL, NULL, 1, NULL, '2024-12-15 16:01:05', NULL, '2024-12-15 16:01:05'),
(4, 36, 71, 45, 'UPDATE', '2024-12-15 16:01:29', NULL, '../../dist/php/uploads/project_files/675efd5943da7_675ef3058cffd_unnamed (1) (1).png', 1, 2, NULL, NULL, '2024-12-15 16:01:05', '2024-12-15 16:01:29'),
(5, 36, 71, 45, 'UPDATE', '2024-12-15 16:01:55', '../../dist/php/uploads/project_files/675efd5943da7_675ef3058cffd_unnamed (1) (1).png', '../../dist/php/uploads/project_files/675efd5943da7_675ef3058cffd_unnamed (1) (1).png', 2, 4, NULL, NULL, '2024-12-15 16:01:29', '2024-12-15 16:01:55'),
(6, 36, 71, 45, 'UPDATE', '2024-12-19 04:13:43', '../../dist/php/uploads/project_files/675efd5943da7_675ef3058cffd_unnamed (1) (1).png', '../../dist/php/uploads/project_files/67639d77b6675_152-Article Text-793-1-10-20231220.pdf', 4, 2, NULL, NULL, '2024-12-15 16:01:55', '2024-12-19 04:13:43'),
(7, 36, 71, 45, 'UPDATE', '2024-12-19 04:16:06', '../../dist/php/uploads/project_files/67639d77b6675_152-Article Text-793-1-10-20231220.pdf', '../../dist/php/uploads/project_files/67639d77b6675_152-Article Text-793-1-10-20231220.pdf', 2, 3, NULL, NULL, '2024-12-19 04:13:43', '2024-12-19 04:16:06'),
(8, 37, 73, 45, 'INSERT', '2024-12-19 04:19:11', NULL, NULL, NULL, 1, NULL, '2024-12-19 04:19:11', NULL, '2024-12-19 04:19:11'),
(9, 37, 73, 45, 'UPDATE', '2024-12-19 04:19:57', NULL, '../../dist/php/uploads/project_files/67639eedbd980_675ea5b85f9f6___PG_M.A._Socialogy.pdf', 1, 2, NULL, NULL, '2024-12-19 04:19:11', '2024-12-19 04:19:57'),
(10, 37, 73, 45, 'UPDATE', '2024-12-19 04:20:35', '../../dist/php/uploads/project_files/67639eedbd980_675ea5b85f9f6___PG_M.A._Socialogy.pdf', '../../dist/php/uploads/project_files/67639eedbd980_675ea5b85f9f6___PG_M.A._Socialogy.pdf', 2, 4, NULL, NULL, '2024-12-19 04:19:57', '2024-12-19 04:20:35'),
(11, 37, 73, 45, 'UPDATE', '2024-12-19 04:21:27', '../../dist/php/uploads/project_files/67639eedbd980_675ea5b85f9f6___PG_M.A._Socialogy.pdf', '../../dist/php/uploads/project_files/67639f472a424_Capture1.PNG', 4, 2, NULL, NULL, '2024-12-19 04:20:35', '2024-12-19 04:21:27'),
(12, 37, 73, 45, 'UPDATE', '2024-12-19 04:21:56', '../../dist/php/uploads/project_files/67639f472a424_Capture1.PNG', '../../dist/php/uploads/project_files/67639f472a424_Capture1.PNG', 2, 3, NULL, NULL, '2024-12-19 04:21:27', '2024-12-19 04:21:56'),
(13, 35, 69, 45, 'UPDATE', '2024-12-19 04:24:02', '../../dist/php/uploads/project_files/675ef3058cffd_unnamed (1) (1).png', '../../dist/php/uploads/project_files/675ef3058cffd_unnamed (1) (1).png', 2, 4, NULL, NULL, '2024-12-15 15:17:25', '2024-12-19 04:24:02'),
(14, 35, 69, 45, 'UPDATE', '2024-12-19 04:24:15', '../../dist/php/uploads/project_files/675ef3058cffd_unnamed (1) (1).png', '../../dist/php/uploads/project_files/67639fef01544_vlcsnap-2024-03-24-13h58m13s661.png', 4, 2, NULL, NULL, '2024-12-19 04:24:02', '2024-12-19 04:24:15'),
(15, 35, 69, 45, 'UPDATE', '2024-12-19 04:24:22', '../../dist/php/uploads/project_files/67639fef01544_vlcsnap-2024-03-24-13h58m13s661.png', '../../dist/php/uploads/project_files/67639fef01544_vlcsnap-2024-03-24-13h58m13s661.png', 2, 3, NULL, NULL, '2024-12-19 04:24:15', '2024-12-19 04:24:22'),
(16, 38, 80, 45, 'INSERT', '2024-12-19 04:31:20', NULL, NULL, NULL, 1, NULL, '2024-12-19 04:31:20', NULL, '2024-12-19 04:31:20'),
(17, 38, 80, 45, 'UPDATE', '2024-12-19 04:32:03', NULL, '../../dist/php/uploads/project_files/6763a1c3e684e_Capture1.PNG', 1, 2, NULL, NULL, '2024-12-19 04:31:20', '2024-12-19 04:32:03'),
(18, 38, 80, 45, 'UPDATE', '2024-12-19 04:34:32', '../../dist/php/uploads/project_files/6763a1c3e684e_Capture1.PNG', '../../dist/php/uploads/project_files/6763a1c3e684e_Capture1.PNG', 2, 4, NULL, NULL, '2024-12-19 04:32:03', '2024-12-19 04:34:32'),
(19, 38, 80, 45, 'UPDATE', '2024-12-19 04:34:41', '../../dist/php/uploads/project_files/6763a1c3e684e_Capture1.PNG', '../../dist/php/uploads/project_files/6763a261736bb_screen1.PNG', 4, 2, NULL, NULL, '2024-12-19 04:34:32', '2024-12-19 04:34:41'),
(20, 39, 81, 45, 'INSERT', '2024-12-19 04:37:10', NULL, NULL, NULL, 1, NULL, '2024-12-19 04:37:10', NULL, '2024-12-19 04:37:10'),
(21, 39, 81, 45, 'UPDATE', '2024-12-19 04:37:31', NULL, '../../dist/php/uploads/project_files/6763a30b939f0_Capture1.PNG', 1, 2, NULL, NULL, '2024-12-19 04:37:10', '2024-12-19 04:37:31');

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
(1, 'pending', '2024-12-14 06:05:20', '2024-12-14 06:05:20'),
(2, 'for review', '2024-12-14 06:05:20', '2024-12-14 06:05:52'),
(3, 'accepted', '2024-12-14 06:05:20', '2024-12-14 06:05:20'),
(4, 'rejected', '2024-12-14 06:05:20', '2024-12-14 06:05:20');

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
(258, 46, 132, '2024-12-15 21:25:31', '2024-12-15 21:25:31'),
(259, 46, 131, '2024-12-15 21:25:31', '2024-12-15 21:25:31'),
(277, 45, 132, '2024-12-19 04:45:26', '2024-12-19 04:45:26'),
(278, 45, 131, '2024-12-19 04:45:26', '2024-12-19 04:45:26'),
(279, 45, 71, '2024-12-19 04:45:26', '2024-12-19 04:45:26'),
(280, 45, 75, '2024-12-19 04:45:26', '2024-12-19 04:45:26'),
(281, 45, 73, '2024-12-19 04:45:26', '2024-12-19 04:45:26');

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
(71, NULL, 81, 45, 1, 'Your application for Testing Project 2 has been accepted.', 0, '2024-12-19 04:37:10', '2024-12-19 04:37:10');

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
(44, 'Client Ronald', 'Sullano', '2003-07-14', 1, 'Caloocan, Metro Manila, Philippines', 'ronaldsullano1234@gmail.com', '9515910701', 'Filipino', 'English', 'Filipino', 1, '../../dist/php/uploads/profile_pictures/675eef1b9bf16_nTGMV1Eo_400x400.jpg', 1, '$2y$10$VICcznSY.2YbbFpYtOk8GOa7uXD3iwt92qDf300dZHcNAw70hDwjy', 153988, '2024-12-19 14:42:54', NULL, '2024-12-19 14:14:56', NULL, 1, '2024-12-15 14:50:44', '2024-12-19 06:14:56'),
(45, 'Freelancer Ronald', 'Sullano', '2003-07-14', 1, 'Caloocan, Metro Manila, Philippines', 'ronaldsullano666@gmail.com', '9515910708', 'Filipino', 'Filipino', 'English', 2, '../../dist/php/uploads/profile_pictures/675eee2120b97_IMG_20230104_162006.png', 1, '$2y$10$8Gy0CYySzXp9yzRYKjCRw.oTEO3FT4qJzDUcaqtuxzFybJSs.IEk6', NULL, NULL, NULL, '2024-12-19 14:32:34', NULL, 1, '2024-12-15 14:54:46', '2024-12-19 06:32:34'),
(46, 'Jireh', 'Sodsod', '2003-09-07', 1, 'Caloocan, Metro Manila, Philippines', 'sodsodwalter@gmail.com', '', '', '', '', 2, '../../dist/php/uploads/profile_pictures/675f493d32b76_675ef3058cffd_unnamed (1) (1).png', NULL, '$2y$10$gCnpb4UUW1FyGepKrYUeP.6J7G2cGya.X/CNOS74OxhloUMEJZYcO', 4551, '2024-12-16 07:13:23', NULL, '2024-12-16 05:24:27', NULL, 1, '2024-12-15 21:23:38', '2024-12-15 22:43:23');

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
(3, 'Database Administrator', '2024-12-09 12:07:31', '2024-12-09 12:07:44');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `client_project_audit`
--
ALTER TABLE `client_project_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT for table `freelancer_applications_audit`
--
ALTER TABLE `freelancer_applications_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `freelancer_application_status`
--
ALTER TABLE `freelancer_application_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `freelancer_connects`
--
ALTER TABLE `freelancer_connects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `freelancer_experiences`
--
ALTER TABLE `freelancer_experiences`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `freelancer_merits`
--
ALTER TABLE `freelancer_merits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `freelancer_project_submissions`
--
ALTER TABLE `freelancer_project_submissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `freelancer_project_submissions_audit`
--
ALTER TABLE `freelancer_project_submissions_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `freelancer_project_submissions_status`
--
ALTER TABLE `freelancer_project_submissions_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `freelancer_skills`
--
ALTER TABLE `freelancer_skills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=282;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `users_gender`
--
ALTER TABLE `users_gender`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users_job_titles`
--
ALTER TABLE `users_job_titles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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

CREATE DEFINER=`root`@`localhost` EVENT `e_delete_read_notifications` ON SCHEDULE EVERY 1 DAY STARTS '2024-12-01 22:37:44' ENDS '2025-12-01 22:37:44' ON COMPLETION NOT PRESERVE ENABLE DO DELETE FROM notifications
    WHERE is_read = 1$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
