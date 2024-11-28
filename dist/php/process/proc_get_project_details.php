<?php
session_start();
$mysqli = require '../../../connection.php';

if (isset($_GET['project_id'])) {
    $query = "SELECT * FROM projects WHERE project_id = ? AND user_id = ?";
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param("ii", $_GET['project_id'], $_SESSION['user_id']);
    $stmt->execute();
    
    $result = $stmt->get_result();
    $project = $result->fetch_assoc();
    
    echo json_encode($project);
}
