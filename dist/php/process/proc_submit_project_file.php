<?php
session_start();
require_once '../../../connection.php';

header('Content-Type: application/json');

try {
    if (!isset($_FILES['project_files'])) {
        throw new Exception('No files uploaded');
    }

    $project_id = $_POST['project_id'];
    $user_id = $_SESSION['user_id'];
    $submission_status_id = 2;
    
    $upload_dir = '../uploads/project_files/';
    if (!file_exists($upload_dir)) {
        mkdir($upload_dir, 0777, true);
    }
    
    $uploaded_files = [];
    foreach($_FILES['project_files']['tmp_name'] as $key => $tmp_name) {
        $filename = uniqid() . '_' . $_FILES['project_files']['name'][$key];
        $filepath = $upload_dir . $filename;
        
        if (move_uploaded_file($tmp_name, $filepath)) {
            $file_url = '../../dist/php/uploads/project_files/' . $filename;
            
            $query = "CALL sp_submit_project_file(?, ?, ?, ?)";
            $stmt = $mysqli->prepare($query);
            $stmt->bind_param("siii", $file_url, $submission_status_id, $project_id, $user_id);
            $stmt->execute();
            
            $uploaded_files[] = $file_url;
        }
    }

    echo json_encode([
        'success' => true,
        'files' => $uploaded_files
    ]);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
