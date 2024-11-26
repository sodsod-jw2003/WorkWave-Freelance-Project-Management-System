<?php 
session_start();
$mysqli = require ('../../connection.php');
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Client Profile</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">


    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">

    <!-- freelancer_profile.js -->
    <script src="../../dist/js/client_profile.js" defer></script>

</head>
<body>
    <section class="container-fluid poppins">
        <div class="container">
            <!-- profile header -->
            <div class="row mt-4 align-items-center">
                <!-- project title -->
                <div class="col-12 col-md-6">
                    <h2 class="text-start fw-semibold">Dynamic Project Title</h2>
                </div>
                <!-- /end project title -->

                <!-- breadcrumb navigation -->
                <div class="col-12 col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="dashboard.php"><?php echo htmlspecialchars($user['first_name']); ?>'s Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="profile.php" >Projects</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Dynamic Project Title</li>
                        </ol>
                    </nav>
                </div>
                <!-- /breadcrumb naviagtion -->
            </div>
            <!-- /profile header -->

            <!-- task content -->
            <div class="row">
                <!-- sidebar task card and freelancer card -->
                <div class="col-12 col-md-4 col-lg-3 p-3">
                    <div class="card card-primary card-outline border-top-accent shadow border-0 mb-4 position-relative">
                        <div class="container fs-5 text-center mt-3 fw-semibold">Project Title</div>
                        <div class="container fs-6 text-center text-muted mb-4">Project Category</div>
                    </div>
                    <div class="card card-primary card-outline shadow border-0 mb-4">
                        <!-- task header -->
                        <div class="card-header bg-green-30 p-3">
                            <div class="d-flex align-items-center text-white">
                                <i class="fa-solid fa-list-check text-white mx-1"></i>
                                <div class="text-white p-1 d-inline">Tasks</div>
                            </div>
                        </div>
                        <!-- /task header -->
                        <!-- task sidebar content -->
                        <div class="card-body">
                            <div class="mb-3">
                                <div class="d-flex justify-content-between align-items-center">
                                    <!-- dynamic task details depending on tak_id -->
                                    <div class="text-muted fw-semibold text-green-60">Task Title</div>
                                    <div class="badge bg-success text-white py-1 px-2">Task Status</div>
                                </div>
                                <div class="text-muted small mt-2">Assigned Freelancer</div>
                            </div>
                            <hr class="divider">
                        </div>
                        <!-- /task sidebar content -->
                    </div>
                </div>
                <!-- /sidebar task card and freelancer card -->

                <!-- main task card -->
                <div class="col-12 col-md-8 col-lg-9 p-3">
                    <div class="card shadow border-0">
                        <div class="card-body">
                            <!-- project title & status -->
                            <div class="container d-flex justify-content-between align-items-center px-4 pt-4 pb-0 mb-0 me-2">
                                <h4 class="text-green-50">Dynamic Project Title</h4>
                                <span class="badge bg-success mb-2">Project Status</span>
                            </div>
                            <!-- /project title & status -->
                            <!-- project category & description -->
                            <div class="container px-4 pt-2 pb-1 ">
                                <h5 class="">Project Category</h5>
                                <h6 class="text-muted small mt-3">Project Description</h6>
                            </div>
                            <!-- /project category & description -->
                            <!-- task main card -->
                            <div class="card mx-4 my-4 shadow-sm">
                                <!-- task header & add task button -->
                                <div class="container d-flex justify-content-between align-items-center px-4 pt-4 pb-0 mb-3 me-2">
                                    <h5>Tasks</h5>
                                    <button id="addTask" class="btn btn-dark-green">
                                        <i class="fas fa-plus me-2"></i>Add Task
                                    </button>
                                </div>
                                <!-- task header & add task button -->
                                <!-- task sub card -->
                                <div class="container px-4 py-2">
                                    <div class="card shadow-sm p-3 border-start-accent mb-4 bg-light">
                                        <div class="row">
                                            <!-- task title -->
                                            <div class="col-md-5 mb-1">
                                                <label for="task_title" class="text-muted small mb-2 ms-1">Task Title</label>
                                                <input type="text" 
                                                    name="task_title" 
                                                    id="task_title" 
                                                    class="form-control bg-white-100 no-outline-green-focus border-1" 
                                                    value="">
                                            </div>
                                            <!-- /task title -->
                                            <!-- assign freelancer -->
                                            <div class="col-md-4 mb-1">
                                                <label for="freelancer" class="text-muted small mb-2 ms-1">Freelancer</label>
                                                <select 
                                                    name="freelancer" 
                                                    id="freelancer" 
                                                    class="form-select bg-white-100 no-outline-green-focus border-1 w-100">
                                                </select>
                                            </div>
                                            <!-- /assign freelancer -->
                                            <!-- task status -->
                                            <div class="col-md-3 mb-1">
                                                <label for="status" class="text-muted small mb-2 ms-1">Status</label>
                                                <select 
                                                    name="status" 
                                                    id="status" 
                                                    class="form-select bg-white-100 no-outline-green-focus border-1 w-100">
                                                </select>
                                            </div>
                                            <!-- /task status -->
                                        </div>
                                        <div class="row mt-1">
                                            <!-- task description -->
                                            <div class="col-md-12 mb-1">
                                                <label for="task_description" class="text-muted small mb-2 ms-1">Task Description</label>
                                                <textarea name="task_description" id="task_description" class="form-control bg-white-100 no-outline-green-focus border-1"></textarea>
                                            </div>
                                            <!-- /task description -->
                                        </div>
                                        <div class="row">
                                            <!-- task controls -->
                                            <div class="container pt-3">
                                                <button type="submit" class="btn btn-dark-green">Save Task</button>
                                                <button type="button" class="btn btn-secondary" id="cancelAddTask">Cancel</button>
                                            </div>
                                            <!-- /task controls -->
                                        </div>
                                    </div>
                                    <!--  -->
                                    <div class="card shadow-sm p-3 border-start-accent mb-4 bg-light">
                                        <div class="row">
                                            <div class="col-12 d-flex align-items-center justify-content-between">
                                                <h5 class="container">Task Title</h5>
                                                <span class="badge bg-success">Task Status</span>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-12">
                                                <h6 class="container text-muted">Task Description</h6>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-12 mt-2 d-flex justify-content-between align-items-center">
                                                <div class="">
                                                    <span class="container"><i class="fas fa-user text-green-50"></i></span>
                                                    <h6 class="d-inline">Assigned Freelancer</h6>
                                                </div>
                                                <div class="">
                                                    <button class="btn btn-outline-primary"><i class="fas fa-edit"></i></button>
                                                    <button class="btn btn-outline-danger"><i class="fas fa-trash"></i></button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--  -->
                                <!-- /task sub card -->
                            </div>
                            <!-- /task main card -->
                        </div>
                    </div>                
                </div>
                <!-- /main task card -->
            </div>
            <!-- /task content -->
        </div>
    </section>
</body>
</html>