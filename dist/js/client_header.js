document.addEventListener('DOMContentLoaded', function() {
    // Existing notification code
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
    const searchInput = document.getElementById('searchFreelancer');
    const searchResults = document.getElementById('searchResults');

    let timeoutId;

    searchInput.addEventListener('input', function() {
        clearTimeout(timeoutId);
        
        timeoutId = setTimeout(() => {
            const searchTerm = this.value.trim();
            
            if (searchTerm.length > 0) {
                fetch('../../dist/php/process/proc_search_freelancers.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ search: searchTerm })
                })
                .then(response => response.json())
                .then(data => {
                    searchResults.innerHTML = '';
                    
                    if (data.length > 0) {
                        data.forEach(freelancer => {
                            const profilePic = freelancer.profile_picture_url || '../../img/default-profile.png';
                            
                            searchResults.innerHTML += `
                            <li>
                                <a href="view_freelancer.php?id=${freelancer.id}" class="dropdown-item py-2 d-flex align-items-center">
                                    <img src="${profilePic}" alt="Profile" class="rounded-circle me-2" style="width: 32px; height: 32px; object-fit: cover;" onerror="this.onerror=null; this.src='../../img/default-profile.png';">
                                    <div>
                                        <div class="fw-bold">${freelancer.first_name} ${freelancer.last_name}</div>
                                        ${freelancer.job_title ? `<small class="text-muted">${freelancer.job_title}</small>` : ''}
                                    </div>
                                </a>
                            </li>
                        `;                        
                        });
                        $(searchResults).dropdown('show');
                    } else {
                        searchResults.innerHTML = '<div class="dropdown-item">No results found</div>';
                        $(searchResults).dropdown('show');
                    }
                });
            } else {
                $(searchResults).dropdown('hide');
            }
        }, 300);
    });
});
