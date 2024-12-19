document.addEventListener('DOMContentLoaded', function() {
    const notificationLinks = document.querySelectorAll('.dropdown-menu .dropdown-item');
    
    notificationLinks.forEach(link => {
        link.addEventListener('click', function() {
            const notificationId = this.dataset.notificationId;
            
            fetch('../../dist/php/process/proc_update_notification.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    notification_id: notificationId
                })
            });
        });
    });

    // New search functionality
    const searchInput = document.getElementById('headerSearchProjects');
    const searchResults = document.getElementById('headerSearchResults');


    let timeoutId;

    searchInput.addEventListener('input', function() {
        clearTimeout(timeoutId);
        
        timeoutId = setTimeout(() => {
            const searchTerm = this.value.trim();
            
            if (searchTerm.length > 0) {
                fetch('../../dist/php/process/proc_search_projects_clients.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ search: searchTerm })
                })
                .then(response => response.json())
                .then(data => {
                    searchResults.innerHTML = '';
                    
                    // Projects section
                    if (data.projects.length > 0) {
                        searchResults.innerHTML += '<li class="dropdown-header">Projects</li>';
                        data.projects.forEach(project => {
                            searchResults.innerHTML += `
                                <li>
                                    <a href="project_application.php?id=${project.id}" class="dropdown-item py-2">
                                        <div class="fw-bold">${project.project_title}</div>
                                        <small class="text-muted">${project.project_category}</small>
                                    </a>
                                </li>
                            `;
                        });
                    }

                    // Clients section
                    if (data.clients.length > 0) {
                        searchResults.innerHTML += '<li class="dropdown-header mt-2">Clients</li>';
                        data.clients.forEach(client => {
                            const profilePic = client.profile_picture_url || '../../img/default-profile.png';
                            searchResults.innerHTML += `
                                <li>
                                    <a href="view_client.php?id=${client.id}" class="dropdown-item py-2 d-flex align-items-center">
                                        <img src="${profilePic}" alt="Profile" class="rounded-circle me-2" style="width: 32px; height: 32px; object-fit: cover;" onerror="this.onerror=null; this.src='../../img/default-profile.png';">
                                        <div>
                                            <div class="fw-bold">${client.first_name} ${client.last_name}</div>
                                            ${client.job_title ? `<small class="text-muted">${client.job_title}</small>` : ''}
                                        </div>
                                    </a>
                                </li>
                            `;
                        });
                    }

                    if (data.projects.length === 0 && data.clients.length === 0) {
                        searchResults.innerHTML = '<li><div class="dropdown-item">No results found</div></li>';
                    }

                    $(searchResults).dropdown('show');
                });
            } else {
                $(searchResults).dropdown('hide');
            }
        }, 300);
    });
});
