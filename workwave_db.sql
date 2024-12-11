-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 11, 2024 at 02:51 PM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_activate_account` (IN `p_activation_token_hash` VARCHAR(255))   BEGIN
	SELECT * FROM
	users 
	WHERE
	activation_token_hash = p_activation_token_hash;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_projects` (IN `p_user_id` INT(11), IN `p_project_title` VARCHAR(255), IN `p_project_category` VARCHAR(255), IN `p_project_description` TEXT, IN `p_project_status` VARCHAR(50), IN `p_connect_cost` INT(11), IN `p_merit_worth` INT(11))   BEGIN
    INSERT INTO client_projects (
        user_id,
        project_title,
        project_category_id,
        project_description,
        project_status_id,
        project_connect_cost,
        project_merit_worth
    )
    VALUES (
        p_user_id,
        p_project_title,
        p_project_category,
        p_project_description,
        p_project_status,
        p_connect_cost,
        p_merit_worth
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_user_skills` (IN `p_user_id` INT(11), IN `P_skill_id` INT(11))   BEGIN
	INSERT INTO freelancer_skills (user_id, skill_id) VALUES (p_user_id, P_skill_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_refund_connects` (IN `p_project_connect_cost` INT(11), IN `p_user_id` INT(11))   BEGIN
    UPDATE freelancer_connects
    SET connects = connects + p_project_connect_cost
    WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_signup_users` (IN `p_first_name` VARCHAR(50), IN `p_last_name` VARCHAR(50), IN `p_birthdate` DATE, IN `p_gender` VARCHAR(21), IN `p_city` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_password_hash` VARCHAR(255), IN `p_activation_token_hash` VARCHAR(255), IN `p_role` VARCHAR(255))   BEGIN
	IF p_first_name = '' OR p_last_name = '' OR p_birthdate = '' OR p_gender = '' OR p_city = '' OR p_email = '' OR p_password_hash = ''
    THEN
    SELECT 'please fillup all fields' as error_message;
	ELSE
	INSERT INTO users(users.first_name, users.last_name, users.birthdate, users.gender_id, users.city, users.email, users.password_hash, users.activation_token_hash, users.role_id)
	VALUES (p_first_name, p_last_name, p_birthdate, p_gender, p_city, p_email, p_password_hash, p_activation_token_hash, p_role);
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_activation_token` (IN `p_user_id` INT(11))   BEGIN
	UPDATE users
	SET
	activation_token_hash = NULL
	WHERE
	id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_application_status` (IN `p_status` INT(11), IN `p_application_id` INT(11))   BEGIN
    UPDATE freelancer_applications
    SET application_status_id = p_status
    WHERE id = p_application_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_client_projects` (IN `p_project_title` VARCHAR(255), IN `p_project_category` VARCHAR(255), IN `p_project_description` TEXT, IN `p_project_status` VARCHAR(50), IN `p_project_id` INT(11), IN `p_user_id` INT(11), IN `p_connect_cost` INT(11), IN `p_merit_worth` INT(11))   BEGIN
    UPDATE client_projects
    SET 
        project_title = p_project_title,
        project_category_id = p_project_category,
        project_description = p_project_description,
        project_status_id = p_project_status,
        project_connect_cost = p_connect_cost,
        project_merit_worth = p_merit_worth
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_reset_token` (IN `p_reset_token_hash` VARCHAR(255), IN `p_email` VARCHAR(255))   BEGIN
	UPDATE users 
    SET reset_token_hash = p_reset_token_hash,
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
reset_token_hash = NULL 
WHERE id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_user_profile` (IN `p_user_id` INT(11), IN `p_first_name` VARCHAR(255), IN `p_last_name` VARCHAR(255), IN `p_job_title_id` INT(11), IN `p_gender` VARCHAR(255), IN `p_mobile_number` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_city` VARCHAR(255), IN `p_nationality` VARCHAR(255), IN `p_language` VARCHAR(255))   BEGIN
    UPDATE users
    SET 
        first_name = p_first_name,
        last_name = p_last_name,
        job_title_id = p_job_title_id,
        gender_id = p_gender,
        mobile_number = p_mobile_number,
        email = p_email,
        city = p_city,
        nationality = p_nationality,
        language = p_language
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
  `project_status_id` int(11) NOT NULL DEFAULT 1,
  `project_connect_cost` int(11) DEFAULT NULL,
  `project_merit_worth` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client_projects`
--

INSERT INTO `client_projects` (`id`, `user_id`, `project_title`, `project_category_id`, `project_description`, `project_status_id`, `project_connect_cost`, `project_merit_worth`, `created_at`, `updated_at`) VALUES
(25, 31, 'Dev Ops', 1, 'Create something', 2, 10, 25, '2024-12-06 01:25:14', '2024-12-10 13:32:02'),
(26, 31, 'Game Development', 2, 'DSA\nDA\nSD\nAS\nDAS\nDAS\nD\nsad\nasd', 1, 5, 10, '2024-12-06 01:41:09', '2024-12-10 02:54:53'),
(27, 32, 'Jensen Project', 23, 'Testing \n', 3, 10, 10, '2024-12-06 10:59:05', '2024-12-09 14:13:01'),
(28, 31, 'Banana Game', 31, 'Saging to the max', 1, 5, 10, '2024-12-06 11:40:08', '2024-12-09 14:13:05'),
(40, 31, 'Banana', 20, 'adaa', 1, 9, 11, '2024-12-09 23:52:52', '2024-12-10 11:12:23'),
(47, 32, 'test hiring', 21, 'hirrrr', 2, 10, 10, '2024-12-11 10:52:31', '2024-12-11 10:54:29'),
(50, 32, 'Test audit', 15, 'test', 2, 10, 10, '2024-12-11 13:07:20', '2024-12-11 13:50:06'),
(52, 32, 'Capitalize test', 9, 'aaa', 2, 10, 10, '2024-12-11 13:43:47', '2024-12-11 13:49:21');

--
-- Triggers `client_projects`
--
DELIMITER $$
CREATE TRIGGER `tr_after_delete_client_project` AFTER DELETE ON `client_projects` FOR EACH ROW BEGIN
    INSERT INTO client_project_audit (
        project_id, user_id, action_type,
        old_project_title, old_project_category_id,
        old_project_description, old_project_connect_cost, old_project_merit_worth
    )
    VALUES (
        OLD.id, OLD.user_id, 'DELETE',
        OLD.project_title, OLD.project_category_id,
        OLD.project_description, OLD.project_connect_cost, OLD.project_merit_worth
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_after_insert_client_project` AFTER INSERT ON `client_projects` FOR EACH ROW BEGIN
    INSERT INTO client_project_audit (
        project_id, user_id, action_type,
        new_project_title, new_project_category_id, new_project_description,
        new_project_connect_cost, new_project_merit_worth
    )
    VALUES (
        NEW.id, NEW.user_id, 'INSERT',
        NEW.project_title, NEW.project_category_id, NEW.project_description,
        NEW.project_connect_cost, NEW.project_merit_worth
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_after_update_client_project` AFTER UPDATE ON `client_projects` FOR EACH ROW BEGIN
    INSERT INTO client_project_audit (
        project_id, user_id, action_type,
        old_project_title, new_project_title,
        old_project_category_id, new_project_category_id,
        old_project_description, new_project_description,
        old_project_connect_cost, new_project_connect_cost,
        old_project_merit_worth, new_project_merit_worth
    )
    VALUES (
        OLD.id, OLD.user_id, 'UPDATE',
        OLD.project_title, NEW.project_title,
        OLD.project_category_id, NEW.project_category_id,
        OLD.project_description, NEW.project_description,
        OLD.project_connect_cost, NEW.project_connect_cost,
        OLD.project_merit_worth, NEW.project_merit_worth
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_capitalize_project_title_before_insert` BEFORE INSERT ON `client_projects` FOR EACH ROW BEGIN
    SET NEW.project_title = CONCAT(
        UPPER(LEFT(NEW.project_title, 1)),
        LOWER(SUBSTRING(NEW.project_title, 2))
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_capitalize_project_title_before_update` BEFORE UPDATE ON `client_projects` FOR EACH ROW BEGIN
    SET NEW.project_title = CONCAT(
        UPPER(LEFT(NEW.project_title, 1)),
        LOWER(SUBSTRING(NEW.project_title, 2))
    );
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
  `old_project_connect_cost` int(11) DEFAULT NULL,
  `new_project_connect_cost` int(11) DEFAULT NULL,
  `old_project_merit_worth` int(11) DEFAULT NULL,
  `new_project_merit_worth` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client_project_audit`
--

INSERT INTO `client_project_audit` (`id`, `project_id`, `user_id`, `action_type`, `action_timestamp`, `old_project_title`, `new_project_title`, `old_project_category_id`, `new_project_category_id`, `old_project_description`, `new_project_description`, `old_project_connect_cost`, `new_project_connect_cost`, `old_project_merit_worth`, `new_project_merit_worth`) VALUES
(1, 48, 32, 'UPDATE', '2024-12-11 13:06:38', 'try', 'test audit', 30, 30, 'qaa', 'qaa', 10, 10, 10, 10),
(2, 48, 32, 'DELETE', '2024-12-11 13:06:48', 'test audit', NULL, 30, NULL, 'qaa', NULL, 10, NULL, 10, NULL),
(3, 50, 32, 'INSERT', '2024-12-11 13:07:20', NULL, 'test audit', NULL, 15, NULL, 'test', NULL, 10, NULL, 10),
(4, 51, 32, 'INSERT', '2024-12-11 13:29:30', NULL, 'Capitalize', NULL, 15, NULL, 'haha', NULL, 10, NULL, 10),
(5, 51, 32, 'UPDATE', '2024-12-11 13:31:09', 'Capitalize', 'Capitalize', 15, 15, 'haha', 'haha', 10, 10, 10, 10),
(6, 51, 32, 'UPDATE', '2024-12-11 13:31:26', 'Capitalize', 'Capitalize test', 15, 15, 'haha', 'haha', 10, 10, 10, 10),
(7, 51, 32, 'DELETE', '2024-12-11 13:40:45', 'Capitalize test', NULL, 15, NULL, 'haha', NULL, 10, NULL, 10, NULL),
(8, 52, 32, 'INSERT', '2024-12-11 13:43:47', NULL, 'Capitalize test', NULL, 9, NULL, 'aaa', NULL, 10, NULL, 10),
(9, 52, 32, 'UPDATE', '2024-12-11 13:49:21', 'Capitalize test', 'Capitalize test', 9, 9, 'aaa', 'aaa', 10, 10, 10, 10),
(10, 50, 32, 'UPDATE', '2024-12-11 13:50:06', 'test audit', 'Test audit', 15, 15, 'test', 'test', 10, 10, 10, 10);

-- --------------------------------------------------------

--
-- Table structure for table `client_project_status`
--

CREATE TABLE `client_project_status` (
  `id` int(11) NOT NULL,
  `status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client_project_status`
--

INSERT INTO `client_project_status` (`id`, `status`) VALUES
(1, 'Hiring'),
(2, 'In Progress'),
(3, 'Completed');

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
(14, 26, 30, 'sadasdasd\r\nASDAS\r\nDASD', 'https://chatgpt.com/c/6752cf26-842c-800d-b682-1fff3c29335c', 2, '2024-12-06 18:18:32', '2024-12-09 12:13:47', '2024-12-10 03:04:38'),
(15, 25, 30, 'adas\r\nAD\r\nAS\r\nDA\r\n    aaaaaaa', 'https://chatgpt.com/c/6752cf26-842c-800d-b682-1fff3c29335c', 1, '2024-12-06 18:57:35', '2024-12-09 12:13:47', '2024-12-10 12:38:45'),
(16, 25, 35, 'asdas', 'https://github.com/', 2, '2024-12-06 19:31:45', '2024-12-09 12:13:47', '2024-12-10 13:32:02'),
(18, 28, 35, 'fd', '', 1, '2024-12-06 19:41:32', '2024-12-09 12:13:47', '2024-12-10 11:06:34'),
(66, 40, 35, 'bannanananana', 'https://www.merriam-webster.com/dictionary/proposal', 1, '2024-12-11 16:19:46', '2024-12-11 08:19:46', '2024-12-11 08:19:46'),
(78, 47, 35, 'kate apply', 'https://www.merriam-webster.com/dictionary/proposal', 2, '2024-12-11 18:53:28', '2024-12-11 10:53:28', '2024-12-11 10:54:39'),
(79, 47, 37, 'ronald apply', 'https://www.merriam-webster.com/dictionary/proposal', 2, '2024-12-11 18:54:01', '2024-12-11 10:54:01', '2024-12-11 10:54:29'),
(82, 50, 35, 'apply', 'https://www.merriam-webster.com/dictionary/proposal', 2, '2024-12-11 21:49:53', '2024-12-11 13:49:53', '2024-12-11 13:50:06');

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
(1, 30, 20, '2024-12-09 12:13:10', '2024-12-10 11:58:50'),
(4, 35, 11, '2024-12-09 12:13:10', '2024-12-11 13:49:53'),
(5, 37, 70, '2024-12-10 14:26:07', '2024-12-11 10:54:01'),
(7, 39, 100, '2024-12-11 13:21:56', '2024-12-11 13:21:56');

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
(16, 19, 'Bamama', 'ASDaaa', '2003-2321', '2024-12-09 12:12:26', '2024-12-09 12:12:52'),
(17, 19, 'asadasdaa', 'asd', '2003-1212', '2024-12-09 12:12:26', '2024-12-09 12:12:52'),
(25, 19, 'sad', 'asd', '2003-1212', '2024-12-09 12:12:26', '2024-12-09 12:12:52'),
(26, 22, 'Software Developer', 'Internet Org', '2021-2024', '2024-12-09 12:12:26', '2024-12-09 12:12:52'),
(33, 22, 'Taga hugas ng pinggan sa bahay', 'ICOR Inc.', '2012-2024', '2024-12-09 12:12:26', '2024-12-09 12:12:52'),
(35, 22, 'Software Engineer', 'ICOR Inc.aa', '2001-2002', '2024-12-09 12:12:26', '2024-12-09 12:12:52'),
(47, 23, 'Software Engineer', 'ICOR Inc.', '2005-2012', '2024-12-09 12:12:26', '2024-12-09 12:12:52'),
(53, 28, 'test', 'aaa', '2023-2024', '2024-12-09 12:12:26', '2024-12-09 12:12:52'),
(55, 30, 'Software Developer', 'Google', '2020-2021', '2024-12-09 12:12:26', '2024-12-10 09:46:37'),
(56, 33, 'Software Engineer', 'Yahoo', '2020-Present', '2024-12-09 12:12:26', '2024-12-09 12:12:52'),
(57, 35, 'Software Developer', 'Yahoo', '2020-Present', '2024-12-09 12:12:26', '2024-12-09 12:12:52'),
(59, 30, 'dasd', 'sad', '2001-2003', '2024-12-10 11:24:10', '2024-12-10 11:24:10'),
(60, 30, 'das', 'sad', '2020-2022', '2024-12-10 11:56:05', '2024-12-10 11:56:05');

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
(1, 30, 0, '2024-12-09 12:11:05', '2024-12-09 12:11:21'),
(2, 35, 0, '2024-12-09 12:11:05', '2024-12-09 12:11:21'),
(3, 37, 0, '2024-12-10 14:26:07', '2024-12-10 14:26:07'),
(5, 39, 0, '2024-12-11 13:21:56', '2024-12-11 13:21:56');

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
(193, 35, 57, '2024-12-09 12:09:16', '2024-12-09 12:09:48'),
(194, 35, 56, '2024-12-09 12:09:16', '2024-12-09 12:09:48'),
(242, 30, 131, '2024-12-10 11:25:27', '2024-12-10 11:25:27');

-- --------------------------------------------------------

--
-- Table structure for table `skills`
--

CREATE TABLE `skills` (
  `id` int(11) NOT NULL,
  `skill_name` varchar(255) NOT NULL,
  `skill_category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `skills`
--

INSERT INTO `skills` (`id`, `skill_name`, `skill_category_id`) VALUES
(1, 'Content Writing', 1),
(2, 'Copywriting', 1),
(3, 'Technical Writing', 1),
(4, 'Blog Writing', 1),
(5, 'Creative', 1),
(6, 'Multilingual Translation', 2),
(7, 'Subtitling', 2),
(8, 'Transcription', 2),
(9, 'Proofreading', 2),
(10, 'Editing', 2),
(11, 'Logo Design', 3),
(12, 'Branding Design', 3),
(13, 'Infographic Design', 3),
(14, 'Social Media Graphics', 3),
(15, 'Print Design', 3),
(16, 'Video Editing', 4),
(17, 'Motion Graphics', 4),
(18, '2D Animation', 4),
(19, '3D Animation', 4),
(20, 'Explainer Videos', 4),
(21, 'Wireframing', 5),
(22, 'Prototyping', 5),
(23, 'Mobile App Design', 5),
(24, 'Website Design', 5),
(25, 'User Testing', 5),
(26, 'Front-End Development', 6),
(27, 'Back-End Development', 6),
(28, 'Full-Stack Development', 6),
(29, 'CMS Development (WordPress, Joomla)', 6),
(30, 'E-Commerce Development', 6),
(31, 'iOS Development', 7),
(32, 'Android Development', 7),
(33, 'Flutter Development', 7),
(34, 'React Native Development', 7),
(35, 'Game App Development', 7),
(36, 'Python Development', 8),
(37, 'Java Development', 8),
(38, '.NET Development', 8),
(39, 'C++ Development', 8),
(40, 'API Development', 8),
(41, 'Social Media Marketing', 9),
(42, 'SEO (Search Engine Optimization)', 9),
(43, 'Content Marketing', 9),
(44, 'Email Marketing', 9),
(45, 'Affiliate Marketing', 9),
(46, 'Lead Generation', 10),
(47, 'CRM Management', 10),
(48, 'Cold Calling', 10),
(49, 'Sales Funnel Design', 10),
(50, 'Prospect Research', 10),
(51, 'PPC Campaigns', 11),
(52, 'Google Ads', 11),
(53, 'Facebook Ads', 11),
(54, 'LinkedIn Ads', 11),
(55, 'Display Advertising', 11),
(56, 'Email Management', 12),
(57, 'Calendar Management', 12),
(58, 'Travel Booking', 12),
(59, 'Social Media Assistance', 12),
(60, 'File Organization', 12),
(61, 'Typing', 13),
(62, 'Data Cleaning', 13),
(63, 'Online Research', 13),
(64, 'Spreadsheet Management', 13),
(65, 'CRM Data Input', 13),
(66, 'Chat Support', 14),
(67, 'Phone Support', 14),
(68, 'Ticket Management', 14),
(69, 'Complaint Resolution', 14),
(70, 'Technical Support', 14),
(71, 'Bookkeeping', 15),
(72, 'Payroll Management', 15),
(73, 'Financial Analysis', 15),
(74, 'Tax Preparation', 15),
(75, 'Budget Planning', 15),
(76, 'Business Strategy', 16),
(77, 'Market Research', 16),
(78, 'SWOT Analysis', 16),
(79, 'Operations Management', 16),
(80, 'Process Improvement', 16),
(81, 'Recruitment', 17),
(82, 'Onboarding', 17),
(83, 'Employee Training', 17),
(84, 'Performance Reviews', 17),
(85, 'HR Policies', 17),
(86, 'Hardware Troubleshooting', 18),
(87, 'Software Installation', 18),
(88, 'IT Helpdesk Support', 18),
(89, 'Network Setup', 18),
(90, 'Remote Assistance', 18),
(91, 'System Administration', 19),
(92, 'Cloud Computing', 19),
(93, 'VPN Setup', 19),
(94, 'Server Maintenance', 19),
(95, 'Cybersecurity', 19),
(96, 'CI/CD Pipelines', 20),
(97, 'Docker', 20),
(98, 'Kubernetes', 20),
(99, 'Automation Scripting', 20),
(100, 'Infrastructure as Code', 20),
(101, 'Civil Engineering', 21),
(102, 'Mechanical Engineering', 21),
(103, 'Electrical Engineering', 21),
(104, 'Structural Analysis', 21),
(105, 'Robotics Design', 21),
(106, 'Building Design', 22),
(107, 'CAD Drafting', 22),
(108, '3D Modeling', 22),
(109, 'Interior Design', 22),
(110, 'Landscape Architecture', 22),
(111, 'Product Design', 23),
(112, 'CNC Programming', 23),
(113, '3D Printing', 23),
(114, 'Materials Engineering', 23),
(115, 'Prototyping', 23),
(116, 'Life Coaching', 24),
(117, 'Career Counseling', 24),
(118, 'Parenting Advice', 24),
(119, 'Fitness Planning', 25),
(120, 'Nutrition Consulting', 25),
(121, 'Meditation Training', 25),
(122, 'Contract Drafting', 26),
(123, 'Intellectual Property Consulting', 26),
(124, 'Immigration Support', 26),
(125, 'Business Compliance Assistance', 27),
(126, 'Legal Research', 27),
(127, 'Data Cleaning', 28),
(128, 'Data Wrangling', 28),
(129, 'Big Data Analytics', 28),
(130, 'Predictive Analytics', 29),
(131, 'Machine Learning Model Development', 29),
(132, 'Data Visualization', 29),
(133, 'Game Testing', 30),
(134, 'Level Design', 30),
(135, 'Narrative Writing', 30),
(136, 'Game Monetization Strategy', 31),
(137, 'Esports Coaching', 31);

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
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
  `task_id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `task_title` varchar(255) NOT NULL,
  `task_description` text DEFAULT NULL,
  `status` enum('pending','in progress','completed','approved') NOT NULL,
  `assigned_to` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
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
  `role_id` int(11) NOT NULL,
  `profile_picture_url` varchar(255) NOT NULL,
  `job_title_id` int(10) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `reset_token_hash` varchar(255) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL,
  `activation_token_hash` varchar(255) DEFAULT NULL,
  `last_login_date` datetime DEFAULT NULL,
  `attempts` int(1) DEFAULT NULL,
  `deactivation_duration` datetime DEFAULT NULL,
  `status_id` int(11) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `birthdate`, `gender_id`, `city`, `email`, `mobile_number`, `nationality`, `language`, `role_id`, `profile_picture_url`, `job_title_id`, `password_hash`, `reset_token_hash`, `reset_token_expiry`, `activation_token_hash`, `last_login_date`, `attempts`, `deactivation_duration`, `status_id`, `created_at`, `updated_at`) VALUES
(30, 'Freelance Ronald', 'Sullano', '2003-07-14', 1, 'Caloocan, Metro Manila, Philippines', 'ronaldsullano1234@gmail.com', '9515910708', 'Filipino', 'Tagalog', 2, '../../dist/php/uploads/profile_pictures/675246781cbb9_IMG_20230104_162006.png', 3, '$2y$10$Q3m0sXMrqggmcrhuC12vIOF.6X3JBBgrD0P/83W02T67CyUwneq12', NULL, '2024-12-10 20:07:53', NULL, '2024-12-10 22:43:21', NULL, NULL, 1, '2024-12-09 11:44:32', '2024-12-10 14:43:21'),
(31, 'Client Ronald', 'Sullano', '2003-07-14', 1, 'Caloocan, Metro Manila, Philippines', 'ronaldsullano666@gmail.com', '9515910708', 'American', 'Filipino', 1, '../../dist/php/uploads/profile_pictures/67578ddc5763e_vlcsnap-2024-03-24-13h58m13s661.png', 1, '$2y$10$vHM7B/FJH.ob3aWWSVs9Sup1AWms7CAZne0HxsmAiQCbSxfnRjFZi', NULL, NULL, NULL, NULL, NULL, NULL, 1, '2024-12-09 11:44:32', '2024-12-10 11:12:10'),
(32, 'Kate', 'Jensen', '2003-07-10', 2, 'Antipolo, Rizal, Philippines', 'ronaldsullano12345@gmail.com', '9515910702', 'Thai', 'Guaranir', 1, '../../dist/php/uploads/profile_pictures/6752d8cfd48d2_received_364139713153077.jpeg', 3, '$2y$10$sTftvqLPrrJnugSToi/2Ee7qHUqAU26S6RWhgIg5Rvari9KdxdAGa', NULL, NULL, NULL, '2024-12-11 20:27:53', NULL, NULL, 1, '2024-12-09 11:44:32', '2024-12-11 12:27:53'),
(35, 'Freelance Kate', 'Jensen', '2003-07-03', 2, 'Angeles, Pampanga, Philippines', 'ronaldsullano6666@gmail.com', '9515120708', 'Filipino', 'Tagalog', 2, '../../dist/php/uploads/profile_pictures/6752e0aaed0bc_received_364139713153077.jpeg', 1, '$2y$10$I3mN3hppEF20cswF8ty1L.euzn1caw0ZyBSahmbfINVIRaCAChHbe', NULL, NULL, NULL, '2024-12-11 21:49:02', NULL, NULL, 1, '2024-12-09 11:44:32', '2024-12-11 13:49:02'),
(37, 'Ronald', 'Sullano', '2003-06-10', 1, 'Angeles, Pampanga, Philippines', 'ronaldsullano76@gmail.com', '', '', '', 2, '', NULL, '$2y$10$J0HgpBTEQodobO7/uuhzvuLJaNeFuGrhrsQZlAq1ZG2sk4inX2/aW', NULL, NULL, NULL, '2024-12-11 17:47:23', NULL, NULL, 1, '2024-12-10 14:26:07', '2024-12-11 09:47:23'),
(39, 'Pixie', 'Boo', '2003-09-08', 2, 'Angeles, Pampanga, Philippines', 'jensenkajie@gmail.com', '', '', '', 2, '', NULL, '$2y$10$jBRLueeGykPq4DOJjEHMxuNpk2vYQETSCf.rSuzqIgtS8UtM5vow6', NULL, NULL, '$2y$10$zsnZlvGS3BmYVUUXk3WLdu.MQEr6nr0/LIoSJODwxRQ8Z38hOLed6', NULL, NULL, NULL, 1, '2024-12-11 13:21:56', '2024-12-11 13:21:56');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `tr_capitalize_names_before_insert` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    SET NEW.first_name = CONCAT(UPPER(LEFT(NEW.first_name, 1)), LOWER(SUBSTRING(NEW.first_name, 2)));
    SET NEW.last_name = CONCAT(UPPER(LEFT(NEW.last_name, 1)), LOWER(SUBSTRING(NEW.last_name, 2)));
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
-- Stand-in structure for view `v_not_verified_emails`
-- (See below for the actual view)
--
CREATE TABLE `v_not_verified_emails` (
`email` varchar(255)
,`activation_token_hash` varchar(255)
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
-- Stand-in structure for view `v_users_with_reset_tokens`
-- (See below for the actual view)
--
CREATE TABLE `v_users_with_reset_tokens` (
`id` int(11)
,`full_name` varchar(101)
,`reset_token_hash` varchar(255)
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
,`nationality` varchar(255)
,`language` varchar(255)
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

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_all_application`  AS SELECT `freelancer_applications`.`id` AS `id`, `users`.`first_name` AS `first_name`, `users`.`last_name` AS `last_name`, `users`.`email` AS `email`, `users`.`mobile_number` AS `mobile_number`, `users`.`profile_picture_url` AS `profile_picture_url`, `users_job_titles`.`job_title` AS `job_title`, `client_projects`.`user_id` AS `project_owner`, `client_projects`.`project_title` AS `project_title`, `freelancer_applications`.`created_at` AS `application_date`, `freelancer_application_status`.`status` AS `status` FROM ((((`users` join `freelancer_applications` on(`users`.`id` = `freelancer_applications`.`user_id`)) join `client_projects` on(`freelancer_applications`.`project_id` = `client_projects`.`id`)) left join `users_job_titles` on(`users`.`job_title_id` = `users_job_titles`.`id`)) join `freelancer_application_status` on(`freelancer_applications`.`application_status_id` = `freelancer_application_status`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_applications`
--
DROP TABLE IF EXISTS `v_applications`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_applications`  AS SELECT `freelancer_applications`.`id` AS `id`, `freelancer_applications`.`application_details` AS `application_details`, `freelancer_applications`.`portfolio_url` AS `portfolio_url`, `freelancer_application_status`.`status` AS `status`, `freelancer_applications`.`application_date` AS `application_date`, `freelancer_applications`.`created_at` AS `created_at`, `freelancer_applications`.`updated_at` AS `updated_at` FROM (`freelancer_applications` join `freelancer_application_status` on(`freelancer_applications`.`application_status_id` = `freelancer_application_status`.`id`)) ;

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
-- Structure for view `v_not_verified_emails`
--
DROP TABLE IF EXISTS `v_not_verified_emails`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_not_verified_emails`  AS SELECT `users`.`email` AS `email`, `users`.`activation_token_hash` AS `activation_token_hash` FROM `users` WHERE `users`.`activation_token_hash` is not null ;

-- --------------------------------------------------------

--
-- Structure for view `v_project_details`
--
DROP TABLE IF EXISTS `v_project_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_project_details`  AS SELECT `client_projects`.`id` AS `id`, `client_projects`.`user_id` AS `project_owner`, `client_projects`.`project_title` AS `project_title`, `skills_category`.`category_name` AS `project_category`, `client_projects`.`project_description` AS `project_description`, `client_project_status`.`status` AS `project_status`, `client_projects`.`project_connect_cost` AS `project_connect_cost`, `client_projects`.`project_merit_worth` AS `project_merit_worth`, `client_projects`.`created_at` AS `created_at` FROM ((`client_projects` join `skills_category` on(`client_projects`.`project_category_id` = `skills_category`.`id`)) join `client_project_status` on(`client_projects`.`project_status_id` = `client_project_status`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_skills_with_category`
--
DROP TABLE IF EXISTS `v_skills_with_category`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_skills_with_category`  AS SELECT `skills`.`id` AS `id`, `skills`.`skill_name` AS `skill`, `skills_category`.`category_name` AS `category` FROM (`skills` join `skills_category` on(`skills_category`.`id` = `skills`.`skill_category_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_users_with_reset_tokens`
--
DROP TABLE IF EXISTS `v_users_with_reset_tokens`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_users_with_reset_tokens`  AS SELECT `users`.`id` AS `id`, concat(`users`.`first_name`,' ',`users`.`last_name`) AS `full_name`, `users`.`reset_token_hash` AS `reset_token_hash`, `users`.`reset_token_expiry` AS `reset_token_expiry` FROM `users` WHERE `users`.`reset_token_hash` is not null ;

-- --------------------------------------------------------

--
-- Structure for view `v_user_credentials`
--
DROP TABLE IF EXISTS `v_user_credentials`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_user_credentials`  AS SELECT `users`.`id` AS `id`, `users`.`email` AS `email`, `users_roles`.`role` AS `role`, `users`.`password_hash` AS `password_hash` FROM (`users` join `users_roles` on(`users`.`role_id` = `users_roles`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_user_profile`
--
DROP TABLE IF EXISTS `v_user_profile`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_user_profile`  AS SELECT `users`.`id` AS `id`, `users`.`first_name` AS `first_name`, `users`.`last_name` AS `last_name`, `users`.`birthdate` AS `birthdate`, `users_gender`.`gender` AS `gender`, `users`.`city` AS `city`, `users`.`email` AS `email`, `users`.`mobile_number` AS `mobile_number`, `users`.`nationality` AS `nationality`, `users`.`language` AS `language`, `users_job_titles`.`job_title` AS `job_title`, `users`.`profile_picture_url` AS `profile_picture_url` FROM ((`users` join `users_gender` on(`users`.`gender_id` = `users_gender`.`id`)) left join `users_job_titles` on(`users`.`job_title_id` = `users_job_titles`.`id`)) ;

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
-- Indexes for table `freelancer_applications`
--
ALTER TABLE `freelancer_applications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `freelancer_applications_ibfk_3` (`application_status_id`);

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
-- Indexes for table `freelancer_skills`
--
ALTER TABLE `freelancer_skills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `skill_id` (`skill_id`);

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
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`task_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `tasks_ibfk_2` (`assigned_to`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ResetToken` (`reset_token_hash`),
  ADD UNIQUE KEY `activation_token_hash` (`activation_token_hash`),
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `client_project_audit`
--
ALTER TABLE `client_project_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `client_project_status`
--
ALTER TABLE `client_project_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `freelancer_applications`
--
ALTER TABLE `freelancer_applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT for table `freelancer_application_status`
--
ALTER TABLE `freelancer_application_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `freelancer_connects`
--
ALTER TABLE `freelancer_connects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `freelancer_experiences`
--
ALTER TABLE `freelancer_experiences`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `freelancer_merits`
--
ALTER TABLE `freelancer_merits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `freelancer_skills`
--
ALTER TABLE `freelancer_skills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=243;

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
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `task_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

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
-- Constraints for table `freelancer_merits`
--
ALTER TABLE `freelancer_merits`
  ADD CONSTRAINT `freelancer_merits_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `freelancer_skills`
--
ALTER TABLE `freelancer_skills`
  ADD CONSTRAINT `skill_id` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `skills`
--
ALTER TABLE `skills`
  ADD CONSTRAINT `category_id` FOREIGN KEY (`skill_category_id`) REFERENCES `skills_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `client_projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tasks_ibfk_2` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
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

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
