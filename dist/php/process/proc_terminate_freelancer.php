<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0);
require_once('../../../connection.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['freelancer_id']) && isset($_POST['project_id'])) {
    $freelancer_id = $_POST['freelancer_id'];
    $project_id = $_POST['project_id'];
    
    $query = "CALL sp_terminate_freelancer(?, ?)";
              
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param("ii", $freelancer_id, $project_id);
    
    $response = ['success' => $stmt->execute()];
    
    echo json_encode($response);
}
