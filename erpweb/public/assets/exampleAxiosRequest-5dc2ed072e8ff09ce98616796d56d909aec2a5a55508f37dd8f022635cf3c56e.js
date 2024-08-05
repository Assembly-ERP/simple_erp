// app/javascripts/exampleAxiosRequest.js
// Ensure Axios is available
document.addEventListener('DOMContentLoaded', function() {
  if (typeof axios !== 'undefined') {
    console.log('Axios is available.');

    // Test Axios request
    axios.get('/operational_portal/customers')
      .then(response => console.log(response))
      .catch(error => console.error(error));
  } else {
    console.error('Axios is not defined.');
  }
});
