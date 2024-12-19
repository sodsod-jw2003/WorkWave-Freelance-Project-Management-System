<?php
session_start();
$mysqli = require('../../../connection.php');

//login checking
if (!isset($_SESSION['user_id'])) {
    header("Location: /WorkWave/index.php");
    exit;
}

//get logged-in user's ID
$user_id = $_SESSION['user_id'];

//get the selected deactivation duration
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $duration = $_POST['deactivationDuration'];
    $deactivation_duration = null;

    // Calculate deactivation_duration based on the selected option
    switch ($duration) {
        case '1_week':
            $deactivation_duration = date('Y-m-d H:i:s', strtotime('+1 week'));
            break;
        case '1_month':
            $deactivation_duration = date('Y-m-d H:i:s', strtotime('+1 month'));
            break;
        case 'indefinite':
            $deactivation_duration = date('Y-m-d H:i:s', strtotime('+999 year'));//wala naman na siguro buhay nito
            break;
        default:
            echo "Invalid duration selected.";
            exit;
    }

    //update the user's status and deactivation_duration in the database
    $query = "CALL sp_update_deactivation(?,?)";
    $stmt = $mysqli->prepare($query);

    $stmt->bind_param("si", $deactivation_duration, $user_id);
    if ($stmt->execute()) {
        session_unset();
        session_destroy();
        header("Location: ../../php/login.php");
        exit;
    } else {
        echo "Error: " . $mysqli->error;
    }
}
?>
