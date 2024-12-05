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
    <title>WorkWave | Freelancer Dashboard</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">

    <!-- freelancer_dashboard.js -->
    <script src="../../dist/js/freelancer_dashboard.js" defer></script>

</head>
<body>
<section class="container-fluid poppins">
    <div class="row d-flex justify-content-center">

        <!-- filter jobs -->
        <!-- <div class="col-md-2 col-12 bg-light min0vh-100">
        .
        </div> -->
        <!-- /filter jobs -->

        <!-- feed -->
        <div class="col-md-10 col-12">
            <!-- creds and cons -->
            <div class="row mx-0 my-3">
                <div class="col-10 col-lg-6 d-flex align-items-center mb-3 mb-lg-0">
                    <h2 class="m-0">Dashboard</h2>
                </div>
                <div class="col-12 col-lg-6 pe-lg-3">
                    <div class="row d-flex justify-content-lg-end g-2">
                        <!-- creds -->
                        <div class="col-6 col-md-4 d-flex bg-green-30 text-white rounded shadow-sm border me-2">
                            <div class="col-5 d-flex justify-content-center align-items-center">
                                <i class="fas fa-coins fa-2x p-3"></i>
                            </div>
                            <div class="col-7 d-flex justify-content-start align-items-center">
                                <div>
                                    <div class="text-start text-green-10 small">Credits</div>
                                    <div class="text-start fw-semibold">2,742</div>
                                </div>
                            </div>
                        </div>
                        <!-- /creds -->
                        <!-- cons -->
                        <div class="col-6 col-md-4 d-flex bg-green-30 text-white rounded shadow-sm border">
                            <div class="col-5 d-flex justify-content-center align-items-center">
                                <i class="fas fa-handshake fa-2x p-3"></i>
                            </div>
                            <div class="col-7 d-flex justify-content-start align-items-center">
                                <div>
                                    <div class="text-start text-green-10 small">Connects</div>
                                    <div class="text-start fw-semibold">100</div>
                                </div>
                            </div>
                        </div>
                        <!-- /cons -->
                    </div>
                </div>
            </div>
            <!-- /creds and cons -->
            <!-- projects, tasks, and clients -->
            <div class="row mx-0 my-3 g-4">
                <div class="col-12 col-md-4 p-2">
                    <div class="px-3 pb-3 pt-2 rounded-2 bg-light shadow d-flex align-items-center">
                        <div class="col-7 d-flex flex-column align-items-start mt-1">
                            <div class="fw-bold fs-2 ps-2">4</div>
                            <div class="fs-6 ps-2">Ongoing Projects</div>
                        </div>
                        <div class="col-5 d-flex justify-content-center align-items-center mt-2">
                            <i class="fas fa-diagram-project fa-4x text-green-50"></i>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-md-4 p-2">
                    <div class="px-3 pb-3 pt-2 rounded-2 bg-light shadow d-flex align-items-center">
                        <div class="col-7 d-flex flex-column align-items-start mt-1">
                            <div class="fw-bold fs-2 ps-2">13</div>
                            <div class="fs-6 ps-2">Ongoing Tasks</div>
                        </div>
                        <div class="col-5 d-flex justify-content-center align-items-center mt-2">
                            <i class="fas fa-list-check fa-4x text-green-50"></i>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-md-4 p-2">
                    <div class="px-3 pb-3 pt-2 rounded-2 bg-light shadow d-flex align-items-center">
                        <div class="col-7 d-flex flex-column align-items-start mt-1">
                            <div class="fw-bold fs-2 ps-2">2</div>
                            <div class="fs-6 ps-2">Active Clients</div>
                        </div>
                        <div class="col-5 d-flex justify-content-center align-items-center mt-2">
                            <i class="fas fa-user-tie fa-4x text-green-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /projects, tasks, and clients -->
            <!-- project feed -->
            <div class="row px-1">
                <div class="container px-3">
                    <!-- project card -->
                    <div class="card mb-4 shadow border-0 rounded-3">
                        <div class="card-body">
                            <!-- title and cons -->
                            <div class="col-12 col d-flex justify-content-between mb-2">
                                <div class="col-md-6 pt-2 d-flex bg- align-items-center">
                                    <a href="project_application.php" class="text-green-40 fw-semibold ps-2 fs-3">Project Title</a>
                                </div>
                                <div class="col-md-3 bg- d-flex align-items-center justify-content-end pe-2">
                                    <span class="me-3">
                                        <span class="text-muted">Cost:</span>
                                        <span class="fw-semibold text-green-40">10</span>
                                        <span class="fw-semibold text-green-40">Connects</span>
                                    </span>
                                    <span class="">
                                        <span class="text-muted">Worth:</span>
                                        <span class="fw-semibold text-green-40">25</span>
                                        <span class="fw-semibold text-green-40">Merits</span>
                                    </span>
                                </div>
                            </div>
                            <!-- title and cons -->
                            <hr class="divider mx-2">
                            <!-- project category -->
                            <div class="col-12 col d-flex align-items-center justify-content-between mb-2">
                                <!-- proj category -->
                                <span class="d-flex align-items-center p-2 rounded-3 text-green-40">
                                    <span class="fas fa-cog fs-5"></span> <!-- sample icon lung shea -->
                                    <span class="px-2 fs-5 fw-semibold">Project Category</span>
                                </span>
                                <!-- /proj category -->
                                <!-- apply and heart btn -->
                                <span class="d-flex align-items-center">
                                    <!-- apply btn -->
                                    <span class="d-flex align-items-center p-2 rounded-3 bg-">
                                        <div class="d-flex align-items-center">
                                            <a href="project_application.php" class="btn p-0" id="apply-btn">
                                                <i id="apply-icon" class="fas fa-hand fs-4 text-green-40"></i>
                                            </a>
                                        </div>
                                    </span>
                                    <!-- /apply btn -->
                                    <!-- heart btn -->
                                    <span class="d-flex align-items-center p-2 me-2 rounded-3 bg-">
                                        <div class="d-flex align-items-center">
                                            <button class="btn p-0" id="heart-btn">
                                                <i id="heart-icon" class="far fa-heart fs-4 text-danger"></i>
                                            </button>
                                        </div>
                                    </span>
                                    <!-- /heart btn -->
                                </span>
                                <!-- /apply and heart btn -->
                            </div>
                            <!-- /project category -->
                            <!-- project description -->
                            <div class="col-12 col d-flex align-items-center mt-2">
                                <div class="px-2 text-muted small text-justify"><?php echo $lorenipsum ?></div>
                            </div>
                            <!-- /project description -->
                            <!-- divider -->
                            <hr class="divider mx-2 mt-3"></hr>
                            <!-- divider -->
                            <!-- client name and posted time -->
                            <div class="col-12 col d-flex align-items-center px-2 pt-0 mt-0">
                                <div class="col-md-6 d-flex bg- align-items-center">
                                    <span>
                                        <span class="text-muted me-1">Posted by:</span>
                                        <span class="fw-semibold text-green-40">Client Name</span>
                                    </span>
                                </div>
                                <div class="col-md-6 d-flex bg- align-items-center justify-content-end">
                                    <span class="text-muted small">3 hours ago</span>
                                </div>
                            </div>
                            <!-- /client name and posted time -->
                        </div>
                    </div>
                    <!-- /project card -->
                     
                </div>
            </div>
            <!-- /project feed -->
        </div>
        <!-- /feed -->


        <!-- sidebar right -->
        <!-- <div class="col-md-2 col-12 bg-light ">
            .
        </div> -->
        <!-- /sidebar right -->
    </div>
</section>


</body>
</html>