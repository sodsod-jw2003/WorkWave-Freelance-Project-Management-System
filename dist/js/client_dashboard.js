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
        const search = searchInput.value.trim();
        
        const url = `../../dist/php/process/proc_filter_projects.php?` + 
                   `category=${encodeURIComponent(category)}&` +
                   `sort=${encodeURIComponent(sort)}&` +
                   `direction=${encodeURIComponent(currentDirection)}&` +
                   `search=${encodeURIComponent(search)}`;

        fetch(url)
            .then(response => response.text())
            .then(html => {
                document.querySelector('.card-body .row.px-4').innerHTML = html;
            })
            .catch(error => console.error('Error:', error));
    }

    function updateSortButtons(direction) {
        sortAscBtn.querySelector('i').classList.toggle('text-green-50', direction === 'ASC');
        sortDescBtn.querySelector('i').classList.toggle('text-green-50', direction === 'DESC');
    }

    // Event Listeners
    filterSelect.addEventListener('change', updateProjects);
    
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

    let searchTimeout;
    
    searchInput.addEventListener('keyup', function() {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            updateProjects();
        }, 300);
    });
});
