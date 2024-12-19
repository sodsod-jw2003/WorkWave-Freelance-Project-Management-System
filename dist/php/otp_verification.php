<?php
session_start();
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    if ($_POST['otp'] == $_SESSION['reset_token']) {
        header("Location: reset_password.php");
        exit;
    } else {
        $error_message = "Invalid OTP code";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Verify OTP</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../img/WorkWaveLogo.png">
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
                <source src="uploads/vid/hero_vid.mp4" type="video/mp4">
                Your browser does not support the video tag.
            </video>
        </div>

        <!-- Form Overlay -->
        <div class="form-overlay position-absolute top-0 start-0 w-100 h-100 bg-dark opacity-50 z-index-1"></div>

        <!-- Card Content -->
        <div class="card p-5 rounded-5 shadow w-50 position-relative z-index-2">
            <!-- Header -->
            <div class="text-center mb-4">
                <div class="d-flex align-items-center justify-content-center">
                    <img src="../../img/WorkWaveLogo.png" class="me-2" alt="WorkWave Logo" style="height: 55px; width: auto;">
                    <span class="fs-1 text-green-50 fw-bold">WorkWave</span>
                </div>
                <h6 class="fs-6 text-dark">Enter OTP Code to Reset Your Password</h6>
            </div>

            <!-- Form -->
            <form method="POST">
                <!-- OTP Input -->
                <div class="container mt-4 mb-3">
                    <div class="input-group my-1">
                        <div class="input-group-prepend d-flex align-items-stretch">
                            <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                                <span class="fas fa-key text-green-50 ps-1"></span>
                            </div>
                        </div>
                        <input type="text" name="otp" id="otp" class="form-control no-outline-green-focus rounded-end-5 border px-3 py-2 no-outline" placeholder="Enter OTP Code" required>
                    </div>
                </div>

                <?php if (!empty($error_message)): ?>
                    <div class="text-end text-danger">
                        <em><?= $error_message; ?></em>
                    </div>
                <?php endif; ?>

                <!-- Verify Button -->
                <div class="container mt-4">
                    <div class="row justify-content-center">
                        <div class="col-12">
                            <input type="submit" value="Verify Account" class="btn btn-dark-green rounded-5 w-100">
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </section>

    <script src="https://cdn.botpress.cloud/webchat/v2.2/inject.js"></script>
    <script src="https://files.bpcontent.cloud/2024/12/12/18/20241212181227-C50YEH0A.js"></script>
</body>
</html>