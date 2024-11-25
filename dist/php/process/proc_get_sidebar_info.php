<?php
session_start();
$mysqli = require '../../../connection.php';

$user_id = $_SESSION['user_id'];

$query = "CALL sp_get_user_from_v_user_profile(?)";
$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$user = $stmt->get_result()->fetch_assoc();

echo '<div class="mb-3">
        <span class="fas fa-mars-and-venus me-1 text-green-60"></span>
        <span class="text-muted fw-semibold text-green-60">Gender</span>
        <div class="text-muted small">' . htmlspecialchars($user['gender']) . '</div>
    </div>
    <hr class="divider">
    <div class="mb-3">
        <span class="fas fa-phone me-1 text-green-60"></span>
        <span class="text-muted fw-semibold text-green-60">Mobile Number</span>
        <div class="text-muted small">' . htmlspecialchars($user['mobile_number']) . '</div>
    </div>
    <hr class="divider">
    <div class="mb-3">
        <span class="fas fa-envelope me-1 text-green-60"></span>
        <span class="text-muted fw-semibold text-green-60">Email</span>
        <div class="text-muted small">' . htmlspecialchars($user['email']) . '</div>
    </div>
    <hr class="divider">
    <div class="mb-3">
        <span class="fas fa-location-dot me-1 text-green-60"></span>
        <span class="text-muted fw-semibold text-green-60">Location</span>
        <div class="text-muted small">' . htmlspecialchars($user['city']) . '</div>
    </div>
    <hr class="divider">
    <div class="mb-3">
        <span class="fas fa-flag me-1 text-green-60"></span>
        <span class="text-muted fw-semibold text-green-60">Nationality</span>
        <div class="text-muted small">' . htmlspecialchars($user['nationality']) . '</div>
    </div>
    <hr class="divider">
    <div>
        <span class="fas fa-language me-1 text-green-60"></span>
        <span class="text-muted fw-semibold text-green-60">Language</span>
        <div class="text-muted small">' . htmlspecialchars($user['language']) . '</div>
    </div>';
