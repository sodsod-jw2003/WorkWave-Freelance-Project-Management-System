<?php
session_start();
$mysqli = require '../../../connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_id = $_SESSION['user_id'];
    
    $query = "CALL sp_update_user_profile(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
              
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param("isssssssss", 
        $user_id,
        $_POST['first_name'],
        $_POST['last_name'],
        $_POST['job_title'],
        $_POST['gender'],
        $_POST['mobile_number'],
        $_POST['email'],
        $_POST['city'],
        $_POST['nationality'],
        $_POST['language'],
    );
    
    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false]);
    }
}
