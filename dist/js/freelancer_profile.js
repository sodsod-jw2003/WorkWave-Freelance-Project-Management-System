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
$(document).ready(function() {
    // Load existing job experiences
    loadJobExperiences();
    loadUserSkills();
    function loadJobExperiences() {
        $.ajax({
            url: '../../dist/php/process/proc_get_job_experiences.php',
            type: 'GET',
            success: function(response) {
                $('#jobExperienceContainer').html(response);
                updateSidebarJobs();
            }
        });
    }

    // Add new job experience button click
    $('#addJobExperience').click(function() {
        const newJobForm = `
            <div class="card mb-4">
                <div class="card-body bg-light border-start-accent rounded shadow-sm">
                    <form id="newJobForm" class="needs-validation" novalidate>
                        <div class="mb-3">
                            <input type="text" class="form-control no-outline-green-focus" name="job_title" placeholder="Job Title" required>
                            <div class="invalid-feedback">
                                Provide a job title.
                            </div>
                        </div>
                        <div class="mb-3">
                            <input type="text" class="form-control no-outline-green-focus" name="company_name" placeholder="Company Name" required>
                            <div class="invalid-feedback">
                                Provide a company name.
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col">
                                <input type="number" class="form-control no-outline-green-focus" name="start_year" placeholder="Start Year" min="1975" max="2025" required>
                                <div class="invalid-feedback">Provide a valid end year (1975-2025).</div>      
                            </div>
                            <div class="col">
                                <input type="number" class="form-control no-outline-green-focus" name="end_year" placeholder="End Year" min="1975" max="2025" required>
                                <div class="invalid-feedback">Provide a valid end year (1975-2025).</div>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-dark-green">Save Experience</button>
                        <button type="button" class="btn btn-secondary" id="cancelAdd">Cancel</button>
                    </form>
                </div>
            </div>
        `;
        $('#jobExperienceContainer').prepend(newJobForm);
    });

    // Handle new job form submission
    $(document).on('submit', '#newJobForm', function(e) {
        e.preventDefault();

        // Get form reference
        const form = this;

        // Check form validity
        if (form.checkValidity() === false) {
            // Add client-side validation if form is invalid
            form.classList.add('was-validated');
            return;
        }

        // Serialize form data
        const formData = $(this).serializeArray();
        const duration = formData.find(f => f.name === 'start_year').value + '-' + formData.find(f => f.name === 'end_year').value;

        // Send data via AJAX
        $.ajax({
            url: '../../dist/php/process/proc_add_job_experience.php',
            type: 'POST',
            data: {
                job_title: formData.find(f => f.name === 'job_title').value,
                company_name: formData.find(f => f.name === 'company_name').value,
                duration: duration
            },
            success: function(response) {
                // Success alert with SweetAlert2
                Swal.fire({
                    title: 'Success!',
                    text: 'Your job experience has been saved.',
                    icon: 'success',
                    confirmButtonText: 'OK'
                });

                // Reload job experiences
                loadJobExperiences();
                updateSidebarJobs();
            },
            error: function(xhr, status, error) {
                // Error alert with SweetAlert2
                Swal.fire({
                    title: 'Error!',
                    text: 'There was an issue saving your job experience. Please try again.',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
            }
        });
    });

    // Handle delete job experience
    $(document).on('click', '.delete-job', function () {
        const jobId = $(this).data('id');

        // SweetAlert2 confirmation modal
        Swal.fire({
            title: 'Are you sure?',
            text: 'This action cannot be undone. Do you want to delete this job experience?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                // Proceed with the deletion
                $.ajax({
                    url: '../../dist/php/process/proc_delete_job_experience.php',
                    type: 'POST',
                    data: { user_experience_id: jobId },
                    success: function (response) {
                        Swal.fire({
                            title: 'Deleted!',
                            text: 'Your job experience has been successfully deleted.',
                            icon: 'success',
                            confirmButtonText: 'OK'
                        });

                        // Remove the job card from the DOM
                        $(`[data-job-id="${jobId}"]`).remove();
                        updateSidebarJobs();
                    },
                    error: function () {
                        Swal.fire({
                            title: 'Error!',
                            text: 'There was an error deleting the job experience. Please try again.',
                            icon: 'error',
                            confirmButtonText: 'OK'
                        });
                    }
                });
            }
        });
    });

    // Cancel add form
    $(document).on('click', '#cancelAdd', function() {
        $(this).closest('.card').remove();
        });
    // Add edit button click handler
    $(document).on('click', '.edit-job', function () {
        const jobCard = $(this).closest('.job-card');
        const jobId = jobCard.data('job-id');
        const jobTitle = jobCard.find('.card-title').text();
        const companyName = jobCard.find('.card-subtitle').text();
        const duration = jobCard.find('.text-muted.small').text();
        const [startYear, endYear] = duration.split('-');

        const editForm = `
            <div class="card-body">
                <form class="edit-job-form needs-validation" data-id="${jobId}" novalidate>
                    <div class="mb-3">
                        <label for="job_title" class="form-label">Job Title</label>
                        <input type="text" class="form-control no-outline-green-focus" id="job_title" name="job_title" value="${jobTitle.trim()}" required>
                        <div class="invalid-feedback">Provide a job title.</div>
                    </div>
                    <div class="mb-3">
                        <label for="company_name" class="form-label">Company Name</label>
                        <input type="text" class="form-control no-outline-green-focus" id="company_name" name="company_name" value="${companyName.trim()}" required>
                        <div class="invalid-feedback">Provide a company name.</div>
                    </div>
                    <div class="row mb-3">
                        <div class="col">
                            <label for="start_year" class="form-label">Start Year</label>
                            <input type="number" class="form-control no-outline-green-focus" id="start_year" name="start_year" value="${startYear.trim()}" min="1975" max="2025" required>
                            <div class="invalid-feedback">Provide a valid start year (1975-2025).</div>
                        </div>
                        <div class="col">
                            <label for="end_year" class="form-label">End Year</label>
                            <input type="number" class="form-control no-outline-green-focus" id="end_year" name="end_year" value="${endYear.trim()}" min="1975" max="2025" required>
                            <div class="invalid-feedback">Provide a valid end year (1975-2025).</div>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-success">Update</button>
                    <button type="button" class="btn btn-secondary cancel-edit">Cancel</button>
                </form>
            </div>
        `;

        jobCard.html(editForm);
    });

    // Handle edit form submission with validation
    $(document).on('submit', '.edit-job-form', function (e) {
        e.preventDefault();
        const form = this;

        // Bootstrap validation
        if (!form.checkValidity()) {
            e.stopPropagation();
            $(form).addClass('was-validated');
            return;
        }

        const formData = $(form).serializeArray();
        const jobId = $(form).data('id');
        const duration = formData.find(f => f.name === 'start_year').value + '-' + formData.find(f => f.name === 'end_year').value;

        $.ajax({
            url: '../../dist/php/process/proc_update_job_experience.php',
            type: 'POST',
            data: {
                user_experience_id: jobId,
                job_title: formData.find(f => f.name === 'job_title').value,
                company_name: formData.find(f => f.name === 'company_name').value,
                duration: duration
            },
            success: function (response) {
                loadJobExperiences();
                updateSidebarJobs();

                // Show success message using Swal
                Swal.fire({
                    icon: 'success',
                    title: 'Job Updated!',
                    text: 'The job experience has been successfully updated.',
                    confirmButtonText: 'OK'
                });
            },
            error: function (xhr, status, error) {
                // Show error message using Swal
                Swal.fire({
                    icon: 'error',
                    title: 'Update Failed',
                    text: 'Something went wrong while updating the job experience.',
                    confirmButtonText: 'OK'
                });
            }
        });
    });

    // Cancel edit
    $(document).on('click', '.cancel-edit', function() {
        loadJobExperiences();
    });
});

function updateSidebarJobs() {
    $.ajax({
        url: '../../dist/php/process/proc_get_sidebar_jobs.php',
        type: 'GET',
        success: function(response) {
            $('#jobExperienceCollapse .card-body').html(response);
        }
    });
}

// Handle personal information form submission
$(document).on('submit', '#personalInfoForm', function (e) {
    e.preventDefault();

    // Validate the form
    const form = this;

    if (!form.checkValidity()) {
        // Apply Bootstrap's validation styling
        form.classList.add('was-validated');
        return;
    }

    // Proceed with AJAX if form is valid
    $.ajax({
        url: '../../dist/php/process/proc_update_personal_info.php',
        type: 'POST',
        data: $(form).serialize(),
        dataType: 'json',
        success: function (response) {
            if (response.success) {
                // Update sidebar dynamically
                updateSidebarInfo();

                // Update displayed full name
                const fullName = $('#first_name').val() + ' ' + $('#last_name').val();
                $('.container.fs-5.text-center.mt-3').text(fullName);

                // Update job title dynamically
                const jobTitle = $('#job_title option:selected').text();
                $('.container.fs-6.text-center.text-muted.mb-5').text(jobTitle);

                // Success alert
                Swal.fire({
                    title: 'Success!',
                    text: 'Your personal information has been updated.',
                    icon: 'success',
                    confirmButtonText: 'OK'
                });

                // Reset validation styling
                form.classList.remove('was-validated');
            } else {
                // Handle failure response
                Swal.fire({
                    title: 'Error!',
                    text: response.message || 'There was a problem updating your information.',
                    icon: 'error',
                    confirmButtonText: 'Try Again'
                });
            }
        },
        error: function () {
            // Handle network or server error
            Swal.fire({
                title: 'Error!',
                text: 'Unable to process your request. Please try again later.',
                icon: 'error',
                confirmButtonText: 'OK'
            });
        }
    });
});


function updateSidebarInfo() {
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
  function updateSidebarSkills() {
      $.ajax({
          url: '../../dist/php/process/proc_get_sidebar_skills.php',
          type: 'GET',
          success: function(response) {
              const data = JSON.parse(response);
              $('#skillsCollapse .card-body .container').first().html(data.icons);
              $('#skillsCollapse .card-body').children().not(':first').remove();
              $('#skillsCollapse .card-body').append(data.skills);
              // Reinitialize tooltips
              $('[data-bs-toggle="tooltip"]').tooltip();
          }
      });
  }

  // Load user skills on page load
  function loadUserSkills() {
      $.ajax({
          url: '../../dist/php/process/proc_get_user_skills.php',
          type: 'GET',
          success: function(response) {
              const userSkills = JSON.parse(response);
              // Check corresponding checkboxes
              userSkills.forEach(skill => {
                  $(`#skill_${skill.id}`).prop('checked', true);
              });
          }
      });
  }

  // Update skills form submission
  $(document).on('submit', '#skillsForm', function(e) {
      e.preventDefault();
    
      $.ajax({
          url: '../../dist/php/process/proc_update_user_skills.php',
          type: 'POST',
          data: $(this).serialize(),
          dataType: 'json',
          success: function(response) {
              if(response.success) {
                  updateSidebarSkills();
                  Swal.fire({
                    title: 'Success!',
                    text: 'Your skills has been saved.',
                    icon: 'success',
                    confirmButtonText: 'OK'
                });
              }
          }
      });
  });
  // Call on page load
  $(document).ready(function() {
      loadUserSkills();
      updateSidebarSkills();
  });

  document.addEventListener('DOMContentLoaded', async () => {
    const nationalityInput = document.getElementById('nationality');
    const nationalityList = document.getElementById('nationalities');
    const languageInput = document.getElementById('language');
    const languageList = document.getElementById('languages');

    let nationalities = [];
    let languages = [];

    try {
        // Using GitHub Gist raw URL - Replace with your own Gist URL
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
// Skills category dropdown handler
document.getElementById('skillCategory').addEventListener('change', function() {
    const selectedCategory = this.value;
    const skillGroups = document.querySelectorAll('.skill-group');
    
    skillGroups.forEach(group => {
        if (group.dataset.category === selectedCategory) {
            group.style.display = 'block';
        } else {
            group.style.display = 'none';
        }
    });
});

function loadUserSkills() {
    $.ajax({
        url: '../../dist/php/process/proc_get_user_skills.php',
        type: 'GET',
        success: function(response) {
            const userSkills = JSON.parse(response);
            console.log('User Skills:', userSkills);
            // Check corresponding checkboxes
            userSkills.forEach(skill => {
                $(`#skill_${skill.skill_id}`).prop('checked', true);
            });
        }
    });
}

document.getElementById('toggleMobile').addEventListener('click', function() {
    const mobileInput = document.getElementById('mobile_number');
    const icon = this.querySelector('span');
    
    if (mobileInput.type === 'password') {
        mobileInput.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        mobileInput.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
});