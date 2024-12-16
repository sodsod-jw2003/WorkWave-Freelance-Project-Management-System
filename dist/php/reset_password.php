<?php
date_default_timezone_set('Asia/Manila');
$token = $_GET["token"];

$mysqli = require "../../connection.php";

//checking of token
$stmt = $mysqli->prepare("SELECT * FROM v_users_with_reset_tokens WHERE reset_token_hash = ?");
$stmt->bind_param("s", $token);

$stmt->execute();

$result = $stmt->get_result();
$user = $result->fetch_assoc();

if ($user === null) {
    die("token not found.");
}

if ($user["reset_token_expiry"] <= date('Y-m-d H:i:s')) {
    die("token has expired");
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Reset Password</title>

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../css/custom.css">

    <!-- register.js -->
    <script src="../js/register.js" defer></script>

    <script src="https://cdn.botpress.cloud/webchat/v2.2/inject.js"></script>
    <script src="https://files.bpcontent.cloud/2024/12/12/18/20241212181227-C50YEH0A.js"></script>
    
</head>
<body>
<section class="container-fluid poppins vh-100 p-5 d-flex justify-content-center align-items-center position-relative">
    <!-- Video Background -->
    <div class="hero-video position-absolute top-0 start-0 w-100 h-100 z-index-0">
        <video autoplay loop muted playsinline class="w-100 h-100 object-fit-cover">
            <source src="uploads/vid/hero_vid.mp4" type="video/mp4">
            Your browser does not support the video tag.
        </video>
    </div>

    <div class="card p-5 rounded-5 shadow w-50 z-index-1">
        <!-- header -->
        <div class="container">
            <h1 class="fs-1 text-center text-green-70 fw-bold">Reset Password</h1>
            <h6 class="fs-6 text-center">Enter your new Password</h6>
        </div>

        <!-- form -->
        <form action="process/proc_reset_password.php" method="post" id="reset">
            <input type="hidden" name="token" value="<?= htmlspecialchars($token) ?>">

            <!-- password -->
            <div class="container mt-4 mb-3">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-lock text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <input type="password" name="password" id="password" class="form-control rounded-end-0 border px-3 py-2" placeholder="New Password" required>
                    <button type="button" id="togglePassword1" class="btn btn rounded-end-5 btn-outline-light border">
                        <span class="fas fa-eye text-green-50"></span>
                    </button>
                </div>
            </div>

            <!-- confirm password -->
            <div class="container mb-4">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-lock text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <input type="password" name="confirm_password" id="confirm_password" class="form-control rounded-end-0 border px-3 py-2" placeholder="Confirm New Password" required>
                    <button type="button" id="togglePassword2" class="btn btn rounded-end-5 btn-outline-light border">
                        <span class="fas fa-eye text-green-50"></span>
                    </button>
                </div>
            </div>

            <!-- buttons -->
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-6 d-flex justify-content-center">
                        <a href="login.php" class="btn btn-light-green fw-bold text-green-100 rounded-5 w-100">Back to Login</a>
                    </div>
                    <div class="col-6 d-flex justify-content-center">
                        <input type="submit" name="reset_password" value="Reset Password" class="btn btn-dark-green flex-grow-1 flex-sm-grow-0 col-12 col-sm-5 rounded-5 w-100">
                    </div>
                </div>
            </div>
            
            <!-- form ends here -->
        </form>
    </div>
</section>

</body>
</html>