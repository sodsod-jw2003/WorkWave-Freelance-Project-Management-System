let autocomplete;

function initAutocomplete() {

autocomplete = new google.maps.places.Autocomplete(
document.getElementById("city"), 
{
types: ["(cities)"],
componentRestrictions: { country: "ph" },
}
);
}