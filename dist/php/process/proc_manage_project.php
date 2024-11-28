<?php
session_start();
$mysqli = require '../../../connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $response = array();
    
    switch($_POST['action']) {
        case 'update':
            $query = "UPDATE projects 
                     SET project_title = ?, 
                         project_category = ?, 
                         project_description = ?, 
                         project_status = ? 
                     WHERE project_id = ? AND user_id = ?";
            
            $stmt = $mysqli->prepare($query);
            $stmt->bind_param("ssssii", 
                $_POST['project_title'],
                $_POST['project_category'],
                $_POST['project_description'],
                $_POST['status'],
                $_POST['project_id'],
                $_SESSION['user_id']
            );
            
            $response['success'] = $stmt->execute();
            break;
            
        case 'delete':
            $query = "DELETE FROM projects WHERE project_id = ? AND user_id = ?";
            $stmt = $mysqli->prepare($query);
            $stmt->bind_param("ii", $_POST['project_id'], $_SESSION['user_id']);
            $response['success'] = $stmt->execute();
            break;
    }
    
    echo json_encode($response);
}
