<?php
session_start();
$mysqli = require '../../../connection.php';

if (isset($_GET['project_id'])) {
    $query = "SELECT p.*, sc.id as category_id 
          FROM v_project_details p
          LEFT JOIN v_available_skills_category sc 
          ON p.project_category = sc.skills_category 
          WHERE p.id = ? AND p.project_owner = ?;";
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param("ii", $_GET['project_id'], $_SESSION['user_id']);
    $stmt->execute();
    
    $result = $stmt->get_result();
    $project = $result->fetch_assoc();
    
    echo json_encode($project);
}
