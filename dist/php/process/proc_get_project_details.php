<?php
session_start();
$mysqli = require '../../../connection.php';

if (isset($_GET['project_id'])) {
    $query = "CALL sp_get_project_details(?, ?)";
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param("ii", $_GET['project_id'], $_SESSION['user_id']);
    $stmt->execute();
    
    $result = $stmt->get_result();
    $project = $result->fetch_assoc();
    
    echo json_encode($project);
}
