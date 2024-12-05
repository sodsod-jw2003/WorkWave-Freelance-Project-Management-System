<?php 

require ('../../connection.php');
if (!isset($_SESSION['user_id'])) {
    header("Location: ../../dist/php/login.php");; //to be updated to landing page if done(index.php)
    exit;
}
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');

// placeholder lang
$lorenipsum = "Lorem ipsum dolor sit amet. Sit quidem molestias aut inventore optio ad illo mollitia qui porro asperiores et perferendis nostrum. Est aspernatur illo nam velit consequatur eum voluptatem magnam id eius voluptas. Est repellendus nihil sed dignissimos magni qui aliquam reiciendis aut nesciunt porro sit galisum dolores. Eum nobis quibusdam cum corrupti inventore hic obcaecati veritatis est illo necessitatibus eum voluptas fugit in molestias voluptas.";

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | View Application</title>
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
            <!-- profile header -->
            <div class="row mt-4 d-flex align-items-center">
                <!-- profile title -->
                <div class="col-12 col-md-6">
                    <h2 class="text-start">View Application</h2>
                </div>
                <!-- breadcrumb navigation -->
                <div class="col-12 col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="dashboard.php"><?php echo htmlspecialchars($user['first_name']); ?>'s Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="applications.php">All Applications</a></li>
                            <li class="breadcrumb-item active" aria-current="page">View Application</li>
                        </ol>
                    </nav>
                </div>
            </div>
            <!-- /profile header -->
            <!-- application -->
            <div class="row mt-4 d-flex g-3">
                <div class="col-md-9 ">
                    <div class="rounded shadow border p-4 mb-3">
                        <div class="col-12 d-flex justify-content-between align-items-center">
                            <div class="col-md-6 fs-4 text-green-50 fw-semibold bg-">Project Title</div>
                            <div class="col-md-6 d-flex justify-content-end bg-">
                                <span class="me-3">
                                    <span class="small text-muted">Costs:</span>
                                    <span class="small text-green-40 fw-semibold">10 Connects</span>
                                </span>
                                <span>
                                    <span class="small text-muted">Worth:</span>
                                    <span class="small text-green-40 fw-semibold">25 Merits</span>
                                </span>
                            </div>
                        </div>
                        <hr class="divider">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-cog me-2 text-green-50"></i>
                            <span class="fs-5 text-green-50 fw-semibold">Project Category</span>
                        </div>
                        <h6 class="text-muted small mt-2 text-justify">Project Description</h6>
                    </div>
                    <div class="bg-white rounded shadow border p-4">
                            <h4 class="fw-semibold text-green-50">Proposal</h4>
                            <hr class="divider">
                            <h5 class="mt-3">Cover Letter</h5>
                            <h6 class="small text-muted text-justify"><?php echo $lorenipsum ?></h6>
                            <h5 class="mt-3">Portfolio Link</h5>
                            <a href="#" class="small no-deco text-muted">https://www.google.com/</a> 
                        <div class="mt-3">
                            <button class="btn btn-success">Hire Freelancer</button>
                            <a href="applications.php" class="btn btn-secondary">Ignore</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 d-flex h-100">
                    <div class="rounded shadow border p-4 mb-3 w-100">
                        <div class="container d-flex justify-content-center mt-2 position-relative">
                            <div class="profile-pic-wrapper">
                                <img src="<?php echo $user['profile_picture_url'] ?>" 
                                    class="profile-pic rounded-circle" 
                                    style="width: 100px; height: 100px; object-fit: cover;">
                            </div>
                        </div>
                        <div class="container fs-5 text-center mt-3"><?php echo htmlspecialchars($full_name); ?></div>
                        <div class="container fs-6 text-center text-muted"><?php echo htmlspecialchars($job_title); ?></div>
                        <div class="bg- mt-4">
                            <div class="mb-3">
                                <span class="fas fa-phone me-1 text-green-60"></span>
                                <span class="text-muted fw-semibold text-green-60">Mobile Number</span>
                                <div class="text-muted small"><?php echo $user['first_name'] ?></div>
                            </div>
                            <hr class="divider">
                            <div class="mb-3">
                                <span class="fas fa-envelope me-1 text-green-60"></span>
                                <span class="text-muted fw-semibold text-green-60">Email</span>
                                <div class="text-muted small"><?php echo $user['email'] ?></div>
                            </div>
                            <hr class="divider">
                            <div class="mb-3">
                                <span class="fas fa-mars-and-venus me-1 text-green-60"></span>
                                <span class="text-muted fw-semibold text-green-60">Gender</span>
                                <div class="text-muted small"><?php echo $user['gender'] ?></div>
                            </div>
                            <hr class="divider">
                            <div class="mb-3">
                                <span class="fas fa-location-dot me-1 text-green-60"></span>
                                <span class="text-muted fw-semibold text-green-60">Location</span>
                                <div class="text-muted small"><?php echo $user['city'] ?></div>
                            </div>
                            <hr class="divider">
                            <div class="mb-3">
                                <span class="fas fa-flag me-1 text-green-60"></span>
                                <span class="text-muted fw-semibold text-green-60">Nationality</span>
                                <div class="text-muted small"><?php echo $user['nationality'] ?></div>
                            </div>
                            <hr class="divider">
                            <div class="">
                                <span class="fas fa-language me-1 text-green-60"></span>
                                <span class="text-muted fw-semibold text-green-60">Language</span>
                                <div class="text-muted small"><?php echo $user['language'] ?></div>
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