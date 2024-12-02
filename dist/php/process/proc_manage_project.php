<?php
session_start();
$mysqli = require '../../../connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $response = array();

    switch ($_POST['action']) {
        case 'update':
            $query = "CALL sp_update_client_projects(?, ?, ?, ?, ?, ?)";
            
            $stmt = $mysqli->prepare($query);
            $stmt->bind_param("ssssii",
                $_POST['project_title'], 
                $_POST['project_category'],  
                $_POST['project_description'], 
                $_POST['status'],          
                $_POST['project_id'],
                $_SESSION['user_id'], 
            );
            
            $response['success'] = $stmt->execute();
            break;

        case 'delete':
            
            $query = "CALL sp_delete_client_projects(?, ?)";
            $stmt = $mysqli->prepare($query);
            $stmt->bind_param(
                "ii", 
                $_POST['project_id'],   
                $_SESSION['user_id']    
            );
            
            $response['success'] = $stmt->execute();
            break;
    }

    echo json_encode($response);
}
