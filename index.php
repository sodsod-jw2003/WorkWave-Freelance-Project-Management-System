<?php
session_start();
require ('connection.php');

// Add this login check
if (isset($_SESSION["user_id"])) {
    if ($_SESSION["role"] === "Client") {
        header("Location: pages/client/dashboard.php");
    } else {
        header("Location: pages/freelancer/dashboard.php");
    }
    exit;
}

$sql = "SELECT * FROM v_indemand_categories";
$result = $mysqli->query($sql);

$categories = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $categories[] = $row;
    }
}

$mysqli->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave</title>
    <link rel="icon" type="image/png" sizes="64x64" href="img/WorkWaveLogo.png">

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="dist/css/index.css">

</head>
<body class="poppins">
    <header class="bg- position-absolute z-index-1 w-100">
        <?php include 'header.php' ?>
    </header>

    <main class="bg-light">
        <!-- hero section -->
        <section class="hero-section">
            <div class="hero-content">
                <h1 class="hero-title text-start">WorkWave</h1>
                <h3 class="hero-text text-start">Freelancing made easy. </h3>
                <h5 class="hero-text-sub text-start">Connecting clients and freelancers for collaboration and project success.</h5>
                <br><br>
                <h6 class="hero-text fs-5 text-start mb-3">Join our growing community and show your skills to the world!</h6>
                <div class="d-flex justify-content-start ps-5">
                    <a href="dist/php/register.php" class="btn btn-dark-green ms-5">Create an Account</a>
                    <a href="dist/php/login.php" class="btn btn-outline-light ms-2">Login</a>
                </div>
            </div>
            <div class="hero-video">
                <video autoplay loop muted playsinline>
                    <source src="dist/php/uploads/vid/hero_vid.mp4" type="video/mp4">
                    Your browser does not support the video tag.
                </video>
            </div>
        </section>
        <!-- hero section -->

        <!-- key features -->
        <section class="py-5 my-5">
            <div class="container">
                <div class="col-12 text-center mb-5">
                    <h4 class="fw-bold text-green-50 display-6">Our Key Features</h4>
                    <p class="text-muted fs-5">Discover the powerful features that make WorkWave a helpful platform for both clients and freelancers.</p>
                </div>
                <div class="row justify-content-center">
                    <div class="col-12 col-md-6 mb-4 mb-md-0">
                        <div class="card shadow-lg border-0 p-4 rounded-3">
                            <h5 class="fw-bold text-green-50 px-3 pt-3">Project and Objective Management</h5>
                            <p class="text-muted text-justify px-3 mt-2">
                                This feature emphasizes the ability to create, organize, and monitor projects and objectives easily within the system. Clients can create detailed projects, freelancers can then update their progress, ensuring that both sides have visibility into task status.
                            </p>
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="card shadow-lg border-0 p-4 rounded-3">
                            <h5 class="fw-bold text-green-50 px-3 pt-3">Client and Freelancer Collaboration</h5>
                            <p class="text-muted text-justify px-3 mt-2">
                                This refers to features that enhance communication and collaboration between clients and freelancers. It includes features like file sharing, comments, and notifications, ensuring that everyone involved is on the same page.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- /key features -->

        <!-- who can use workwave -->
        <section class="py-5 my-5">
            <div class="container">
                <div class="row">
                    <div class="col-12 text-center">
                        <h4 class="fw-bold text-green-50 display-6">Who Can Use WorkWave?</h4>
                        <p class="text-muted fs-5">WorkWave is designed for both Clients and Freelancers, each with specific roles to ensure smooth project management.</p>
                    </div>
                </div>
                <div class="row mt-4">
                    <!-- cleint card -->
                    <div class="col-md-6 d-flex justify-content-center mb-4">
                        <div class="card border-0 p-4 bg-transparent rounded shadow-lg">
                            <div class="d-flex align-items-center">
                                <div class="icon-container me-4">
                                    <i class="fas fa-user-tie fa-3x text-green-50"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold text-green-50">Client</h5>
                                    <p class="text-muted mb-0">
                                        Responsible for setting up projects, defining requirements, and hiring freelancers to perform the work.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- cleint card -->
                    <!-- freelancer card -->
                    <div class="col-md-6 d-flex justify-content-center mb-4">
                        <div class="card border-0 p-4 bg-transparent rounded shadow-lg">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <h5 class="fw-bold text-green-50 text-end">Freelancer</h5>
                                    <p class="text-muted mb-0 text-end">
                                        Self-employed professionals working on a project-by-project basis, offering specialized skills or services.
                                    </p>
                                </div>
                                <div class="icon-container ms-4">
                                    <i class="fas fa-briefcase fa-3x text-green-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- freelancer card -->
                </div>
            </div>
        </section>
        <!-- /who can use workwave -->

        <!-- how workwave work -->
        <section class="py-5 my-5">
            <div class="container">
                <div class="text-center mb-5">
                    <h4 class="fw-bold text-green-50 display-6">How Does WorkWave Actually <i>Work</i>?</h4>
                    <p class="text-muted fs-5">A simple four-step process to ensure smooth project management.</p>
                </div>
                <!-- steps -->
                <div class="row justify-content-center">
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center position-relative">
                            <!-- s1 -->
                            <div class="step text-center">
                                <div class="step-circle shadow-lg bg-green-50 text-white">
                                    1
                                </div>
                                <p class="step-label mt-4 fw-bold text-muted">Project Creation</p>
                            </div>
                            <div class="line bg-green-50"></div>
                            <!-- s2 -->
                            <div class="step text-center">
                                <div class="step-circle shadow-lg bg-green-50 text-white">
                                    2
                                </div>
                                <p class="step-label mt-4 fw-bold text-muted">Freelancer Application</p>
                            </div>
                            <div class="line bg-green-50"></div>
                            <!-- s3 -->
                            <div class="step text-center">
                                <div class="step-circle shadow-lg bg-green-50 text-white">
                                    3
                                </div>
                                <p class="step-label mt-4 fw-bold text-muted">Freelancer Admission</p>
                            </div>
                            <div class="line bg-secondary-subtle"></div>
                            <!-- s4 -->
                            <div class="step text-center">
                                <div class="step-circle shadow-lg bg-green-50 text-white">
                                    4
                                </div>
                                <p class="step-label mt-4 fw-bold text-muted">Objective Submission</p>
                            </div>
                            <!-- s5 -->
                            <div class="step text-center">
                                <div class="step-circle shadow-lg bg-green-50 text-white">
                                    5
                                </div>
                                <p class="step-label mt-4 fw-bold text-muted">Project Completion</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- /how workwave work -->

        <!-- top 3 categgories -->
        <section class="py-5 mt-5 bg-light">
            <div class="container">
                <div class="text-center mb-5">
                    <h4 class="fw-bold text-green-50 display-6">Top 3 Most In-Demand Project Categories</h4>
                    <p class="text-muted fs-5">Discover the most popular project categories in demand right now.</p>
                </div>
                <div class="row justify-content-center">
                    <?php if (!empty($categories)): ?>
                        <?php foreach ($categories as $index => $category): ?>
                            <div class="col-md-4 mb-4">
                                <div class="col-12 d-flex align-items-center shadow-lg border-0 h-100 p-4 rounded">
                                    <div class="col-md-2 bg-green-50 rounded d-flex align-items-center justify-content-center pt-2">
                                        <h1 class="fw-bolder text-center text-white"><?php echo ($index + 1)?></h1>
                                    </div>
                                    <div class="col-md-10 ms-3">
                                        <h4 class="fw-semibold text-start mb-0"><?php echo htmlspecialchars($category['project_category']);?></h4>
                                        <h6 class="text-start "><?php echo $category['category_count']; ?> Project/s</h6>
                                    </div>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <div class="col-12 text-center">
                            <p class="text-muted fs-5">No data available for top project categories.</p>
                        </div>
                    <?php endif; ?>
                </div>
            </div>
        </section>
        <!-- top 3 categgories -->
    </main>
    <footer class="bg-green-100">
        .
    </footer>
    
    <script src="https://cdn.botpress.cloud/webchat/v2.2/inject.js"></script>
    <script src="https://files.bpcontent.cloud/2024/12/12/18/20241212181227-C50YEH0A.js"></script>
</body>
</html>