<?php
session_start();
$mysqli = require '../../../connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_id = $_SESSION['user_id'];
    $password = password_hash($_POST['change_password'], PASSWORD_DEFAULT);
    
    $query = "CALL sp_update_user_password(?, ?)";
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param("si", $password, $user_id);
    
    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Failed to update password'
        ]);
    }
}
