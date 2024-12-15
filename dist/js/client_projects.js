document.addEventListener('DOMContentLoaded', function() {
    let savedCategories = '';
    loadSkillCategories();
    loadProjects();

    document.querySelector('#addProject').addEventListener('click', function() {
        const newProjectForm = `
            <form id="addProjectForm" class="needs-validation" novalidate>
                <div class="card px-3 pt-3 pb-1 mx-2 mb-3 bg-light border-start-accent">
                    <div class="row">
                        <div class="col-md-5 mb-1">
                            <label for="project_title" class="text-muted small mb-2 ms-1">Project Title</label>
                            <input type="text" name="project_title" id="project_title" class="form-control bg-white-100 no-outline-green-focus border-1" required>
                            <div class="invalid-feedback">Enter a project title.</div>
                        </div>
                        <div class="col-md-4 mb-1">
                            <label for="project_category" class="text-muted small mb-2 ms-1">Category</label>
                            <select name="project_category" id="project_category" class="form-select bg-white-100 no-outline-green-focus border-1 w-100 project_category" required>
                                <option value="" disabled selected>Select Category</option>
                                ${window.savedCategories}
                            </select>
                            <div class="invalid-feedback">Select a category.</div>
                        </div>
                        <div class="col-md-3 mb-1">
                            <label for="status" class="text-muted small mb-2 ms-1">Status</label>
                            <select name="status" id="status" class="form-select bg-white-100 no-outline-green-focus border-1 w-100" required>
                                <option value="" disabled selected>Select Status</option>
                                <option value="1">Hiring</option>
                                <option value="2">In Progress</option>
                                <option value="3">Completed</option>
                            </select>
                            <div class="invalid-feedback">Select a status.</div>
                        </div>
                    </div>
                    <div class="row mt-1">
                        <div class="col-md-12 mb-1">
                            <label for="project_description" class="text-muted small mb-2 ms-1">Project Description</label>
                            <textarea name="project_description" id="project_description" class="form-control bg-white-100 no-outline-green-focus border-1" required></textarea>
                            <div class="invalid-feedback">Enter a project description.</div>
                        </div>
                    </div>
                    <div class="row mt-1">
                        <div class="col-md-12 mb-1">
                            <label for="project_objective" class="text-muted small mb-2 ms-1">Project Objective</label>
                            <textarea name="project_objective" id="project_objective" class="form-control bg-white-100 no-outline-green-focus border-1" required></textarea>
                            <div class="invalid-feedback">Enter a project objective.</div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="container pt-3 mb-3">
                            <button type="submit" class="btn btn-dark-green">Save Project</button>
                            <button type="button" class="btn btn-secondary" id="cancelAddProject">Cancel</button>
                        </div>
                    </div>
                </div>
            </form>
        `;
        document.querySelector('#projectFormContainer').innerHTML = newProjectForm;
    });

    // Handle form submission
    document.addEventListener('submit', function(e) {
        if (e.target && e.target.id === 'addProjectForm') {
            e.preventDefault();
            
            if (!e.target.checkValidity()) {
                e.stopPropagation();
                e.target.classList.add('was-validated');
                return;
            }

            const formData = new FormData(e.target);
            fetch('../../dist/php/process/proc_add_project.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.querySelector('#projectFormContainer').innerHTML = '';
                    Swal.fire({
                        icon: 'success',
                        title: 'Project Added',
                        text: 'The project has been added successfully.'
                    });
                    loadProjects();
                }
            });
        }
    });

    // Handle cancel button
    document.addEventListener('click', function(e) {
        if (e.target && e.target.id === 'cancelAddProject') {
            document.querySelector('#projectFormContainer').innerHTML = '';
        }
    });
});

function loadSkillCategories() {
    fetch('../../dist/php/process/proc_get_skills_category.php')
        .then(response => response.json())
        .then(categories => {
            
            window.savedCategories = categories
                .map(category => `<option value="${category.id}">${category.skills_category}</option>`)
                .join('');

        })
        .catch(error => console.log('Error loading categories:', error));
}

