//./app/javascript/axios.js
// Save the token to localStorage after login

// Save the token to localStorage after login
function handleLogin(response) {
  const token = response.data.token;
  localStorage.setItem('jwtToken', token);
}

// Include the token in the Authorization header for all Axios requests
const token = localStorage.getItem('jwtToken');
axiosLocal.defaults.headers.common['Authorization'] = `Bearer ${token}`;

// Make an API request
axiosLocal.get('http://localhost/api/v1/products')
  .then(response => console.log(response.data))
  .catch(error => console.error('Error:', error));

export default axiosLocal;
