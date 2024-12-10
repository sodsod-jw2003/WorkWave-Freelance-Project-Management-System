<?php
session_start();
$mysqli = require '../../../connection.php';

// Get filter parameters
$category = $_GET['category'] ?? '';
$sort = $_GET['sort'] ?? '';
$direction = $_GET['direction'] ?? 'ASC';
$search = $_GET['search'] ?? '';

// Base query
$query = "SELECT * FROM v_project_details WHERE project_owner = ?";
$params = [$_SESSION['user_id']];
$types = "i";

// Add category filter
if (!empty($category)) {
    $query .= " AND project_category = ?";
    $params[] = $category;
    $types .= "s";
}

// Add search filter
if (!empty($search)) {
    $query .= " AND (project_title LIKE ? OR project_description LIKE ? OR project_category LIKE ?)";
    $params[] = "%{$search}%";
    $params[] = "%{$search}%";
    $params[] = "%{$search}%";
    $types .= "sss";
}


// Add sorting
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
$stmt->bind_param($types, ...$params);
$stmt->execute();
$projects = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Return projects HTML
include('../../../misc/project_card_template.php');
