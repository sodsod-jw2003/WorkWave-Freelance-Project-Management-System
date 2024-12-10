<?php if ($projects): ?>
    <?php foreach($projects as $project): ?>
        <!-- project card -->
        <div class="card mb-4 shadow-sm bg-light border rounded-3">
            <div class="card-body">
                <!-- title and cons -->
                <div class="col-12 col d-flex justify-content-between mb-2">
                    <div class="col-md-6 pt-2 d-flex bg- align-items-center">
                        <a href="project_application.php?id=<?php echo htmlspecialchars($project['id']); ?>"
                        class="text-green-40 fw-semibold ps-2 fs-3">
                            <?php echo htmlspecialchars($project['project_title']); ?>
                        </a>
                    </div>
                    <div class="col-md-3 bg- d-flex align-items-center justify-content-end pe-2">
                        <span class="me-3">
                            <span class="text-muted">Cost:</span>
                            <span class="fw-semibold text-green-40"><?php echo htmlspecialchars($project['project_connect_cost']); ?></span>
                            <span class="fw-semibold text-green-40">Connects</span>
                        </span>
                        <span class="">
                            <span class="text-muted">Worth:</span>
                            <span class="fw-semibold text-green-40"><?php echo htmlspecialchars($project['project_merit_worth']); ?></span>
                            <span class="fw-semibold text-green-40">Merits</span>
                        </span>
                    </div>
                </div>

                <hr class="divider mx-2">

                <!-- project category -->
                <div class="col-12 col d-flex align-items-center justify-content-between mb-2">
                    <span class="d-flex align-items-center p-2 rounded-3 text-green-40">
                        <span class="fas fa-diagram-project fs-5"></span>
                        <span class="px-2 fs-5 fw-semibold"><?php echo htmlspecialchars($project['project_category']); ?></span>
                    </span>
                    <!-- buttons -->
                    <span class="d-flex align-items-center">
                        <span class="d-flex align-items-center p-2 rounded-3">
                            <div class="d-flex align-items-center">
                                <a href="project_application.php?id=<?php echo htmlspecialchars($project['id']); ?>" class="btn p-0" id="apply-btn">
                                    <i class="fas fa-hand fs-4 text-green-40"></i>
                                </a>
                            </div>
                        </span>
                        <span class="d-flex align-items-center p-2 me-2 rounded-3">
                            <div class="d-flex align-items-center">
                                <button class="btn p-0 heart-btn" data-project-id="<?php echo htmlspecialchars($project['id']); ?>">
                                    <i class="far fa-heart fs-4 text-danger heart-icon"></i>
                                </button>
                            </div>
                        </span>
                    </span>
                </div>

                <!-- project description -->
                <div class="col-12 col d-flex align-items-center mt-2">
                    <div class="px-2 text-muted small text-justify">
                        <?php echo htmlspecialchars($project['project_description']); ?>
                    </div>
                </div>

                <hr class="divider mx-2 mt-3">

                <!-- client name and posted time -->
                <div class="col-12 col d-flex align-items-center px-2 pt-0 mt-0">
                    <div class="col-md-6 d-flex bg- align-items-center">
                        <span>
                            <span class="text-muted me-1">Posted by:</span>
                            <span class="fw-semibold text-green-40"><?php echo htmlspecialchars($project['client_name']); ?></span>
                        </span>
                    </div>
                    <div class="col-md-6 d-flex bg- align-items-center justify-content-end">
                        <span class="text-muted small"><?php echo date('M j, Y', strtotime($project['created_at'])); ?></span>
                    </div>
                </div>
            </div>
        </div>
    <?php endforeach; ?>
<?php else: ?>
    <div class="card mb-4 shadow-sm bg-light border rounded-3">
        <div class="card-body text-center">
            <p class="mb-0">No projects found.</p>
        </div>
    </div>
<?php endif; ?>
