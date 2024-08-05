// app/javascript/axiosHelper.js
import apiConfig from './apiConfig';

// Function to wait for axios to be loaded
function ensureAxiosLoaded(callback) {
  if (typeof axios !== 'undefined') {
    callback();
  } else {
    document.addEventListener('axios:loaded', callback);
  }
}

// Create an instance of axios
const axiosHelper = (function() {
  let instance;

  ensureAxiosLoaded(() => {
    instance = axios.create({
      baseURL: apiConfig.apiUrl,
      withCredentials: true, // This ensures cookies are included in the request
    });

// Add a request interceptor to include the JWT token in the headers
axiosHelper.interceptors.request.use(
  (config) => {
    config.headers['Content-Type'] = 'application/json';
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Add a response interceptor to handle errors
axiosHelper.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    return Promise.reject(error);
  }
);
// Dispatch an event to notify that axiosHelper is ready
document.dispatchEvent(new Event('axiosHelper:loaded'));
});

return instance;
})();

export default axiosHelper;
