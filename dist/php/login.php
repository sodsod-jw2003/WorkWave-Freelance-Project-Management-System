<?php 

$is_invalid_status = false;
$is_invalid = false;

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $mysqli = require "../../connection.php";

    // Query user credentials
    $stmt = $mysqli->prepare("SELECT * FROM v_user_credentials WHERE email = ?");
    $stmt->bind_param("s", $_POST["email"]);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    // Check if email exists in v_not_verified_emails
    $stmt = $mysqli->prepare("SELECT COUNT(*) AS count FROM v_not_verified_emails WHERE email = ?");
    $stmt->bind_param("s", $_POST["email"]);
    $stmt->execute();
    $result = $stmt->get_result();
    $not_verified = $result->fetch_assoc();

    if ($user) {
        // Check password validity
        if (password_verify($_POST["password"], $user["password_hash"])) {
            // Check if account is activated
            if ($not_verified['count'] == 0) {
                $stmt = $mysqli->prepare("CALL sp_update_user_last_login_date(?)");
                $stmt->bind_param("i", $user["id"]);
                $stmt->execute();

                // Account is verified, proceed to login
                if (session_status() === PHP_SESSION_NONE) {
                    session_start();
                }

                session_regenerate_id(); 
                $_SESSION["user_id"] = $user["id"];
                $_SESSION["role"] = $user["role"];

                // Redirect based on role
                if ($user["role"] === "Client") {
                    header("Location: ../../pages/client/dashboard.php");
                } elseif ($user["role"] === "Freelancer") {
                    header("Location: ../../pages/freelancer/dashboard.php");
                }
                exit;
            } else {
                // Account not verified
                $is_invalid_status = true;
                $error_message = "Account not activated. Please verify your email.";
            }
        } else {
            // Incorrect password
            $is_invalid = true;
            $error_message = "Wrong email or password.";
        }
    } else {
        // User not found
        $is_invalid = true;
        $error_message = "Wrong email or password.";
    }
}

?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Login</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">
    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../css/custom.css">
</head>
<body>

<section class="container-fluid poppins vh-100 p-5 d-flex justify-content-center align-items-center position-relative">
    <!-- Video Background -->
    <div class="hero-video position-absolute top-0 start-0 w-100 h-100 z-index-0">
        <video autoplay loop muted playsinline class="w-100 h-100 object-fit-cover">
            <source src="/dist/php/uploads/vid/hero_vid.mp4" type="video/mp4">
            Your browser does not support the video tag.
        </video>
    </div>

    <!-- Form Overlay -->
    <div class="form-overlay position-absolute top-0 start-0 w-100 h-100 bg-dark opacity-50 z-index-1"></div>

    <!-- Card Content -->
    <div class="card p-5 rounded-5 shadow w-50 position-relative z-index-2">
        <!-- Header -->
        <div class="text-center mb-2">
            <div class="d-flex align-items-center justify-content-center">
                <img src="../../img/WorkWaveLogo.png" class="me-2" alt="WorkWave Logo" style="height: 55px; width: auto;">
                <span class="fs-1 text-green-50 fw-bold">WorkWave</span>
            </div>
            <h6 class="fs-6 text-dark">Login and Continue with your Account</h6>
        </div>

        <!-- Form -->
        <form method="POST" id="loginForm">
            <!-- Email -->
            <div class="container mt-4 mb-3">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-envelope text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <input type="email" name="email" id="email" class="form-control no-outline-green-focus rounded-end-5 border px-3 py-2 no-outline" placeholder="Email" required>
                </div>
            </div>

            <!-- Password -->
            <div class="container mb-1">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-lock text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <input type="password" name="password" id="password" class="form-control no-outline-green-focus rounded-end-0 border-end-0 px-3 py-2 no-outline" placeholder="Password" required>
                    <button type="button" id="togglePassword1" class="btn btn rounded-end-5 btn-outline-light border-end border-top border-bottom">
                        <span class="fas fa-eye text-green-50 bg-transparent"></span>
                    </button>
                </div>
            </div>

            <!-- Login Status -->
            <?php if ($is_invalid_status): ?>
                <div class="text-end text-danger">
                    <em> <?= $error_message; ?> </em>
                </div>
            <?php elseif ($is_invalid): ?>
                <div class="text-end text-danger">
                    <em> <?= $error_message; ?> </em>
                </div>
            <?php endif; ?>

            <!-- Forgot Password -->
            <div class="container my-4">
                <a class="no-deco text-green-50 fw-bold" href="forgot_password.php">I forgot my password</a>
            </div>

            <!-- Buttons -->
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-6 d-flex justify-content-center">
                        <a href="register.php" class="btn btn-light-green fw-medium text-green-50 rounded-5 w-100">Register</a>
                    </div>
                    <div class="col-6 d-flex justify-content-center">
                        <input type="submit" name="login" value="Login" class="btn btn-dark-green flex-grow-1 flex-sm-grow-0 col-12 col-sm-5 rounded-5 w-100">
                    </div>
                </div>
            </div>
        </div>
        <!-- End Card Content -->
    </form>
</section>

    
    <script src="https://cdn.botpress.cloud/webchat/v2.2/inject.js"></script>
    <script src="https://files.bpcontent.cloud/2024/12/12/18/20241212181227-C50YEH0A.js"></script>
    <script src="../js/login.js"></script>
</body>
</html>
