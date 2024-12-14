<?php 
session_start();
$mysqli = require ('../../connection.php');
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');

$project_id = $_GET['id'] ?? null;

// Fetch project details
$project_query = "Select * from v_project_details WHERE id = ?";
$stmt = $mysqli->prepare($project_query);
$stmt->bind_param("i", $project_id);
$stmt->execute();
$project_result = $stmt->get_result();
$project = $project_result->fetch_assoc();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Project Details</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">


    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- freelancer_profile.js -->
    <script src="../../dist/js/project_details.js" defer></script>
    <script src="https://cdn.botpress.cloud/webchat/v2.2/inject.js"></script>
    <script src="https://files.bpcontent.cloud/2024/12/12/18/20241212181227-C50YEH0A.js"></script>

</head>
<body>
    <section class="container-fluid poppins">
        <div class="container">
            <!-- profile header -->
            <div class="row mt-4 align-items-center">
                <!-- project title -->
                <div class="col-12 col-md-6">
                    <h2 class="text-start fw-semibold">proj title</h2>
                </div>
                <!-- /end project title -->

                <!-- breadcrumb navigation -->
                <div class="col-12 col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="dashboard.php">'s Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="projects.php" >Projects</a></li>
                            <li class="breadcrumb-item active" aria-current="page">proj title</li>
                        </ol>
                    </nav>
                </div>
                <!-- /breadcrumb naviagtion -->
            </div>
            <!-- /profile header -->

            <!-- objective content -->
            <div class="row">
                <!-- sidebar objective card and freelancer card -->
                <div class="col-12 col-md-4 col-lg-3 p-3">
                    <div class="card card-primary card-outline shadow border-0 mb-4">
                        <!-- objective header -->
                        <div class="card-header bg-green-30 p-3">
                            <div class="d-flex align-items-center text-white">
                                <i class="fa-solid fa-list-check text-white mx-1"></i>
                                <div class="text-white p-1 d-inline">Completion History</div>
                            </div>
                        </div>
                        <!-- /objective header -->
                        <!-- objective sidebar content -->
                        <div class="card-body">

                        </div>
                        <!-- /objective sidebar content -->
                    </div>
                </div>
                <!-- /sidebar objective card and freelancer card -->
                <div class="col-12 col-md-8 col-lg-9 p-3">
                    <div class="card shadow border-0">
                        <div class="card-body">
                            <!-- project title & status -->
                            <div class="container d-flex justify-content-between align-items-center px-4 pt-4 pb-0 mb-0 me-2">
                                <h4 class="text-green-50 fw-semibold">proj title</h4>
                                <span class="badge bg-success mb-2">status</span>
                            </div>
                            <!-- /project title & status -->
                            <!-- project category & description -->
                            <div class="container px-4 pt-2 pb-3 ">
                                <h5 class="">categ</h5>
                                <h6 class="text-muted mt-3 text-justify">desc</h6>
                                <h6 class="text-muted small mt-3 text-justify">objectives</h6>
                            </div>
                            <!-- /project category & description -->
                        </div>
                    </div> 
                    <!-- file input (freelancers submission will reflect here) -->
                    <div class="card shadow border-0 mt-3">
                        .
                    </div>
                </div>
            </div>
            <!-- /objective content -->
        </div>
    </section>
</body>
</html>