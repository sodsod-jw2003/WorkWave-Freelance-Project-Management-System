<?php
require_once('../../../connection.php');

$data = json_decode(file_get_contents('php://input'), true);
$search = '%' . $data['search'] . '%';

$query = "SELECT id, first_name, last_name, job_title, profile_picture_url 
          FROM v_freelancers
          WHERE first_name LIKE ? 
          OR last_name LIKE ? 
          OR email LIKE ? 
          OR mobile_number LIKE ?
          OR job_title LIKE ?
          LIMIT 5";

$stmt = $mysqli->prepare($query);
$stmt->bind_param("sssss", $search, $search, $search, $search, $search);
$stmt->execute();
$result = $stmt->get_result();

$freelancers = [];
while ($row = $result->fetch_assoc()) {
    $freelancers[] = $row;
}

header('Content-Type: application/json');
echo json_encode($freelancers);
