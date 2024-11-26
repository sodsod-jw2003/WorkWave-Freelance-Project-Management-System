// toggle change password
const togglePassword1 = document.querySelector("#togglePassword1");
const password = document.querySelector("#change_password");

togglePassword1.addEventListener("click", function () {
    const type = password.getAttribute("type") === "password" ? "text" : "password";
    password.setAttribute("type", type);
    this.querySelector("span").classList.toggle("fa-eye");
    this.querySelector("span").classList.toggle("fa-eye-slash");
});

// toggle confirm password
const togglePassword2 = document.querySelector("#togglePassword2");
const confirmPassword = document.querySelector("#confirm_password");

togglePassword2.addEventListener("click", function () {
    const type = confirmPassword.getAttribute("type") === "password" ? "text" : "password";
    confirmPassword.setAttribute("type", type);
    this.querySelector("span").classList.toggle("fa-eye");
    this.querySelector("span").classList.toggle("fa-eye-slash");
});

document.addEventListener('DOMContentLoaded', function() {
    const profilePicInput = document.getElementById('profile-pic-input');
    const profilePicForm = document.getElementById('profile-pic-form');

    //event listenner for profile picture click
    document.querySelector('.profile-pic-wrapper').addEventListener('click', function() {
        profilePicInput.click();
    });

    //file input change event
    profilePicInput.addEventListener('change', function() {
        if (this.files && this.files[0]) {
            const formData = new FormData(profilePicForm);
            
            fetch('../../dist/php/process/proc_update_profile_picture.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update profile picture preview
                    document.querySelector('.profile-pic').src = data.image_url;
                }
            });
        }
    });
});

// dynamic chev direction on collapse or expand
document.addEventListener("DOMContentLoaded", function () {
    const collapseElements = document.querySelectorAll(".collapse-section");

    collapseElements.forEach(collapseElement => {
        const toggleIcon = document.querySelector(`.icon-toggle[data-target="#${collapseElement.id}"]`);

        collapseElement.addEventListener("shown.bs.collapse", function () {
            toggleIcon.classList.remove("fa-chevron-down");
            toggleIcon.classList.add("fa-chevron-up");
        });

        collapseElement.addEventListener("hidden.bs.collapse", function () {
            toggleIcon.classList.remove("fa-chevron-up");
            toggleIcon.classList.add("fa-chevron-down");
        });
    });
});

// tooltio initializatiob
document.addEventListener("DOMContentLoaded", function () {
    // Initialize all tooltips on the page
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.forEach(function (tooltipTriggerEl) {
        new bootstrap.Tooltip(tooltipTriggerEl);
    });
});

    // Add new project button click
    $('#addProject').click(function() {
        const newProjectForm = `
            <div class="card px-3 pt-3 pb-1 mx-2 mb-3 bg-light border-start-accent">
                <div class="row">
                    <!-- project title -->
                    <div class="col-md-5 mb-1">
                        <label for="project_title" class="text-muted small mb-2 ms-1">Project Title</label>
                        <input type="text" 
                            name="project_title" 
                            id="project_title" 
                            class="form-control bg-white-100 no-outline-green-focus border-1" 
                            value="">
                    </div>
                    <!-- /project title -->
                    <!-- category -->
                    <div class="col-md-4 mb-1">
                        <label for="project_category" class="text-muted small mb-2 ms-1">Category</label>
                        <select 
                            name="project_category" 
                            id="project_category" 
                            class="form-select bg-white-100 no-outline-green-focus border-1 w-100">
                        </select>
                    </div>
                    <!-- /category -->
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
                    <!-- project description -->
                    <div class="col-md-12 mb-1">
                        <label for="project_description" class="text-muted small mb-2 ms-1">Project Description</label>
                        <textarea 
                            name="project_description" 
                            id="project_description" 
                            class="form-control bg-white-100 no-outline-green-focus border-1"></textarea>
                    </div>
                    <!-- /project description -->
                </div>
                <div class="row">
                    <!-- project controls -->
                    <div class="container pt-3 mb-3">
                        <button type="submit" class="btn btn-dark-green">Save Project</button>
                        <button type="button" class="btn btn-secondary" id="cancelAddProject">Cancel</button>
                    </div>
                    <!-- /project controls -->
                </div>
            </div>
        `;
        $('#projectContainer').prepend(newProjectForm);
    });