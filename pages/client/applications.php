<?php 

require ('../../connection.php');
if (!isset($_SESSION['user_id'])) {
    header("Location: ../../dist/php/login.php");; //to be updated to landing page if done(index.php)
    exit;
}
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | All Applications</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">

</head>
<body>
    <section class="container-fluid poppins">
        <div class="container">
            <!-- Profile Header -->
            <div class="row mt-4 align-items-center">
                <!-- Profile Title -->
                <div class="col-12 col-md-6">
                    <h2 class="text-start">Applications</h2>
                </div>
                <!-- Breadcrumb Navigation -->
                <div class="col-12 col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="dashboard.php"><?php echo htmlspecialchars($user['first_name']); ?>'s Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">All Applications</li>
                        </ol>
                    </nav>
                </div>
            </div>
            <!-- application -->
            <div class="row mt-4">
                <div class="container px-3">
                    <div class="card mb-4 shadow border-0 rounded-3">
                        <div class="card-body">
                            <div class="row my-3 mx-1 border-0">
                                <h3>Freelancers' Applications</h3>
                            </div>
                            <div class="row m-3">
                                <!-- application card -->
                                <div class="col-12 d-flex justify-content-between align-items-center p-4 rounded shadow-sm border mb-3 bg-light">
                                    <div class="col-md-5">
                                        <h6 class="text-secondary">Project Title</h6>
                                        <div class="d-flex align-items-center mt-3">
                                            <img src="<?php echo $user['profile_picture_url'] ?>" 
                                                    alt="" 
                                                    class="rounded-circle" 
                                                    style="width: 30px; height: 30px;">
                                            <span class="fs-5 ms-3 fw-semibold">Freelancer Name</span>
                                        </div>
                                    </div>
                                    <div class="col-md-6 d-flex justify-content-end m-0">
                                        <a href="view_application.php" class="btn btn-outline-secondary me-2"><i class="fas fa-eye"></i></a>
                                        <button class="btn btn-success me-2">Hire Freelancer</button>
                                        <button class="btn btn-danger">Remove</button>
                                    </div>
                                </div>
                                <!-- /application card -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /application -->
        </div>
    </section>
</body>
</html>