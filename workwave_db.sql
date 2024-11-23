-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 23, 2024 at 11:45 AM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `activate_account` (IN `p_activation_token_hash` VARCHAR(255))   BEGIN
	SELECT * FROM
	users 
	WHERE
	activation_token_hash = p_activation_token_hash;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_by_email` (IN `p_email` VARCHAR(255))   BEGIN
	SELECT * FROM users
    WHERE users.email = p_email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_by_id` (IN `p_user_id` INT(11))   BEGIN
	SELECT * FROM
	users
	WHERE
	user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_by_reset_token_hash` (IN `p_reset_token_hash` VARCHAR(255))   BEGIN
	IF p_reset_token_hash = ''
	THEN
		SELECT 'please fillup all fields' as error_message;
	ELSE
		SELECT * FROM users
		WHERE reset_token_hash = p_reset_token_hash;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `signup_users` (IN `p_first_name` VARCHAR(50), IN `p_last_name` VARCHAR(50), IN `p_birthdate` DATE, IN `p_gender` VARCHAR(21), IN `p_city` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_password_hash` VARCHAR(255), IN `p_activation_token_hash` VARCHAR(255), IN `p_role` VARCHAR(255))   BEGIN
	IF p_first_name = '' OR p_last_name = '' OR p_birthdate = '' OR p_gender = '' OR p_city = '' OR p_email = '' OR p_password_hash = ''
    THEN
    SELECT 'please fillup all fields' as error_message;
	ELSE
	INSERT INTO users(users.first_name, users.last_name, users.birthdate, users.gender, users.city, users.email, users.password_hash, users.activation_token_hash, users.role)
	VALUES (p_first_name, p_last_name, p_birthdate, p_gender, p_city, p_email, p_password_hash, p_activation_token_hash, p_role);
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_activation_token` (IN `p_user_id` INT(11))   BEGIN
	UPDATE users
	SET
	activation_token_hash = NULL
	WHERE
	user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_reset_token` (IN `p_reset_token_hash` VARCHAR(255), IN `p_email` VARCHAR(255))   BEGIN
	UPDATE users 
    SET reset_token_hash = p_reset_token_hash,
		reset_token_expiry = DATE_ADD(NOW(), INTERVAL 30 MINUTE)
    WHERE email = p_email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_profile_picture` (IN `p_profile_picture_url` VARCHAR(255), IN `p_user_id` INT(11))   BEGIN
	UPDATE users 
	SET
		users.profile_picture_url = p_profile_picture_url
	WHERE
		users.user_id = p_user_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `skills`
--

CREATE TABLE `skills` (
  `skill_id` int(11) NOT NULL,
  `skill_name` varchar(255) NOT NULL,
  `skill_category` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `birthdate` date NOT NULL,
  `gender` varchar(21) NOT NULL,
  `city` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `profile_picture_url` varchar(255) NOT NULL,
  `job_title` varchar(255) NOT NULL,
  `bio` varchar(500) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `reset_token_hash` varchar(255) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL,
  `activation_token_hash` varchar(255) DEFAULT NULL,
  `last_login_date` datetime DEFAULT NULL,
  `attempts` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `birthdate`, `gender`, `city`, `email`, `role`, `profile_picture_url`, `job_title`, `bio`, `password_hash`, `reset_token_hash`, `reset_token_expiry`, `activation_token_hash`, `last_login_date`, `attempts`) VALUES
(17, 'Ronald', 'Jensen', '2024-11-01', 'Female', 'Angeles, Pampanga, Philippines', 'ronaldsullano1234@gmail.com', 'Freelancer', '../../dist/php/uploads/profile_pictures/6741aeba86914_IMG_20230104_162006.png', 'Professional Tambay', '', '$2y$10$qLMlJaMQ0vTG1JmjVizsQO0r.lPZisR7chw8WJKPPNaFpct/Utc8K', NULL, '2024-11-22 18:19:39', NULL, NULL, NULL),
(18, 'Kate', 'Jensen', '2024-10-30', 'Male', 'Antipolo, Rizal, Philippines', 'ronaldsullano14@gmail.com', 'Client', '', '', '', '$2y$10$fCUE6zU7pEq127Fv/23u9.7FlL8cLlL6WW9DEkBSSITw1UX3D2SL2', NULL, NULL, NULL, NULL, NULL),
(19, 'Kate', 'Jensen', '2003-09-13', 'Female', 'Caloocan, Metro Manila, Philippines', 'ronaldsullano666@gmail.com', 'Freelancer', '', '', '', '$2y$10$VzA1NGX.l9gXOijcrrVqC.9zEdJLQa3Fkz0.tzaQWaJaa1kAMdupK', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users_experiences`
--

CREATE TABLE `users_experiences` (
  `user_experience_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `job_title` varchar(255) NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `duration` varchar(9) NOT NULL,
  `description` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_skills`
--

CREATE TABLE `users_skills` (
  `user_skills_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `skill_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `user_profile`
-- (See below for the actual view)
--
CREATE TABLE `user_profile` (
`user_id` int(11)
,`first_name` varchar(50)
,`last_name` varchar(50)
,`birthdate` date
,`gender` varchar(21)
,`city` varchar(255)
,`email` varchar(255)
,`profile_picture_url` varchar(255)
,`job_title` varchar(255)
,`bio` varchar(500)
);

-- --------------------------------------------------------

--
-- Structure for view `user_profile`
--
DROP TABLE IF EXISTS `user_profile`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `user_profile`  AS SELECT `users`.`user_id` AS `user_id`, `users`.`first_name` AS `first_name`, `users`.`last_name` AS `last_name`, `users`.`birthdate` AS `birthdate`, `users`.`gender` AS `gender`, `users`.`city` AS `city`, `users`.`email` AS `email`, `users`.`profile_picture_url` AS `profile_picture_url`, `users`.`job_title` AS `job_title`, `users`.`bio` AS `bio` FROM `users` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `skills`
--
ALTER TABLE `skills`
  ADD PRIMARY KEY (`skill_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `ResetToken` (`reset_token_hash`),
  ADD UNIQUE KEY `activation_token_hash` (`activation_token_hash`);

--
-- Indexes for table `users_experiences`
--
ALTER TABLE `users_experiences`
  ADD PRIMARY KEY (`user_experience_id`),
  ADD KEY `user` (`user_id`);

--
-- Indexes for table `users_skills`
--
ALTER TABLE `users_skills`
  ADD PRIMARY KEY (`user_skills_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `skill_id` (`skill_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `skills`
--
ALTER TABLE `skills`
  MODIFY `skill_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `users_experiences`
--
ALTER TABLE `users_experiences`
  MODIFY `user_experience_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_skills`
--
ALTER TABLE `users_skills`
  MODIFY `user_skills_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `users_experiences`
--
ALTER TABLE `users_experiences`
  ADD CONSTRAINT `user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `users_skills`
--
ALTER TABLE `users_skills`
  ADD CONSTRAINT `skill_id` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`skill_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
