<?php
session_start();
$mysqli = require '../../../connection.php';

$user_id = $_SESSION['user_id'];

//get user's skills with categories
$query = "CALL sp_get_distint_user_skills(?)";

$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$skills_by_category = [];
while ($row = $result->fetch_assoc()) {
    $skills_by_category[$row['skill_category']][] = $row['skill_name'];
}

//icon mapping
$category_icons = [
    'Writing' => 'fa-solid fa-pen-nib',
    'Translation' => 'fa-solid fa-language',
    'Graphic Design' => 'fa-solid fa-user-pen',
    'Video and Animation' => 'fa-solid fa-video',
    'UI/UX Design' => 'fa-brands fa-figma',
    'Web Development' => 'fa-solid fa-globe',
    'Mobile Development' => 'fa-solid fa-mobile',
    'Software Development' => 'fa-solid fa-file-code',
    'Digital Marketing' => 'fa-solid fa-store',
    'Sales Support' => 'fa-solid fa-phone',
    'Advertising' => 'fa-solid fa-megaphone',
    'Virtual Assistance' => 'fa-solid fa-headset',
    'Data Entry' => 'fa-solid fa-database',
    'Customer Support' => 'fa-solid fa-phone',
    'Financial Skills' => 'fa-solid fa-coins',
    'Business Consulting' => 'fa-solid fa-briefcase',
    'Human Resources' => 'fa-solid fa-users',
    'IT Support' => 'fa-solid fa-screwdriver-wrench',
    'Networking' => 'fa-solid fa-network-wired',
    'DevOps' => 'fa-solid fa-gears',
    'Engineering' => 'fa-solid fa-helmet-safety',
    'Architecture' => 'fa-brands fa-unity',
    'Manufacturing' => 'fa-solid fa-industry',
    'Coaching & Development' => 'fa-solid fa-notes-medical',
    'Health & Wellness' => 'fa-solid fa-shield-heart',
    'Contract & Documentation' => 'fa-solid fa-file-contract',
    'Compliance & Research' => 'fa-solid fa-book',
    'Data Processing' => 'fa-solid fa-chart-simple',
    'Advanced Analytics' => 'fa-solid fa-chart-line',
    'Game Development Support' => 'fa-solid fa-gamepad',
    'Monetization & Coaching' => 'fa-solid fa-chalkboard-user'
];

//icon generator
$icons_html = '<div class="container d-flex justify-content-center"><div class="mb-1 text-secondary fa-2x d-inline">';
foreach ($skills_by_category as $category => $skills) {
    if (isset($category_icons[$category])) {
        $icons_html .= '<span class="' . $category_icons[$category] . ' mx-1" data-bs-toggle="tooltip" title="' . $category . '"></span>';
    }
}
$icons_html .= '</div></div>';

//generate skills list HTML
$skills_html = '';
foreach ($skills_by_category as $category => $skills) {
    $skills_html .= '<div class="mb-1">
                        <hr class="divider">
                        <div class="text-muted fw-semibold text-green-60">' . htmlspecialchars($category) . '</div>';
    foreach ($skills as $skill) {
        $skills_html .= '<div class="text-muted small">' . htmlspecialchars($skill) . '</div>';
    }
    $skills_html .= '</div>';
}

echo json_encode([
    'icons' => $icons_html,
    'skills' => $skills_html
]);
