<?php
session_start();
require_once '../../../connection.php';

header('Content-Type: application/json');

//profile picture upload and saving to database
try {
    if (!isset($_FILES['profile_picture'])) {
        throw new Exception('No file uploaded');
    }

    $file = $_FILES['profile_picture'];
    $user_id = $_SESSION['user_id'];
    
    $upload_dir = '../uploads/profile_pictures/';
    if (!file_exists($upload_dir)) {
        mkdir($upload_dir, 0777, true);
    }
    
    $filename = uniqid() . '_' . $file['name'];
    $filepath = $upload_dir . $filename;
    
    if (!move_uploaded_file($file['tmp_name'], $filepath)) {
        throw new Exception('Failed to upload file');
    }

    $profile_picture_url = '../../dist/php/uploads/profile_pictures/' . $filename;
    
    $stmt = $mysqli->prepare("CALL sp_update_user_profile_picture(?, ?)");
    $stmt->bind_param("si", $profile_picture_url, $user_id);
    
    if (!$stmt->execute()) {
        throw new Exception('Failed to update database');
    }

    echo json_encode([
        'success' => true,
        'image_url' => $profile_picture_url
    ]);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
