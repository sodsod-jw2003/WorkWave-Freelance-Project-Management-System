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

// Handle personal information form submission
$(document).on('submit', '#personalInfoForm', function(e) {
    e.preventDefault();
    
    $.ajax({
        url: '../../dist/php/process/proc_update_personal_info.php',
        type: 'POST',
        data: $(this).serialize(),
        dataType: 'json',
        success: function(response) {
            if(response.success) {
                // Update profile card name
                const fullName = $('#first_name').val() + ' ' + $('#last_name').val();
                $('.container.fs-5.text-center.mt-3').text(fullName);
                // Update job title using selected option text
                const jobTitle = $('#job_title option:selected').text();
                $('.container.fs-6.text-center.text-muted.mb-5').text(jobTitle);
                updateSidebarInfo();
            } else {
                alert(response.message || 'Failed to update personal information');
            }
        }
    });
  });function updateSidebarInfo() {
    $.ajax({        url: '../../dist/php/process/proc_get_sidebar_info.php',
        type: 'GET',
        success: function(response) {
            $('#personalInformationCollapse .card-body').html(response);
        }
    });
}

// Handle password change form submission
$(document).on('submit', '#passwordChangeForm', function(e) {
    e.preventDefault();
    
    // Verify passwords match
    const password = $('#change_password').val();
    const confirmPassword = $('#confirm_password').val();
    
    if (password !== confirmPassword) {
        alert('Passwords do not match');
        return;
    }
    
    $.ajax({
        url: '../../dist/php/process/proc_profile_update_password.php',
        type: 'POST',
        data: $(this).serialize(),
        dataType: 'json',
        success: function(response) {
            if(response.success) {
                // Clear form
                $('#passwordChangeForm')[0].reset();
                // Show success message
                alert('Password updated successfully');
            } else {
                alert(response.message || 'Failed to update password');
            }
        }
    });
});

  document.addEventListener('DOMContentLoaded', async () => {
    const nationalityInput = document.getElementById('nationality');
    const nationalityList = document.getElementById('nationalities');
    const languageInput = document.getElementById('language');
    const languageList = document.getElementById('languages');

    let nationalities = [];
    let languages = [];

    try {
        const response = await fetch('https://gist.githubusercontent.com/DongDANN/c41bba3f66514fcfb7e63ae3ea2e4281/raw/a49b5fdedc2e6fbff2a971b94496a20dad7f0f6c/gistfile1.txt');
        const data = await response.json();

        // Save fetched data for filtering
        nationalities = data.nationalities;
        languages = data.languages;

    } catch (error) {
        console.log('Loading fallback data');
        const fallbackData = {
            nationalities: [
                'American', 'British', 'Canadian', 'Chinese', 'Filipino',
                'French', 'German', 'Indian', 'Japanese', 'Korean'
            ],
            languages: [
                'Arabic', 'Chinese', 'English', 'Filipino', 'French',
                'German', 'Hindi', 'Japanese', 'Korean', 'Spanish'
            ]
        };

        // Save fallback data for filtering
        nationalities = fallbackData.nationalities;
        languages = fallbackData.languages;
    }

    // Helper function to update datalist options
    const updateDatalist = (input, list, options) => {
        list.innerHTML = ''; // Clear previous options
        const value = input.value.toLowerCase();
        if (value) {
            const filteredOptions = options.filter(option =>
                option.toLowerCase().startsWith(value)
            );
            filteredOptions.forEach(option => {
                const optionElement = document.createElement('option');
                optionElement.value = option;
                list.appendChild(optionElement);
            });
        }
    };

    // Add event listener for nationality input
    nationalityInput.addEventListener('keyup', () => {
        updateDatalist(nationalityInput, nationalityList, nationalities);
    });

    // Add event listener for language input
    languageInput.addEventListener('keyup', () => {
        updateDatalist(languageInput, languageList, languages);
    });
});


document.addEventListener('DOMContentLoaded', function() {
    const cityInput = document.getElementById('city');
    
    const autocomplete = new google.maps.places.Autocomplete(cityInput, {
        types: ['(cities)'],
        fields: ['address_components', 'formatted_address'],
        componentRestrictions: { country: 'PH' }
    });

    autocomplete.addListener('place_changed', function() {
        const place = autocomplete.getPlace();
        let city = '';
        let country = '';

        // Extract city and country from address components
        place.address_components.forEach(component => {
            if (component.types.includes('locality')) {
                city = component.long_name;
            }
            if (component.types.includes('country')) {
                country = component.long_name;
            }
        });

        // Set the input value to "City, Country" format
        cityInput.value = city + ', ' + country;
    });
});

