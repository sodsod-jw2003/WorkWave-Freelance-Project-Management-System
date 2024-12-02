<?php
session_start();
$mysqli = require '../../../connection.php';


$query = "CALL sp_get_projects(?)";
$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();

$result = $stmt->get_result();
$projects = $result->fetch_all(MYSQLI_ASSOC);

echo json_encode($projects);


