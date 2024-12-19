<?php
error_reporting(0);
header('Content-Type: application/json');

session_start();
$mysqli = require '../../../connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_id = $_SESSION['user_id'];
    
    // Handle 'job_title' to set null if empty
    $job_title = isset($_POST['job_title']) && $_POST['job_title'] !== '' ? $_POST['job_title'] : null;
    
    $query = "CALL sp_update_user_profile(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
              
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param("isssssssss", 
        $user_id,
        $_POST['first_name'],
        $_POST['last_name'],
        $job_title,
        $_POST['gender'],
        $_POST['mobile_number'],
        $_POST['email'],
        $_POST['city'],
        $_POST['language'],
        $_POST['secondlanguage'],

    );
    
    $result = ['success' => false, 'message' => ''];
    
    try {
        if ($stmt->execute()) {
            $result['success'] = true;
            $result['message'] = 'Profile updated successfully';
        } else {
            $result['message'] = 'Database error: ' . $mysqli->error;
        }
    } catch (Exception $e) {
        $result['message'] = 'Error: ' . $e->getMessage();
    }
    
    echo json_encode($result);
    $stmt->close();
    exit;
}
