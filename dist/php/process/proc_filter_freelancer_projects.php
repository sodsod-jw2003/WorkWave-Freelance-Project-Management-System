<?php
session_start();
$mysqli = require '../../../connection.php';

$category = $_GET['category'] ?? '';
$sort = $_GET['sort'] ?? '';
$direction = $_GET['direction'] ?? 'ASC';
$search = $_GET['search'] ?? '';

$query = "SELECT v_project_details.*, 
          CONCAT(v_user_profile.first_name, ' ', v_user_profile.last_name) AS client_name 
          FROM v_project_details
          JOIN v_user_profile ON v_project_details.project_owner = v_user_profile.id
          WHERE project_status = 'hiring'";
$params = [];
$types = "";

if (!empty($category)) {
    $query .= " AND project_category = ?";
    $params[] = $category;
    $types .= "s";
}

if (!empty($search)) {
    $query .= " AND (project_title LIKE ? OR project_description LIKE ? OR project_category LIKE ?)";
    $params[] = "%$search%";
    $params[] = "%$search%";
    $params[] = "%$search%";
    $types .= "sss";
}

if (!empty($sort)) {
    switch($sort) {
        case 'title':
            $query .= " ORDER BY project_title " . $direction;
            break;
        case 'date':
            $query .= " ORDER BY created_at " . $direction;
            break;
    }
}

$stmt = $mysqli->prepare($query);
if (!empty($types)) {
    $stmt->bind_param($types, ...$params);
}
$stmt->execute();
$projects = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);

include('../../../misc/freelancer_project_template.php');
