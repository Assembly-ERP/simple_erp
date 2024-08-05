// app/assets/javascripts/local_time.js

document.addEventListener('DOMContentLoaded', function() {
  const elements = document.querySelectorAll('.local-time');
  elements.forEach(function(element) {
    const timeString = element.getAttribute('data-time');
    if (timeString) {
      const localTime = new Date(timeString);
      element.textContent = localTime.toLocaleString();
    }
  });
});