function loadProjects() {
    fetch('../../dist/php/process/proc_get_projects.php')
        .then(response => response.json())
        .then(projects => {

            const projectsContainer = document.querySelector('.row.px-4');
            let projectsHTML = '';
            
            if (projects.length > 0) {
                projects.forEach(project => {
                    projectsHTML += `
                        <div class="col-12 d-flex justify-content-center align-items-center p-4 rounded shadow-sm border mb-3 bg-light" data-project-id="${project.id}">
                            <div class="col-12">
                                <div class="row align-items-center px-3 py-2 rounded-top">
                                    <div class="col-md-6 d-flex align-items-center ps-0">
                                        <h5 class="mb-0">
                                            <a href="project_details.php?id=${project.id}" class="text-green-50 fs-4 text-decoration-none fw-semibold">
                                                ${project.project_title}
                                            </a>
                                            <span class="badge bg-secondary text-white ms-2 small">
                                                Posted ${new Date(project.created_at).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })}
                                            </span>
                                        </h5>
                                    </div>
                                    <div class="col-md-6 d-flex justify-content-end pe-0">
                                        <span class="badge bg-success">
                                            ${project.project_status}
                                        </span>
                                    </div>
                                </div>
                                <div class="row align-items-center px-3 py-2 rounded-bottom">
                                    <div class="col-md-6 d-flex align-items-center ms-0 ps-0">
                                        <i class="${getCategoryIcon(project.project_category)} me-3 text-green-50 fa-2x"></i>
                                        <span class="fs-5">
                                            ${project.project_category}
                                        </span>
                                    </div>
                                    <div class="col-md-6 d-flex justify-content-end pe-0">
                                        <a href="project_details.php?id=${project.id}" class="btn btn-secondary me-2">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <button class="btn btn-primary me-2 edit-project">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-danger delete-project">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `;
                });
            } else {
                projectsHTML = `
                    <div class="col-12 text-center py-4">
                        <p>No projects found.</p>
                    </div>
                `;
            }
            
            projectsContainer.innerHTML = projectsHTML;
        });
}


function getCategoryIcon(category) {
    const icons = {
        'Writing': 'fa-solid fa-pen-nib',
        'Translation': 'fa-solid fa-language',
        'Graphic Design': 'fa-solid fa-user-pen',
        'Video and Animation': 'fa-solid fa-video',
        'UI/UX Design': 'fa-brands fa-figma',
        'Web Development': 'fa-solid fa-globe',
        'Mobile Development': 'fa-solid fa-mobile',
        'Software Development': 'fa-solid fa-file-code',
        'Digital Marketing': 'fa-solid fa-store',
        'Sales Support': 'fa-solid fa-phone',
        'Advertising': 'fa-solid fa-megaphone',
        'Virtual Assistance': 'fa-solid fa-headset',
        'Data Entry': 'fa-solid fa-database',
        'Customer Support': 'fa-solid fa-phone',
        'Financial Skills': 'fa-solid fa-coins',
        'Business Consulting': 'fa-solid fa-briefcase',
        'Human Resources': 'fa-solid fa-users',
        'IT Support': 'fa-solid fa-screwdriver-wrench',
        'Networking': 'fa-solid fa-network-wired',
        'DevOps': 'fa-solid fa-gears',
        'Engineering': 'fa-solid fa-helmet-safety',
        'Architecture': 'fa-brands fa-unity',
        'Manufacturing': 'fa-solid fa-industry',
        'Coaching & Development': 'fa-solid fa-notes-medical',
        'Health & Wellness': 'fa-solid fa-shield-heart',
        'Contract & Documentation': 'fa-solid fa-file-contract',
        'Compliance & Research': 'fa-solid fa-book',
        'Data Processing': 'fa-solid fa-chart-simple',
        'Advanced Analytics': 'fa-solid fa-chart-line',
        'Game Development Support': 'fa-solid fa-gamepad',
        'Monetization & Coaching': 'fa-solid fa-chalkboard-user'
    };
    return icons[category] || 'fas fa-folder'; // Default icon if category not found
}

