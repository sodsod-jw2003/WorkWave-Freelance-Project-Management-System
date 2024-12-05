<?php 

require ('../../connection.php');
if (!isset($_SESSION['user_id'])) {
    header("Location: ../../dist/php/login.php");; //to be updated to landing page if done(index.php)
    exit;
}
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');
include ('../../misc/accordion_values.php');

// placeholder lang
$lorenipsum = "Lorem ipsum dolor sit amet. Sit quidem molestias aut inventore optio ad illo mollitia qui porro asperiores et perferendis nostrum. Est aspernatur illo nam velit consequatur eum voluptatem magnam id eius voluptas. Est repellendus nihil sed dignissimos magni qui aliquam reiciendis aut nesciunt porro sit galisum dolores. Eum nobis quibusdam cum corrupti inventore hic obcaecati veritatis est illo necessitatibus eum voluptas fugit in molestias voluptas.";

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Project Application </title>
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
        <!-- heading and breadcrumb -->
        <div class="row mt-4">
            <div class="col-12 col-md-6">
                <h2 class="text-start">Project Application</h2>
            </div>
            <div class="col-12 col-md-6 d-flex align-items-center justify-content-md-end mt-3 mt-md-0">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item">
                            <a href="dashboard.php">
                                <?php echo htmlspecialchars($user['first_name']); ?>'s Dashboard
                            </a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">Project Application</li>
                    </ol>
                </nav>
            </div>
        </div>
        <!-- /heading and breadcrumb -->
        <!-- project details -->
        <div class="row mt-4 d-flex g-3">
            <!-- proj title, category, description, and cost connects -->
            <div class="col-12 col-lg-9 pb-4 pt-0  d-flex justify-content-center">
                <div class="container bg-white rounded shadow p-4">
                    <div class="d-flex align-items-center justify-content-between mb-0">
                        <h3 class="fw-semibold text-green-50">Project Title</h3>
                        <span>
                            <span class="me-2">
                                <span class="text-muted">Cost:</span>
                                <span class="fw-semibold text-green-40">10</span>
                                <span class="fw-semibold text-green-40">Connects</span>
                            </span>
                            <span class="">
                                <span class="text-muted">Worth:</span>
                                <span class="fw-semibold text-green-40">10</span>
                                <span class="fw-semibold text-green-40">Merits</span>
                            </span>
                        </span>
                    </div>
                    <hr class="divider">
                    <div class="d-flex align-items-center mb-2 text-green-50">
                        <span class="fas fa-cog fs-6 me-2"></span>
                        <span class="fs-5 fw-semibold">Project Category</span>
                    </div>
                    <h6 class="text-muted small text-justify mb-0"><?php echo htmlspecialchars($lorenipsum); ?></h6>
                </div>
            </div>
            <!-- /proj title, category, description, and cost connects -->
            <!-- client pic, name, and industry -->
            <div class="col-12 col-lg-3 pb-4 pt-0  d-flex justify-content-center">
                <div class="container bg-white rounded shadow p-4 d-flex align-items-center">
                    <div class="container d-flex justify-content-center align-items-center mt-2">
                        <div class="row">
                            <!-- temporary profile picture if none is uploaded -->
                            <div class="profile-pic-wrapper bg- d-flex justify-content-center align-items-center">
                                <img src="<?php echo htmlspecialchars($user['profile_picture_url']); ?>" 
                                    class="profile-pic rounded-circle" 
                                    style="width: 100px; height: 100px; object-fit: cover;">
                            </div>
                            <div> 
                                <div class="container fs-5 text-center mt-3"><?php echo htmlspecialchars($full_name); ?></div>
                                <div class="container fs-6 text-center text-muted"><?php echo htmlspecialchars($job_title); ?></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /client pic, name, and industry -->
        </div>
        <!-- /project details -->
        <!-- proposal -->
        <div class="row">
            <div class="col-12 col-lg-8 pb-4 pt-0  d-flex justify-content-center h-100">
                <div class="container bg-white rounded shadow p-4 ">
                    <!-- heading and definition of proposal -->
                    <h4>Write a Proposal</h4>
                    <h6 class=" text-muted text-justify">A 
                        <span class="fw-semibold text-green-50">Proposal</span> is a document, submitted to highlight your suitability for the project, including 
                        <span class="fw-semibold text-green-50">Cover Letter</span> or
                        <span class="fw-semibold text-green-50">Portfolio</span> that will strengthen your application
                    </h6>
                    <!-- /heading and definition of proposal -->
                    <!-- text area ng proposal -->
                    <div class="mt-4">
                        <div class="col-md-12 mb-1">
                            <label 
                                for="proposal" 
                                class="text-muted small mb-2">Write a cover letter <i>(Why should <?php echo htmlspecialchars($full_name); ?> hire you?)</i>
                            </label>
                            <textarea name="proposal" id="proposal" class="form-control bg-light no-outline-green-focus border-1" rows="3"></textarea>
                        </div>
                    </div>
                    <!-- /text arae ng proposal -->
                    <!-- link to portfolio -->
                    <div class="mt-4">
                        <div class="col-md-12 mb-1">
                            <label 
                                for="portfolio_link"
                                class="text-muted small mb-2">Enter link to your portfolio <i>(if you have any)</i>
                            </label>
                            <input 
                                id="portfolio_link" 
                                type="text" 
                                name="portfolio_link" 
                                class="form-control bg-light no-outline-green-focus border-1 w-100" 
                                placeholder="https://">
                        </div>
                    </div>
                    <!-- /link to portfolio -->
                    <!-- submit and canvel button -->
                    <div class="mt-4">
                        <div class="">
                            <button type="submit" class="btn btn-dark-green">Submit Proposal</button>
                            <button type="button" class="btn btn-secondary" id="cancelAdd">Cancel</button>
                        </div>
                    </div>
                    <!-- /submit and canvel button -->
                </div>
            </div>

            <!-- proposal tips -->
            <div class="col-12 col-lg-4 pb-4 pt-0">
                <div class="card card-primary card-outline shadow border-0 mb-4">
                    <!-- proposal tips: collapsible header -->
                    <div class="card-header bg-green-30 p-3">
                        <a class="d-flex align-items-center text-decoration-none toggle-icon"
                        data-bs-toggle="collapse" 
                        href="#proposalTips" 
                        role="button" 
                        aria-expanded="true" 
                        aria-controls="proposalTips">
                            <i class="fa-solid fa-lightbulb text-white mx-1"></i>
                            <span class="text-white p-1 d-inline">Tips on Writing a Good Cover Letter</span>
                            <i class="fa-solid fa-chevron-down text-white ms-auto pe-1 icon-toggle"></i>
                        </a>
                    </div>
                    <!-- proposal tips: collapsible header -->
                    <!-- proposal tips: collapsible content -->
                    <div id="proposalTips" class="collapse-section collapse show">
                        <div class="card-body">
                            <h6 class="text-muted text-justify small p-1">
                                A well-structured cover letter can increase your chances of getting hired. Here’s a suggested structure to help you write a compelling and professional proposal:
                            </h6>
                            <div class="accordion" id="proposalAccordion">
                                <!-- tip #1  -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingOne">
                                        <button class="accordion-button no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseOne" 
                                            aria-expanded="false" 
                                            aria-controls="collapseOne">
                                            <?php echo htmlspecialchars($tips['Tip_1']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseOne" 
                                        class="accordion-collapse collapse show" 
                                        aria-labelledby="headingOne" 
                                        data-bs-parent="#proposalAccordion">
                                        <div class="accordion-body ">
                                            <p class="text-secondary small text-justify">
                                                <?php echo htmlspecialchars($tips['Tip_1']['tipDescription']); ?>
                                            </p>
                                            <div class="card mt-3 mb-1 bg-light">
                                                <div class="card-body pb-2">
                                                    <h6 class="fst-italic text-muted small">
                                                        <?php echo htmlspecialchars($tips['Tip_1']['tipExample']); ?>
                                                    </h6>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- /tip #1 -->
                                <!-- tip #2  -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingTwo">
                                        <button class="accordion-button no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseTwo" 
                                            aria-expanded="false" 
                                            aria-controls="collapseTwo">
                                            <?php echo htmlspecialchars($tips['Tip_2']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseTwo" 
                                        class="accordion-collapse collapse show" 
                                        aria-labelledby="headingTwo" 
                                        data-bs-parent="#proposalAccordion">
                                        <div class="accordion-body ">
                                            <p class="text-secondary small text-justify">
                                                <?php echo htmlspecialchars($tips['Tip_2']['tipDescription']); ?>
                                            </p>
                                            <div class="card mt-3 mb-1 bg-light">
                                                <div class="card-body pb-2">
                                                    <h6 class="fst-italic text-muted small">
                                                        <?php echo htmlspecialchars($tips['Tip_2']['tipExample']); ?>
                                                    </h6>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- /tip #2 -->
                                <!-- tip #3  -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingThree">
                                        <button class="accordion-button no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseThree" 
                                            aria-expanded="false" 
                                            aria-controls="collapseThree">
                                            <?php echo htmlspecialchars($tips['Tip_3']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseThree" 
                                        class="accordion-collapse collapse show" 
                                        aria-labelledby="headingThree" 
                                        data-bs-parent="#proposalAccordion">
                                        <div class="accordion-body ">
                                            <p class="text-secondary small text-justify">
                                                <?php echo htmlspecialchars($tips['Tip_3']['tipDescription']); ?>
                                            </p>
                                            <div class="card mt-3 mb-1 bg-light">
                                                <div class="card-body pb-2">
                                                    <h6 class="fst-italic text-muted small">
                                                        <?php echo htmlspecialchars($tips['Tip_3']['tipExample']); ?>
                                                    </h6>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- /tip #3 -->
                                <!-- tip #4  -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingFour">
                                        <button class="accordion-button no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseFour" 
                                            aria-expanded="false" 
                                            aria-controls="collapseFour">
                                            <?php echo htmlspecialchars($tips['Tip_4']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseFour" 
                                        class="accordion-collapse collapse show" 
                                        aria-labelledby="headingFour" 
                                        data-bs-parent="#proposalAccordion">
                                        <div class="accordion-body ">
                                            <p class="text-secondary small text-justify">
                                                <?php echo htmlspecialchars($tips['Tip_4']['tipDescription']); ?>
                                            </p>
                                            <div class="card mt-3 mb-1 bg-light">
                                                <div class="card-body pb-2">
                                                    <h6 class="fst-italic text-muted small">
                                                        <?php echo htmlspecialchars($tips['Tip_4']['tipExample']); ?>
                                                    </h6>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- /tip #4 -->
                                <!-- tip #5  -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingFive">
                                        <button class="accordion-button no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseFive" 
                                            aria-expanded="false" 
                                            aria-controls="collapseFive">
                                            <?php echo htmlspecialchars($tips['Tip_5']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseFive" 
                                        class="accordion-collapse collapse show" 
                                        aria-labelledby="headingFive" 
                                        data-bs-parent="#proposalAccordion">
                                        <div class="accordion-body ">
                                            <p class="text-secondary small text-justify">
                                                <?php echo htmlspecialchars($tips['Tip_5']['tipDescription']); ?>
                                            </p>
                                            <div class="card mt-3 mb-1 bg-light">
                                                <div class="card-body pb-2">
                                                    <h6 class="fst-italic text-muted small">
                                                        <?php echo htmlspecialchars($tips['Tip_5']['tipExample']); ?>
                                                    </h6>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- /tip #5 -->
                                <!-- tip #6  -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingSix">
                                        <button class="accordion-button no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseSix" 
                                            aria-expanded="false" 
                                            aria-controls="collapseSix">
                                            <?php echo htmlspecialchars($tips['Tip_6']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseSix" 
                                        class="accordion-collapse collapse show" 
                                        aria-labelledby="headingSix" 
                                        data-bs-parent="#proposalAccordion">
                                        <div class="accordion-body ">
                                            <p class="text-secondary small text-justify">
                                                <?php echo htmlspecialchars($tips['Tip_6']['tipDescription']); ?>
                                            </p>
                                            <div class="card mt-3 mb-1 bg-light">
                                                <div class="card-body pb-2">
                                                    <h6 class="fst-italic text-muted small">
                                                        <?php echo htmlspecialchars($tips['Tip_6']['tipExample']); ?>
                                                    </h6>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- /tip #6 -->
                                <!-- tip #7  -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingSeven">
                                        <button class="accordion-button no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseSeven" 
                                            aria-expanded="false" 
                                            aria-controls="collapseSeven">
                                            <?php echo htmlspecialchars($tips['Tip_7']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseSeven" 
                                        class="accordion-collapse collapse show" 
                                        aria-labelledby="headingSeven" 
                                        data-bs-parent="#proposalAccordion">
                                        <div class="accordion-body ">
                                            <p class="text-secondary small text-justify">
                                                <?php echo htmlspecialchars($tips['Tip_7']['tipDescription']); ?>
                                            </p>
                                            <div class="card mt-3 mb-1 bg-light">
                                                <div class="card-body pb-2">
                                                    <h6 class="fst-italic text-muted small">
                                                        <?php echo htmlspecialchars($tips['Tip_7']['tipExample']['lineOne']); ?>
                                                    </h6>
                                                    <h6 class="fst-italic text-muted small">
                                                        <?php echo htmlspecialchars($tips['Tip_7']['tipExample']['lineTwo']); ?>
                                                    </h6>
                                                    <h6 class="fst-italic text-muted small">
                                                        <?php echo htmlspecialchars($tips['Tip_7']['tipExample']['lineThree']); ?>
                                                    </h6>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- /tip #7 -->
                            </div>
                        </div>
                    </div>
                    <!-- /proposal tips: collapsible content -->
                </div>
            </div>
            <!-- /proposal tips -->
        </div>
        <!-- /proposal -->

    </div>
</section>

</body>
</html>