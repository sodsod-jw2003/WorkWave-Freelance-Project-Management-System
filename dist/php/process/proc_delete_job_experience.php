<?php
session_start();
$mysqli = require '../../../connection.php';

if (isset($_POST['user_experience_id'])) {
    $user_experience_id = $_POST['user_experience_id'];
    $user_id = $_SESSION['user_id'];

    $query = "CALL sp_delete_user_experience(?, ?)";
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param("ii", $user_experience_id, $user_id);
    
    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false]);
    }
}