// Edit project handler
$(document).on('click', '.edit-project', function() {
    const projectCard = $(this).closest('[data-project-id]');
    const projectId = projectCard.data('project-id');
    console.log('Edit clicked for project:', projectId);

    $.ajax({
        url: '../../dist/php/process/proc_get_project_details.php',
        type: 'GET',
        data: { project_id: projectId },
        dataType: 'json',
        success: function(project) {
            const editForm = `
                <form id="editProjectForm" data-project-id="${projectId}" class="needs-validation" novalidate>
                    <div class="card px-3 pt-3 pb-1 mx-2 mb-3 bg-light border-start-accent">
                        <div class="row">
                            <div class="col-md-5 mb-1">
                                <label class="text-muted small mb-2 ms-1">Project Title</label>
                                <input type="text" name="project_title" class="form-control no-outline-green-focus" value="${project.project_title}" required>
                                <div class="invalid-feedback">Provide a project title.</div>
                            </div>
                            <div class="col-md-4 mb-1">
                                <label class="text-muted small mb-2 ms-1">Category</label>
                                <select name="project_category" class="form-select no-outline-green-focus" required>
                                    ${window.savedCategories}
                                </select>
                                <div class="invalid-feedback">Select a category.</div>
                            </div>
                            <div class="col-md-3 mb-1">
                                <label class="text-muted small mb-2 ms-1">Status</label>
                                <select name="status" class="form-select no-outline-green-focus" required>
                                    <option value="1" ${project.project_status === 'Hiring' ? 'selected' : ''}>Hiring</option>
                                    <option value="2" ${project.project_status === 'In Progress' ? 'selected' : ''}>In Progress</option>
                                    <option value="3" ${project.project_status === 'Completed' ? 'selected' : ''}>Completed</option>
                                </select>
                                <div class="invalid-feedback">Select a status.</div>
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-md-12 mb-1">
                                <label class="text-muted small mb-2 ms-1">Project Description</label>
                                <textarea name="project_description" class="form-control no-outline-green-focus" required>${project.project_description}</textarea>
                                <div class="invalid-feedback">Provide a project description.</div>
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-md-12 mb-1">
                                <label class="text-muted small mb-2 ms-1">Project Objective</label>
                                <textarea name="project_objective" class="form-control no-outline-green-focus" required>${project.project_objective}</textarea>
                                <div class="invalid-feedback">Provide a project objective.</div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="container pt-3 mb-3">
                                <button type="submit" class="btn btn-dark-green">Update Project</button>
                                <button type="button" class="btn btn-secondary cancel-edit">Cancel</button>
                            </div>
                        </div>
                    </div>
                </form>
            `;

            projectCard.replaceWith(editForm);
            $('select[name="project_category"]').val(project.category_id);
        }
    });
});

// Handle edit form submission
$(document).on('submit', '#editProjectForm', function(e) {
    e.preventDefault();

    if (!this.checkValidity()) {
        e.stopPropagation();
        $(this).addClass('was-validated');
        return;
    }

    const projectId = $(this).data('project-id');
    const formData = $(this).serializeArray();
    formData.push({ name: 'action', value: 'update' });
    formData.push({ name: 'project_id', value: projectId });

    $.ajax({
        url: '../../dist/php/process/proc_manage_project.php',
        type: 'POST',
        data: formData,
        dataType: 'json',
        success: function(response) {
            if (response.success) {
                Swal.fire({
                    icon: 'success',
                    title: 'Project Updated',
                    text: 'The project has been updated successfully.'
                });
                loadProjects();
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Update Failed',
                    text: response.message || 'Failed to update project.'
                });
            }
        }
    });
});

// Cancel edit
$(document).on('click', '.cancel-edit', function() {
    loadProjects();
});

// DEelete
$(document).on('click', '.delete-project', function() {
    const projectId = $(this).closest('[data-project-id]').data('project-id');

    Swal.fire({
        title: 'Are you sure?',
        text: 'You won\'t be able to revert this!',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!',
        cancelButtonText: 'No, cancel!'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '../../dist/php/process/proc_manage_project.php',
                type: 'POST',
                data: {
                    action: 'delete',
                    project_id: projectId
                },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Deleted!',
                            text: 'Your project has been deleted.'
                        });
                        loadProjects();
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Oops...',
                            text: 'There was an issue deleting the project.'
                        });
                    }
                }
            });
        }
    });
});