// variable for saved categories
let savedCategories = '';

function loadSkillCategories() {
    $.ajax({
        url: '../../dist/php/process/proc_get_skills_category.php',
        type: 'GET',
        success: function (response) {
            try {
                const categories = JSON.parse(response);

                savedCategories = categories
                    .map(category => `<option value="${category.skill_category}">${category.skill_category}</option>`)
                    .join('');
            } catch (error) {
                console.error('JSON parse error:', error.message);
                alert('An error occurred while processing the data.');
            }
        },
        error: function () {
            console.error('Failed to fetch skill categories.');
            alert('Unable to load categories. Try again.');
        }
    });
}
  // categoories fetching for add project
  $(document).ready(function () {
      loadSkillCategories();
      loadProjects();
      updateSidebarProjects();
  });

// Add project form
$('#addProject').click(function () {
    if (!savedCategories) {
        Swal.fire({
            icon: 'warning',
            title: 'Categories Not Loaded',
            text: 'Categories are not loaded yet. Please wait.',
        });
        return;
    }

    const newProjectForm = `
        <form id="addProjectForm" class="needs-validation" novalidate>
            <div class="card px-3 pt-3 pb-1 mx-2 mb-3 bg-light border-start-accent">
                <div class="row">
                    <div class="col-md-5 mb-1">
                        <label for="project_title" class="text-muted small mb-2 ms-1">Project Title</label>
                        <input type="text" 
                            name="project_title" 
                            id="project_title" 
                            class="form-control bg-white-100 no-outline-green-focus border-1" 
                            required>
                        <div class="invalid-feedback">Enter a project title.</div>
                    </div>
                    <div class="col-md-4 mb-1">
                        <label for="project_category" class="text-muted small mb-2 ms-1">Category</label>
                        <select 
                            name="project_category" 
                            id="project_category" 
                            class="form-select bg-white-100 no-outline-green-focus border-1 w-100 project_category"
                            required>
                            <option value="" disabled selected>Select Category</option>
                            ${savedCategories}
                        </select>
                        <div class="invalid-feedback">Select a category.</div>
                    </div>
                    <div class="col-md-3 mb-1">
                        <label for="status" class="text-muted small mb-2 ms-1">Status</label>
                        <select 
                            name="status" 
                            id="status" 
                            class="form-select bg-white-100 no-outline-green-focus border-1 w-100"
                            required>
                            <option value="" disabled selected>Select Status</option>
                            <option value="Hiring">Hiring</option>
                            <option value="In Progress">In Progress</option>
                            <option value="Completed">Completed</option>
                        </select>
                        <div class="invalid-feedback">Select a status.</div>
                    </div>
                </div>
                <div class="row mt-1">
                    <div class="col-md-12 mb-1">
                        <label for="project_description" class="text-muted small mb-2 ms-1">Project Description</label>
                        <textarea 
                            name="project_description" 
                            id="project_description" 
                            class="form-control bg-white-100 no-outline-green-focus border-1"
                            required></textarea>
                        <div class="invalid-feedback">Enter a project description.</div>
                    </div>
                </div>
                <div class="row mt-1">
                    <div class="col-md-6 mb-1">
                        <label for="connect_cost" class="text-muted small mb-2 ms-1">Connect Cost</label>
                        <input type="number" 
                            name="connect_cost" 
                            id="connect_cost" 
                            class="form-control bg-white-100 no-outline-green-focus border-1" 
                            min="5"
                            max="10" 
                            required>
                        <div class="invalid-feedback">Enter a connect cost between 5 and 10.</div>
                    </div>
                    <div class="col-md-6 mb-1">
                        <label for="merit_worth" class="text-muted small mb-2 ms-1">Merit</label>
                        <input type="number" 
                            name="merit_worth" 
                            id="merit_worth" 
                            class="form-control bg-white-100 no-outline-green-focus border-1" 
                            min="10"
                            max="50" 
                            required>
                        <div class="invalid-feedback">Enter a merit worth between 10 and 50.</div>
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
    $('#projectContainer').prepend(newProjectForm);
});

// handle project add
$(document).on('submit', '#addProjectForm', function (e) {
    e.preventDefault();
    
    // Bootstrap validation
    const form = this;
    if (!form.checkValidity()) {
        e.stopPropagation();
        $(form).addClass('was-validated');
        return;
    }

    // Gather project data
    const projectData = {
        project_title: $('#project_title').val(),
        project_category: $('#project_category').val(),
        project_description: $('#project_description').val(),
        status: $('#status').val(),
        connect_cost: $('#connect_cost').val(),
        merit_worth: $('#merit_worth').val()
    };

    // AJAX request
    $.ajax({
        url: '../../dist/php/process/proc_add_project.php',
        type: 'POST',
        data: projectData,
        dataType: 'json',
        success: function (response) {
            if (response.success) {
                Swal.fire({
                    icon: 'success',
                    title: 'Project Added',
                    text: 'The project was successfully added.',
                });

                // Add the new project card
                const newProjectCard = `
                    <div class="card px-3 pt-3 pb-1 mx-2 mb-3 bg-light border-start-accent" data-project-id="${response.project_id}">
                        <div class="container d-flex justify-content-between align-items-center my-2">
                            <h5><a href="project_details.php?id=${response.project_id}" class="text-dark fw-semibold">${projectData.project_title}</a></h5>
                            <span class="badge bg-success mb-2">${projectData.status}</span>
                        </div>
                        <div class="container mb-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6>${projectData.project_category}</h6>
                                    <h6 class="text-muted small">${projectData.project_description.substring(0, 10)}...</h6>
                                </div>
                                <div>
                                    <button class="btn btn-outline-primary edit-project"><i class="fas fa-edit"></i></button>
                                    <button class="btn btn-outline-danger delete-project"><i class="fas fa-trash"></i></button>
                                </div>
                            </div>
                        </div>
                        <div class="container">
                            <span class="text-secondary small">Costs: </span>
                            <span class="text-green-50 fw-semibold small">${projectData.connect_cost} Connects</span>
                        </div>
                        <div class="container mb-3">
                            <span class="text-secondary small">Worth: </span>
                            <span class="text-green-50 fw-semibold small">${projectData.merit_worth} Merit</span>
                        </div>
                    </div>
                `;
                $('#projectContainer').prepend(newProjectCard);
                $('#addProjectForm').remove();
                updateSidebarProjects();
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Failed to Add Project',
                    text: response.message,
                });
            }
        },
        error: function () {
            Swal.fire({
                icon: 'error',
                title: 'Error Occurred',
                text: 'There was an issue adding the project. Try again.',
            });
        },
    });
});

// Edit project
$(document).on('click', '.edit-project', function () {
    const projectCard = $(this).closest('.card');
    const projectId = projectCard.data('project-id');

    $.ajax({
        url: '../../dist/php/process/proc_get_project_details.php',
        type: 'GET',
        data: { project_id: projectId },
        dataType: 'json',
        success: function (project) {
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
                                    ${savedCategories}
                                </select>
                                <div class="invalid-feedback">Select a category.</div>
                            </div>
                            <div class="col-md-3 mb-1">
                                <label class="text-muted small mb-2 ms-1">Status</label>
                                <select name="status" class="form-select no-outline-green-focus" required>
                                    <option value="Hiring" ${project.project_status === 'Hiring' ? 'selected' : ''}>Hiring</option>
                                    <option value="In Progress" ${project.project_status === 'In Progress' ? 'selected' : ''}>In Progress</option>
                                    <option value="Completed" ${project.project_status === 'Completed' ? 'selected' : ''}>Completed</option>
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
                            <div class="col-md-6 mb-1">
                                <label for="connect_cost" class="text-muted small mb-2 ms-1">Connect Cost</label>
                                <input type="number" 
                                    name="connect_cost" 
                                    id="connect_cost" 
                                    class="form-control bg-white-100 no-outline-green-focus border-1" 
                                    min="5"
                                    max="10"
                                    value="${project.project_connect_cost}" 
                                    required>
                                <div class="invalid-feedback">Connect cost must be between 5 and 10.</div>
                            </div>
                            <div class="col-md-6 mb-1">
                                <label for="merit_worth" class="text-muted small mb-2 ms-1">Merit</label>
                                <input type="number" 
                                    name="merit_worth" 
                                    id="merit_worth" 
                                    class="form-control bg-white-100 no-outline-green-focus border-1" 
                                    min="10"
                                    max="50" 
                                    value="${project.project_merit_worth}" 
                                    required>
                                <div class="invalid-feedback">Merit worth must be between 10 and 50.</div>
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
            $('select[name="project_category"]').val(project.project_category);
        }
    });
});

// Handle project update with client side validation and swal
$(document).on('submit', '#editProjectForm', function (e) {
    e.preventDefault();

    // Check if form is valid
    const form = $(this)[0];
    if (!form.checkValidity()) {
        e.stopPropagation();
        form.classList.add('was-validated');
        return;
    }

    const projectTitle = $('input[name="project_title"]').val().trim();
    const projectCategory = $('select[name="project_category"]').val();
    const projectStatus = $('select[name="status"]').val();
    const projectDescription = $('textarea[name="project_description"]').val().trim();
    const connectCost = $('input[name="connect_cost"]').val().trim();
    const meritWorth = $('input[name="merit_worth"]').val().trim();

    if (connectCost < 5 || connectCost > 10) {
        Swal.fire({
            icon: 'error',
            title: 'Invalid Connect Cost',
            text: 'Connect Cost must be between 5 and 10.',
        });
        return;
    }

    if (meritWorth < 10 || meritWorth > 50) {
        Swal.fire({
            icon: 'error',
            title: 'Invalid Merit Worth',
            text: 'Merit Worth must be between 10 and 50.',
        });
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
        success: function (response) {
            if (response.success) {
                Swal.fire({
                    icon: 'success',
                    title: 'Project Updated',
                    text: 'The project has been updated successfully.',
                });
                loadProjects();
                updateSidebarProjects();
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Update Failed',
                    text: 'There was an error updating the project.',
                });
            }
        },
        error: function () {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'An error occurred while processing your request.',
            });
        }
    });
});


// Delete project with SweetAlert confirmation and success
$(document).on('click', '.delete-project', function () {
    const projectCard = $(this).closest('.card');
    const projectId = projectCard.data('project-id');

    // SweetAlert confirmation before deletion
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
            // Proceed with the deletion
            $.ajax({
                url: '../../dist/php/process/proc_manage_project.php',
                type: 'POST',
                data: {
                    action: 'delete',
                    project_id: projectId
                },
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        // SweetAlert success message after deletion
                        Swal.fire({
                            icon: 'success',
                            title: 'Deleted!',
                            text: 'Your project has been deleted.',
                        });

                        // Reload projects and update sidebar
                        loadProjects();
                        updateSidebarProjects();
                    } else {
                        // SweetAlert error message if deletion fails
                        Swal.fire({
                            icon: 'error',
                            title: 'Oops...',
                            text: 'There was an issue deleting the project.',
                        });
                    }
                },
                error: function () {
                    // SweetAlert error if the request fails
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'An error occurred while processing your request.',
                    });
                }
            });
        }
    });
});


  // Cancell add
  $(document).on('click', '#cancelAddProject', function () {
      $(this).closest('.card').remove();
  });

  // Cancel edit
  $(document).on('click', '.cancel-edit', function() {
          loadProjects();
  });

  // Load projects
  function loadProjects() {
          $.ajax({
              url: '../../dist/php/process/proc_get_projects.php',
              type: 'GET',
              success: function(response) {
                  const projects = JSON.parse(response);
                  let projectsHTML = '';
                
                  projects.forEach(project => {
                      projectsHTML += `
                          <div class="card px-3 pt-3 pb-1 mx-2 mb-3 bg-light border-start-accent" data-project-id="${project.project_id}">
                              <div class="container d-flex justify-content-between align-items-center my-2">
                                  <h5><a href="project_details.php?id=${project.project_id}" class="text-dark fw-semibold">${project.project_title}</a></h5>
                                  <span class="badge bg-success mb-2">${project.project_status}</span>
                              </div>
                              <div class="container mb-2">
                                  <div class="d-flex justify-content-between align-items-center">
                                      <div class="">
                                          <h6 class="">${project.project_category}</h6>
                                          <h6 class="text-muted small">${project.project_description.length > 10 ? project.project_description.substring(0, 25) + '...' : project.project_description}</h6>     
                                      </div>
                                      <div class="">
                                          <button class="btn btn-outline-primary edit-project"><i class="fas fa-edit"></i></button>
                                          <button class="btn btn-outline-danger delete-project"><i class="fas fa-trash"></i></button>
                                      </div>                                  
                                  </div>
                              </div>
                              <div class="container">
                                  <span class="text-secondary small">Costs: </span>
                                  <span class="text-green-50 fw-semibold small">${project.project_connect_cost} Connects</span>
                              </div>
                              <div class="container mb-3">
                                  <span class="text-secondary small">Worth: </span>
                                  <span class="text-green-50 fw-semibold small">${project.project_merit_worth} Merit</span>
                              </div>
                          </div>
                      `;
                  });
                
                  $('#projectContainer').html(projectsHTML);
              }
          });
  }

  function updateSidebarProjects() {
      $.ajax({
          url: '../../dist/php/process/proc_get_sidebar_projects.php',
          type: 'GET',
          success: function(response) {
              $('#projectHistoryCollapse .card-body').html(response);
          }
      });
  }
