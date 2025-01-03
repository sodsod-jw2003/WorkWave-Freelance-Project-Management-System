document.addEventListener('DOMContentLoaded', function() {
    const filterSelect = document.getElementById('filterProjects');
    const sortSelect = document.getElementById('sortSelect');
    const sortAscBtn = document.getElementById('sortAsc');
    const sortDescBtn = document.getElementById('sortDesc');
    const searchInput = document.getElementById('searchProjects');
    
    let currentDirection = 'ASC';

    function updateProjects() {
        const category = filterSelect.value || '';
        const sort = sortSelect.value || '';
        const search = searchInput?.value.trim() || '';
        
        const url = `../../dist/php/process/proc_filter_freelancer_projects.php?` + 
                   `category=${encodeURIComponent(category)}&` +
                   `sort=${encodeURIComponent(sort)}&` +
                   `direction=${encodeURIComponent(currentDirection)}&` +
                   `search=${encodeURIComponent(search)}`;

                   fetch(url)
                   .then(response => response.text())
                   .then(html => {
                       // Update this line to match your container
                       document.querySelector('.row.px-1 .container.px-3').innerHTML = html;
                   });
    }

    function updateSortButtons(direction) {
        sortAscBtn.querySelector('i').classList.toggle('text-green-50', direction === 'ASC');
        sortDescBtn.querySelector('i').classList.toggle('text-green-50', direction === 'DESC');
    }

    // Event Listeners
    sortSelect.addEventListener('change', () => {
        if (sortSelect.selectedIndex !== 0) {
            updateProjects();
        }
    });

    sortAscBtn.addEventListener('click', () => {
        if (sortSelect.selectedIndex !== 0) {
            currentDirection = 'ASC';
            updateSortButtons(currentDirection);
            updateProjects();
        }
    });

    sortDescBtn.addEventListener('click', () => {
        if (sortSelect.selectedIndex !== 0) {
            currentDirection = 'DESC';
            updateSortButtons(currentDirection);
            updateProjects();
        }
    });

    // JavaScript for toggling heart icon
    // Get all heart buttons
    const heartButtons = document.querySelectorAll('.heart-btn');
    // Add click handler to each button
    heartButtons.forEach(button => {
        button.addEventListener("click", function() {
            const icon = this.querySelector('.heart-icon');
            icon.classList.toggle("far");
            icon.classList.toggle("fas");
        });
    });

    let searchTimeout;
    
    searchInput.addEventListener('keyup', function() {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            updateProjects();
        }, 300);
    });

    filterSelect.addEventListener('change', () => {
        updateProjects();
    });
});