<?php
session_start();
$mysqli = require '../../../connection.php';


$query = "SELECT * FROM v_project_details WHERE project_owner = ? ORDER BY created_at DESC;";
$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();

$result = $stmt->get_result();
$project = $result->fetch_all(MYSQLI_ASSOC);

echo json_encode($project);


