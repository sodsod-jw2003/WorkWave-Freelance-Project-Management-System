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
$project_id = $_GET['id'];

// Check existing application
$check_query = "SELECT * FROM v_applications
                JOIN v_applications_ids ON v_applications.id = v_applications_ids.id
                WHERE project_id = ? AND user_id = ?";
$stmt = $mysqli->prepare($check_query);
$stmt->bind_param("ii", $project_id, $_SESSION['user_id']);
$stmt->execute();
$existing_application = $stmt->get_result()->fetch_assoc();


$query1 = "SELECT v_project_details.*,  v_user_profile.first_name AS client_name FROM v_project_details 
           JOIN v_user_profile ON v_user_profile.id = v_project_details.project_owner
          WHERE v_project_details.id = ?";
$stmt = $mysqli->prepare($query1);
$stmt->bind_param("i", $project_id);
$stmt->execute();
$result = $stmt->get_result();
$project = $result->fetch_assoc();
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

    <!-- project_id -->
    <script>const projectId = <?php echo json_encode($project_id); ?>;</script>
    
    <!-- freelancer_application.js -->
    <script src="../../dist/js/freelancer_application.js"></script>

    <!-- SweetAlert2 CDN -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.botpress.cloud/webchat/v2.2/inject.js"></script>
    <script src="https://files.bpcontent.cloud/2024/12/12/18/20241212181227-C50YEH0A.js"></script>
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
                            <a href="dashboard.php"><?php echo htmlspecialchars($user['first_name']); ?>'s Dashboard</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page"><?php echo htmlspecialchars($project['project_title']); ?></li>
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
                        <h3 class="fw-semibold text-green-50"><?php echo htmlspecialchars($project['project_title']); ?></h3>
                        <span>
                            <span class="me-2">
                                <span class="text-muted">Cost:</span>
                                <span class="fw-semibold text-green-40"><?php echo htmlspecialchars($project['project_connect_cost']); ?></span>
                                <span class="fw-semibold text-green-40">Connects</span>
                            </span>
                            <span class="">
                                <span class="text-muted">Worth:</span>
                                <span class="fw-semibold text-green-40"><?php echo htmlspecialchars($project['project_merit_worth']); ?></span>
                                <span class="fw-semibold text-green-40">Merits</span>
                            </span>
                        </span>
                    </div>
                    <hr class="divider">
                    <div class="d-flex align-items-center mb-2 text-green-50">
                        <span class="fas fa-diagram-project fs-6 me-2"></span>
                        <span class="fs-5 fw-semibold"><?php echo htmlspecialchars($project['project_category']); ?></span>
                    </div>
                    <h6 class="text-muted small text-justify mb-0"><?php echo nl2br(htmlspecialchars($project['project_description'])); ?></h6>
                </div>
            </div>            <!-- /proj title, category, description, and cost connects -->
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
                    <form id="proposalForm" class="row g-3 needs-validation" novalidate>
                        <input type="hidden" name="project_id" value="<?php echo htmlspecialchars($project_id); ?>">

                        <div class="col-md-12 mb-1">
                            <label for="proposal" class="text-muted small mb-2">Write a cover letter <i>(Why should <?php echo htmlspecialchars($project['client_name']); ?> hire you?)</i></label>
                            <textarea 
                                name="application_details" 
                                id="proposal" 
                                class="form-control bg-light no-outline-green-focus border-1" 
                                rows="3" 
                                required
                                <?php echo $existing_application ? 'disabled' : ''; ?>
                            ><?php echo $existing_application ? htmlspecialchars($existing_application['application_details']) : ''; ?></textarea>
                            <div class="invalid-feedback">Write a cover letter.</div>
                        </div>

                        <div class="col-md-12 mb-1">
                            <label for="portfolio_link" class="text-muted small mb-2">Enter link to your portfolio <i>(if you have any)</i></label>
                            <input 
                                type="url" 
                                name="portfolio_url" 
                                id="portfolio_link" 
                                class="form-control bg-light no-outline-green-focus border-1 w-100" 
                                placeholder="https://" 
                                value="<?php echo $existing_application ? htmlspecialchars($existing_application['portfolio_url']) : ''; ?>"
                                required
                                <?php echo $existing_application ? 'disabled' : ''; ?>
                            >
                            <div class="invalid-feedback">Enter a valid URL for your portfolio.</div>
                        </div>

                        <div class="col-12">
                            <?php if ($existing_application): ?>
                                <button type="button" id="cancelProposal" class="btn btn-danger">Withdraw Application</button>
                            <?php else: ?>
                                <button type="submit" id="submitProposal" class="btn btn-dark-green">Submit Proposal</button>
                                <button type="button" id="cancelProposal" class="btn btn-secondary">Cancel</button>
                            <?php endif; ?>
                        </div>
                    </form>
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
                                        <button class="accordion-button bg-light no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseOne" 
                                            aria-expanded="false" 
                                            aria-controls="collapseOne">
                                            <?php echo htmlspecialchars($tips['Tip_1']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseOne" 
                                        class="accordion-collapse collapse " 
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
                                        <button class="accordion-button bg-light no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseTwo" 
                                            aria-expanded="false" 
                                            aria-controls="collapseTwo">
                                            <?php echo htmlspecialchars($tips['Tip_2']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseTwo" 
                                        class="accordion-collapse collapse " 
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
                                        <button class="accordion-button bg-light no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseThree" 
                                            aria-expanded="false" 
                                            aria-controls="collapseThree">
                                            <?php echo htmlspecialchars($tips['Tip_3']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseThree" 
                                        class="accordion-collapse collapse " 
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
                                        <button class="accordion-button bg-light no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseFour" 
                                            aria-expanded="false" 
                                            aria-controls="collapseFour">
                                            <?php echo htmlspecialchars($tips['Tip_4']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseFour" 
                                        class="accordion-collapse collapse " 
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
                                        <button class="accordion-button bg-light no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseFive" 
                                            aria-expanded="false" 
                                            aria-controls="collapseFive">
                                            <?php echo htmlspecialchars($tips['Tip_5']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseFive" 
                                        class="accordion-collapse collapse " 
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
                                        <button class="accordion-button bg-light no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseSix" 
                                            aria-expanded="false" 
                                            aria-controls="collapseSix">
                                            <?php echo htmlspecialchars($tips['Tip_6']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseSix" 
                                        class="accordion-collapse collapse " 
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
                                        <button class="accordion-button bg-light no-outline-green-focus" 
                                            type="button" 
                                            data-bs-toggle="collapse" 
                                            data-bs-target="#collapseSeven" 
                                            aria-expanded="false" 
                                            aria-controls="collapseSeven">
                                            <?php echo htmlspecialchars($tips['Tip_7']['tipTitle']); ?>
                                        </button>
                                    </h2>
                                    <div id="collapseSeven" 
                                        class="accordion-collapse collapse " 
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